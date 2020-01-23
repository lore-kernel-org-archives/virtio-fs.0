Date: Thu, 23 Jan 2020 10:19:29 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200123101929.GC2698@work-vm>
References: <20200122024008.28126-1-yangx.jy@cn.fujitsu.com>
	<20200122185224.GS3263@work-vm> <5E28F304.70602@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5E28F304.70602@cn.fujitsu.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Remove unused enum
	fuse_buf_copy_flags
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc: virtio-fs@redhat.com

* Xiao Yang (yangx.jy@cn.fujitsu.com) wrote:
> On 2020/1/23 2:52, Dr. David Alan Gilbert wrote:
> > I'm confused as to which version this patch is against; all the worlds I
> > can see don't take 'req' into fuse_buf_copy.
> Hi Dave,
> 
> I just used the development branch:
> https://gitlab.com/virtio-fs/qemu/tree/virtio-fs-dev
> 
> I saw that fuse_buf_copy() still has 'req' parameter on this branch.  Is it
> obsolete?
> https://gitlab.com/virtio-fs/qemu/blob/virtio-fs-dev/tools/virtiofsd/buffer.c#L270

OK, my mistake - the 'req' parameter is added late on, in the DAX
extensions; so I need to backport this cleanup before it.
I'll do that.

Dave

> Best Regards,
> Xiao Yang
> 
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

