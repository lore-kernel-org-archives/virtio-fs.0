MIME-Version: 1.0
References: <20210121144429.58885-1-stefanha@redhat.com>
	<CAOssrKfjLrR0TXqPgk7sYAz9xiuNankgQpOtX69-zXWaGOnu6w@mail.gmail.com>
	<20210126101839.GC226981@stefanha-x1.localdomain>
In-Reply-To: <20210126101839.GC226981@stefanha-x1.localdomain>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Tue, 26 Jan 2021 11:27:18 +0100
Message-ID: <CAOssrKfc2zFgYfBVRmmNt2sW1Ktpwe2xCMz8__1-wHFV7SpCLA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: prevent opening of special files
	(CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: QEMU Developers <qemu-devel@nongnu.org>, P J P <ppandit@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, Alex Xu <alex@alxu.ca>, Vivek Goyal <vgoyal@redhat.com>

On Tue, Jan 26, 2021 at 11:18 AM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Mon, Jan 25, 2021 at 05:12:23PM +0100, Miklos Szeredi wrote:
> > On Thu, Jan 21, 2021 at 3:44 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> >
> > > This patch adds the missing checks to virtiofsd. This is a short-term
> > > solution because it does not prevent a compromised virtiofsd process
> > > from opening device nodes on the host.
> >
> > I think the proper solution is adding support to the host in order to
> > restrict opens on filesystems that virtiofsd has access to.
> >
> > My idea was to add a "force_nodev" mount option that cannot be
> > disabled and will make propagated mounts  also be marked
> > "force_nodev,nodev".
>
> Interesting idea! Mount options that are relevant:
>  * noexec
>  * nosuid
>  * nodev
>  * nosymfollow
>
> Do you have time to work on the force_* mount options?

Not at the moment, but first we need to probe Al to see if this idea sticks...

> > A possibly simpler solution is to extend seccomp to restrict the
> > process itself from being able to open special files.  Not sure if
> > that's within the scope of seccomp though.
>
> I don't think seccomp can provide that restriction since it's unrelated
> to the syscall or its arguments.

How about selinux, then?

Thanks,
Miklos

