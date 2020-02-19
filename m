Date: Wed, 19 Feb 2020 14:43:38 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200219144338.GH1078625@stefanha-x1.localdomain>
References: <20200210160639.GA411895@stefanha-x1.localdomain>
	<55e0b779-8cb3-3614-a094-158349685203@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ISKrrfpKsPiF35CV"
Content-Disposition: inline
In-Reply-To: <55e0b779-8cb3-3614-a094-158349685203@redhat.com>
Subject: Re: [Virtio-fs] SELinux support in virtio-fs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Daniel Walsh <dwalsh@redhat.com>
Cc: virtio-fs@redhat.com


--ISKrrfpKsPiF35CV
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 17, 2020 at 12:48:46PM -0500, Daniel Walsh wrote:
> On 2/10/20 11:06 AM, Stefan Hajnoczi wrote:
> > Hi Dan,
> > I've CCed the public virtio-fs mailing list because SELinux support in
> > virtio-fs has been asked about recently.
> >
> > It's time to figure out what level of SELinux support will be available
> > in virtio-fs.  The file system client shares most of its code with FUSE
> > and SELinux labels on files are currently not supported in FUSE.
> >
> > It would be possible to pass through extended attributes to the
> > virtiofsd daemon running on the host.  However, passing through xattrs
> > allows the client to relabel files on the host file system and this
> > could pose a security problem.  virtiofsd already allows the client to
> > set the uid/gid and permissions, but is passing through SELinux xattrs a
> > bad idea?
> >
> > virtiofsd is in a position to mangle extended attribute names
> > ("security.selinux" -> "virtiofs.security.selinux") in order to separate
> > guest SELinux labels from host SELinux labels.
> >
> > As someone who knows very little about SELinux I'm eager to hear what
> > you think would be a good approach.  Secure containers (e.g. Kata
> > Containers) are an important use case but virtio-fs can also be used as
> > the root file system for a guest (a scenario where full SELinux support
> > is needed).
> >
> > Thanks,
> > Stefan
>=20
> First off.=A0 Lets look at some fundamental rules about SELinux.=A0
>=20
> One if a file system like overlay is mounted with a context mount, then
> SELinux labels can not be modified on this label.=A0 This is going to be a
> common use case for kata.=A0=A0=A0 We expect the labels inside of the
> container to be some form of container_file_t.=A0 With an MCS Label to
> match. Anything on the image that needs to be written inside of the
> container needs to be done on an Overlay File system.=A0 Bottom line, I
> would like the labels from the host system to pass into the container
> and be enforced in the container, iff the container supports SELinux
> labeling.  I believe in KATA case, the Containers Kernel will basically
> see SELinux as disabled, and will do no SELinux actions.=A0

Yes, the upstream Kata guest kernel currently has SELinux disabled.

> We will run the virtiofs daemon(s) as the same label as the qemu
> process, something like kvm_container_t. Where it will only be able to
> write to files/directories with the container_file_t:MCS labels that matc=
h.
>=20
> Then if a container process inside of a VM tries to write to content on
> the host that was volume mounted into the container via virtiofs,
> SELinux will block the access unless the content is labeled correctly.=A0
> This would match the behavior of non KVM Containers.

Sounds good.

> Now if we look at VM's we have different issues.=A0 Theoretically we could
> mount a volume from the host into a VM with labels.=A0 And the VM could
> have SELinux enabled inside with a different policy.=A0
>=20
> What happens then?
>=20
> If the processes inside of the container attempts to create content on
> the mount point with a label that is not defined on the host system, it
> will be denied.=A0 And this is a good thing.=A0 We don't want bogus from =
the
> host point of view labels on disk.=A0 If a label on the host is mounted
> into the container and the containers kernel does not understand the
> label, then SELinux will report the label as unlabeled_t. Confined
> processes will not be allowed to interact with unlabeled_t files.
>=20
> I am not crazy about adding a new XATTR to support alternate types for a
> file on the host.=A0 This is asking for problems, and if should be
> discussed with the upstream SELinux developers before it is considered.=A0
> Two big issues I see with this is around Nesting.=A0 If I want to run a
> container and virtiofs inside of a VM running Virtiofs, then you have a
> problem.=A0 Second problem is around getting permission denials, become
> hard to diagnose. A process inside of a container might get permission
> denied trying to write to a file label, that looks correct in the VM,
> but the virtiofs on the host is being denied access to a different type
> on the host.
>=20
> When we did labeled NFS we basically stated that the types used in a
> mount point must be shared between the host and client and would be
> enforced by both the client kernel and the server kernel.=A0 I see no
> reason to make this more complicated to start.=A0

Okay, so no nesting and client/server must share types.  I'll try to get
that working.  At the moment setting labels on files inside the guest
fails because the setxattr("security.selinux", label) is rejected by the
host kernel.

Stefan

--ISKrrfpKsPiF35CV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5NSZoACgkQnKSrs4Gr
c8jNrgf9HU0F3aaLBbR4wk+4oD+ULMcexbHXS0TcvtpMjvnHQ1N4iYlTazY9ldT5
o8zqWe1g8aC2MbjMMfqioXVr+tggYuYje0omPRD0XIF7/R80c0YzzVXcFwSdwRfy
DilGLVZ+yst5+B5b+t9Qi8mZp99LoDjCZhXNThXA7x/jI6/yTbe8UPpABA1mytuw
LudFjPhGzpEiEGjKgUXJSoh+GGNTlD+BoSVDa8zTUyqSGUs5pbc0aEEbrGoFcaGF
ggqRauDc2TIL3SulV55iTfLQrsAK2FANixx7ahFGhKYAjW/+nsMr/yntIUVKTQCi
bnHpNV9IRtGIKPwYq+5XYxhYAUUOHA==
=qQcq
-----END PGP SIGNATURE-----

--ISKrrfpKsPiF35CV--

