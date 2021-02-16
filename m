From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue, 16 Feb 2021 18:37:34 +0000
Message-Id: <20210216183734.57810-7-dgilbert@redhat.com>
In-Reply-To: <20210216183734.57810-1-dgilbert@redhat.com>
References: <20210216183734.57810-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 6/6] virtiofsd: Do not use a thread pool by
	default
List-Id: Development discussions about virtio-fs <virtio-fs.listman.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@listman.redhat.com>
List-Help: <mailto:virtio-fs-request@listman.redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, wainersm@redhat.com, groug@kaod.org, philmd@redhat.com, vgoyal@redhat.com
Cc: virtio-fs@redhat.com

From: Vivek Goyal <vgoyal@redhat.com>

Currently we created a thread pool (With 64 max threads per pool) for
each virtqueue. We hoped that this will provide us with better scalability
and performance.

But in practice, we are getting better numbers in most of the cases
when we don't create a thread pool at all and a single thread per
virtqueue receives the request and processes it.

Hence, I am proposing that we switch to no thread pool by default
(equivalent of --thread-pool-size=0). This will provide out of
box better performance to most of the users. In fact other users
have confirmed that not using a thread pool gives them better
numbers. So why not use this as default. It can be changed when
somebody can fix the issues with thread pool performance.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Message-Id: <20210210182744.27324-2-vgoyal@redhat.com>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/fuse_lowlevel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index f78692ef66..1aa26c6333 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -18,7 +18,7 @@
 
 #include <sys/file.h>
 
-#define THREAD_POOL_SIZE 64
+#define THREAD_POOL_SIZE 0
 
 #define OFFSET_MAX 0x7fffffffffffffffLL
 
-- 
2.29.2

