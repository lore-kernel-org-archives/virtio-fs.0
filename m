From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Date: Wed, 16 Oct 2019 19:37:52 +0900
Message-ID: <20191016103754.2047-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Subject: [Virtio-fs] [PATCH 0/2] virtiofsd: Two fix for xattr operation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: qemu-devel@nongnu.org, misono.tomohiro@jp.fujitsu.com

Hello,

I test xattr operation on virtiofs using xfstest generic/062
(with -o xattr option and XFS backend) and see some problems.

These patches fixes the two of the problems.

The remaining problems are:
 1. we cannot xattr to block device created by mknod
    which does not have actual device (since open in virtiofsd fails)
 2. we cannot xattr to symbolic link

I don't think 1 is a big problem but can we fix 2?

Misono Tomohiro (2):
  virtiofsd: Avoid process hang when doing xattr operation to FIFO
  virtiofsd: Allow setxattr operation to directry

 contrib/virtiofsd/passthrough_ll.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.21.0

