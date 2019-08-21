Date: Wed, 21 Aug 2019 16:38:02 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190821153802.GB9095@stefanha-x1.localdomain>
References: <5D4D0D06.1090602@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
In-Reply-To: <5D4D0D06.1090602@huawei.com>
Subject: Re: [Virtio-fs] [PATCH][RFC] Support multiqueue mode by setting cpu
 affinity
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: virtio-fs@redhat.com


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 09, 2019 at 02:04:54PM +0800, piaojun wrote:
> Set cpu affinity for each queue in multiqueue mode to improve the iops
> performance.
>=20
> >From my test, the iops is increased by adding multiqueues as below,
> but it has not achieved my expect yet due to some reason. So I'm
> considering if we could drop some locks when operating vq as it is
> binded to one vCPU. I'm very glad to have a discuss with other
> developers.
>=20
> Further more, I modified virtiofsd to support multiqueue which just for
> testing.
>=20
> Test Environment:
> Guest configuration:
> 8 vCPU
> 8GB RAM
> Linux 5.1 (vivek-aug-06-2019)
>=20
> Host configuration:
> Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz (8 cores x 4 threads)
> 32GB RAM
> Linux 3.10.0
> EXT4 + 4G Ramdisk
>=20
> ---
> Single-queue:
> # fio -direct=3D1 -time_based -iodepth=3D128 -rw=3Drandwrite -ioengine=3D=
libaio -bs=3D4k -size=3D1G -numjob=3D8 -runtime=3D30 -group_reporting -name=
=3Dfile -filename=3D/mnt/virtiofs/file
> file: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dlibaio,=
 iodepth=3D128
> ...
> fio-2.13
> Starting 8 processes
> Jobs: 8 (f=3D8): [w(8)] [100.0% done] [0KB/316.5MB/0KB /s] [0/81.2K/0 iop=
s] [eta 00m:00s]
> file: (groupid=3D0, jobs=3D8): err=3D 0: pid=3D5808: Fri Aug  9 20:35:22 =
2019
>   write: io=3D9499.9MB, bw=3D324251KB/s, iops=3D81062, runt=3D 30001msec
>=20
> Multi-queues:
> # fio -direct=3D1 -time_based -iodepth=3D128 -rw=3Drandwrite -ioengine=3D=
libaio -bs=3D4k -size=3D1G -numjob=3D8 -runtime=3D30 -group_reporting -name=
=3Dfile -filename=3D/mnt/virtiofs/file
> file: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dlibaio,=
 iodepth=3D128
> ...
> fio-2.13
> Starting 8 processes
> Jobs: 8 (f=3D8): [w(8)] [100.0% done] [0KB/444.6MB/0KB /s] [0/114K/0 iops=
] [eta 00m:00s]
> file: (groupid=3D0, jobs=3D8): err=3D 0: pid=3D5704: Fri Aug  9 20:38:47 =
2019
>   write: io=3D12967MB, bw=3D442582KB/s, iops=3D110645, runt=3D 30001msec
> ---

How does the same fio command-line perform on the host when bound to 8
CPUs?

What about the virtiofsd changes?  Did you implement host CPU affinity
for the virtqueue processing threads and their workqueues?

I wonder if numbers are better if you use 8 files instead of 1 file.

