From: Vivek Goyal <vgoyal@redhat.com>
Date: Mon, 14 Jun 2021 13:44:54 -0400
Message-Id: <20210614174454.903555-3-vgoyal@redhat.com>
In-Reply-To: <20210614174454.903555-1-vgoyal@redhat.com>
References: <20210614174454.903555-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 2/2] init/do_mounts.c: Add 9pfs to the list
	of tag based filesystems
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com
Cc: hch@infradead.org, miklos@szeredi.hu, richard.weinberger@gmail.com, asmadeus@codewreck.org, dhowells@redhat.com, viro@zeniv.linux.org.uk, v9fs-developer@lists.sourceforge.net, vgoyal@redhat.com

Add 9p to the list of tag based filesystems. I tested basic testing
with kernel command line "root=hostShared rootfstype=9p rw" and it
works for me.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 init/do_mounts.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 2a18238f4962..7c86bfdab15b 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -35,6 +35,9 @@ static char *__initdata tag_based_rootfs[] = {
 #if IS_BUILTIN(CONFIG_VIRTIO_FS)
 	"virtiofs",
 #endif
+#if IS_BUILTIN(CONFIG_9P_FS)
+	"9p",
+#endif
 };
 static bool __initdata tag_based_root;
 static int root_wait;
-- 
2.25.4

