Return-Path: <slp@redhat.com>
Date: Wed, 28 Sep 2022 10:33:40 +0200
From: Sergio Lopez <slp@redhat.com>
Message-ID: <20220928083340.eyizwu6mm3cc3bxu@mhamilton>
References: <4362261a-c762-4666-84e2-03c9daa6c4d9@www.fastmail.com>
 <YzMmu3xfOtQwuFUx@redhat.com> <YzMrYAJQeSP2hDSs@redhat.com>
 <CAJh=p+5rQDBJJC8VNGL10KYgDeq-Hg5WK7avONCti03eJGH+ow@mail.gmail.com>
 <798fe353-9537-44fe-a76a-819e8c93abb5@www.fastmail.com>
 <YzNZnPiUqySu6sGh@fedora>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="lmyp75irfhdzyuhx"
Content-Disposition: inline
In-Reply-To: <YzNZnPiUqySu6sGh@fedora>
Subject: Re: [Virtio-fs] virtiofsd: Any reason why there's not an "openat2"
 sandbox mode?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Colin Walters <walters@verbum.org>, virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>


--lmyp75irfhdzyuhx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 27, 2022 at 04:14:20PM -0400, Stefan Hajnoczi wrote:
> On Tue, Sep 27, 2022 at 01:51:41PM -0400, Colin Walters wrote:
> >=20
> >=20
> > On Tue, Sep 27, 2022, at 1:27 PM, German Maglione wrote:
> > >
> > >> > Now all the development has moved to rust virtiofsd.
> >=20
> > Oh, awesome!!  The code there looks great.
> >=20
> > > I could work on this for the next major version and see if anything b=
reaks.
> > > But I prefer to add this as a compilation feature, instead of a comma=
nd line
> > > option that we will then have to maintain for a while.
> >=20
> > Hmm, what would be the issue with having the code there by default?  I =
think rather than any new command line option, we automatically use `openat=
2+RESOLVE_IN_ROOT` if the process is run as a nonzero uid.
> >=20
> > > Also, I don't see it as a sandbox feature, as Stefan mentioned, a com=
promised
> > > process can call openat2() without RESOLVE_IN_ROOT.=20
> >=20
> > I'm a bit skeptical honestly about how secure the existing namespace co=
de is against a compromised virtiofsd process.  The primary worry is guest =
filesystem traversals, right?  openat2+RESOLVE_IN_ROOT addresses that.  Plu=
s being in Rust makes this dramatically safer.
> >=20
> > > I did some test with
> > > Landlock to lock virtiofsd inside the shared directory, but IIRC it r=
equires a
> > > kernel 5.13
> >=20
> > But yes, landlock and other things make sense, I just don't see these t=
hings as strongly linked.  IOW we shouldn't in my opinion block unprivilege=
d virtiofsd on more sandboxing than openat2 already gives us.
>=20
> I think openat2(RESOLVE_IN_ROOT) support should be added unless there is
> another unprivileged mechanism that is stronger.
>=20
> The security implications need to be covered in the user documentation
> so people can decide whether using this mode is appropriate.
>=20
> We should continue to explain the difference between a voluntary
> mechanism like openat2(RESOLVE_IN_ROOT) and a mandatory mechanism like
> mount namespaces with pivot_root(2). Rust programs are not immune to
> arbitrary code execution, but it's less likely than with a C program.

I agree. Perhaps we could modify the "none" sandbox mode to use
openat2, if available, and add an "openat2" mode which does basically
the same thing, but bailing out if openat2 is not available.

And explain this clearly in the docs, of course.

Sergio.

--lmyp75irfhdzyuhx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAmM0BuMACgkQ9GknjS8M
AjXa9RAAmMn37H5nvrK0KlyhPF0aCUNMuALPhvCLC540vQBIsA6fOI8pNEQmfCuY
coosqUijnp0kW4Pk+O2JdKCYEa1M1ZhX+t7T0rOOEteCt4lw9S3egpQ0K6plVIfC
BRVDWJ/igh7OExX7Hb84gPLM4UzHqtDcE9/0Dm1feNuqu0pZUqK7jT5uVbu7fSeD
dj/+Z8u4SNIxobH0G17IZpTjb6r+P3RrgMplByH4PtqtyMf9oueObrBRm7MQmq8P
bQexURbGmKunHGtled8Zafuw4EB2vbKmTtnQxkV1l//yYmBCZyj74m70Wb3sHda0
6jiTlQbJxKgTlycmTBbtbkAUtcahQFmXEKCVOI2sIZz9JZ3rfwOvYENBARX6iGDU
/c91/fm9jGnmiv7aRTWZNyhlUl/xl7boPFPXe/llF+YzVur/M1UBEdZbFKbpbMj/
/yICFJ4lJQkBPLjB+mIBzo7gfmTchPQ6W/BP6LVoFvGhvcE6dL26x89/8UtdyxQT
zYiHvZgntqJ6MqXhW5Up8HFmShbVrCln4E6WaJmpEVjop7xTOBEp2oX6Ix3vbL9k
yTklajDYWfaRpehNUH9Q5fWOCq79kROEQ3mv75KZTc2ke2kf+x2MUJQwz9T3JRhR
Uq1+7hnLuiXtdDRDiL5oZ5sCxiEqX+znLPt6ao5sAb4p9ANE66A=
=yhfj
-----END PGP SIGNATURE-----

--lmyp75irfhdzyuhx--
