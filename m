Return-Path: <gmaglion@redhat.com>
MIME-Version: 1.0
References: <4362261a-c762-4666-84e2-03c9daa6c4d9@www.fastmail.com>
 <YzMmu3xfOtQwuFUx@redhat.com> <YzMrYAJQeSP2hDSs@redhat.com>
In-Reply-To: <YzMrYAJQeSP2hDSs@redhat.com>
From: German Maglione <gmaglione@redhat.com>
Date: Tue, 27 Sep 2022 19:27:02 +0200
Message-ID: <CAJh=p+5rQDBJJC8VNGL10KYgDeq-Hg5WK7avONCti03eJGH+ow@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] virtiofsd: Any reason why there's not an "openat2"
 sandbox mode?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Colin Walters <walters@verbum.org>, qemu-devel@nongnu.org, virtio-fs-list <virtio-fs@redhat.com>, Sergio Lopez <slp@redhat.com>

On Tue, Sep 27, 2022 at 6:57 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Sep 27, 2022 at 12:37:15PM -0400, Vivek Goyal wrote:
> > On Fri, Sep 09, 2022 at 05:24:03PM -0400, Colin Walters wrote:
> > > We previously had a chat here https://lore.kernel.org/all/348d4774-bd5f-4832-bd7e-a21491fdac8d@www.fastmail.com/T/
> > > around virtiofsd and privileges and the case of trying to run virtiofsd inside an unprivileged (Kubernetes) container.
> > >
> > > Right now we're still using 9p, and it has bugs (basically it seems like the 9p inode flushing callback tries to allocate memory to send an RPC, and this causes OOM problems)
> > > https://github.com/coreos/coreos-assembler/issues/1812
> > >
> > > Coming back to this...as of lately in Linux, there's support for strongly isolated filesystem access via openat2():
> > > https://lwn.net/Articles/796868/
> > >
> > > Is there any reason we couldn't do an -o sandbox=openat2 ?  This operates without any privileges at all, and should be usable (and secure enough) in our use case.
> >
> > [ cc virtio-fs-list, german, sergio ]
> >
> > Hi Colin,
> >
> > Using openat2(RESOLVE_IN_ROOT) (if kernel is new enough), sounds like a
> > good idea. We talked about it few times but nobody ever wrote a patch to
> > implement it.
> >
> > And it probably makes sense with all the sandboxes (chroot(), namespaces).
> >
> > I am wondering that it probably should not be a new sandbox mode at all.
> > It probably should be the default if kernel offers openat2() syscall.
> >
> > Now all the development has moved to rust virtiofsd.
> >
> > https://gitlab.com/virtio-fs/virtiofsd
> >
> > C version of virtiofsd is just seeing small critical fixes.
> >
> > And rust version allows running unprivileged (inside a user namespace).
> > German is also working on allowing running unprivileged without
> > user namespaces but this will not allow arbitrary uid/gid switching.
> >
> > https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/136
> >
> > If one wants to run unprivileged and also do arbitrary uid/gid switching,
> > then you need to use user namepsaces and map a range of subuid/subgid
> > into the user namepsace virtiofsd is running in.
> >
> > If possible, please try to use rust virtiofsd for your situation. Its
> > already packaged for fedora.
> >
> > Coming back to original idea of using openat2(), I think we should
> > probably give it a try in rust virtiofsd and if it works, it should
> > work across all the sandboxing modes.
>
> Thinking more about it, enabling openat2() usage conditionally based on
> some option probably is not a bad idea. I was assuming that using
> openat2() by default will not break any of the existing use cases. But
> I am not sure. I have burnt my fingers so many times and had to back
> out on default settings that enabling usage of openat2() conditionally
> will probably be a safer choice. :-)
>

I could work on this for the next major version and see if anything breaks.
But I prefer to add this as a compilation feature, instead of a command line
option that we will then have to maintain for a while.

Also, I don't see it as a sandbox feature, as Stefan mentioned, a compromised
process can call openat2() without RESOLVE_IN_ROOT. I did some test with
Landlock to lock virtiofsd inside the shared directory, but IIRC it requires a
kernel 5.13

Cheers,
-- 
German

