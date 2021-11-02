From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Tue,  2 Nov 2021 13:56:40 +0800
Message-Id: <20211102055646.103337-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v7 0/6] virtiofsd: support per inode DAX
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
https://lore.kernel.org/all/20211102052604.59462-1-jefflexu@linux.alibaba.com/

changes since v6:
- rebase to 'virtio-fs-dev' branch
- the added new option is now named as "-o dax=inode|filesize"
- virtiofsd won't advertise support for per inode DAX if no DAX policy
  specified

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
  virtiofsd: support per inode DAX in fuse protocol
  virtiofsd: add 'dax=' option
  virtiofsd: negotiate per inode DAX in FUSE_INIT
  virtiofsd: implement xflag based dax policy
  virtiofsd: implement file size based dax policy

 include/standard-headers/linux/fuse.h |   2 +
 tools/virtiofsd/fuse_common.h         |   5 +
 tools/virtiofsd/fuse_lowlevel.c       |   6 ++
 tools/virtiofsd/helper.c              |   5 +
 tools/virtiofsd/passthrough_ll.c      | 141 ++++++++++++++++++++++++++
 tools/virtiofsd/passthrough_seccomp.c |   1 +
 6 files changed, 160 insertions(+)

-- 
2.27.0

