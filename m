Date: Mon, 21 Sep 2020 17:57:33 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200921165733.GA189810@stefanha-x1.localdomain>
References: <20200918213436.GA3520@redhat.com>
	<20200921083923.GA71121@stefanha-x1.localdomain>
	<20200921133944.GB13362@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <20200921133944.GB13362@redhat.com>
Subject: Re: [Virtio-fs] tools/virtiofs: Multi threading seems to hurt
	performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2020 at 09:39:44AM -0400, Vivek Goyal wrote:
> On Mon, Sep 21, 2020 at 09:39:23AM +0100, Stefan Hajnoczi wrote:
> > On Fri, Sep 18, 2020 at 05:34:36PM -0400, Vivek Goyal wrote:
> > > And here are the comparision results. To me it seems that by default
> > > we should switch to 1 thread (Till we can figure out how to make
> > > multi thread performance better even when single process is doing
> > > I/O in client).
> >=20
> > Let's understand the reason before making changes.
> >=20
> > Questions:
> >  * Is "1-thread" --thread-pool-size=3D1?
>=20
> Yes.

Okay, I wanted to make sure 1-thread is still going through the glib
thread pool. So it's the same code path regardless of the
--thread-pool-size=3D value. This suggests the performance issue is
related to timing side-effects like lock contention, thread scheduling,
etc.

> >  * How do the kvm_stat vmexit counters compare?
>=20
> This should be same, isn't it. Changing number of threads serving should
> not change number of vmexits?

There is batching at the virtio and eventfd levels. I'm not sure if it's
coming into play here but you would see it by comparing vmexits and
eventfd reads. Having more threads can increase the number of
notifications and completion interrupt, which can make overall
performance worse in some cases.

> >  * How does host mpstat -P ALL compare?
>=20
> Never used mpstat. Will try running it and see if I can get something
> meaningful.

Tools like top, vmstat, etc can give similar information. I'm wondering
what the host CPU utilization (guest/sys/user) looks like.

> But I suepct it has to do with thread pool implementation and possibly
> extra cacheline bouncing.

I think perf can record cacheline bounces if you want to check.

Stefan

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl9o230ACgkQnKSrs4Gr
c8gVwgf+OJBcIY86ciAhejGlGT0sFDeY62sC2thZr4KeUmDaCRDZb8C/46Gm3LNA
9Qlmh9ALdEbpK/INXV06JPKSkC5HYmiSpTcChzvltJ3B4RvhkgCsEEC+P3eKsqCd
pYgE96xH6uCWxGMQx3OifYoumjYdtCrN3kVOxKEEa7HYTkVYSk2zbKemLt3ASkpn
kG9XPO9WBthP/Zr1tuI5PnqkqBHcTcHe5/Fe36YGeKBODz6pOytsFt5O1mys/1xy
e4OYdKgdlI4jDKNUP2/02bCVsc0T5+V0EhavV+fyMAWEHFXftGOlcArjTQpww/uN
xB2QbKZxajPwg/KKNRfGhIMD0c+V2A==
=q61H
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--

