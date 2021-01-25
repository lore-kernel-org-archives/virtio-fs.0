Date: Mon, 25 Jan 2021 14:53:30 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210125145330.GA226981@stefanha-x1.localdomain>
References: <20210121144429.58885-1-stefanha@redhat.com>
	<20210121144803.GN3125227@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <20210121144803.GN3125227@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: prevent opening of special files
 (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, P J P <ppandit@redhat.com>, virtio-fs@redhat.com, Alex Xu <alex@alxu.ca>, vgoyal@redhat.com


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 21, 2021 at 02:48:03PM +0000, Daniel P. Berrang=E9 wrote:
> On Thu, Jan 21, 2021 at 02:44:29PM +0000, Stefan Hajnoczi wrote:
> > A well-behaved FUSE client does not attempt to open special files with
> > FUSE_OPEN because they are handled on the client side (e.g. device nodes
> > are handled by client-side device drivers).
> >=20
> > The check to prevent virtiofsd from opening special files is missing in
> > a few cases, most notably FUSE_OPEN. A malicious client can cause
> > virtiofsd to open a device node, potentially allowing the guest to
> > escape. This can be exploited by a modified guest device driver. It is
> > not exploitable from guest userspace since the guest kernel will handle
> > special files inside the guest instead of sending FUSE requests.
> >=20
> > This patch adds the missing checks to virtiofsd. This is a short-term
> > solution because it does not prevent a compromised virtiofsd process
> > from opening device nodes on the host.
> >=20
> > Reported-by: Alex Xu <alex@alxu.ca>
> > Fixes: CVE-2020-35517
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> > This issue was diagnosed on public IRC and is therefore already known
> > and not embargoed.
> >=20
> > A stronger fix, and the long-term solution, is for users to mount the
> > shared directory and any sub-mounts with nodev, as well as nosuid and
> > noexec. Unfortunately virtiofsd cannot do this automatically because
> > bind mounts added by the user after virtiofsd has launched would not be
> > detected. I suggest the following:
> >=20
> > 1. Modify libvirt and Kata Containers to explicitly set these mount
> >    options.
> > 2. Then modify virtiofsd to check that the shared directory has the
> >    necessary options at startup. Refuse to start if the options are
> >    missing so that the user is aware of the security requirements.
> >=20
> > As a bonus this also increases the likelihood that other host processes
> > besides virtiofsd will be protected by nosuid/noexec/nodev so that a
> > malicious guest cannot drop these files in place and then arrange for a
> > host process to come across them.
> >=20
> > Additionally, user namespaces have been discussed. They seem like a
> > worthwhile addition as an unprivileged or privilege-separated mode
> > although there are limitations with respect to security xattrs and the
> > actual uid/gid stored on the host file system not corresponding to the
> > guest uid/gid.
> > ---
> >  tools/virtiofsd/passthrough_ll.c | 84 +++++++++++++++++++++-----------
> >  1 file changed, 56 insertions(+), 28 deletions(-)
> >=20
> > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthr=
ough_ll.c
> > index 5fb36d9407..e08352d649 100644
> > --- a/tools/virtiofsd/passthrough_ll.c
> > +++ b/tools/virtiofsd/passthrough_ll.c
> > @@ -555,6 +555,29 @@ static int lo_fd(fuse_req_t req, fuse_ino_t ino)
> >      return fd;
> >  }
> > =20
> > +/*
> > + * Open a file descriptor for an inode. Returns -EBADF if the inode is=
 not a
> > + * regular file or a directory. Use this helper function instead of raw
> > + * openat(2) to prevent security issues when a malicious client opens =
special
> > + * files such as block device nodes.
> > + */
> > +static int lo_inode_open(struct lo_data *lo, struct lo_inode *inode,
> > +                         int open_flags)
> > +{
> > +    g_autofree char *fd_str =3D g_strdup_printf("%d", inode->fd);
> > +    int fd;
> > +
> > +    if (!S_ISREG(inode->filetype) && !S_ISDIR(inode->filetype)) {
> > +        return -EBADF;
> > +    }
> > +
> > +    fd =3D openat(lo->proc_self_fd, fd_str, open_flags);
>=20
> Whats the intended behaviour with symlinks ?  Do we need to
> allow S_ISLNK, or are we assuming the symlink has already
> been expanded to the target file by this point ? If the latter
> adding a comment about this would be useful.

I will add a comment. The FUSE client is expected to resolve symlinks
on the client side.

In other words, the client does not open the symlink inode in order to
access the target of the symlink. It must open the target directly.

Stefan

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAO22oACgkQnKSrs4Gr
c8hIWwf9GmpnwRx10Flg4TZV96v3TJmJa7pZ8cSfEiUqP/9hPUpiaPz06yeXb8Qk
2EcGTb+9afyxzxhhg88N1/xQPSI15qBYsSi/lCA65hVO/AG9W0SuGiTx2B03ADKu
4kpHrzEzkm58S04ui2sm/wojdowvmBgv4TlUP49XpnA4r7P44Kt8STqEQwRiHSAr
6V4qFwZcyB64MWYpvqe3oLjD2WTZ9DO8gSgJVBrVAVMvasZn+aYxmxp03+a57gqR
Qi0PMqhWveWtfvMqwR3DKEx3oC3aawji/s2jd5w0mopPBzKNtpnkXN/7FBNd+dju
UsnVM/gtOxHLHzVUD7T9etTr/p78Zw==
=r5EZ
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--

