From: Carlos Venegas <jose.carlos.venegas.munoz@intel.com>
Date: Wed, 14 Apr 2021 20:12:07 +0000
Message-Id: <20210414201207.3612432-3-jose.carlos.venegas.munoz@intel.com>
In-Reply-To: <20210414201207.3612432-1-jose.carlos.venegas.munoz@intel.com>
References: <20210414201207.3612432-1-jose.carlos.venegas.munoz@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH 2/2] virtiofsd: Add help for -o xattr-mapping
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

The option is not documented in help.

Add small help about the option.

Signed-off-by: Carlos Venegas <jose.carlos.venegas.munoz@intel.com>
---
 tools/virtiofsd/helper.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
index 28243b51b2..5e98ed702b 100644
--- a/tools/virtiofsd/helper.c
+++ b/tools/virtiofsd/helper.c
@@ -172,6 +172,9 @@ void fuse_cmdline_help(void)
            "                               default: no_writeback\n"
            "    -o xattr|no_xattr          enable/disable xattr\n"
            "                               default: no_xattr\n"
+           "    -o xattrmap=<mapping>      Enable xattr mapping (enables xattr)\n"
+           "                               <mapping> is a string consists of a series of rules\n"
+           "                               e.g. -o xattrmap=:map::user.virtiofs.:\n"
            "    -o modcaps=CAPLIST         Modify the list of capabilities\n"
            "                               e.g. -o modcaps=+sys_admin:-chown\n"
            "    --rlimit-nofile=<num>      set maximum number of file descriptors\n"
-- 
2.25.1

