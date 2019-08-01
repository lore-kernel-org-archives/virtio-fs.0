DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id;
	bh=ZmGIGRyQgEw1eVbcCdiGmxCP8QD0XwROamoNMi0o15c=;
	b=cwi/qvfsIJHUmH16iyeNsf2YEsw4PGVD5y7WvrIy7AopftqL7Jhz6jftjjiEuvTn/W
	ODnSDezMB3RIJ6oUQ1OgYHsUrmwPiErDmzstn6iQ4vWy0ppozwrNF2Jo8YKpOCTgvs6J
	vz7yVPFUj5GLsFZQxQRjgq+94j/u0BWRuczfC/Um8eIfnN4ajvIt/sMKse/s48t0WL8A
	4msTIlNSkyjhY400eR89+wKpcBVXGSqCIKu/CZs7Qps8w8lq+m/FKsyCG/sH2n2bJRuJ
	kiVOMbFSOE7ecci4i5sjSEDM8E6kCfXQQL5f7zOhBMUpW0CPlPA4ESTdo99BSUnKFF3X
	K28w==
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Date: Thu,  1 Aug 2019 11:13:48 -0400
Message-Id: <20190801151348.14947-1-msys.mizuma@gmail.com>
Subject: [Virtio-fs] [PATCH] virtiofsd: Prevent multiply running with same
	vhost_user_socket
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

virtiofsd can run multiply even if the vhost_user_socket is
same path.

  ]# ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu -o source=/tmp/share &
  [1] 244965
  virtio_session_mount: Waiting for vhost-user socket connection...
  ]# ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu -o source=/tmp/share &
  [2] 244966
  virtio_session_mount: Waiting for vhost-user socket connection...
  ]#

The file access from the guest works because the second virtiofsd
handles that, however, the user will get confused the situation
and may be the cause of unexpected problem. So it's better to
prevent the multiple running.

Change unlink() of the socket to the exit of virtiofsd so that the
latter virtiofsd can fail on bind() as EADDRINUSE.

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 contrib/virtiofsd/fuse_lowlevel.c | 1 +
 contrib/virtiofsd/fuse_virtio.c   | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
index 8adc4b1ab8..0624d26ffc 100644
--- a/contrib/virtiofsd/fuse_lowlevel.c
+++ b/contrib/virtiofsd/fuse_lowlevel.c
@@ -2584,6 +2584,7 @@ void fuse_session_destroy(struct fuse_session *se)
 		virtio_session_close(se);
 	}
 
+	unlink(se->vu_socket_path);
 	free(se->vu_socket_path);
 	se->vu_socket_path = NULL;
 
diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
index 083e4fc317..54ba7cbbcb 100644
--- a/contrib/virtiofsd/fuse_virtio.c
+++ b/contrib/virtiofsd/fuse_virtio.c
@@ -879,7 +879,6 @@ static int fv_create_listen_socket(struct fuse_session *se)
         /* Create the Unix socket to communicate with qemu
          * based on QEMU's vhost-user-bridge
          */
-        unlink(se->vu_socket_path);
         strcpy(un.sun_path, se->vu_socket_path);
         size_t addr_len = sizeof(un.sun_family) + strlen(se->vu_socket_path);
 
-- 
2.18.1

