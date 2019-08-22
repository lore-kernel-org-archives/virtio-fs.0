Date: Thu, 22 Aug 2019 16:35:03 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <20190822153503.GX3267@redhat.com>
References: <20190821085659.8448-1-eguan@linux.alibaba.com>
	<20190821150429.GH3309@work-vm>
	<3ca44559-d2ad-f72c-62ae-f44d13c1e0e4@huawei.com>
	<20190822141603.GA4553@stefanha-x1.localdomain>
	<CAMxuvaw2Mh97QQJojQ2uGTZP9hxHG8ya7x=RCsvc=iYGzFH+SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMxuvaw2Mh97QQJojQ2uGTZP9hxHG8ya7x=RCsvc=iYGzFH+SA@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: add support to change log level
 on fly
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>
Cc: virtio-fs@redhat.com

On Thu, Aug 22, 2019 at 06:33:05PM +0400, Marc-André Lureau wrote:
> Hi
> 
> On Thu, Aug 22, 2019 at 6:16 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> >
> > On Thu, Aug 22, 2019 at 01:07:18PM +0800, piaojun wrote:
> > > On 2019/8/21 23:04, Dr. David Alan Gilbert wrote:
> > > > * Eryu Guan (eguan@linux.alibaba.com) wrote:
> > > >> Introduce a file which contains the target log level, and
> > > >> current_log_level will be reloaded to the target log level on SIGHUP.
> > > >>
> > > >> The file is set to "/run/virtiofsd/log_level.<pid>". Due to
> > > >> sandboxing in virtiofsd, this file can only be read/write via
> > > >> /proc/<pid>/fd/<fd> for now.
> > > >>
> > > >> Example usage:
> > > >>
> > > >>   # view current log level
> > > >>   cat /proc/<pid>/fd/<fd>
> > > >>   # change log level to debug
> > > >>   echo debug > /proc/<pid>/fd/<fd>
> > > >>   kill -HUP <pid>
> > > >>
> > > >> Signed-off-by: Eryu Guan <eguan@linux.alibaba.com>
> > > >
> > > > This looks really complex for something that can only be used for
> > > > changing log levels.
> > >
> > > I have the same opinion with Dave, and I wonder if we have some easier
> > > channel to tell virtiofsd to change log level. And making the channel
> > > more generic is good for the expansibility of virtiofsd.
> >
> > Adding Dan and Marc-André, who have dealt with DBus and QMP.  They can
> > share their experience.
> >
> > The long-term concern we should think about is whether vhost-user
> > backends should have standardized management commands.  They would be
> > defined in docs/interop/vhost-user.rst and all backends implementing a
> > device type would implement a subset of them (plus additional
> > "vendor-specific commands" if they really don't fit into the vhost-user
> > specification).
> >
> > In order to have standard commands we need to choose a standard RPC
> > mechanism.  I'm pretty sure that DBus is a good choice based on my
> > previous discussions with Dan and Marc-André.  It is easy to use from
> > most programming languages and therefore easier to integrate than a
> > custom management channel.
> >
> > Dan and Marc-André: The first commands we would like to offer in
> > virtiofsd are:
> >
> >   get-log-level -> NUM
> >   Return the current logging threshold level.
> >
> >   set-log-level NUM
> >   Set the logging threshold level.
> >
> > If you have time to give a quick overview of how this looks in DBus that
> > would be very helpful.  The virtiofsd code is written in C and currently
> 
> Well that depends how generic we want the interface to be :)
> 
> https://dbus.freedesktop.org/doc/dbus-api-design.html
> 
> service-name: none, or org.qemu.VhostUser1 or even org.qemu.VirtioFs1 ?
> iface: org.qemu.VhostUser1, org.qemu.VirtioFs1 ?
> path: /org/qemu/VhostUser1
> property: "LogLevel", readwrite, string. If you follow systemd/syslogd:
> "this accepts a numerical log level or the well-known syslog(3)
> symbolic names (lowercase): emerg, alert, crit, err, warning, notice,
> info, debug."
> 
> Systemd also has "LogTarget" and a bunch of other options/properties
> that are settable from command line and at runtime with dbus (see man
> page).
> 
> 
> > does not use glib/gobject/gio heavily, so I think we'd prefer a
> > lightweight approach without a lot of gobject boilerplate, if possible.
> 
> If you can afford GIO, I would highly recommend it. Even if you have
> to run it in a seperate thread, that may be easier to maintain.
> 
> Otherwise, sdbus or libdbus.

sdbus is fairly nice if you absolutely must avoid GIO, but per my
other msg I'd strongly recommend just using GIO for C apps.

I would strongly recommend staying well away from libdbus. It is
a very low level API and has some very unfortunate design choices
which especially impact threaded usage. Most widely used DBus impls
have dropped / avoided libdbus these  days and just impl the wire
protocol themselves.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

