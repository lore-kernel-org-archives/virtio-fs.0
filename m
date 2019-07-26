From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 26 Jul 2019 11:58:35 -0400
Message-Id: <20190726155837.29155-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/2][V2] virtiofsd: Do not setup mapping
	read-write always
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Setup mapping either read-only or read-write depending on what client
has asked for. Also open file O_RDONLY for read-only mapping (and not
O_RDWR). Otherwise files always get copied up on overlayfs.

Vivek Goyal (2):
  virtiofsd: During setup mapping, open file O_RDWR only if needed
  virtiofsd: No need to promote O_WRONLY to O_RDWR

 contrib/virtiofsd/fuse_lowlevel.c  |  5 +++--
 contrib/virtiofsd/passthrough_ll.c | 29 +++++++----------------------
 2 files changed, 10 insertions(+), 24 deletions(-)

-- 
2.17.2

