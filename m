Date: Tue, 12 Nov 2019 09:45:14 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191112094514.GA463128@stefanha-x1.localdomain>
References: <CAJFHJrrqfjQqMu-K99DiBYNmD1=hB710wRZ88w--SQ0GxQv9Tw@mail.gmail.com>
	<20191015155749.GH3073@work-vm>
	<CAJFHJroxYvu_cfwCCxdWV_mN-0pxZ4qBbXdjiJEzPECui-ygrA@mail.gmail.com>
	<20191015162634.GI3073@work-vm>
	<ac410eee095de0faf2e8ccd3f917e322c7d68384.camel@intel.com>
	<CAJFHJrpwkry6r9WDf=4aY2ONUvXKvm_BqWrONFfgRboqGony9g@mail.gmail.com>
	<20191016141407.GB5487@stefanha-x1.localdomain>
	<59aa4481a68fe627ee7dfa34f01f4c8f16b1e969.camel@intel.com>
	<20191016183815.GD14762@stefanha-x1.localdomain>
	<923a5ab7b17371fe1b702717c125d89f7e76bf5b.camel@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <923a5ab7b17371fe1b702717c125d89f7e76bf5b.camel@intel.com>
Subject: Re: [Virtio-fs] xfstest results for virtio-fs on aarch64
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Cc: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "Bradford,
	Robert" <robert.bradford@intel.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "masayoshi.mizuma@fujitsu.com" <masayoshi.mizuma@fujitsu.com>, "Ortiz, Samuel" <samuel.ortiz@intel.com>, "vgoyal@redhat.com" <vgoyal@redhat.com>


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 01, 2019 at 10:26:54PM +0000, Boeuf, Sebastien wrote:
> +Samuel
> +Rob
>=20
> Hi Stefan, Dave,
>=20
> I had some time to get started on the virtiofsd in Rust, based on the
> code from Chirantan. So basically I relied on the following Crosvm
> branch (code not merged yet):
> https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/1=
705654
>=20
> From there I have ported the code that was needed to rely on the nice
> implementation from Chirantan. I had to make it fit the vm-virtio crate
> from Cloud-Hypervisor (since it's not yet complete on rust-vmm), and
> also the vm-memory crate from rust-vmm.
>=20
> Once the porting done, I created a dedicated vhost-user-fs daemon
> binary relying on the vhost_user_backend crate. I connected all the
> dots together and the result is here:
> https://github.com/intel/cloud-hypervisor/pull/404
>=20
> I have listed the remaining tasks here:=20
> https://github.com/intel/cloud-hypervisor/pull/404#issue-335636924
> (some can be quite big and should come as a follow up PR IMO).
>=20
> I'll be in vacation next week, but if you have some time, it'd be very
> nice to get everybody's feedback on this.
>=20
> And of course, if you have more time to continue working on this, feel
> free to reuse my branch 'vhost_user_fs_daemon' from my forked repo=20
> https://github.com/sboeuf/cloud-hypervisor-1.git

Awesome, thanks!

Stefan

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl3KfyoACgkQnKSrs4Gr
c8hRfggAo8NNuQgFXcEveY8j/olrmy+6jFndtruKpRoaUEH4JgdJAdAA4DKREgpC
p0WCYPxuuclLIDhbTFFcdm/aXtMhjZlYWY2qhSs7uC41VCCjBskMP22pWS8hS0Lc
qc5/gOuMCkL+8ZyC5CQgdhKrejnxORX5sm0MZ9eYY+FM2SBF5QAOWIR1uCDtvONf
9jEgXH945sLjJ/rQsqzJqW1XIlRnNWm8J/3d1subZOsP74s/Mo7Tu7MM0xlFlNj4
8bRmBJFprrYOsP6M2He3tyUgS91du5ZdXkcIwps8AvpJM+8mnm1R7RqkhiFjpa6L
Q5dB0YYgHmVf/bXvJS7CXGZv7hptLw==
=0xUt
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--

