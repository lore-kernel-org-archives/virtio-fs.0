References: <20200210160639.GA411895@stefanha-x1.localdomain>
From: Daniel Walsh <dwalsh@redhat.com>
Message-ID: <bbcbd9a0-a036-1c1e-ed66-ac2aaca454a5@redhat.com>
Date: Wed, 12 Feb 2020 10:29:06 -0500
MIME-Version: 1.0
In-Reply-To: <20200210160639.GA411895@stefanha-x1.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="08rbWrLYMx9McwkzjjZMadBzxQYj2FdT0"
Subject: Re: [Virtio-fs] SELinux support in virtio-fs
Reply-To: dwalsh@redhat.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, selinux-internal-list <selinux-internal-list@redhat.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--08rbWrLYMx9McwkzjjZMadBzxQYj2FdT0
Content-Type: multipart/mixed; boundary="lm4uq1hIGKrhm3EOYBXKoX0o8xixQKm4F"

--lm4uq1hIGKrhm3EOYBXKoX0o8xixQKm4F
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US

On 2/10/20 11:06 AM, Stefan Hajnoczi wrote:
> Hi Dan,
> I've CCed the public virtio-fs mailing list because SELinux support in
> virtio-fs has been asked about recently.
>
> It's time to figure out what level of SELinux support will be available=

> in virtio-fs.  The file system client shares most of its code with FUSE=

> and SELinux labels on files are currently not supported in FUSE.
>
> It would be possible to pass through extended attributes to the
> virtiofsd daemon running on the host.  However, passing through xattrs
> allows the client to relabel files on the host file system and this
> could pose a security problem.  virtiofsd already allows the client to
> set the uid/gid and permissions, but is passing through SELinux xattrs =
a
> bad idea?
>
> virtiofsd is in a position to mangle extended attribute names
> ("security.selinux" -> "virtiofs.security.selinux") in order to separat=
e
> guest SELinux labels from host SELinux labels.
>
> As someone who knows very little about SELinux I'm eager to hear what
> you think would be a good approach.  Secure containers (e.g. Kata
> Containers) are an important use case but virtio-fs can also be used as=

> the root file system for a guest (a scenario where full SELinux support=

> is needed).
>
> Thanks,
> Stefan

I am traveling right now.=A0 We should add in the SELinux team, and I wil=
l
be able to look at this on Friday.



--lm4uq1hIGKrhm3EOYBXKoX0o8xixQKm4F--

--08rbWrLYMx9McwkzjjZMadBzxQYj2FdT0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE+re/ImQyQPB/0p5rot+QHaviwCgFAl5EGcIACgkQot+QHavi
wCimPgf+NLlxFlQKw6YQc/LrXSbS5ziq2DXHfKHhxoprHL5HnlQO+Nei8WCqXXvq
FvRwrj+2v/Hquw2BZmKZw8yZN5XtQLnZFtlUTW3Qwch0NUuYHNIM2vG5B4dau1Fx
SC4Z3op1HehvLSRgPA4B7tUKB4zVCqjN1kw4ELqFMA54Fflmn+vrzWa38GF4UzFx
AAlNzzUefSkzNwvaesIqjJKsqpScugBnEoZlyU5VJ9d9upvkOnvWvqHlnSWkNjiG
XJbMsVz5fywfPQQXOD4p5hJzWzr3T30ZjtwlHQ2Ulcr3+qYWRDvheAdJlGMmgycR
nC/1Jiy8HwJyjR7Wrorqs1l+mL4YAA==
=wq2f
-----END PGP SIGNATURE-----

--08rbWrLYMx9McwkzjjZMadBzxQYj2FdT0--

