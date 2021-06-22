Date: Tue, 22 Jun 2021 09:36:33 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YNGhERcnLuzjn8j9@stefanha-x1.localdomain>
References: <20210621062657.3641879-1-hch@lst.de>
	<20210622081217.GA2975@lst.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Y+sWrBBljVlHm2Wk"
Content-Disposition: inline
In-Reply-To: <20210622081217.GA2975@lst.de>
Subject: Re: [Virtio-fs] [PATCH 3/2] fs: simplify get_filesystem_list /
 get_all_fs_names
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, viro@zeniv.linux.org.uk, Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org


--Y+sWrBBljVlHm2Wk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 22, 2021 at 10:12:17AM +0200, Christoph Hellwig wrote:
> Just output the '\0' separate list of supported file systems for block
> devices directly rather than going through a pointless round of string
> manipulation.
>=20
> Based on an earlier patch from Al Viro <viro@zeniv.linux.org.uk>.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/filesystems.c   | 24 ++++++++++++++----------
>  include/linux/fs.h |  2 +-
>  init/do_mounts.c   | 20 +-------------------
>  3 files changed, 16 insertions(+), 30 deletions(-)
>=20
> diff --git a/fs/filesystems.c b/fs/filesystems.c
> index 90b8d879fbaf..7c136251607a 100644
> --- a/fs/filesystems.c
> +++ b/fs/filesystems.c
> @@ -209,21 +209,25 @@ SYSCALL_DEFINE3(sysfs, int, option, unsigned long, =
arg1, unsigned long, arg2)
>  }
>  #endif
> =20
> -int __init get_filesystem_list(char *buf)
> +void __init list_bdev_fs_names(char *buf, size_t size)
>  {
> -	int len =3D 0;
> -	struct file_system_type * tmp;
> +	struct file_system_type *p;
> +	size_t len;
> =20
>  	read_lock(&file_systems_lock);
> -	tmp =3D file_systems;
> -	while (tmp && len < PAGE_SIZE - 80) {
> -		len +=3D sprintf(buf+len, "%s\t%s\n",
> -			(tmp->fs_flags & FS_REQUIRES_DEV) ? "" : "nodev",
> -			tmp->name);
> -		tmp =3D tmp->next;
> +	for (p =3D file_systems; p; p =3D p->next) {
> +		if (!(p->fs_flags & FS_REQUIRES_DEV))
> +			continue;
> +		len =3D strlen(p->name) + 1;
> +		if (len > size) {
> +			pr_warn("%s: truncating file system list\n", __func__);
> +			break;
> +		}
> +		memcpy(buf, p->name, len);
> +		buf +=3D len;
> +		size -=3D len;
>  	}
>  	read_unlock(&file_systems_lock);
> -	return len;
>  }

I don't see the extra NUL terminator byte being added that's required by
the loop in mount_block_root()?

--Y+sWrBBljVlHm2Wk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmDRoREACgkQnKSrs4Gr
c8g8mgf+PDTW/0OS88/JmQ5E27ZXpLlNGUJkTSdpn4jhWZpdPhbG/+yiPRoTpPv8
NmvfbL7yomhRXntd+pA/WUlyF6Eb2SDv8Wfo0/qU+fTIsaHA7mz/d9300ucC1Thw
ZuDl7uadlf2KbJRlhLZHzl9Q2Q9+PsscEql0TSsIJU0X2qO1qxm4tvncbyyXY/lc
nLLkGJVf9205rvJf2TcuBFF1UYUThOB7+VjIzn2CBfKahLyTOGSePy5GyvcdFp2s
0EGWvIFHcsWuHxkDRdGVLt51bsOiEHRBsjZ7LHiIruzo0Y9tqYNJDTvhphtE+fMw
jDjcU52ufud1nFXZcKVeYswxfIp8vg==
=08W1
-----END PGP SIGNATURE-----

--Y+sWrBBljVlHm2Wk--

