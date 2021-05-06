From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Thu,  6 May 2021 19:56:31 +0100
Message-Id: <20210506185641.284821-3-dgilbert@redhat.com>
In-Reply-To: <20210506185641.284821-1-dgilbert@redhat.com>
References: <20210506185641.284821-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 02/12] virtiofsd: Allow use "-o xattrmap" without
	"-o xattr"
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, groug@kaod.org, jose.carlos.venegas.munoz@intel.com, ma.mandourr@gmail.com
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

From: Carlos Venegas <jose.carlos.venegas.munoz@intel.com>

When -o xattrmap is used, it will not work unless xattr is enabled.

This patch enables xattr when -o xattrmap is used.

Signed-off-by: Carlos Venegas <jose.carlos.venegas.munoz@intel.com>
Message-Id: <20210414201207.3612432-2-jose.carlos.venegas.munoz@intel.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 6592f96f68..2c36f4ec46 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3831,6 +3831,7 @@ int main(int argc, char *argv[])
     }
 
     if (lo.xattrmap) {
+        lo.xattr = 1;
         parse_xattrmap(&lo);
     }
 
-- 
2.31.1

