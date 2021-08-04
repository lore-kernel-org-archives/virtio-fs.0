From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Wed,  4 Aug 2021 15:24:08 +0800
Message-Id: <20210804072411.1180-1-jefflexu@linux.alibaba.com>
In-Reply-To: <20210804070653.118123-1-jefflexu@linux.alibaba.com>
References: <20210804070653.118123-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH virtiofsd 0/3] virtiofsd: support per-file DAX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, virtualization@lists.linux-foundation.org

As discussed with Vivek Goyal, I tried to make virtiofsd support
per-file DAX by checking if the file is marked with FS_DAX_FL attr. Thus
I need to implement .ioctl() method for passthrough_ll.c (because
FS_DAX_FL attr is get/set by FS_IOC_GETFLAGS/FS_IOC_SETFLAGS ioctl),
something like

```
static struct fuse_lowlevel_ops lo_oper = {
+    .ioctl = lo_ioctl,

+static void lo_ioctl(...)
+{
+	ret = ioctl(fd, FS_IOC_SETFLAGS, ...);
}
```

But unfortunately once virtiofsd calls ioctl() syscall, it directly
exits, and qemu also hangs with 'qemu-system-x86_64: Unexpected
end-of-file before all data were read'. I'm not sure if it's because
ioctl() is not permitted at all for virtiofsd or qemu. Many thanks if
someone familiar with virtualization could help.

The code repository of virtiofsd used is:
gitlab.com/virtio-fs/qemu.git virtio-fs-dev

Thus this patch set is still used for test only, marking files larger
than 1MB shall enable per-file DAX.

Jeffle Xu (3):
  virtiofsd: expand fuse protocol to support per-file DAX
  virtiofsd: support per-file DAX negotiation in FUSE_INIT
  virtiofsd: support per-file DAX in FUSE_LOOKUP

 include/standard-headers/linux/fuse.h | 2 ++
 tools/virtiofsd/fuse_common.h         | 5 +++++
 tools/virtiofsd/fuse_lowlevel.c       | 6 ++++++
 tools/virtiofsd/passthrough_ll.c      | 6 ++++++
 4 files changed, 19 insertions(+)

-- 
2.27.0

