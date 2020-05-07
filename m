MIME-Version: 1.0
References: <20200506153529.239939-1-mreitz@redhat.com>
	<20200506153637.240191-3-mreitz@redhat.com>
	<CAOssrKerr_KvfuXqTNjJ4936SXiN3AZ6rZ6oo8Mv+9bvDrFAWQ@mail.gmail.com>
	<879d4262-fde1-eedb-a114-2a0b8a185125@redhat.com>
	<CAOssrKd99kBf9ccc4xk_ZktO+Sc_+WvP0=wvVOXV7+Jgp8sTZA@mail.gmail.com>
	<5396dbd9-0d6c-556d-d015-cbc034d6471e@redhat.com>
In-Reply-To: <5396dbd9-0d6c-556d-d015-cbc034d6471e@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Thu, 7 May 2020 16:05:16 +0200
Message-ID: <CAOssrKfX1ocpXH_rnaAYMJS50L3kKTr1yGvY6=iqvn9TcwdhWg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [RFC 3/5] fuse: Split fuse_mount off of fuse_conn
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Max Reitz <xanclic@xanclic.moe>

On Thu, May 7, 2020 at 2:08 PM Max Reitz <mreitz@redhat.com> wrote:
>
> On 07.05.20 13:24, Miklos Szeredi wrote:

> > Even better:  share the bdi between submounts.  This would make a lot
> > more sense and remove the need for loops.
>
> Hm, isn’t bdi related to the (anonymous) block device “serving” the
> super block, and thus the st_dev value?  (Which is necessarily different
> for all fuse_mounts)

BDI is normally an object bound to a block device, but a block device
can have multiple partitions, each having different st_dev values.  So
yes, a bdi *can* be shared by multiple super blocks, and this very
much makes sense in the case of fuse submounts sharing a connection.

Thanks,
Miklos


