Date: Tue, 8 Dec 2020 09:33:36 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201208143336.GB3212@redhat.com>
References: <CAFqZXNsGabHBfV36nNAVLJgEzjkBev-O3YZ1vnmXyVoaDdjiHQ@mail.gmail.com>
	<CAHC9VhRCu5W4YOzcidUhv7biVc+a4QrRknVn-57YVSM3vWZH+Q@mail.gmail.com>
	<20201207205209.GD3107@redhat.com> <ypjlczzlmhus.fsf@defensec.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ypjlczzlmhus.fsf@defensec.nl>
Subject: Re: [Virtio-fs] virtiofs and its optional xattr support vs.
	fs_use_xattr
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Dominick Grift <dominick.grift@defensec.nl>
Cc: Paul Moore <paul@paul-moore.com>, SElinux list <selinux@vger.kernel.org>, Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, Zdenek Pytela <zpytela@redhat.com>

On Mon, Dec 07, 2020 at 10:22:35PM +0100, Dominick Grift wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Mon, Dec 07, 2020 at 10:03:24AM -0500, Paul Moore wrote:
> >> On Mon, Dec 7, 2020 at 9:43 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> >> >
> >> > Hi everyone,
> >> >
> >> > In [1] we ran into a problem with the current handling of filesystem
> >> > labeling rules. Basically, it is only possible to specify either
> >> > genfscon or fs_use_xattr for a given filesystem, but in the case of
> >> > virtiofs, certain mounts may support security xattrs, while other ones
> >> > may not.
> >> 
> >
> > [ cc virtio-fs list and miklos ]
> >> Quickly skimming the linked GH issue, it appears that the problem
> >> really lies in the fact that virtiofs allows one to enable/disable
> >> xattrs at mount time.  What isn't clear to me is why one would need to
> >> disable xattrs, can you explain that use case?  Why does enabling
> >> xattrs in virtiofs cause problems?
> >
> > Its not exactly a mount time option. Its a virtiofs file server option.
> >
> > xattr support by default is disabled because it has performance
> > penalty. Users can enable it if they want to.
> 
> if SELinux is enabled then you should preferably just use fs_use xattr unconditionally
> 
> >
> > So if virtiofsd starts without xattr support and somebody runs a
> > VM with SELinux enabled, they should still be able to mount virtiofs,
> > I guess (instead of failing it).
> 
> SELinux requires that everything is always labeled one way or another
> and so if SELinux is enabled one should either use genfscon or fs_use xattr
> 
> Since is support fs_use xattr that should be the default and if any
> would for any reason want to replace that with genfscon then that is
> something they have to address (by excluding the fs_use xattr rule and
> replacing it with a genfscon rule (not sure why anyone would ever want
> that)
> 
> Gist is that if SELinux is enabled then one of the two should be
> present, preferably fs_use xattr (so thats the default).

I understand that current state is that one needs to choose either
genfscon or fs_use_xattr depending on filesystem type. Will be nice
if this was more flexibile.

If virtiofsd is running on top of a filesystem which does not support
xattr, then also virtiofs mount will fail.

IOW, with virtiofs both kind of configurations can be easily produed
(xattr enabled or disabled). So none of the defaults (genfscon or
fs_use_xattr) seems to be ideal.

IIUC, policy is assuming that virtiofs will either always support xattr
or will not always support xattrs. Which probably is true for many
filesystems. But not necessarily in this case. So hard coding one
assumption will break other configurations. It will be nice if we there
is a way to fix this in policy.

Thanks
Vivek

