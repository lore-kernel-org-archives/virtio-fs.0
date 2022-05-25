Return-Path: <stefanha@redhat.com>
From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Wed, 25 May 2022 13:49:09 +0100
Message-Id: <20220525124909.867787-2-stefanha@redhat.com>
In-Reply-To: <20220525124909.867787-1-stefanha@redhat.com>
References: <20220525124909.867787-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 1/1] docs: Correct the default thread-pool-size
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs@redhat.com, qemu-block@nongnu.org, Liu Yiding <liuyd.fnst@fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>

From: Liu Yiding <liuyd.fnst@fujitsu.com>

Refer to 26ec190964 virtiofsd: Do not use a thread pool by default

Signed-off-by: Liu Yiding <liuyd.fnst@fujitsu.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Message-id: 20220413042054.1484640-1-liuyd.fnst@fujitsu.com
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 docs/tools/virtiofsd.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/docs/tools/virtiofsd.rst b/docs/tools/virtiofsd.rst
index e457b13d56..5f5ac9dd56 100644
--- a/docs/tools/virtiofsd.rst
+++ b/docs/tools/virtiofsd.rst
@@ -132,7 +132,7 @@ Options
 .. option:: --thread-pool-size=NUM
 
   Restrict the number of worker threads per request queue to NUM.  The default
-  is 64.
+  is 0.
 
 .. option:: --cache=none|auto|always
 
-- 
2.36.1

