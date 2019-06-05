From: Peng Tao <tao.peng@linux.alibaba.com>
Date: Wed,  5 Jun 2019 11:02:32 +0800
Message-Id: <20190605030233.19567-1-tao.peng@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH-v3 0/1] virtiofs: FUSE_REMOVEMAPPING remove
	multiple entries in one call
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Peng Tao <tao.peng@linux.alibaba.com>, Vivek Goyal <vgoyal@redhat.com>

Hi Vivek,

This works with corresponding qemu virtiofsd patch:
"[PATCH-v3] virtiofsd: make FUSE_REMOVEMAPPING support multiple entries".

v1-v2: make fuse_removemapping_in count fuse_removemapping_one
v2->v3:
1. fold in Vivek's cleanup and rename all forget_one to remove_one
2. assert dmap->list is not used by anyone when adding to temporary list
3. list_del() dmap->list when removing it from to_remove list

Please add your SOB line as I don't see it with your cleanup and thus
did not add it to the patch when folding your change.

Thanks,
Tao

Peng Tao (1):
  virtiofs: FUSE_REMOVEMAPPING remove multiple entries in one call

 fs/fuse/file.c            | 205 +++++++++++++++++++++++++++-----------
 fs/fuse/fuse_i.h          |   6 +-
 fs/fuse/inode.c           |   2 +-
 include/uapi/linux/fuse.h |   7 ++
 4 files changed, 160 insertions(+), 60 deletions(-)

-- 
2.17.1

