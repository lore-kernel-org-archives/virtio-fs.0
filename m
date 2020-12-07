From: Vivek Goyal <vgoyal@redhat.com>
Date: Mon,  7 Dec 2020 13:30:18 -0500
Message-Id: <20201207183021.22752-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/3] virtiofsd: Fix lo_flush() and
	inode->posix_lock init
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, lersek@redhat.com, vgoyal@redhat.com

Laszlo is writing a virtiofs client for OVMF and noticed that if he
sends fuse FLUSH command for directory object, virtiofsd crashes.
virtiofsd does not expect a FLUSH arriving for a directory object.

This patch series has one of the patches which fixes that. It also
has couple of posix lock fixes as a result of lo_flush() related debugging.

Vivek Goyal (3):
  virtiofsd: Set up posix_lock hash table for root inode
  virtiofsd: Disable posix_lock hash table if remote locks are not
    enabled
  virtiofsd: Check file type in lo_flush()

 tools/virtiofsd/passthrough_ll.c | 54 +++++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 15 deletions(-)

-- 
2.25.4

