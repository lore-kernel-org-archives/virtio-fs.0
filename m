From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Wed, 31 Jul 2019 17:10:01 +0100
Message-Id: <20190731161006.9447-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/5] virtiofsd: multithreading preparation part 2
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org

This is the second in a multi-series effort to make virtiofsd thread-safe.  The
main goal in this installment is to make lo_inode thread-safe, but other fixes
are included too.  Like any good author I will build suspense and won't tell
where this story is headed, but I still have some more code auditing to do
before we can declare virtiofsd thread-safe :).

Based-on: <20190726091103.23503-1-stefanha@redhat.com> ("virtiofsd: multithreading preparation")

Stefan Hajnoczi (5):
  virtiofsd: take lo->mutex around lo_add_fd_mapping()
  virtiofsd: take lo->mutex around lo_add_dirp_mapping()
  virtiofsd: rename inode->refcount to inode->nlookup
  virtiofsd: fix inode nlookup leaks
  virtiofsd: introduce inode refcount to prevent use-after-free

 contrib/virtiofsd/passthrough_ll.c | 262 +++++++++++++++++++++++------
 1 file changed, 214 insertions(+), 48 deletions(-)

-- 
2.21.0

