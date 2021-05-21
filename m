Date: Fri, 21 May 2021 10:39:21 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210521103921.153a243d@bahia.lan>
In-Reply-To: <CAJfpegugQM-ChaGiLyfPkbFr9c=_BiOBQkJTeEz5yN0ujO_O4A@mail.gmail.com>
References: <20210520154654.1791183-1-groug@kaod.org>
	<20210520154654.1791183-5-groug@kaod.org>
	<CAJfpegugQM-ChaGiLyfPkbFr9c=_BiOBQkJTeEz5yN0ujO_O4A@mail.gmail.com>
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

On Fri, 21 May 2021 10:26:27 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Thu, 20 May 2021 at 17:47, Greg Kurz <groug@kaod.org> wrote:
> >
> > All submounts share the same virtio-fs device instance as the root
> > mount. If the same virtiofs filesystem is mounted again, sget_fc()
> > is likely to pick up any of these submounts and reuse it instead of
> > the root mount.
> >
> > On the server side:
> >
> > # mkdir ${some_dir}
> > # mkdir ${some_dir}/mnt1
> > # mount -t tmpfs none ${some_dir}/mnt1
> > # touch ${some_dir}/mnt1/THIS_IS_MNT1
> > # mkdir ${some_dir}/mnt2
> > # mount -t tmpfs none ${some_dir}/mnt2
> > # touch ${some_dir}/mnt2/THIS_IS_MNT2
> >
> > On the client side:
> >
> > # mkdir /mnt/virtiofs1
> > # mount -t virtiofs myfs /mnt/virtiofs1
> > # ls /mnt/virtiofs1
> > mnt1 mnt2
> > # grep virtiofs /proc/mounts
> > myfs /mnt/virtiofs1 virtiofs rw,seclabel,relatime 0 0
> > none on /mnt/mnt1 type virtiofs (rw,relatime,seclabel)
> > none on /mnt/mnt2 type virtiofs (rw,relatime,seclabel)
> >
> > And now remount it again:
> >
> > # mount -t virtiofs myfs /mnt/virtiofs2
> > # grep virtiofs /proc/mounts
> > myfs /mnt/virtiofs1 virtiofs rw,seclabel,relatime 0 0
> > none on /mnt/mnt1 type virtiofs (rw,relatime,seclabel)
> > none on /mnt/mnt2 type virtiofs (rw,relatime,seclabel)
> > myfs /mnt/virtiofs2 virtiofs rw,seclabel,relatime 0 0
> > # ls /mnt/virtiofs2
> > THIS_IS_MNT2
> >
> > Submount mnt2 was picked-up instead of the root mount.
> 

> Why is this a problem?
> 

It seems very weird to mount the same filesystem again
and to end up in one of its submounts. We should have:

# ls /mnt/virtiofs2
mnt1 mnt2

> Thanks,
> Miklos

