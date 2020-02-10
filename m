Date: Mon, 10 Feb 2020 16:06:39 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200210160639.GA411895@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
Subject: [Virtio-fs] SELinux support in virtio-fs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: dwalsh@redhat.com
Cc: virtio-fs@redhat.com


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dan,
I've CCed the public virtio-fs mailing list because SELinux support in
virtio-fs has been asked about recently.

It's time to figure out what level of SELinux support will be available
in virtio-fs.  The file system client shares most of its code with FUSE
and SELinux labels on files are currently not supported in FUSE.

It would be possible to pass through extended attributes to the
virtiofsd daemon running on the host.  However, passing through xattrs
allows the client to relabel files on the host file system and this
could pose a security problem.  virtiofsd already allows the client to
set the uid/gid and permissions, but is passing through SELinux xattrs a
bad idea?

virtiofsd is in a position to mangle extended attribute names
("security.selinux" -> "virtiofs.security.selinux") in order to separate
guest SELinux labels from host SELinux labels.

As someone who knows very little about SELinux I'm eager to hear what
you think would be a good approach.  Secure containers (e.g. Kata
Containers) are an important use case but virtio-fs can also be used as
the root file system for a guest (a scenario where full SELinux support
is needed).

Thanks,
Stefan

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5Bf48ACgkQnKSrs4Gr
c8j71gf/QaxaARXRWbnzL0W6xTjcbeOkz29tMIBzNfTs1eIoFOwD3KogMPEXKLKM
e4UiId+Zfeeo44RnQI9mJL2vNndEAjfrJE/YsVgmocmpkf4gbjWUIwfa05HRKLvC
Z6PH8JumnDM1NkpCf4MRoQFuEG56kkRoyn67lhFzlloyzNPefpYdkLwY1tQSZooR
ZxQWsZ+gEr1cBNRk+X0khsbnZlXsUbyX0UAzr6/tJfTkBP8Js7Y5wUWN0r0SGa56
symRq0d8TAM2edX4SrdVLIemL88WIPqQ+BHSlou4k2ZOLsm4DeGTQ7111Z8pO4gu
RU4Br5YWw49hFsbHpenmW2PGdub4eQ==
=MLDo
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--

