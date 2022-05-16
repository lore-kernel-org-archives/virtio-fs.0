Return-Path: <jefflexu@linux.alibaba.com>
From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Mon, 16 May 2022 11:39:03 +0800
Message-Id: <20220516033906.58771-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH v8 0/3] virtiofsd: support per inode DAX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu, virtio-fs@redhat.com
Cc: joseph.qi@linux.alibaba.com, hsiangkao@linux.alibaba.com, haibinzhang@tencent.com, liudonghua@uniontech.com

This patchset aims for adding support for per-inode DAX for (C version)
virtiofsd. Sorry it is has been a long time since the last version, and
several developers have asked me how to test this feature. :( Sorry for
the inconvenience.

Besids I know the C version virtiofsd has been marked as deprecated,
while the mainline branch in qemu also has minimal support for DAX. Thus
I'm not sure what the community thinks of this patchset.

It is worth mentioning that, this patchset is developed based on
gitlab.com/virtio-fs/qemu.git virtio-fs-dev, whilst the following
commits also need to be cherry-picked.

939513863f virtiofsd: Extend size of fuse_conn_info->capable and ->want fields
99401173dd virtiofsd: Parse extended "struct fuse_init_in"
f1af2502ab virtiofsd: Fix breakage due to fuse_init_in size change
214617239b linux-headers: Update headers to v5.17-rc1
0f9c46c89b linux-headers: update to 5.16-rc1

It can ben tested on
https://github.com/lostjeffle/virtiofsd/commits/jingbo/dev-perfile-dax-v8


changes since v7:
- merge patches implementing various DAX policies into one patch (patch
  2); merge patches introducing "dax=" option and negotiation among
  FUSE_INIT phase into one patch (patch 3)
- patch 1: restrict the newly introduced .ioctl() to only querying
  and setting FS_DAX_FL/FS_XFLAG_DAX flag (Vivek Goyal [1])
- patch 2: besides "inode" and "filesize" DAX policy, also add "none"
  and "always" policy (Vivek Goyal [2])
- patch3: return error if any operation fails when handling the fuse
  request, rather than fallback to "dax=none" behavior (Vivek Goyal
  [3])
- As disccussed in [2], a default threshold of 32KB in "filesize" policy
  is fine for now. We can add new option "--dax-filesize-threshold" if
  it's needed later.

[1] https://www.mail-archive.com/virtio-fs@redhat.com/msg04460.html
[2] https://www.mail-archive.com/virtio-fs@redhat.com/msg04461.html
[3] https://www.mail-archive.com/virtio-fs@redhat.com/msg04462.html

Corresponding kernel patchset v8 (merged)
https://lore.kernel.org/all/YbeMvKVmzUwmrZhC@redhat.com/T/

virtiofsd patchset v7
https://www.mail-archive.com/virtio-fs@redhat.com/msg04349.html


Jeffle Xu (3):
  virtiofsd: add .ioctl() support
  virtiofsd: implement DAX policies for per inodex DAX mode
  virtiofsd: add 'dax=' option

 tools/virtiofsd/fuse_common.h         |   5 +
 tools/virtiofsd/fuse_lowlevel.c       |   6 +
 tools/virtiofsd/helper.c              |   6 +
 tools/virtiofsd/passthrough_ll.c      | 211 +++++++++++++++++++++++++-
 tools/virtiofsd/passthrough_seccomp.c |   1 +
 5 files changed, 226 insertions(+), 3 deletions(-)

-- 
2.27.0

