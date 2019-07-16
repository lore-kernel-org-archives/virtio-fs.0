From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 16 Jul 2019 17:00:45 -0400
Message-Id: <20190716210051.11724-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/6] virtio-fs: Get rid of inode lock and misc
	fixes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hi Liu Bo,

I am proposing following patches and fixes. I have modified your patch
a bit to use refcount_t. 

I have done few other cleanup and fixes as well.

If things look good, I will squash these patches into exisitng patches.

Thanks
Vivek

Vivek Goyal (6):
  fuse: Continue to wait if inline reclaim returns null
  fuse: Requeue work if number of free ranges is not above threshold
  fuse: Do cond_resched() if we can't get inode lock
  fuse: Get rid of inode lock in range reclaim path
  fuse: Get rid of -EAGAIN logic in dmap free worker thread
  fuse: Dax read can now do range reclaim inline

 fs/fuse/file.c   | 161 ++++++++++++++++++++++++++---------------------
 fs/fuse/fuse_i.h |   3 +
 fs/fuse/inode.c  |   1 +
 3 files changed, 93 insertions(+), 72 deletions(-)

-- 
2.20.1

