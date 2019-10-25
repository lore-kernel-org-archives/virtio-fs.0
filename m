From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Fri, 25 Oct 2019 12:01:51 +0200
Message-Id: <20191025100152.6638-3-stefanha@redhat.com>
In-Reply-To: <20191025100152.6638-1-stefanha@redhat.com>
References: <20191025100152.6638-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC 2/3] qgraph: add an "after" test callback function
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, virtio-fs@redhat.com, Paolo Bonzini <pbonzini@redhat.com>, vgoyal@redhat.com

Add a callback that runs after a test completes.  This will be used for
cleanup.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 tests/libqos/qgraph.h          | 2 ++
 tests/libqos/qgraph_internal.h | 1 +
 tests/libqos/qgraph.c          | 1 +
 tests/qos-test.c               | 6 ++++++
 4 files changed, 10 insertions(+)

diff --git a/tests/libqos/qgraph.h b/tests/libqos/qgraph.h
index 3a25dda4b2..5e73a00e4a 100644
--- a/tests/libqos/qgraph.h
+++ b/tests/libqos/qgraph.h
@@ -47,6 +47,7 @@ typedef void (*QOSStartFunct) (QOSGraphObject *object);
 
 /* Test options functions */
 typedef void *(*QOSBeforeTest) (GString *cmd_line, void *arg);
+typedef void (*QOSAfterTest) (void *arg);
 
 /**
  * SECTION: qgraph.h
@@ -341,6 +342,7 @@ struct QOSGraphTestOptions {
                                  * additional parameters to the command line
                                  * and modify the argument to the test function.
                                  */
+    QOSAfterTest after;         /* executed after the test */
     bool subprocess;            /* run the test in a subprocess */
 };
 
diff --git a/tests/libqos/qgraph_internal.h b/tests/libqos/qgraph_internal.h
index f4734c8681..5e1131f06c 100644
--- a/tests/libqos/qgraph_internal.h
+++ b/tests/libqos/qgraph_internal.h
@@ -68,6 +68,7 @@ struct QOSGraphNode {
             QOSTestFunc function;
             void *arg;
             QOSBeforeTest before;
+            QOSAfterTest after;
             bool subprocess;
         } test;
     } u;
diff --git a/tests/libqos/qgraph.c b/tests/libqos/qgraph.c
index 7a7ae2a19e..f3e792a509 100644
--- a/tests/libqos/qgraph.c
+++ b/tests/libqos/qgraph.c
@@ -603,6 +603,7 @@ void qos_add_test(const char *name, const char *interface,
     assert(!opts->edge.size_arg);
 
     node->u.test.before = opts->before;
+    node->u.test.after = opts->after;
     node->u.test.subprocess = opts->subprocess;
     node->available = true;
     add_edge(interface, test_name, QEDGE_CONSUMED_BY, &opts->edge);
diff --git a/tests/qos-test.c b/tests/qos-test.c
index fd70d73ea5..fa77f661c6 100644
--- a/tests/qos-test.c
+++ b/tests/qos-test.c
@@ -273,6 +273,7 @@ void *qos_allocate_objects(QTestState *qts, QGuestAllocator **p_alloc)
  * 3) call all nodes constructor and get_driver/get_device depending on edge,
  *    start the hardware (*_device_enable functions)
  * 4) start test
+ * 5) @after test function as defined in the given QOSGraphTestOptions
  */
 static void run_one_test(const void *arg)
 {
@@ -296,6 +297,11 @@ static void run_one_test(const void *arg)
 
     obj = qos_allocate_objects(global_qtest, &alloc);
     test_node->u.test.function(obj, test_arg, alloc);
+
+    /* After test */
+    if (test_node->u.test.after) {
+        test_node->u.test.after(test_arg);
+    }
 }
 
 static void subprocess_run_one_test(const void *arg)
-- 
2.21.0

