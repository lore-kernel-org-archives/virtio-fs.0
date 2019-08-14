Date: Wed, 14 Aug 2019 13:41:17 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190814124117.GB23970@stefanha-x1.localdomain>
References: <5D4CC344.7030706@huawei.com>
	<20190811020659.GB13456@ali-6c96cfe09cf9.local>
	<ba984781-dc70-8633-7cb4-6ccd00e4e23e@huawei.com>
	<20190811111556.GC13456@ali-6c96cfe09cf9.local>
	<769b4025-b973-6107-f9f2-c65f72701bf2@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Content-Disposition: inline
In-Reply-To: <769b4025-b973-6107-f9f2-c65f72701bf2@huawei.com>
Subject: Re: [Virtio-fs] [PATCH v4 0/2] virtiofsd: Improve io bandwidth by
 replacing pwrite with pwritev
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eric Ren <renzhen@linux.alibaba.com>
Cc: virtio-fs@redhat.com


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 11, 2019 at 09:55:17PM +0800, piaojun wrote:
>=20
>=20
> On 2019/8/11 19:15, Eric Ren wrote:
> > Hi,
> >=20
> > On Sun, Aug 11, 2019 at 10:46:02AM +0800, piaojun wrote:
> >>
> >>
> >> On 2019/8/11 10:06, Eric Ren wrote:
> >>> Hi jun,
> >>>
> >>> On Fri, Aug 09, 2019 at 08:50:12AM +0800, piaojun wrote:
> >>>> >From my test, write bandwidth will be improved greatly by replacing
> >>>> pwrite with pwritev, and the test result as below:
> >>>
> >>> Could you share more information about this testing?
> >>>
> >>> - args for qemu: cache size?
> >>> - args for virtiofsd: which cache mode=EF=BC=9F
> >>> - DAX is used, right?
> >>
> >> DAX is disabled, as this optimization only works on Host side.
> >=20
> >=20
> > OK, thanks for the info.
> >=20
> > The test runs in KATA container, which use DAX as its default mount
> > option.
> >=20
> >>
> >>>
> >>> - which kind of disk are you using, what's then IOPS/BW limit?
> >>>
> >>> I tried this patch with HDD disk - IOPS:5000, BW: 140MB/s.
> >>
> >> I used EXT4 and ramdisk as backend device.
> >>
> >>>
> >>> - VM: 4 vcpus, 8G mem
> >>> - cache=3Dalways, cache-size=3D8G, DAX
> >>> - fio job
> >>>
> >>> ```
> >>> [global]
> >>> fsync=3D0
> >>> name=3Dvirtiofs-test
> >>> filename=3Dfio-test
> >>> directory=3D$mntdir   # share dir for test sitting on the disk
> >>> rw=3Drandwrite
> >>> bs=3D4K
> >>
> >> *bs* should be 1M for bandwidth test which makes writev works well.
> >=20
> > Yes, but seq write "rw=3Dwrite" is also good fr BW test, right?
>=20
> Right.

The purpose of piaojun's patch is to accelerate cases where the guest
submits multiple pages.  If bs is 4KB then there is only one page and
writev will not speed things up.

You need a larger blocksize if you want to see the effects of this
optimization.

Stefan

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1UAW0ACgkQnKSrs4Gr
c8g37wf+JAn287l0YgN5U2NwcpmDQFQK8bb92Me2GfA2BcFmjWdTimYBc9VuHHYY
GEuPgGID0D4e1hqV54P6gJcJ6Bb57eLyJcl+vPLG2Ca2+CiaWfxT/a7dKoU34JMw
a2iKnFUkUE4ejJtgJGl8ENsgF8jvU08CL4e3mQgomL/n8J8bAAgL/EbRnGX3yVD6
h80TYt2FWs2DSZqSQMx0MOcWnJf4uPQHIFAmuiKWxnUHOUf3CfjUAAy/RDrleZ9x
XAg+30KGVlvk2lkcAUL7Ly3cf417FYt8lBs7k6ikxCKHyzYQy27kLSpqvM8Zj9Sa
GtflcR5CX5w1cNkshO0pRFNHnvrfTw==
=udIx
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--

