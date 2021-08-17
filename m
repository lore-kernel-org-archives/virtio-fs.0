From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Tue, 17 Aug 2021 10:23:43 +0800
Message-Id: <20210817022347.18098-1-jefflexu@linux.alibaba.com>
In-Reply-To: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
References: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd PATCH v4 0/4] virtiofsd: support per-file DAX
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

I mentioned in virtiofsd PATCH v1 that virtiofsd exits once ioctl() is
called. After depper investigation into this issue, I find that it is
because ioctl() is blocked out the whitelist of seccomp of virtiofsd.

To support ioctl, ioctl syscall shall be added into the whitelist (see
patch
1).

And this is the complete workable version for virtiofsd:
- virtiofsd now supports FUSE_IOCTL now, though currently only
  FS_IOC_G[S]ETFLAGS/FS_IOC_FSG[S]ETXATTR are supported.
- During FUSE_INIT, virtiofsd advertise support for per-file DAX only
  when the backend fs is ext4/xfs.
- FS_IOC_SETFLAGS/FS_IOC_FSSETXATTR FUSE_IOCTL will be directed to host,
  so that FS_DAX_FL could be flushed to backed fs persistently.
- During FUSE_LOOKUP, virtiofsd will decide DAX shall be enabled for
  current file according to if this file is marked with FS_DAX_FL in the
  backend fs.


changes since v2/v3:
Patch 4 in v2 is incomplete by mistake and it will fail to be compiled.
I had ever sent a seperate patch 4 of v3. Now I send the whole complete
set in v4. Except for this, there's no other diferrence.

Jeffle Xu (4):
  virtiofsd: add .ioctl() support
  virtiofsd: expand fuse protocol to support per-file DAX
  virtiofsd: support per-file DAX negotiation in FUSE_INIT
  virtiofsd: support per-file DAX in FUSE_LOOKUP

 include/standard-headers/linux/fuse.h |   2 +
 tools/virtiofsd/fuse_common.h         |   5 ++
 tools/virtiofsd/fuse_lowlevel.c       |   6 ++
 tools/virtiofsd/passthrough_ll.c      | 125 ++++++++++++++++++++++++++
 tools/virtiofsd/passthrough_seccomp.c |   1 +
 5 files changed, 139 insertions(+)

-- 
2.27.0

