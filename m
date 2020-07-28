Date: Tue, 28 Jul 2020 16:52:33 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <20200728155233.GC3443476@redhat.com>
References: <20200727190223.422280-1-stefanha@redhat.com>
	<20200727190223.422280-4-stefanha@redhat.com>
	<OSBPR01MB45826073E5A54CF869E56721E5730@OSBPR01MB4582.jpnprd01.prod.outlook.com>
	<CALDPj7syG0KPhtZEma5n403=YFZ2ptcD4MtP=GdrY9n1eUs5Eg@mail.gmail.com>
	<20200728131250.GB78409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200728131250.GB78409@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 3/3] virtiofsd: probe unshare(CLONE_FS)
 and print an error
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "vromanso@redhat.com" <vromanso@redhat.com>, "mpatel@redhat.com" <mpatel@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, Roman Mohr <rmohr@redhat.com>

On Tue, Jul 28, 2020 at 09:12:50AM -0400, Vivek Goyal wrote:
> On Tue, Jul 28, 2020 at 12:00:20PM +0200, Roman Mohr wrote:
> > On Tue, Jul 28, 2020 at 3:07 AM misono.tomohiro@fujitsu.com <
> > misono.tomohiro@fujitsu.com> wrote:
> > 
> > > > Subject: [PATCH v2 3/3] virtiofsd: probe unshare(CLONE_FS) and print an
> > > error
> > > >
> > > > An assertion failure is raised during request processing if
> > > > unshare(CLONE_FS) fails. Implement a probe at startup so the problem can
> > > > be detected right away.
> > > >
> > > > Unfortunately Docker/Moby does not include unshare in the seccomp.json
> > > > list unless CAP_SYS_ADMIN is given. Other seccomp.json lists always
> > > > include unshare (e.g. podman is unaffected):
> > > >
> > > https://raw.githubusercontent.com/seccomp/containers-golang/master/seccomp.json
> > > >
> > > > Use "docker run --security-opt seccomp=path/to/seccomp.json ..." if the
> > > > default seccomp.json is missing unshare.
> > >
> > > Hi, sorry for a bit late.
> > >
> > > unshare() was added to fix xattr problem:
> > >
> > > https://github.com/qemu/qemu/commit/bdfd66788349acc43cd3f1298718ad491663cfcc#
> > > In theory we don't need to call unshare if xattr is disabled, but it is
> > > hard to get to know
> > > if xattr is enabled or disabled in fv_queue_worker(), right?
> > >
> > >
> > In kubevirt we want to run virtiofsd in containers. We would already not
> > have xattr support for e.g. overlayfs in the VM after this patch series (an
> > acceptable con at least for us right now).
> > If we can get rid of the unshare (and potentially of needing root) that
> > would be great. We always assume that everything which we run in containers
> > should work for cri-o and docker.
> 
> But cri-o and docker containers run as root, isn't it? (or atleast have
> the capability to run as root). Havind said that, it will be nice to be able
> to run virtiofsd without root. 
> 
> There are few hurdles though.
> 
> - For file creation, we switch uid/gid (seteuid/setegid) and that seems
>   to require root. If we were to run unpriviliged, probably all files
>   on host will have to be owned by unpriviliged user and guest visible
>   uid/gid will have to be stored in xattrs. I think virtfs supports
>   something similar.

I think I've mentioned before, 9p virtfs supports different modes,
passthrough, squashed or remapped.

passthrough should be reasonably straightforward to support in virtiofs.
The guest sees all the host UID/GIDs ownership as normal, and can read
any files the host user can read, but are obviously restricted to write
to only the files that host user can write too. No DAC-OVERRIDE facility
in essence. You'll just get EPERM, which is fine. This simple passthrough
scenario would be just what's desired for a typical desktop virt use
cases, where you want to share part/all of your home dir with a guest for
easy file access. Personally this is the mode I'd be most interested in
seeing provided for unprivileged virtiofsd usage.

squash is similar to passthrough, except the guest sees everything
as owned by the same user. This can be surprising as the guest might
see a file owned by them, but not be able to write to it, as on the
host its actually owned by some other user. Fairly niche use case
I think.

remapping would be needed for a more general purpose use cases
allowing the guest to do arbitrary UID/GID changes, but on the host
everything is still stored as one user and remapped somehow.

The main challenge for all the unprivileged scenarios is safety of
the sandbox, to avoid risk of guests escaping to access files outside
of the exported dir via symlink attacks or similar.



Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

