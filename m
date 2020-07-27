Date: Mon, 27 Jul 2020 12:18:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200727161841.GA54539@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [PATCH] virtiofsd: Disable remote posix locks by default
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs-list <virtio-fs@redhat.com>

Right now we enable remote posix locks by default. That means when guest
does a posix lock it sends request to server (virtiofsd). But currently
we only support non-blocking posix lock and return -EOPNOTSUPP for
blocking version.

This means that existing applications which are doing blocking posix
locks get -EOPNOTSUPP and fail. To avoid this, people have been
running virtiosd with option "-o no_posix_lock". For new users it
is still a surprise and trial and error takes them to this option.

Given posix lock implementation is not complete in virtiofsd, disable
it by default. This means that posix locks will work with-in applications
in a guest but not across guests. Anyway we don't support sharing
filesystem among different guests yet in virtiofs so this should
not lead to any kind of surprise or regression and will make life
little easier for virtiofs users.

Reported-by: Aa Aa <jimbothom@yandex.com>
Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 6514674f04..82d8c962d0 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3208,7 +3208,7 @@ int main(int argc, char *argv[])
     struct lo_data lo = {
         .debug = 0,
         .writeback = 0,
-        .posix_lock = 1,
+        .posix_lock = 0,
         .proc_self_fd = -1,
     };
     struct lo_map_elem *root_elem;
-- 
2.25.4

