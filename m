MIME-Version: 1.0
References: <20200514140736.20561-1-mszeredi@redhat.com>
	<20200515034309.GA49087@rsjd01523.et2sqa>
In-Reply-To: <20200515034309.GA49087@rsjd01523.et2sqa>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Fri, 15 May 2020 06:42:00 +0200
Message-ID: <CAOssrKeLqOtsRXVwHBncyaWEW2ZP3T-rL+O7C3j8=Jp3DKpGXg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: remove symlink fallbacks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

On Fri, May 15, 2020 at 5:43 AM Liu Bo <bo.liu@linux.alibaba.com> wrote:
>
> On Thu, May 14, 2020 at 04:07:36PM +0200, Miklos Szeredi wrote:
> > Path lookup in the kernel has special rules for looking up magic symlinks
> > under /proc.  If a filesystem operation is instructed to follow symlinks
> > (e.g. via AT_SYMLINK_FOLLOW or lack of AT_SYMLINK_NOFOLLOW), and the final
> > component is such a proc symlink, then the target of the magic symlink is
> > used for the operation, even if the target itself is a symlink.  I.e. path
> > lookup is always terminated after following a final magic symlink.
> >
>
> Hi Miklos,
>
> Are these mentioned special rules supported by a recent kernel version
> or are they there from day one linux?

Hi Liubo,

AFAICS, these rules have been there from day one.

Thanks,
Miklos

