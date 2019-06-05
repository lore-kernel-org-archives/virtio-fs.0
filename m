From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Wed,  5 Jun 2019 08:42:35 +0800
Message-Id: <1559695356-75503-5-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1559695356-75503-1-git-send-email-bo.liu@linux.alibaba.com>
References: <1559695356-75503-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH 4/5] virtiofsd: fix error handling in main()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Neither fuse_parse_cmdline() nor fuse_opt_parse() goes to the right place
to do cleanup.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 contrib/virtiofsd/passthrough_ll.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index e7e19dc..649991e 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -2243,7 +2243,8 @@ int main(int argc, char *argv[])
 	lo_map_init(&lo.fd_map);
 
 	if (fuse_parse_cmdline(&args, &opts) != 0)
-		return 1;
+		goto err_out1;
+
 	if (opts.show_help) {
 		printf("usage: %s [options]\n\n", argv[0]);
 		fuse_cmdline_help();
@@ -2258,7 +2259,7 @@ int main(int argc, char *argv[])
 	}
 
 	if (fuse_opt_parse(&args, &lo, lo_opts, NULL)== -1)
-		return 1;
+		goto err_out1;
 
 	lo.debug = opts.debug;
 	if (lo.source) {
-- 
1.8.3.1

