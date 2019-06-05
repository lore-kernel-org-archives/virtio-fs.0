From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Wed,  5 Jun 2019 08:42:33 +0800
Message-Id: <1559695356-75503-3-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1559695356-75503-1-git-send-email-bo.liu@linux.alibaba.com>
References: <1559695356-75503-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH 2/5] virtiofsd: fix memory leak on lo.source
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

valgrind reported that lo.source is leaked on quiting, but it was defined
as (const char*) as it may point to a const string "/".

This adds a check to free the allocated memory only.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 contrib/virtiofsd/passthrough_ll.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index b58708f..f348b16 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -2217,6 +2217,7 @@ int main(int argc, char *argv[])
 	};
 	struct lo_map_elem *root_elem;
 	int ret = -1;
+        bool free_source = false;
 
 	/* Don't mask creation mode, kernel already did that */
 	umask(0);
@@ -2269,9 +2270,10 @@ int main(int argc, char *argv[])
 			err(1, "failed to stat source (\"%s\")", lo.source);
 		if (!S_ISDIR(stat.st_mode))
 			errx(1, "source is not a directory");
-
+                free_source = true;
 	} else {
 		lo.source = "/";
+                free_source = false;
 	}
 	lo.root.is_symlink = false;
 	if (!lo.timeout_set) {
@@ -2333,5 +2335,8 @@ err_out1:
 	if (lo.root.fd >= 0)
 		close(lo.root.fd);
 
+        if (free_source)
+                free((char *)lo.source);
+
 	return ret ? 1 : 0;
 }
-- 
1.8.3.1

