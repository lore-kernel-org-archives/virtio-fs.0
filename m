From: Haotian Li <lihaotian9@huawei.com>
References: <3477d902-ace9-1aa1-531a-9d20d6e93a05@huawei.com>
Message-ID: <f1e48ca8-d6de-d901-63c8-4f4024bda518@huawei.com>
Date: Wed, 11 Nov 2020 09:10:38 +0800
MIME-Version: 1.0
In-Reply-To: <3477d902-ace9-1aa1-531a-9d20d6e93a05@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] [PATCH 3/3] virtiofsd: check whether strdup lo.source
 return NULL in main func
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: linfeilong@huawei.com

In main func, strdup lo.source may fail. So check whether strdup
lo.source return NULL before using it.

Signed-off-by: Haotian Li <lihaotian9@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
 tools/virtiofsd/passthrough_ll.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 3e9bbc7a04..0c11134fb5 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3525,6 +3525,10 @@ int main(int argc, char *argv[])
         }
     } else {
         lo.source = strdup("/");
+        if (!lo.source) {
+            fuse_log(FUSE_LOG_ERR, "failed to strdup source\n");
+            goto err_out1;
+        }
     }

     if (lo.xattrmap) {
-- 

