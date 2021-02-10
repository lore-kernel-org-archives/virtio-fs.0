From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 10 Feb 2021 13:27:44 -0500
Message-Id: <20210210182744.27324-2-vgoyal@redhat.com>
In-Reply-To: <20210210182744.27324-1-vgoyal@redhat.com>
References: <20210210182744.27324-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/1] virtiofsd: Do not use a thread pool by
	default
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: vgoyal@redhat.com

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
---
 tools/virtiofsd/fuse_lowlevel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index e94b71110b..fbdf62ee9b 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -18,7 +18,7 @@
 
 #include <sys/file.h>
 
-#define THREAD_POOL_SIZE 64
+#define THREAD_POOL_SIZE 0
 
 #define OFFSET_MAX 0x7fffffffffffffffLL
 
-- 
2.25.4

