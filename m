Date: Thu, 29 Aug 2019 13:35:28 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190829123528.GA18693@stefanha-x1.localdomain>
References: <20190821173742.24574-1-vgoyal@redhat.com>
	<CAJfpegv_XS=kLxw_FzWNM2Xao5wsn7oGbk3ow78gU8tpXwo-sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <CAJfpegv_XS=kLxw_FzWNM2Xao5wsn7oGbk3ow78gU8tpXwo-sg@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v3 00/13] virtio-fs: shared file system for
 virtual machines
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 29, 2019 at 11:28:27AM +0200, Miklos Szeredi wrote:
> On Wed, Aug 21, 2019 at 7:38 PM Vivek Goyal <vgoyal@redhat.com> wrote:

Thanks!

>  - removed option parsing completely.  Virtiofs config is fixed to "-o
> rootmode=040000,user_id=0,group_id=0,allow_other,default_permissions".
> Does this sound reasonable?

That simplifies things for users and I've never seen a need to change
these options in virtio-fs.  If we need the control for some reason in
the future we can add options back in again.

> I think we also need something in
> "Documentation/filesystems/virtiofs.rst" which describes the design
> (how  request gets to userspace and back) and how to set up the
> server, etc...  Stefan, Vivek can you do something like that?

Sure.  I'll send a patch.

Stefan

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1nxpAACgkQnKSrs4Gr
c8jjQwgAvWE4oapn65FxQy/VdB7RtefE3yzw3Eqivc7NYcdOZJxKNpfeU7w5HEgY
QK6WGmXSW7udfIoPEmVO9MLd9G4+sjbewz5OhGKYm8b0rDfGXPTD9JZO75MkvrSO
3nTLOX7Qoe2omYOyCcwQRXqFujBerFwsY22L0+QnubAWgHgHuV4+vgUKc1iJ6PlD
7jDG5W6l0omMY2G7kym4QYr/jk67cRdzUonm3rYTKIy1q0xLzg/XeQta/rvXVfFB
vCx5+Fks5LZ6bO9Sj+SkzyP3etHAQH8dzYXtcuAsZk7clqcuYqGn4NSAHt+AqNFx
1e6kZW2gsPPyUfBAAIDYRkFJ28Dy9g==
=PAGO
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--

