Date: Tue, 14 Jan 2020 12:25:42 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200114122542.GH2812@work-vm>
References: <20200110190347.GA3855@work-vm>
	<4dcf854ab5133f4bc77191bd3f49aa8e9a96c57d.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <4dcf854ab5133f4bc77191bd3f49aa8e9a96c57d.camel@intel.com>
Subject: Re: [Virtio-fs] Changes in -dev branch
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

* Boeuf, Sebastien (sebastien.boeuf@intel.com) wrote:
> Hi Dave,
>=20
> On Fri, 2020-01-10 at 19:03 +0000, Dr. David Alan Gilbert wrote:
> > Hi,
> >    I've just pushed a new version of the virtio-fs-dev branch in
> >  https://gitlab.com/virtio-fs/qemu
> > =20
> > some things to note:
> >=20
> >   a) The old '-o vhost_user_socket' syntax has now been replaced
> >      by the syntax matching qemu's standardised vhost-user interface
> >      which is;
> >=20
> >      ./virtiofsd --socket-path=3D/path/whereever
>=20
> I was expecting that "./virtiofsd --socket-path /path/whereever" would
> work too, but it doesn't. Is this the expected behavior?
>=20
> Just asking cause it feels weird that we must add "=3D" here.

--socket-path=3D is the stadnard defined in qemu's
docs/interop/vhost-user.rst and fuse_lowlevel also seems
to standardise on options that take parameters using =3D.

Dave

> Thanks,
> Sebastien
>=20
> >=20
> >   b) It's got about 64 of the main patches reviewed by Daniel
> > Berrang=E9
> >      - about another 40 that need reviewing; please leap in
> >      and review any patches on the qemu-devel thread for any patches
> >      that are missing reviews.
> >=20
> >   c) The set that I've just pushed has fixes for all the things
> >      Daniel spotted; so there's a bunch of mostly minor changes.
> >=20
> >   d) It's also got patches that were received on list since
> >      mid December.
> >=20
> > Dave
> >=20
> > --
> > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> >=20
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs
> >=20
> ---------------------------------------------------------------------
> Intel Corporation SAS (French simplified joint stock company)
> Registered headquarters: "Les Montalets"- 2, rue de Paris,=20
> 92196 Meudon Cedex, France
> Registration Number:  302 456 199 R.C.S. NANTERRE
> Capital: 4,572,000 Euros
>=20
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

