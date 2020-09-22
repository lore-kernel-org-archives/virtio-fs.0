Date: Tue, 22 Sep 2020 08:40:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200922124038.GA57620@redhat.com>
References: <20200921213216.GE13362@redhat.com>
	<CAJfpegujM0ygoBT5uPf4zBUDiphDTwgu97NfqaEgaa8HoSnuRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegujM0ygoBT5uPf4zBUDiphDTwgu97NfqaEgaa8HoSnuRw@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Used glib "shared" thread pool
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

On Tue, Sep 22, 2020 at 02:03:18PM +0200, Miklos Szeredi wrote:
> On Mon, Sep 21, 2020 at 11:32 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > glib offers thread pools and it seems to support "exclusive" and "shared"
> > thread pools.
> >
> >
> > https://developer.gnome.org/glib/stable/glib-Thread-Pools.html#g-thread-pool-new
> >
> > Currently we use "exlusive" thread pools but its performance seems to be
> > poor. I tried using "shared" thread pools and performance seems much
> > better. I posted performance results here.
> >
> > https://www.redhat.com/archives/virtio-fs/2020-September/msg00080.html
> >
> > So lets switch to shared thread pools. We can think of making it optional
> > once somebody can show in what cases exclusive thread pools offer better
> > results. For now, my simple performance tests across the board see
> > better results with shared thread pools.
> >
> 
> Needs this as well:

Thanks Miklos. I am wondering why I did not face this issue. May be
I don't have seccomp enabled. Will check.

David, can you please pick this patch as well. May be merge both
the patches.

Do let me know if you want to me post a merged patch instead.

Thanks
Vivek

> 
> --- qemu.orig/tools/virtiofsd/passthrough_seccomp.c 2020-09-16
> 20:21:13.168686176 +0200
> +++ qemu/tools/virtiofsd/passthrough_seccomp.c 2020-09-22
> 14:01:38.499164501 +0200
> @@ -94,6 +94,8 @@ static const int syscall_whitelist[] = {
>      SCMP_SYS(rt_sigaction),
>      SCMP_SYS(rt_sigprocmask),
>      SCMP_SYS(rt_sigreturn),
> +    SCMP_SYS(sched_getattr),
> +    SCMP_SYS(sched_setattr),
>      SCMP_SYS(sendmsg),
>      SCMP_SYS(setresgid),
>      SCMP_SYS(setresuid),
> 
> Thanks,
> Miklos

