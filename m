Date: Wed, 29 Apr 2020 08:34:24 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200429123424.GA231284@redhat.com>
References: <20200424133516.73077-1-mreitz@redhat.com>
	<20200427175902.GM2923@work-vm>
	<20200428145143.GB107541@stefanha-x1.localdomain>
	<CAOssrKcoXBAxE=Ld5ZY79G=Dy=qBh3HdSxxC+nMGJOX52rUxxg@mail.gmail.com>
	<20200428191523.GU2794@work-vm>
	<CAOssrKcsVvMok6i+vAm1KJaq07Ep9JLcMiB1nWhsNU2n1m-Fmw@mail.gmail.com>
	<CAOssrKcZr4QXV1qLO7wmvdutkPKm59nSquPisEApBCWGx-c-uA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOssrKcZr4QXV1qLO7wmvdutkPKm59nSquPisEApBCWGx-c-uA@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Show submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Max Reitz <mreitz@redhat.com>, qemu-devel@nongnu.org

On Wed, Apr 29, 2020 at 11:26:49AM +0200, Miklos Szeredi wrote:
> On Wed, Apr 29, 2020 at 9:59 AM Miklos Szeredi <mszeredi@redhat.com> wrote:
> >
> > On Tue, Apr 28, 2020 at 9:15 PM Dr. David Alan Gilbert
> > <dgilbert@redhat.com> wrote:
> >
> > > So our current sequence is:
> > >
> > >    (new namespace)
> > >  1)    if (mount(NULL, "/", NULL, MS_REC | MS_SLAVE, NULL) < 0) {
> > >  2)   if (mount("proc", "/proc", "proc",
> > >            ....
> > >  3)   if (mount(source, source, NULL, MS_BIND | MS_REC, NULL) < 0) {
> > >  4)  (chdir newroot, pivot, chdir oldroot)
> > >  5)   if (mount("", ".", "", MS_SLAVE | MS_REC, NULL) < 0) {
> > >  6)   if (umount2(".", MNT_DETACH) < 0) {
> > >
> > > So are you saying we need a:
> > >        if (mount(NULL, "/", NULL, MS_REC | MS_SHARED, NULL) < 0) {
> > >
> > >   and can this go straight after (1) ?
> >
> > Or right before (3).   Important thing is that that new mount will
> > only receive propagation if the type of the mount at source (before
> > (3) is performed) is shared.
> 
> And seems I was wrong.  Bind mounting clones the slave property, hence
> no need to set MS_SHARED.  I.e. if the source was a slave, the bind
> mount will be a slave to the same master as well; the two slaves won't
> receive propagation between each other, but both will receive
> propagation from the master.

Agreed. I was playing with it yesterday and noticed the same thing. Wanted
to test more before I said anything

Anyway, I did following.

$ mkdir /tmp/a /tmp/a/c /tmp/b
$ mount --bind /tmp/a /tmp/a

$ findmnt -o +PROPAGATION /tmp/a
TARGET SOURCE    FSTYPE OPTIONS                  PROPAGATION
/tmp/a tmpfs[/a] tmpfs  rw,nosuid,nodev,seclabel shared

$ cat /proc/self/mountifo | grep "/tmp/a"
613 49 0:45 /a /tmp/a rw,nosuid,nodev shared:30 - tmpfs tmpfs rw,seclabel

# Mountpoint /tmp/a is part of peer group "30"
# Create a new mount namespace with slave propagation

$ unshare -m --propagation slave bash

$ findmnt -o +PROPAGATION /tmp/a
TARGET SOURCE    FSTYPE OPTIONS                  PROPAGATION
/tmp/a tmpfs[/a] tmpfs  rw,nosuid,nodev,seclabel private,slave

$ cat /proc/self/mountinfo | grep /tmp/a
666 665 0:45 /a /tmp/a rw,nosuid,nodev master:30 - tmpfs tmpfs rw,seclabel

# /tmp/a in new mount namespace is slave of master "30"

# bind mount /tmp/a to /tmp/b and b should become slave of "30" too.
$ mount --bind /tmp/a /tmp/b

$findmnt -o +PROPAGATION /tmp/b
TARGET SOURCE    FSTYPE OPTIONS                  PROPAGATION
/tmp/b tmpfs[/a] tmpfs  rw,nosuid,nodev,seclabel private,slave

$ cat /proc/self/mountinfo | grep /tmp/b
671 665 0:45 /a /tmp/b rw,nosuid,nodev master:30 - tmpfs tmpfs rw,seclabel

# So /tmp/b is slave of "master:30" too. Say if host mounts something
# under /tmp/a (in init namespace), it should propagate to /tmp/a as
# well as /tmp/b in new mount namespace.

# Do following in init mount namespace
$ mount --bind /tmp/a/c /tmp/a/c

# Check in newly created mount namespace.
# findmnt
├─/tmp                                tmpfs       tmpfs   rw,nosuid,nodev,seclab
│ ├─/tmp/a                            tmpfs[/a]   tmpfs   rw,nosuid,nodev,seclab
│ │ └─/tmp/a/c                        tmpfs[/a/c] tmpfs   rw,nosuid,nodev,seclab
│ ├─/tmp/b                            tmpfs[/a]   tmpfs   rw,nosuid,nodev,seclab
│ │ └─/tmp/b/c                        tmpfs[/a/c] tmpfs   rw,nosuid,nodev,seclab
│ └─/tmp/a/c                          tmpfs[/a/c] tmpfs   rw,nosuid,nodev,seclab

Mount of c has propagated into /tmp/b/c as well.

And that's what we want.

Thanks
Vivek

