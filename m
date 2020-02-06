Date: Thu, 6 Feb 2020 13:56:34 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <20200206135634.GN2391707@redhat.com>
References: <cover.1580403751.git.jtomko@redhat.com>
	<484b10cf2a837ba7bc13400321978aa2076f0967.1580403751.git.jtomko@redhat.com>
	<20200203164351.GV1922177@redhat.com> <20200203183609.GX18565@lpt>
	<20200206134658.GB84608@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200206134658.GB84608@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [libvirt PATCHv3 10/12] qemu: add code for handling
 virtiofsd
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
Cc: libvir-list@redhat.com, virtio-fs@redhat.com

On Thu, Feb 06, 2020 at 01:46:58PM +0000, Stefan Hajnoczi wrote:
> On Mon, Feb 03, 2020 at 07:36:09PM +0100, Ján Tomko wrote:
> > [adding virtiofs list]
> > 
> > On Mon, Feb 03, 2020 at 04:43:51PM +0000, Daniel P. Berrangé wrote:
> > > On Thu, Jan 30, 2020 at 06:06:26PM +0100, Ján Tomko wrote:
> > > > Start virtiofsd for each <filesystem> device using it.
> > > > 
> > > > Pre-create the socket for communication with QEMU and pass it
> > > > to virtiofsd.
> > > > 
> > > > Note that virtiofsd needs to run as root.
> > > 
> > > So we're not able to use  virtiofsd with the session libvirtd
> > > which runs completely unprivileged ?
> > > 
> > 
> > Not with the version of virtiofsd currently merged in the QEMU tree.
> > 
> > > I can understand the need to run as root if we want to support
> > > chown() of files, or DAC_OVERRIDE, but I'm surprised it isn't
> > > possible to run virtiofsd unprivileged & simply have a reduced
> > > featureset where it can only create files as that one user.
> > > 
> > 
> > Apart from the possibly missing features (I don't know how well
> > virtiofsd internals are ready for those), current version of the
> > daemon sets up namespaces and the seccomp sandbox.
> 
> Yes, running unprivileged is not a configuration that has been
> investigated yet.  Today virtiofsd needs to be launched as root.
> 
> It would be interesting to rely on user namespaces to provide
> unprivileged virtio-fs while still supporting more than 1 uid/gid.
> 
> I'm not a fan of using xattrs or other out-of-band information to store
> guest ownership and permission information.  That is inconvenient to
> manage (non-virtio-fs users of the directory won't see the right
> uid/gid), reduces performance, and likely has race conditions.

I don't think these problem needs to be considered a blockers for
the ablity to use as an unprivileged user.

There are valid use cases for virtiofs unprivileged, which would be
satisfied without needing the ability for the guest to use any UID
other than the one the host user has.

eg for desktop virt I run a VM as my unprivileged user and I simply
want to expose my $HOME (or a subdir) to that guest for convenient
file sharing. I'm using the same UID in host & guest for my login.

There is no reason for virtiofsd to need to store ownership/permissions
out of band. It can directly expose the host file ownership/permissions
to the guest, as 9p has been able todo. My guest will simply not be
able to chown() files, and will be bound by permissions as normal.

I also don't think we need the same security isolation for unprivileged
usage. 

IOW, I would simply like virtiofsd to be capable of simply disabling its
use of namespaces, and any other features which are forbidden to non-root
users. If guest operations on files result in EPERM that is fine.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

