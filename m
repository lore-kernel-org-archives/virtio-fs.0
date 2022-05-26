Return-Path: <slp@redhat.com>
Date: Thu, 26 May 2022 10:06:46 +0200
From: Sergio Lopez <slp@redhat.com>
Message-ID: <20220526080646.vsfmqgxyiglhe64r@mhamilton>
References: <BY5PR14MB3893A6AA17C5FEBE843B640286D99@BY5PR14MB3893.namprd14.prod.outlook.com>
 <Yo8xDlTWijVMVNli@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="feyfazohf67u3abn"
Content-Disposition: inline
In-Reply-To: <Yo8xDlTWijVMVNli@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] vhost_set_vring_kick failed
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Prashant Dewan <linux_learner@outlook.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, gmaglione@redhat.com


--feyfazohf67u3abn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 26, 2022 at 08:49:34AM +0100, Stefan Hajnoczi wrote:
> On Thu, May 26, 2022 at 05:34:42AM +0000, Prashant Dewan wrote:
> > Hello Stefan,
> >=20
> > Here is the output from virtofsd..
> >=20
> > ------------------------------------
> > - Journal begins at Thu 2022-05-26 04:23:42 UTC, ends at Thu 2022-05-26=
 04:41:57 UTC. --
> > May 26 04:24:13 localhost systemd[1]: Started virtio-fs vhost-user devi=
ce daemon.<<Placeholder: run this daemon as non-privileged user>>.
> > May 26 04:24:13 localhost virtiofsd[505]: [2022-05-26T04:24:13Z INFO  v=
irtiofsd] Waiting for vhost-user socket connection...
> > May 26 04:27:11 device-3e4b479e2ee9c647 virtiofsd[505]: [2022-05-26T04:=
27:11Z INFO  virtiofsd] Client connected, servicing requests
> > May 26 04:27:33 device-3e4b479e2ee9c647 virtiofsd[505]: [2022-05-26T04:=
27:33Z ERROR virtiofsd] Waiting for daemon failed: HandleRequest(InvalidPar=
am)
>=20
> virtiofsd terminated. I have CCed Sergio and German, who may have
> suggestions about what to check next.

Hi,

Could you please tell us which QEMU version are you running, and paste
here the its command line?

Thanks,
Sergio.

--feyfazohf67u3abn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAmKPNRMACgkQ9GknjS8M
AjWQqQ//VMhoUpU/3z5bX4+aYFYQ1y7bmOJgUXZSsKsng2jD6I92HTaP0mwZn/1n
SyNBf104uJUMjb+NVNlj+Td7h284NZ2BHbaAOcEMwacjpvU7TP+AG37U1eCxGHSA
f4bsjrRrNrLux4IrWFOtXD53pDzf63JUMj9utdtbMHgqxxgdXqW/5MQzG2rngkUu
/hZhxQk/abOtyY6Gs8ES9rvs2FTArdOHbF92HdLXcMLj904sLkBqtkBO4lad2kqx
p3t0E5ONP2mBfsRsKZNLRhKSqAPX4gGKOnDxFnslDUf8N9W+U04POMFXJuXCVclV
YzYUrU+j8SPeCB5N1ynYiogx/vgIa4oUxl8vwjmx8uuc6BTqlppF1hM1WCWXxOaW
KAQPZeF0hTaoPfza810mA5kleqZB9lI2RPFCB+51KSwoQ8V2ZVjS8Ka93kaT8Ukl
xWU7zeMIxj47djB3Rx+Fdz2Sr9O8jIWoUUVjb4Udx2N4zJjrQ/d1Lm83R3Z7ygTK
SfT4QKxFpf6lP5jjMO6LvaIG8Ec5l7OLeoJrs3j72BgkoZ0TdU/J9BhR+MVhVzgf
58KJNnm8JyS7qDKVid9E1jiwXs38faTXb2zga/ZsFDfE08pMQZrBtP53n48NlBw7
rsGsQ1DZ1t2mxgVl/6ctZnWMCGHxLFG3tV1wVkTLT9Jtt7LQs5E=
=+EMf
-----END PGP SIGNATURE-----

--feyfazohf67u3abn--
