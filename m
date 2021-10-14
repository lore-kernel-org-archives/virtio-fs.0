From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Thu, 14 Oct 2021 13:25:54 +0100
Message-Id: <20211014122554.34599-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] virtiofsd: Error on bad socket group name
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: xiagao@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Make the '--socket-group=' option fail if the group name is unknown:

./tools/virtiofsd/virtiofsd .... --socket-group=zaphod
vhost socket: unable to find group 'zaphod'

Reported-by: Xiaoling Gao <xiagao@redhat.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/fuse_virtio.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 8f4fd165b9..39eebffb62 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -999,6 +999,13 @@ static int fv_create_listen_socket(struct fuse_session *se)
                          "vhost socket failed to set group to %s (%d): %m\n",
                          se->vu_socket_group, g->gr_gid);
             }
+        } else {
+            fuse_log(FUSE_LOG_ERR,
+                     "vhost socket: unable to find group '%s'\n",
+                     se->vu_socket_group);
+            close(listen_sock);
+            umask(old_umask);
+            return -1;
         }
     }
     umask(old_umask);
-- 
2.31.1

