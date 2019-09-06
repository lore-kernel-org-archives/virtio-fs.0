Date: Fri, 6 Sep 2019 12:48:38 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <20190906114838.GX5119@redhat.com>
References: <20190905152136.30637-1-stefanha@redhat.com>
	<20190905152136.30637-3-stefanha@redhat.com>
	<20190905172732.GQ2700@work-vm>
	<20190906102328.GE5900@stefanha-x1.localdomain>
	<20190906104953.GV5119@redhat.com> <20190906111223.GD2699@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190906111223.GD2699@work-vm>
Subject: Re: [Virtio-fs] [Qemu-devel] [RFC 2/3] virtiofsd: add DBus server
 to handle log level changes
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>, qemu-devel@nongnu.org

On Fri, Sep 06, 2019 at 12:12:23PM +0100, Dr. David Alan Gilbert wrote:
> * Daniel P. Berrangé (berrange@redhat.com) wrote:
> > On Fri, Sep 06, 2019 at 11:23:28AM +0100, Stefan Hajnoczi wrote:
> > > On Thu, Sep 05, 2019 at 06:27:32PM +0100, Dr. David Alan Gilbert wrote:
> > > > * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > > > > Introduce a DBus server thread that runs alongside the other virtiofsd
> > > > > threads.  It processes changes to the /org/qemu/virtiofsd object which
> > > > > can be accessed at the org.qemu.virtiofsd location on the bus.
> > > > > 
> > > > > This code does not use locking because we are the only writer to the
> > > > > int current_log_level variable.  More advanced management commands would
> > > > > require locking to prevent race conditions with the other threads.
> > > > > 
> > > > > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > 
> > > > OK, that is less complex than I'd feared.
> > > > I guess there's something probably nice to do with name/integer mapping
> > > > for warning levels that we could use from one of the libraries.
> > > 
> > > I used a free-form string because it's what systemd's LogLevel property
> > > also does.  But I can investigate the cleanest approach for limiting it
> > > to a set of string constants.
> > 
> > There's no concept of "enums" at the DBus protocol level. Sending enums
> > in string form is the normal practice - avoiding integer values means
> > you are not vulnerable to enum values changing if someone inserts a new
> > constant in the middlle of the enum. This same reason is why QAPI uses
> > strings for enums instead of ints.
> 
> Oh, I wasn't talking aobut changing protocol; I just meant there was
> probably a neater way of doing the string look up than the opencoded way
> it was done.

Oh sure, you can declare the enum in a header, and then run glib-mkenums
with that header file and it will spit out the code neccessary to
register a GEnum class. This gives you ability to do int/string conversions
with a simple api

  https://developer.gnome.org/gobject/stable/gobject-Enumeration-and-Flag-Types.html
  https://developer.gnome.org/gobject/stable/glib-mkenums.html

It makes sense to use this, since virtiofsd is already using GObject
via GDbus.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

