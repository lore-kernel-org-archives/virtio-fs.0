From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Mon, 11 Oct 2021 11:09:32 +0800
Message-Id: <20211011030938.109206-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd PATCH v6 0/6] virtiofsd: support per-file DAX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu
Cc: virtio-fs@redhat.com, joseph.qi@linux.alibaba.com

The corresponding kernel patch set:
https://lore.kernel.org/all/20211011030052.98923-1-jefflexu@linux.alibaba.com/T/#t

changes since v5:
- add back support for .ioctl()
- add back negotiation during FUSE_INIT
- add '-o dax=[server|attr]' option to control the policy used by
  virtiofsd to determine whether DAX shall be enabled or not for
  specific file. Please refer to the commit log of patch 4/5/6 for
  more detailed information.


changes since v4:
- decide whether DAX shall be enabled or not solely depending on file
  size (DAX is disabled for files smaller than 32KB)
- negotiation during FUSE_INIT is droped
- drop support for .ioctl() for passthrough

changes since v2/v3:
Patch 4 in v2 is incomplete by mistake and it will fail to be compiled.
I had ever sent a seperate patch 4 of v3. Now I send the whole complete
set in v4. Except for this, there's no other diferrence.



Jeffle Xu (6):
  virtiofsd: add .ioctl() support
  virtiofsd: support per-file DAX in fuse protocol
  virtiofsd: negotiate per-file DAX in FUSE_INIT
  virtiofsd: add 'dax=' option
  virtiofsd: implement file size based dax policy
  virtiofsd: implement persistent inode attribute based dax policy

 include/standard-headers/linux/fuse.h |   2 +
 tools/virtiofsd/fuse_common.h         |   5 ++
 tools/virtiofsd/fuse_lowlevel.c       |   3 +
 tools/virtiofsd/helper.c              |   7 ++
 tools/virtiofsd/passthrough_ll.c      | 125 ++++++++++++++++++++++++++
 tools/virtiofsd/passthrough_seccomp.c |   1 +
 6 files changed, 143 insertions(+)

-- 
2.27.0

