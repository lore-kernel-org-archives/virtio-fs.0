Date: Tue, 25 Aug 2020 16:51:40 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200825155140.GA16427@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
Subject: [Virtio-fs] Windows drivers in Fedora virtio-win ISO
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: ghammer@redhat.com
Cc: virtio-fs@redhat.com, o.popov@livelace.ru


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Gal,
On #virtio-fs freenode IRC it was just mentioned that the Fedora
virtio-win "latest" ISO now includes virtio-fs drivers:

15:48 < livelace> It looks like virtio-win contains some virtiofs stuff
15:49 < livelace> 07/15/2020  06:22 PM            55,496 viofs.sys

This is great news! We've had questions about the status of Windows
support recently and this will help many users.

Can you provide a HowTo for the virtio-fs website
(https://virtio-fs.gitlab.io/) so there are instructions on installing
and using the driver?

If you don't have time to write an HTML HowTo (the website git repo is
here: https://gitlab.com/virtio-fs/virtio-fs.gitlab.io) I can format it
for you. Just an email reply would be great.

Thanks,
Stefan

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl9FM4wACgkQnKSrs4Gr
c8hKmgf+OM/SOIxDmOirU1cP53UaZQ3RMgJjW6s4V5LFf7Y/zLkZcmffHjYMysWt
YwwWkTm1DYOIcToEewbbuNqIO3LKneJLDem1Xddn130BQ55sGpy5hH24bnG/VC27
BypAxkwrT6fWaqiIfaz7Yacn/YXnMHfrjLsJSVvQfjX+xaU2h2anc76kf2rwUJJU
8oRApme1b9fFTo/pI97fSVom7OD2LjWw08u5r3dLed6clsIsi7z9B6omuTLOQMZZ
2XceJgNkfp3Sf8t89ZrgMBvVI3EqsdP3TR+Ynemn5m1iKyZO/XSxP8w+MNLaspCh
hF40cyaPaFO3b/pTWwgjHPvBOGvd4Q==
=3fwM
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--

