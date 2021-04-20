DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding;
	bh=6HbB1VAhhgUx/qaXvX023gMFsNxHJqdWOpClPBzOgFg=;
	b=eQOtb/mEx8ubV0mvrl3wHhNnKbKYIPl1kXziZp6hUQC4FzecXfX7YnBa4my8Mj65zp
	ENNXamkQW/GwpcQ3IeqXIIyr0+wLjNQZa0+YfCCKHm1AxYxc9OizMduGhLMDnON3vxVd
	RVezCWJpRZr4bkDvjxzoc2U6eH9yxkwr/UB0gIPDg3cRZtFXENJR83z6C7WG8wXPe+8u
	Ze3o7cH2E5qQwU/ZPurIuKw5lwttxKc46hcArOyW0bjU056PPkoM/FACmFB8xhMFIPLF
	6YJrA9HsQd+w+AUWdg79I2s5KnmQpWQRVKCd8gCnqUn76RdP518vdNUojpHatIBIleIm
	KAsA==
From: Mahmoud Mandour <ma.mandourr@gmail.com>
Date: Tue, 20 Apr 2021 17:46:39 +0200
Message-Id: <20210420154643.58439-5-ma.mandourr@gmail.com>
In-Reply-To: <20210420154643.58439-1-ma.mandourr@gmail.com>
References: <20210420154643.58439-1-ma.mandourr@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v2 4/7] virtiofsd: Changed allocation of
	lo_map_elems to GLib's functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "open list:virtiofs" <virtio-fs@redhat.com>, Mahmoud Mandour <ma.mandourr@gmail.com>

Replaced (re)allocation of lo_map_elem structs from realloc() to
GLib's g_try_realloc_n() and replaced the respective free() call
with a g_free().

Signed-off-by: Mahmoud Mandour <ma.mandourr@gmail.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 1553d2ef45..b9260c26d4 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -406,7 +406,7 @@ static void lo_map_init(struct lo_map *map)
 
 static void lo_map_destroy(struct lo_map *map)
 {
-    free(map->elems);
+    g_free(map->elems);
 }
 
 static int lo_map_grow(struct lo_map *map, size_t new_nelems)
@@ -418,7 +418,7 @@ static int lo_map_grow(struct lo_map *map, size_t new_nelems)
         return 1;
     }
 
-    new_elems = realloc(map->elems, sizeof(map->elems[0]) * new_nelems);
+    new_elems = g_try_realloc_n(map->elems, new_nelems, sizeof(map->elems[0]));
     if (!new_elems) {
         return 0;
     }
-- 
2.25.1

