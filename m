Date: Thu, 22 Aug 2019 16:22:31 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <20190822152231.GW3267@redhat.com>
References: <20190821085659.8448-1-eguan@linux.alibaba.com>
	<20190821150429.GH3309@work-vm>
	<3ca44559-d2ad-f72c-62ae-f44d13c1e0e4@huawei.com>
	<20190822141603.GA4553@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190822141603.GA4553@stefanha-x1.localdomain>
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>

On Thu, Aug 22, 2019 at 03:16:03PM +0100, Stefan Hajnoczi wrote:
> On Thu, Aug 22, 2019 at 01:07:18PM +0800, piaojun wrote:
> > On 2019/8/21 23:04, Dr. David Alan Gilbert wrote:
> > > * Eryu Guan (eguan@linux.alibaba.com) wrote:
> > >> Introduce a file which contains the target log level, and
> > >> current_log_level will be reloaded to the target log level on SIGHUP.
> > >>
> > >> The file is set to "/run/virtiofsd/log_level.<pid>". Due to
> > >> sandboxing in virtiofsd, this file can only be read/write via
> > >> /proc/<pid>/fd/<fd> for now.
> > >>
> > >> Example usage:
> > >>
> > >>   # view current log level
> > >>   cat /proc/<pid>/fd/<fd>
> > >>   # change log level to debug
> > >>   echo debug > /proc/<pid>/fd/<fd>
> > >>   kill -HUP <pid>
> > >>
> > >> Signed-off-by: Eryu Guan <eguan@linux.alibaba.com>
> > > 
> > > This looks really complex for something that can only be used for
> > > changing log levels.
> > 
> > I have the same opinion with Dave, and I wonder if we have some easier
> > channel to tell virtiofsd to change log level. And making the channel
> > more generic is good for the expansibility of virtiofsd.
> 
> Adding Dan and Marc-André, who have dealt with DBus and QMP.  They can
> share their experience.

Back when QMP was first proposed I argued in favour of using a binary
protocol similar to libvirt's use of XDR. We're still suffering long
term pain from our use of JSON for QMP due to the inability to handle
64-bit integers in a portable manner.  In retrospect I really wish that
QEMU uses DBus for its machine monitor interface.

Since that time the use of DBus has only expanded across the open source
software space, and is most definitely not just for desktop apps.

It is very compelling

  - there are convenient APIs to use DBus from any common programming
    languages.
  - the wide usage makes it familiar to many developers
  - there are many tools for helping with debugging
  - it is easily consumed my mgmt apps like cockpit which use dbus
    for everything they mange

Overall I would recommend DBus over QMP every time.

In retrospect I also wish that libvirt's own RPC was using DBus
instead of our XDR based protocol.

> The long-term concern we should think about is whether vhost-user
> backends should have standardized management commands.  They would be
> defined in docs/interop/vhost-user.rst and all backends implementing a
> device type would implement a subset of them (plus additional
> "vendor-specific commands" if they really don't fit into the vhost-user
> specification).
> 
> In order to have standard commands we need to choose a standard RPC
> mechanism.  I'm pretty sure that DBus is a good choice based on my
> previous discussions with Dan and Marc-André.  It is easy to use from
> most programming languages and therefore easier to integrate than a
> custom management channel.
> 
> Dan and Marc-André: The first commands we would like to offer in
> virtiofsd are:
> 
>   get-log-level -> NUM
>   Return the current logging threshold level.
> 
>   set-log-level NUM
>   Set the logging threshold level.
> 
> If you have time to give a quick overview of how this looks in DBus that
> would be very helpful.  The virtiofsd code is written in C and currently
> does not use glib/gobject/gio heavily, so I think we'd prefer a
> lightweight approach without a lot of gobject boilerplate, if possible.

I'd venture to suggest that avoiding gobject / gio is actually the
heavyweight approach, as you will inevitably be re-inventing the
wheel to a large extent !

The boilerplate for creating gobject classes these days is not
anywhere near as verbose as people might have seen in the past,
from looking at much historical application code/docs. IMHO it
is more time efficient & less error/crash prone to write C apps
using GLib than to stick with plain C [1].

The GDBus APIs provided by GIO are a very nice & easy way to
provide DBus services and clients.

There's an example here:

  https://github.com/mikebrady/gdbus-tutorial/tree/master/src

note that most of the dbus boilerplate is autogenerated by
the gdbus-codegen command, from the DBus service specification,
so you only have to focus on writing the interesting code.

It goes with this presentation:

  https://aleksander.es/data/GNOMEASIA2014%20-%20Introduction%20to%20DBus.pdf
  https://www.youtube.com/watch?v=egj4UMPaylk

Regards,
Daniel

[1] its even more efficient to not use C, but that's a whole other
    can or worms :-)
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