> Signed-off-by: Jun Piao <piaojun@huawei.com>
> ---
>  fs/fuse/virtio_fs.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++=
++++--
>  1 file changed, 66 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index a04c320..7ba36fc 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -12,6 +12,7 @@
>  #include <linux/virtio.h>
>  #include <linux/virtio_fs.h>
>  #include <linux/delay.h>
> +#include <linux/cpu.h>
>  #include "fuse_i.h"
>=20
>  /* List of virtio-fs device instances and a lock for the list */
> @@ -61,6 +62,9 @@ struct virtio_fs {
>  	void *window_kaddr;
>  	phys_addr_t window_phys_addr;
>  	size_t window_len;
> +
> +	/* Does the affinity hint is set for virtqueues? */
> +	bool affinity_hint_set;
>  };
>=20
>  struct virtio_fs_forget {
> @@ -378,6 +382,44 @@ static void virtio_fs_vq_done(struct virtqueue *vq)
>  	schedule_work(&fsvq->done_work);
>  }
>=20
> +static void virtio_fs_clean_affinity(struct virtio_fs *fs)
> +{
> +	int i;
> +
> +	if (fs->affinity_hint_set) {
> +		for (i =3D 0; i < fs->num_queues; i++)
> +			virtqueue_set_affinity(fs->vqs[i].vq, NULL);
> +
> +		fs->affinity_hint_set =3D false;
> +	}
> +}
> +
> +static void virtio_fs_set_affinity(struct virtio_fs *fs)
> +{
> +	int i =3D 0, cpu;
> +
> +	/*
> +	 * In single queue mode, we don't set the cpu affinity.
> +	 */
> +	if (fs->num_queues =3D=3D 1) {
> +		virtio_fs_clean_affinity(fs);
> +		fs->affinity_hint_set =3D false;
> +		return;
> +	}
> +
> +	/*
> +	 * In multiqueue mode, we let the queue to be private to one cpu
> +	 * by setting the affinity hint to eliminate the contention.
> +	 */
> +	for_each_online_cpu(cpu) {
> +		virtqueue_set_affinity(fs->vqs[i].vq, cpumask_of(cpu));
> +		if (++i >=3D fs->num_queues)
> +			break;
> +	}
> +
> +	fs->affinity_hint_set =3D true;
> +}
> +
>  /* Initialize virtqueues */
>  static int virtio_fs_setup_vqs(struct virtio_device *vdev,
>  			       struct virtio_fs *fs)
> @@ -440,6 +482,11 @@ static int virtio_fs_setup_vqs(struct virtio_device =
*vdev,
>  		fs->vqs[i].vq =3D vqs[i];
>  		fs->vqs[i].connected =3D true;
>  	}
> +
> +	/* set affinity for vqs */
> +	get_online_cpus();
> +	virtio_fs_set_affinity(fs);
> +	put_online_cpus();
>  out:
>  	kfree(names);
>  	kfree(callbacks);
> @@ -451,6 +498,7 @@ static int virtio_fs_setup_vqs(struct virtio_device *=
vdev,
>  static void virtio_fs_cleanup_vqs(struct virtio_device *vdev,
>  				  struct virtio_fs *fs)
>  {
> +	virtio_fs_clean_affinity(fs);
>  	vdev->config->del_vqs(vdev);
>  }
>=20
> @@ -954,10 +1002,22 @@ static int virtio_fs_enqueue_req(struct virtqueue =
*vq, struct fuse_req *req)
>  	return ret;
>  }
>=20
> +static unsigned virtio_fs_pick_vq_mq(struct virtio_fs *fs)
> +{
> +	unsigned queue_id;
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	queue_id =3D (smp_processor_id() % fs->num_queues) + VQ_REQUEST;
> +	local_irq_restore(flags);
> +
> +	return queue_id;
> +}
> +
>  static void virtio_fs_wake_pending_and_unlock(struct fuse_iqueue *fiq)
>  __releases(fiq->waitq.lock)
>  {
> -	unsigned queue_id =3D VQ_REQUEST; /* TODO multiqueue */
> +	unsigned queue_id =3D VQ_REQUEST;
>  	struct virtio_fs *fs;
>  	struct fuse_conn *fc;
>  	struct fuse_req *req;
> @@ -972,6 +1032,8 @@ static void virtio_fs_wake_pending_and_unlock(struct=
 fuse_iqueue *fiq)
>  	spin_unlock(&fiq->waitq.lock);
>=20
>  	fs =3D fiq->priv;
> +	if (fs->num_queues > 1)
> +		queue_id =3D virtio_fs_pick_vq_mq(fs);
>  	fc =3D fs->vqs[queue_id].fud->fc;
>=20
>  	dev_dbg(&fs->vqs[queue_id].vq->vdev->dev,
> @@ -1066,9 +1128,11 @@ static int virtio_fs_fill_super(struct super_block=
 *sb, char *opts,
>=20
>  	err =3D -ENOMEM;
>  	/* Allocate fuse_dev for hiprio and notification queues */
> -	for (i =3D 0; i < VQ_REQUEST; i++) {
> +	for (i =3D 0; i < VQ_REQUEST + fs->num_queues; i++) {
>  		struct virtio_fs_vq *fsvq =3D &fs->vqs[i];
>=20
> +		if (i =3D=3D VQ_REQUEST)
> +			continue;  /* will be allocated in fuse_fill_super_common */
>  		fsvq->fud =3D fuse_dev_alloc();
>  		if (!fsvq->fud)
>  			goto err_free_fuse_devs;
> --=20
>=20
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1dZVoACgkQnKSrs4Gr
c8gzDQgAgNfxrYw9km4YBkY0cXzuZh2foRK/ib0KkZK/URHLmOmtorpwgfOrr2B3
NCATJvaJUQlwsWC0Oht3AimjNYLzXuDP31msUgEERwQsB4koFNPyPIqbozjNmloB
nApnru1naRi2Fhv35GkXH/XYfzWwqYX3oBbEOT35MxMKrnHNrXVrINN/KsGmVdjk
wf/j9vEps9NPZV3hbQjSi6h8gl8jm7a7XKw3Xzl3fjG0/cK6AWjSk+enmPEiHLV3
/2iCYQq8eHq/QgDtx1vHrIcMu2iBuJm2Po67UR62O+li+NE4iZX3Md0wj1iwR+mj
XrV5ak/Q/9o9FGF/g7RMBWhQTPC4pw==
=ocUI
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--

