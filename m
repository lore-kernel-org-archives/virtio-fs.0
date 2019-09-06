Date: Fri, 6 Sep 2019 11:35:23 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190906103523.GB2699@work-vm>
References: <20190905152136.30637-1-stefanha@redhat.com>
	<20190905174021.GR2700@work-vm>
	<20190906102926.GF5900@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906102926.GF5900@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [RFC 0/3] virtiofsd: get/set log level via DBus
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, qemu-devel@nongnu.org

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Thu, Sep 05, 2019 at 06:40:21PM +0100, Dr. David Alan Gilbert wrote:
> > * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > > It is likely that virtiofsd will need to support "management commands" for
> > > reconfiguring it at runtime.  The first use case was proposed by Eryu Guan for
> > > getting/setting the current log level.
> > > 
> > > I promised to try out DBus as the management interface because it has a rich
> > > feature set and is accessible from most programming languages.  It should be
> > > able to support all the use cases we come up with.
> > > 
> > > This patch series is a prototype that implements the get-log-level and
> > > set-log-level management commands via DBus.  Use the new virtiofsctl tool to
> > > talk to a running virtiofsd process:
> > > 
> > >   # dbus-run-session ./virtiofsd ...
> > >   ...
> > >   Using dbus address unix:abstract=/tmp/dbus-H9WBbpjk3O,guid=0be16acefb868e6025a8737f5d7124d2
> > >   # export DBUS_SESSION_BUS_ADDRESS=unix:abstract=/tmp/dbus-H9WBbpjk3O,guid=0be16acefb868e6025a8737f5d7124d2
> > >   # ./virtiofsctl set-log-level err
> > > 
> > > Most of the work is done by gdbus-codegen(1).  It generates code for the
> > > org.qemu.Virtiofsd.xml interface definition.  Our code can use the simple
> > > virtiofsd_get/set_log_level() APIs and it will make corresponding DBus calls.
> > > 
> > > I'm pretty happy with this approach because the code is straightforward.  It
> > > hasn't even triggered seccomp failures yet :).
> > 
> > Yes it's less complex than I'd worried.
> > Now, I do think we've got to think about how qemu in general is going to
> > use dbus as people were discussing it, because then we have to think
> > what the security aspects are - do we need to look at some calls only
> > available to some clients etc.
> 
> The approach I took in this patch series is to launch a session bus just
> for this virtiofsd.  The abstract socket unix(7) namespace used by GDBus
> by default does not offer any security.  I think any process on the host
> can connect to it, regardless of uid/gid.
> 
> A path like unix:path=/tmp/foo would allow us to use UNIX Domain Socket
> permissions as the main security mechanism.

Yes, that I'm fine with; my worry is that there was talk of much more
complex dbus setups coming out of the qemu world with many things being
connected; and then we have to think about security upfront.

>  I'm not enthusiastic about
> using SELinux or some kind of DBus-specific policy language if we can
> avoid it because it's complex and obscure.

Right.

Dave

> Stefan


--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

