Date: Thu, 17 Oct 2019 10:23:39 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191017092339.GB23557@stefanha-x1.localdomain>
References: <20191009165116.GJ2893@work-vm>
	<27035e4a-bd12-e5d8-30d0-0df45e75457c@jp.fujitsu.com>
	<CAJFHJrr5Esq=cjZNW4qZRABtCCh_vpkFJEQO9kYb=Pg62O+weQ@mail.gmail.com>
	<20191011195935.GB13861@redhat.com>
	<CAJFHJrq6bQo=yvO0tAxH7RWg=U=ftpsePs3c7y-AcE90Wh4afg@mail.gmail.com>
	<20191011203647.GC13861@redhat.com>
	<20191014091108.GH22963@stefanha-x1.localdomain>
	<CAJFHJrrqfjQqMu-K99DiBYNmD1=hB710wRZ88w--SQ0GxQv9Tw@mail.gmail.com>
	<20191016140959.GA5487@stefanha-x1.localdomain>
	<CAJFHJrrtVHJQr6tCRYJmL-roVo_dMekOLQPsb4ryc96Bf6hAJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <CAJFHJrrtVHJQr6tCRYJmL-roVo_dMekOLQPsb4ryc96Bf6hAJA@mail.gmail.com>
Subject: Re: [Virtio-fs] xfstest results for virtio-fs on aarch64
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "masayoshi.mizuma@fujitsu.com" <masayoshi.mizuma@fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2019 at 04:36:33AM +0900, Chirantan Ekbote wrote:
> On Wed, Oct 16, 2019 at 11:10 PM Stefan Hajnoczi <stefanha@redhat.com> wr=
ote:
> >
> > On Tue, Oct 15, 2019 at 11:58:46PM +0900, Chirantan Ekbote wrote:
> > >
> > > As for the performance numbers, I don't have my test device with me
> > > but if I remember correctly the blogbench scores almost doubled when
> > > going from one queue to two queues.
> >
> > If I understand the code correctly each virtqueue is processed by a
> > worker and the number of virtqueues is the vcpu count.  This means that
> > requests are processed in a blocking fashion and the disk is unlikely to
> > reach its maximum queue depth (e.g. often 64 requests).
> >
> > Going from 1 virtqueue to 2 virtqueues will improve performance, but
> > it's still a far cry from the maximum queue depth that the host kernel
> > and hardware supports.  This is why virtiofsd processes multiple
> > requests in parallel on a single virtqueue using a thread pool.
>=20
> Hmm, maybe I'm missing something but isn't this still limited by the
> number of requests that can fit in the virtqueue?

Yes, but not a practical issue.  The maximum virtqueue size is chosen by
the VIRTIO device.  QEMU sets it to 128 and that's larger than the
typical queue depth of a disk.  So in practice the virtqueue size is not
the bottleneck.

It makes sense to set the number of virtqueues to the number of vCPUs to
achieve good CPU and interrupt scalability, but this number will be
lower than the disk's queue depth.  So in order to saturate the disk
it's necessary to process a virtqueue's requests in parallel (e.g.
thread pool, aio, etc).

Stefan

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2oMxsACgkQnKSrs4Gr
c8is4ggAoPD6fnemSE6A4RmUVRPVX+ZMR3VBrhDdeFJlFBPr9xKHrArCaWoMnkEM
ZFG0ScmgTIMO/5ONztmFNLU3jfcMgbsIgIJojfsTcid95bQSLpuS9U0zvWa/4p4W
cRprke8NkrClY52MFPwmm2brhjF0h9oE7GCcgtU6zBaVlXKTCLPogyp/u3+EB3CM
V0L8C7bW/7j16hXJ0JDcxlInhsoBLcqOvKqLHP077hos3bMcJINHaRBfDJrxLXgE
rBNmbGBxgsYwNVZOHo4j1zvc94562qr3bKKSXIggmdUWLY6HFgLBbHpg6D+u38Ur
9pHMw4a3Lro4rSiycmUVr1toS8idJQ==
=tm1s
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--

