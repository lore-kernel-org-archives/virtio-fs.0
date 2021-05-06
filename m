Date: Thu, 6 May 2021 16:32:46 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJQMHh0U+qWekguO@stefanha-x1.localdomain>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-25-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="uYmuTQLrCxwedF5s"
Content-Disposition: inline
In-Reply-To: <20210428110100.27757-25-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 24/26] vhost-user-fs: Extend
 VhostUserFSSlaveMsg to pass additional info
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com


--uYmuTQLrCxwedF5s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 28, 2021 at 12:00:58PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> @@ -144,6 +148,8 @@ typedef struct {
>  } VhostUserFSSlaveMsgEntry;
> =20
>  typedef struct {
> +    /* Generic flags for the overall message */
> +    uint32_t flags;
>      /* Number of entries */
>      uint16_t count;
>      /* Spare */

Please introduce the uint32_t field as a reserved field in the earlier
patch that left a hole in the struct. Everything is okay once we get to
this patch but the earlier patches should have avoided the hole too
(they had the confusing uint16_t padding field which was not enough to
avoid the 64-bit alignment hole).

--uYmuTQLrCxwedF5s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCUDB4ACgkQnKSrs4Gr
c8jTtQf/eLmojdYXkaG9x2oqZfUnUE0tGl1k6spkBTM/Bgh3A1CeHJJMI5et/Thi
OpxPyOf10a/wJ5/jmDRyR4VXSpwhwLE555OiA9Oy5DTnNu62MIzPNukBX4pPsfUU
5KhP6OU3Ik4VoNV0i0icUrMyIYr/ePYbCfvqKiQbG16kTijC2QFGtAkHC2oh4P7r
WT9v7zT3TuQoIoPz2gj293kHv1gLEt5gITNUAESOZ1n9doD+eVBciqEN9kRkHjC+
MAIifoIdYgJ3YfH4lANoy3qr7esDrePy/MLAxlAfDpvT20sODL49SYxFRCIkcVSg
xGohp+cftiJWkl7ZWLEm1bXX6ofZAg==
=kmeA
-----END PGP SIGNATURE-----

--uYmuTQLrCxwedF5s--

