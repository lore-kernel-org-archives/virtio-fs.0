Date: Fri, 6 Sep 2019 12:12:23 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190906111223.GD2699@work-vm>
References: <20190905152136.30637-1-stefanha@redhat.com>
	<20190905152136.30637-3-stefanha@redhat.com>
	<20190905172732.GQ2700@work-vm>
	<20190906102328.GE5900@stefanha-x1.localdomain>
	<20190906104953.GV5119@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20190906104953.GV5119@redhat.com>
Subject: Re: [Virtio-fs] [Qemu-devel] [RFC 2/3] virtiofsd: add DBus server
 to handle log level changes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: virtio-fs@redhat.com, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, qemu-devel@nongnu.org

* Daniel P. Berrang=E9 (berrange@redhat.com) wrote:
> On Fri, Sep 06, 2019 at 11:23:28AM +0100, Stefan Hajnoczi wrote:
> > On Thu, Sep 05, 2019 at 06:27:32PM +0100, Dr. David Alan Gilbert wrote:
> > > * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > > > Introduce a DBus server thread that runs alongside the other virtio=
fsd
> > > > threads.  It processes changes to the /org/qemu/virtiofsd object wh=
ich
> > > > can be accessed at the org.qemu.virtiofsd location on the bus.
> > > >=20
> > > > This code does not use locking because we are the only writer to the
> > > > int current_log_level variable.  More advanced management commands =
would
> > > > require locking to prevent race conditions with the other threads.
> > > >=20
> > > > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > >=20
> > > OK, that is less complex than I'd feared.
> > > I guess there's something probably nice to do with name/integer mappi=
ng
> > > for warning levels that we could use from one of the libraries.
> >=20
> > I used a free-form string because it's what systemd's LogLevel property
> > also does.  But I can investigate the cleanest approach for limiting it
> > to a set of string constants.
>=20
> There's no concept of "enums" at the DBus protocol level. Sending enums
> in string form is the normal practice - avoiding integer values means
> you are not vulnerable to enum values changing if someone inserts a new
> constant in the middlle of the enum. This same reason is why QAPI uses
> strings for enums instead of ints.

Oh, I wasn't talking aobut changing protocol; I just meant there was
probably a neater way of doing the string look up than the opencoded way
it was done.

Dave

> Regards,
> Daniel
> --=20
> |: https://berrange.com      -o-    https://www.flickr.com/photos/dberran=
ge :|
> |: https://libvirt.org         -o-            https://fstop138.berrange.c=
om :|
> |: https://entangle-photo.org    -o-    https://www.instagram.com/dberran=
ge :|
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

