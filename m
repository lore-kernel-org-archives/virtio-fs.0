From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 11 May 2021 17:37:29 -0400
Message-Id: <20210511213736.281016-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/7] virtiofsd: Few cleanups in
	virtio_send_data_iov()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: vgoyal@redhat.com

Hi,

Code in virtio_send_data_iov() little twisted and complicated. This
patch series just tries to simplify it a bit to make it little easier
to read this piece of code.

Thanks
Vivek

Vivek Goyal (7):
  virtiofsd: Check for EINTR in preadv() and retry
  virtiofsd: Get rid of unreachable code in read
  virtiofsd: Use iov_discard_front() to skip bytes
  virtiofsd: get rid of in_sg_left variable
  virtiofsd: Simplify skip byte logic
  virtiofsd: Check EOF before short read
  virtiofsd: Set req->reply_sent right after sending reply

 tools/virtiofsd/fuse_virtio.c | 67 +++++++++++------------------------
 1 file changed, 21 insertions(+), 46 deletions(-)

-- 
2.25.4

