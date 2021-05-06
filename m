From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Thu,  6 May 2021 19:56:32 +0100
Message-Id: <20210506185641.284821-4-dgilbert@redhat.com>
In-Reply-To: <20210506185641.284821-1-dgilbert@redhat.com>
References: <20210506185641.284821-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 03/12] virtiofsd: Add help for -o xattr-mapping
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

The option is not documented in help.

Add small help about the option.

Signed-off-by: Carlos Venegas <jose.carlos.venegas.munoz@intel.com>
Message-Id: <20210414201207.3612432-3-jose.carlos.venegas.munoz@intel.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
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
2.31.1

