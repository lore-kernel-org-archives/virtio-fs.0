From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 16 Sep 2020 12:17:31 -0400
Message-Id: <20200916161737.38028-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 0/6] fuse: Implement FUSE_HANDLE_KILLPRIV_V2
	and enable SB_NOSEC
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, miklos@szeredi.hu
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

Hi All,

Please find attached V2 of the patches to enable SB_NOSEC for fuse. I
posted V1 here.

https://lore.kernel.org/linux-fsdevel/20200724183812.19573-1-vgoyal@redhat.com/

I have generated these patches on top of.

https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git/log/?h=for-next

Previously I was not keen on implementing FUSE_HANDLE_KILLPRIV_V2 and
implemented another idea to enable SB_NOSEC conditional on server
declaring that filesystem is not shared. But that did not go too
far when it came to requirements for virtiofs.

https://lore.kernel.org/linux-fsdevel/20200901204045.1250822-1-vgoyal@redhat.com/

So I went back to having another look at implementing FUSE_HANDLE_KILLPRIV_V2
and I think it fits nicely and should work nicely with wide variety of
use cases.

I have taken care of feedback from last round. For the case of random
write peformance has jumped from 50MB/s to 250MB/s. So I am really
looking forward to these changes so that fuse/virtiofs performance
can be improved.

Thanks
Vivek 

Vivek Goyal (6):
  fuse: Introduce the notion of FUSE_HANDLE_KILLPRIV_V2
  fuse: Set FUSE_WRITE_KILL_PRIV in cached write path
  fuse: setattr should set FATTR_KILL_PRIV upon size change
  fuse: Kill suid/sgid using ATTR_MODE if it is not truncate
  fuse: Add a flag FUSE_OPEN_KILL_PRIV for open() request
  virtiofs: Support SB_NOSEC flag to improve direct write performance

 fs/fuse/dir.c             | 19 ++++++++++++++++++-
 fs/fuse/file.c            |  7 +++++++
 fs/fuse/fuse_i.h          |  6 ++++++
 fs/fuse/inode.c           | 17 ++++++++++++++++-
 include/uapi/linux/fuse.h | 18 +++++++++++++++++-
 5 files changed, 64 insertions(+), 3 deletions(-)

-- 
2.25.4

