From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue,  1 Sep 2020 16:40:43 -0400
Message-Id: <20200901204045.1250822-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC PATCH 0/2] fuse: Enable SB_NOSEC if filesystem is
	not shared
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, miklos@szeredi.hu
Cc: vgoyal@redhat.com

Hi,

I want to enable SB_NOSEC in fuse in some form so that performance of
small random writes can be improved. As of now, we call file_remove_privs(),
which results in fuse always sending getxattr(security.capability) to
server to figure out if security.capability has been set on file or not.
If it has been set, it needs to be cleared. This slows down small
random writes tremendously.

I posted couple of proposals in the past here.

Proposal 1:

https://lore.kernel.org/linux-fsdevel/20200716144032.GC422759@redhat.com/

Proposal 2:

https://lore.kernel.org/linux-fsdevel/20200724183812.19573-1-vgoyal@redhat.com/

This is 3rd proposal now. One of the roadblocks in enabling SB_NOSEC
is shared filesystem. It is possible that another client modified the
file data and this client does not know about it. So we might regress
if we don't fetch security.capability always.

So looks like this needs to be handled different for shared filesystems
and non-shared filesystems. non-shared filesystems will be more like
local filesystems where fuse does not expect file data/metadata to
change outside the fuse. And we should be able to enable SB_NOSEC
optimization. This is what this proposal does.

It does not handle the case of shared filesystems. I believe solution
to that will depend on filesystem based on what's the cache coherency
guarantees filesystem provides and what's the cache invalidation 
mechanism it uses.

For now, all filesystems which are not shared can benefit from this
optimization. I am interested in virtiofs which is not shared in
many of the cases. In fact we don't even support shared mode yet. 

Any comments or feedback is welcome.

Thanks
Vivek

Vivek Goyal (2):
  fuse: Add a flag FUSE_NONSHARED_FS
  fuse: Enable SB_NOSEC if filesystem is not shared

 fs/fuse/fuse_i.h          |  3 +++
 fs/fuse/inode.c           | 12 +++++++++++-
 include/uapi/linux/fuse.h |  4 ++++
 3 files changed, 18 insertions(+), 1 deletion(-)

-- 
2.25.4

