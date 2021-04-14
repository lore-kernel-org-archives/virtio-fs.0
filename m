From: Carlos Venegas <jose.carlos.venegas.munoz@intel.com>
Date: Wed, 14 Apr 2021 20:12:06 +0000
Message-Id: <20210414201207.3612432-2-jose.carlos.venegas.munoz@intel.com>
In-Reply-To: <20210414201207.3612432-1-jose.carlos.venegas.munoz@intel.com>
References: <20210414201207.3612432-1-jose.carlos.venegas.munoz@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH 1/2] virtiofsd: Allow use "-o xattrmap" without
	"-o xattr"
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: qemu-devel@nongnu.org, vgoyal@redhat.com

When -o xattrmap is used, it will not work unless xattr is enabled.

This patch enables xattr when -o xattrmap is used.

Signed-off-by: Carlos Venegas <jose.carlos.venegas.munoz@intel.com>
---
 tools/virtiofsd/passthrough_ll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index ddaf57305c..2337ea5a58 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3939,6 +3939,7 @@ int main(int argc, char *argv[])
     }
 
     if (lo.xattrmap) {
+        lo.xattr = 1;
         parse_xattrmap(&lo);
     }
 
-- 
2.25.1

