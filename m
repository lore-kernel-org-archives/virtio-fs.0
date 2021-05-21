Date: Fri, 21 May 2021 12:06:16 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210521120616.49d52565@bahia.lan>
In-Reply-To: <CAJfpegsNBCX+2k4S_yqdTS15TTu=pbiRgw6SbvdVYoUSmGboGA@mail.gmail.com>
References: <20210520154654.1791183-1-groug@kaod.org>
	<20210520154654.1791183-5-groug@kaod.org>
	<CAJfpegugQM-ChaGiLyfPkbFr9c=_BiOBQkJTeEz5yN0ujO_O4A@mail.gmail.com>
	<20210521103921.153a243d@bahia.lan>
	<CAJfpegsNBCX+2k4S_yqdTS15TTu=pbiRgw6SbvdVYoUSmGboGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v4 4/5] virtiofs: Skip submounts in sget_fc()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, Max Reitz <mreitz@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>

On Fri, 21 May 2021 10:50:34 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Fri, 21 May 2021 at 10:39, Greg Kurz <groug@kaod.org> wrote:
> >
> > On Fri, 21 May 2021 10:26:27 +0200
> > Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > > On Thu, 20 May 2021 at 17:47, Greg Kurz <groug@kaod.org> wrote:
> > > >
> > > > All submounts share the same virtio-fs device instance as the root
> > > > mount. If the same virtiofs filesystem is mounted again, sget_fc()
> > > > is likely to pick up any of these submounts and reuse it instead of
> > > > the root mount.
> > > >
> > > > On the server side:
> > > >
> > > > # mkdir ${some_dir}
> > > > # mkdir ${some_dir}/mnt1
> > > > # mount -t tmpfs none ${some_dir}/mnt1
> > > > # touch ${some_dir}/mnt1/THIS_IS_MNT1
> > > > # mkdir ${some_dir}/mnt2
> > > > # mount -t tmpfs none ${some_dir}/mnt2
> > > > # touch ${some_dir}/mnt2/THIS_IS_MNT2
> > > >
> > > > On the client side:
> > > >
> > > > # mkdir /mnt/virtiofs1
> > > > # mount -t virtiofs myfs /mnt/virtiofs1
> > > > # ls /mnt/virtiofs1
> > > > mnt1 mnt2
> > > > # grep virtiofs /proc/mounts
> > > > myfs /mnt/virtiofs1 virtiofs rw,seclabel,relatime 0 0
> > > > none on /mnt/mnt1 type virtiofs (rw,relatime,seclabel)
> > > > none on /mnt/mnt2 type virtiofs (rw,relatime,seclabel)
> > > >
> > > > And now remount it again:
> > > >
> > > > # mount -t virtiofs myfs /mnt/virtiofs2
> > > > # grep virtiofs /proc/mounts
> > > > myfs /mnt/virtiofs1 virtiofs rw,seclabel,relatime 0 0
> > > > none on /mnt/mnt1 type virtiofs (rw,relatime,seclabel)
> > > > none on /mnt/mnt2 type virtiofs (rw,relatime,seclabel)
> > > > myfs /mnt/virtiofs2 virtiofs rw,seclabel,relatime 0 0
> > > > # ls /mnt/virtiofs2
> > > > THIS_IS_MNT2
> > > >
> > > > Submount mnt2 was picked-up instead of the root mount.
> > >
> >
> > > Why is this a problem?
> > >
> >
> > It seems very weird to mount the same filesystem again
> > and to end up in one of its submounts. We should have:
> >
> > # ls /mnt/virtiofs2
> > mnt1 mnt2
> 
> Okay, sorry, I understand the problem.  The solution is wrong,
> however: the position of the submount on that list is no indication
> that it's the right one (it's possible that the root sb will go away
> and only a sub-sb will remain).
> 

Ah... I had myself convinced this could not happen, i.e. you can't
unmount a parent sb with a sub-sb still mounted.

How can this happen ?

> Even just setting a flag in the root, indicating that it's the root
> isn't fully going to solve the problem.
> 
> Here's issue in full:
> 
> case 1:  no connection for "myfs" exists
>     - need to create fuse_conn, sb
> 
> case 2: connection for "myfs" exists but only sb for submount

How would we know this sb isn't a root sb ?

>     - only create sb for root, reuse fuse_conn
> 
> case 3: connection for "myfs" as well as root sb exists
>    - reuse sb
> 
> I'll think about how to fix this properly, it's probably going to be
> rather more involved...
> 

Sure. BTW I'm wondering why we never reuse sbs for submounts ?

> Thanks,
> Miklos

