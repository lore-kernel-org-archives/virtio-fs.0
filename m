Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:52:02 +0100
Message-Id: <20221205095228.1314-26-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 25/51] tests/qtest/migration-test: Fix unlink
 error and memory leaks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Fam Zheng <fam@euphon.net>, Thomas Huth <huth@tuxfamily.org>, Viresh Kumar <viresh.kumar@linaro.org>, Kevin Wolf <kwolf@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Laurent Vivier <laurent@vivier.eu>, Eric Blake <eblake@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, qemu-block@nongnu.org, Xiaojuan Yang <yangxiaojuan@loongson.cn>, Thomas Huth <thuth@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Peter Maydell <peter.maydell@linaro.org>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <lvivier@redhat.com>, Song Gao <gaosong@loongson.cn>, qemu-s390x@nongnu.org, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, Klaus Jensen <its@irrelevant.dk>, John Snow <jsnow@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Keith Busch <kbusch@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-trivial@nongnu.org, Hanna Reitz <hreitz@redhat.com>, Bin Meng <bmeng@tinylab.org>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>

From: Thomas Huth <thuth@redhat.com>

When running the migration test compiled with Clang from Fedora 37
and sanitizers enabled, there is an error complaining about unlink():

 ../tests/qtest/migration-test.c:1072:12: runtime error: null pointer
  passed as argument 1, which is declared to never be null
 /usr/include/unistd.h:858:48: note: nonnull attribute specified here
 SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior
  ../tests/qtest/migration-test.c:1072:12 in
 (test program exited with status code 1)
 TAP parsing error: Too few tests run (expected 33, got 20)

The data->clientcert and data->clientkey pointers can indeed be unset
in some tests, so we have to check them before calling unlink() with
those.

While we're at it, I also noticed that the code is only freeing
some but not all of the allocated strings in this function, and
indeed, valgrind is also complaining about memory leaks here.
So let's call g_free() on all allocated strings to avoid leaking
memory here.

Message-Id: <20221125083054.117504-1-thuth@redhat.com>
Tested-by: Bin Meng <bmeng@tinylab.org>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 tests/qtest/migration-test.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/tests/qtest/migration-test.c b/tests/qtest/migration-test.c
index 442998d9eb..dbde726adf 100644
--- a/tests/qtest/migration-test.c
+++ b/tests/qtest/migration-test.c
@@ -1066,15 +1066,27 @@ test_migrate_tls_x509_finish(QTestState *from,
     TestMigrateTLSX509Data *data = opaque;
 
     test_tls_cleanup(data->keyfile);
+    g_free(data->keyfile);
+
     unlink(data->cacert);
+    g_free(data->cacert);
     unlink(data->servercert);
+    g_free(data->servercert);
     unlink(data->serverkey);
-    unlink(data->clientcert);
-    unlink(data->clientkey);
+    g_free(data->serverkey);
+
+    if (data->clientcert) {
+        unlink(data->clientcert);
+        g_free(data->clientcert);
+    }
+    if (data->clientkey) {
+        unlink(data->clientkey);
+        g_free(data->clientkey);
+    }
+
     rmdir(data->workdir);
-
     g_free(data->workdir);
-    g_free(data->keyfile);
+
     g_free(data);
 }
 #endif /* CONFIG_TASN1 */
-- 
2.38.1

