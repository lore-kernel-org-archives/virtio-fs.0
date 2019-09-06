Date: Fri, 6 Sep 2019 11:23:28 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190906102328.GE5900@stefanha-x1.localdomain>
References: <20190905152136.30637-1-stefanha@redhat.com>
	<20190905152136.30637-3-stefanha@redhat.com>
	<20190905172732.GQ2700@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="k3qmt+ucFURmlhDS"
Content-Disposition: inline
In-Reply-To: <20190905172732.GQ2700@work-vm>
Subject: Re: [Virtio-fs] [RFC 2/3] virtiofsd: add DBus server to handle log
	level changes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, qemu-devel@nongnu.org


--k3qmt+ucFURmlhDS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 05, 2019 at 06:27:32PM +0100, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > Introduce a DBus server thread that runs alongside the other virtiofsd
> > threads.  It processes changes to the /org/qemu/virtiofsd object which
> > can be accessed at the org.qemu.virtiofsd location on the bus.
> >=20
> > This code does not use locking because we are the only writer to the
> > int current_log_level variable.  More advanced management commands would
> > require locking to prevent race conditions with the other threads.
> >=20
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
>=20
> OK, that is less complex than I'd feared.
> I guess there's something probably nice to do with name/integer mapping
> for warning levels that we could use from one of the libraries.

I used a free-form string because it's what systemd's LogLevel property
also does.  But I can investigate the cleanest approach for limiting it
to a set of string constants.

Stefan

--k3qmt+ucFURmlhDS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1yM6AACgkQnKSrs4Gr
c8ibkQf/dj60BBfKOmis/SmblMlFBwmZEnKcUwgfEso5mZwoRf+ONf+2pC3Gn3GQ
gPB45AL1qvAiSxRlZ4K4AKB+tUkPShjAEwGNMM1kp1HHO1fL3gL9wGwxejjkPXVI
44xHJqq5F9Hst2YRwGwU3UwoE3AoTphy/FvGjfU2yNCJOu7L3ftUnpIvl/xjmSgi
pUZN1j9Z6zWHm8gAaIgX4UGsDRD4vbTPeAsA9D+D7LdJN64WknmcmjU/wENjaWSn
4R1yJe2p5avYtiXEfQsF/mFMW+oF/bZLorbta7lcmK2vfeqz84APfeJORLtbal8l
AXTthC8gchi8FsxxClxOC6Gjr8HjSA==
=LCwc
-----END PGP SIGNATURE-----

--k3qmt+ucFURmlhDS--

