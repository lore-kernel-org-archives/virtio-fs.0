Date: Wed, 6 Oct 2021 11:27:06 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YV15+gGJ4ybRRKnm@stefanha-x1.localdomain>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-14-vgoyal@redhat.com>
	<YVxDouMEj3aqTNf3@stefanha-x1.localdomain>
	<YVxsQg+edz0kFmUl@redhat.com>
	<YVx0U8Wg7jahdoJD@stefanha-x1.localdomain>
	<YVyLNQM8PXO8iDed@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="pDFxbfaz984+NjYw"
Content-Disposition: inline
In-Reply-To: <YVyLNQM8PXO8iDed@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 13/13] virtiofsd,
 seccomp: Add clock_nanosleep() to allow list
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, miklos@szeredi.hu


--pDFxbfaz984+NjYw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 05, 2021 at 01:28:21PM -0400, Vivek Goyal wrote:
> On Tue, Oct 05, 2021 at 04:50:43PM +0100, Stefan Hajnoczi wrote:
> > On Tue, Oct 05, 2021 at 11:16:18AM -0400, Vivek Goyal wrote:
> > > On Tue, Oct 05, 2021 at 01:22:58PM +0100, Stefan Hajnoczi wrote:
> > > > On Thu, Sep 30, 2021 at 11:30:37AM -0400, Vivek Goyal wrote:
> > > > > g_usleep() calls nanosleep() and that now seems to call clock_nan=
osleep()
> > > > > syscall. Now these patches are making use of g_usleep(). So add
> > > > > clock_nanosleep() to list of allowed syscalls.
> > > > >=20
> > > > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > > > ---
> > > > >  tools/virtiofsd/passthrough_seccomp.c | 1 +
> > > > >  1 file changed, 1 insertion(+)
> > > > >=20
> > > > > diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtio=
fsd/passthrough_seccomp.c
> > > > > index cd24b40b78..03080806c0 100644
> > > > > --- a/tools/virtiofsd/passthrough_seccomp.c
> > > > > +++ b/tools/virtiofsd/passthrough_seccomp.c
> > > > > @@ -117,6 +117,7 @@ static const int syscall_allowlist[] =3D {
> > > > >      SCMP_SYS(writev),
> > > > >      SCMP_SYS(umask),
> > > > >      SCMP_SYS(nanosleep),
> > > > > +    SCMP_SYS(clock_nanosleep),
> > > >=20
> > > > This patch can be dropped once sleep has been replaced by a condvar.
> > >=20
> > > There is another sleep in do_pool_destroy() where we are waiting
> > > for all current threads to exit.
> > >=20
> > > do_pool_destroy() {
> > >     g_usleep(10000);
> > > }
> >=20
> > That won't be necessary if there's a way to avoid the thread pool :).
> > See my other reply about closing the OFD instead of using signals to
> > cancel blocking fcntl(2).
>=20
> Hi Stefan,
>=20
> I responded to that email already. man fnctl does not say anything
> about closing fd will unblock the waiter with -EINTR and I had a=20
> quick look at kernel code and did not find anything which suggested
> closing fd will unblock current waiters.
>=20
> So is this something you know works or you want me to try and see
> if it works?

Thanks for testing it!

Stefan

--pDFxbfaz984+NjYw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFdefkACgkQnKSrs4Gr
c8jUBgf+N9IJH4S4Tlyyv5GPZHHa88XFtkfoZEMfLVHBmE5CNM4z66bFuGGMZsLR
YiR5Vg0wxHqhT4ixs9M38kXCjWLGtgoXqJhRvMWsvgjK5jOLSesivwSPktfOTwxf
I9RkBgyBFxIMCNGRrxLmlpBU8jGX1OOE2D8Vi6KAbm3gVk6kE+rrlGIOL4mi3qvv
o8gaVhIQNeZHZh53z8ayZT6GK3XN4/u7K4SjKAWlfRkFLUD9txN1ojfJPcd/NU9B
tlUDy11szZqJI+OSRU9Mf4+isPy6VT9RI3oxKYB3mYTH9beH9mzzUHrn5115v9Gx
dvTWeTKUPphOJz1Vm2fx+Aoo37rAfg==
=J/vs
-----END PGP SIGNATURE-----

--pDFxbfaz984+NjYw--

