Date: Mon, 7 Dec 2020 15:52:09 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201207205209.GD3107@redhat.com>
References: <CAFqZXNsGabHBfV36nNAVLJgEzjkBev-O3YZ1vnmXyVoaDdjiHQ@mail.gmail.com>
	<CAHC9VhRCu5W4YOzcidUhv7biVc+a4QrRknVn-57YVSM3vWZH+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRCu5W4YOzcidUhv7biVc+a4QrRknVn-57YVSM3vWZH+Q@mail.gmail.com>
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
To: Paul Moore <paul@paul-moore.com>
Cc: SElinux list <selinux@vger.kernel.org>, Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, Zdenek Pytela <zpytela@redhat.com>

On Mon, Dec 07, 2020 at 10:03:24AM -0500, Paul Moore wrote:
> On Mon, Dec 7, 2020 at 9:43 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> >
> > Hi everyone,
> >
> > In [1] we ran into a problem with the current handling of filesystem
> > labeling rules. Basically, it is only possible to specify either
> > genfscon or fs_use_xattr for a given filesystem, but in the case of
> > virtiofs, certain mounts may support security xattrs, while other ones
> > may not.
> 

[ cc virtio-fs list and miklos ]
> Quickly skimming the linked GH issue, it appears that the problem
> really lies in the fact that virtiofs allows one to enable/disable
> xattrs at mount time.  What isn't clear to me is why one would need to
> disable xattrs, can you explain that use case?  Why does enabling
> xattrs in virtiofs cause problems?

Its not exactly a mount time option. Its a virtiofs file server option.

xattr support by default is disabled because it has performance
penalty. Users can enable it if they want to.

So if virtiofsd starts without xattr support and somebody runs a
VM with SELinux enabled, they should still be able to mount virtiofs,
I guess (instead of failing it).

Thanks
Vivek

