Date: Wed, 24 Mar 2021 11:51:30 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YFsnwtUqfmr3e7dI@stefanha-x1.localdomain>
References: <47a35ffe-ef39-d098-2c29-34cf7d4eb7ef@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="MDxgyqJ0UkBYpRxk"
Content-Disposition: inline
In-Reply-To: <47a35ffe-ef39-d098-2c29-34cf7d4eb7ef@redhat.com>
Subject: Re: [Virtio-fs] Current file handle status and open questions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>


--MDxgyqJ0UkBYpRxk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 18, 2021 at 06:09:58PM +0100, Max Reitz wrote:
> So, overall it seems like it may be workable to extend the in-kernel MAC
> verification to allow for persistent keys, but I still have some open
> questions, and I don=E2=80=99t know whether I should just defer them unti=
l we
> get to the point where we need persistency.

It seems worth refining these ideas a little bit further until they
reach solid ground. Then we can be sure that there is at least one
possible solution. At the moment it seems like most the components of a
solution are known but it's not clear how they all fit together - and
they have a nasty tendency of failing to meet the requirements if they
aren't put together in exactly the right way :).

> (Of note: If we implement something where a user space process (or
> multiple in conjunction) can arbitrarily choose a MAC key, then this
> will also be usable for live migration, because you can continue to use
> the key from the source on the destination.)

Definitely. Taking migration into account is worthwhile. One question
about that:

Are Linux file handles transferrable between systems? Basic
configurations that come to mind:
1. XFS, brtfs, ext4 on SAN (e.g. FibreChannel SCSI LUN)
2. NFS

I assumed they were in previous discussions but has anyone checked the
file handle implementations to see whether this is really the case?

> Final minor question that doesn=E2=80=99t really fit in fully elsewhere: =
When
> generating a MAC over a file handle, should the mount ID be included?
> I=E2=80=99m worried that this might definitely break persistency, but I t=
hink we
> should include some FS ID.  Maybe the kernel should query the FS UUID
> for this MAC calculation, and use that instead of the mount ID?

This is a good point. If the file handle is not tied to a particular
file system mount then an application can stash a well-known file handle
(e.g. /) from one mount it has full access to and then use open a file
on a mount that it does not have full directory treeaccess to (e.g. a
bind mount/sub-tree?).

Stefan

--MDxgyqJ0UkBYpRxk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBbJ8IACgkQnKSrs4Gr
c8j9UggAldQUYU9C4yzFKRKykIq+Y3YxZBY8DwrVzK5rdF6FuEoSkBqNlQAs+DKu
tkuYMfJuOFgiKewfM8rZFf+jm5gTw2t2TuLCMsY6GREd/9sjZiH7aPlhnfpWjdbi
HfOBlaseIhxfLkal38CbIIGTIPTLWH6XXr97h6nLA5P0PO01QBnDNDq2MBe7gsXA
UC3WHC+cmeRQ9YGalLx1jXtBUHJmtE2foTJGaXrhBJ9F+xQChFpFZrRQLJ+WLH3R
OrafO1CyrzKNjgySN9FDJs8DSCl1261WxlfXXu7vadoVdGYRT8swkHO47VSNdwI9
1apS1sK5+a9O6ad363eD62Waa+sYGg==
=eDfu
-----END PGP SIGNATURE-----

--MDxgyqJ0UkBYpRxk--

