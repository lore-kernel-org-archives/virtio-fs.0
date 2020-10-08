Date: Thu, 8 Oct 2020 16:09:43 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201008150943.GA31472@stefanha-x1.localdomain>
References: <20201008110148.2757734-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <20201008110148.2757734-1-misono.tomohiro@jp.fujitsu.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: passthrough_ll: set
 FUSE_LOG_INFO as default log_level
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 08, 2020 at 08:01:48PM +0900, Misono Tomohiro wrote:
> Just noticed that although help message says default log level is INFO,
> it is actually 0 (EMRGE) and no mesage will be shown when error occurs.
> It's better to follow help message.
>=20
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> ---
>  tools/virtiofsd/passthrough_ll.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

I checked that FUSE_LOG_INFO isn't used in the main request code path.
Therefore this change shouldn't cause a lot of new log output or affect
performance:

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl9/K7YACgkQnKSrs4Gr
c8jJaQgAo/76CVJEKpEY/g8x81q7kfJOpZQhtVmJ9BivLBCerriLMDBhKnfEyf+0
Zj8FFvYU8ILU6HLLwQEG2QYvud+Th6d5DPwikw4fFEBk5Lm/zcE0ueCAOHI9+b9A
Q0hYS9zUADCQ1hT39pBISZmppB2tpQ+Fwsnl8a1kRm2ljQXk1eH1GGRtDZioiICo
vH++qkzr97yG3vuqU5tp8eZ5ji2Dm+greSSTI6VEM7OJoNyzxRor352JNj6jNpxc
lgSTV+trQzsSMlY03dU4mAQhiAG3E3zTr2kw8ypO86bssLXfPvJoL2JFXHMww0Ze
/BBekVgbzUlxeIWcmH2TjneKrpQxrw==
=dzcJ
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--

