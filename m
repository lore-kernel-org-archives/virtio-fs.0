MIME-Version: 1.0
References: <20200424133516.73077-1-mreitz@redhat.com>
	<20200427175902.GM2923@work-vm>
	<20200428145143.GB107541@stefanha-x1.localdomain>
	<CAOssrKcoXBAxE=Ld5ZY79G=Dy=qBh3HdSxxC+nMGJOX52rUxxg@mail.gmail.com>
	<20200428191523.GU2794@work-vm>
	<CAOssrKcsVvMok6i+vAm1KJaq07Ep9JLcMiB1nWhsNU2n1m-Fmw@mail.gmail.com>
In-Reply-To: <CAOssrKcsVvMok6i+vAm1KJaq07Ep9JLcMiB1nWhsNU2n1m-Fmw@mail.gmail.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Wed, 29 Apr 2020 11:26:49 +0200
Message-ID: <CAOssrKcZr4QXV1qLO7wmvdutkPKm59nSquPisEApBCWGx-c-uA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Show submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org, Max Reitz <mreitz@redhat.com>

On Wed, Apr 29, 2020 at 9:59 AM Miklos Szeredi <mszeredi@redhat.com> wrote:
>
> On Tue, Apr 28, 2020 at 9:15 PM Dr. David Alan Gilbert
> <dgilbert@redhat.com> wrote:
>
> > So our current sequence is:
> >
> >    (new namespace)
> >  1)    if (mount(NULL, "/", NULL, MS_REC | MS_SLAVE, NULL) < 0) {
> >  2)   if (mount("proc", "/proc", "proc",
> >            ....
> >  3)   if (mount(source, source, NULL, MS_BIND | MS_REC, NULL) < 0) {
> >  4)  (chdir newroot, pivot, chdir oldroot)
> >  5)   if (mount("", ".", "", MS_SLAVE | MS_REC, NULL) < 0) {
> >  6)   if (umount2(".", MNT_DETACH) < 0) {
> >
> > So are you saying we need a:
> >        if (mount(NULL, "/", NULL, MS_REC | MS_SHARED, NULL) < 0) {
> >
> >   and can this go straight after (1) ?
>
> Or right before (3).   Important thing is that that new mount will
> only receive propagation if the type of the mount at source (before
> (3) is performed) is shared.

And seems I was wrong.  Bind mounting clones the slave property, hence
no need to set MS_SHARED.  I.e. if the source was a slave, the bind
mount will be a slave to the same master as well; the two slaves won't
receive propagation between each other, but both will receive
propagation from the master.

The only reason to set MS_SHARED would be if the bind mount wanted to
receive propagation from within the cloned namespace.   Which is not
the case.

Didn't I tell ya it was complicated ;)

Thanks,
Miklos


