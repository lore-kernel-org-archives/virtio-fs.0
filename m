Date: Wed, 29 Apr 2020 12:39:06 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200429113906.GA126018@stefanha-x1.localdomain>
References: <5D4D0D06.1090602@huawei.com>
	<20190821153802.GB9095@stefanha-x1.localdomain>
	<5D633104.6030000@huawei.com>
	<20190827144258.GF6901@stefanha-x1.localdomain>
	<5D66279D.5000507@huawei.com>
	<20200424021500.GT47669@e18g06458.et15sqa>
	<DB22024898C02A43BF0771615306E8720F8DD6BB@dggemm525-mbx.china.huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <DB22024898C02A43BF0771615306E8720F8DD6BB@dggemm525-mbx.china.huawei.com>
Subject: Re: [Virtio-fs] =?utf-8?b?562U5aSNOiAgW1BBVENIXVtSRkNdIFN1cHBvcnQg?=
 =?utf-8?q?multiqueue_mode_by_setting_cpu_affinity?=
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 26, 2020 at 02:12:15AM +0000, piaojun wrote:
>=20
>=20
> -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> =E5=8F=91=E4=BB=B6=E4=BA=BA: Eryu Guan [mailto:eguan@linux.alibaba.com]=
=20
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2020=E5=B9=B44=E6=9C=8824=E6=97=A5 =
10:15
> =E6=94=B6=E4=BB=B6=E4=BA=BA: piaojun <piaojun@huawei.com>
> =E6=8A=84=E9=80=81: Stefan Hajnoczi <stefanha@redhat.com>; virtio-fs@redh=
at.com
> =E4=B8=BB=E9=A2=98: Re: [Virtio-fs] [PATCH][RFC] Support multiqueue mode =
by setting cpu affinity
>=20
> Hi Jun,
>=20
> On Wed, Aug 28, 2019 at 03:05:01PM +0800, piaojun wrote:
> >=20
> >=20
> > On 2019/8/27 22:42, Stefan Hajnoczi wrote:
> > > On Mon, Aug 26, 2019 at 09:08:20AM +0800, piaojun wrote:
> > >> On 2019/8/21 23:38, Stefan Hajnoczi wrote:
> > >>> On Fri, Aug 09, 2019 at 02:04:54PM +0800, piaojun wrote:
> > >>>> Set cpu affinity for each queue in multiqueue mode to improve the=
=20
> > >>>> iops performance.
>=20
> [snip]
>=20
> > >=20
> > > Doing the setup before entering the sandbox sounds like a good idea.
> > > That way the sandbox does not need to whitelist the required syscalls.
> > >=20
> > > Will you add an option similar to:
> > >=20
> > >   --request-queues N
> > >   --request-queue-cpu-affinity N=3DCPU_A[,CPU_B][-CPU_C]
> > >=20
> > > ?
> >=20
> > I'm writing the multi-queue code for virtiofsd according to your=20
> > suggestion, but the final shape may look a bit different.
>=20
> Just curious, what's the status of this multi-queue support? I'd like to =
try it out :)
>=20
> OK, I wrote a demo a few months ago, but it has little performance promot=
e even setting CPU affinity.
> So, I'm glad you can try it.

Do you want to send RFC patches to virtio-fs@redhat.com so it can be
discussed?

A bug in the virtiofs.ko guest driver has just been discussed that
prevented multiqueue from working:
https://www.redhat.com/archives/virtio-fs/2020-April/msg00030.html
or
https://www.redhat.com/archives/virtio-fs/2020-April/msg00021.html

There is also discussion about multiqueue and performance here:
https://www.redhat.com/archives/virtio-fs/2020-April/msg00026.html

Stefan

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl6pZ1oACgkQnKSrs4Gr
c8jx1gf9F1JFu6e4WN+8OV5dUNt986bJhVu5XD6dA3HTT/THC2InTGiZFGO/Nk/8
7cEMt1oEcv2xNFg7ETaqX7xnuZrWEDP3xMCHGCFGVxTe8ODHYlgzoK7NK0bFOUSn
M9/khAWNcRcif5pKfk7vhvVDOU9+WrrJ4vfomP9p/DL65tShZtmpx3jKHeGdoiDE
jpQ1eriRpScv1Lms2IY7NNdhj16Rher3+X/K10P8BhNhu3vKr89DHM1sfevmGByU
DHtYsQxbxvW6kKrQNxhfcP3hv7/C2HnZQk1Wt0gugHjBM8DFvR0ajBIY+jbCfRq6
2GByU7IvoDuPk+GN8Xly1n6WUQ5P2A==
=OAiV
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--

