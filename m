Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:51:40 +0100
Message-Id: <20221205095228.1314-4-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 03/51] replay: Fix declaration of
 replay_read_next_clock
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Fam Zheng <fam@euphon.net>, Thomas Huth <huth@tuxfamily.org>, Viresh Kumar <viresh.kumar@linaro.org>, Kevin Wolf <kwolf@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Laurent Vivier <laurent@vivier.eu>, Eric Blake <eblake@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, qemu-block@nongnu.org, Xiaojuan Yang <yangxiaojuan@loongson.cn>, Thomas Huth <thuth@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Peter Maydell <peter.maydell@linaro.org>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <lvivier@redhat.com>, Song Gao <gaosong@loongson.cn>, qemu-s390x@nongnu.org, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, Klaus Jensen <its@irrelevant.dk>, John Snow <jsnow@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Keith Busch <kbusch@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-trivial@nongnu.org, Hanna Reitz <hreitz@redhat.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Wilfred Mallawa <wilfred.mallawa@wdc.com>, Pavel Dovgalyuk <Pavel.Dovgalyuk@ispras.ru>

From: Richard Henderson <richard.henderson@linaro.org>

Fixes the build with gcc 13:

replay/replay-time.c:34:6: error: conflicting types for  \
  'replay_read_next_clock' due to enum/integer mismatch; \
  have 'void(ReplayClockKind)' [-Werror=enum-int-mismatch]
   34 | void replay_read_next_clock(ReplayClockKind kind)
      |      ^~~~~~~~~~~~~~~~~~~~~~
In file included from ../qemu/replay/replay-time.c:14:
replay/replay-internal.h:139:6: note: previous declaration of \
  'replay_read_next_clock' with type 'void(unsigned int)'
  139 | void replay_read_next_clock(unsigned int kind);
      |      ^~~~~~~~~~~~~~~~~~~~~~

Fixes: 8eda206e090 ("replay: recording and replaying clock ticks")
Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Reviewed-by: Pavel Dovgalyuk <Pavel.Dovgalyuk@ispras.ru>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-Id: <20221129010547.284051-1-richard.henderson@linaro.org>
---
 replay/replay-internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/replay/replay-internal.h b/replay/replay-internal.h
index 89e377be90..b6836354ac 100644
--- a/replay/replay-internal.h
+++ b/replay/replay-internal.h
@@ -136,7 +136,7 @@ bool replay_next_event_is(int event);
 /*! Reads next clock value from the file.
     If clock kind read from the file is different from the parameter,
     the value is not used. */
-void replay_read_next_clock(unsigned int kind);
+void replay_read_next_clock(ReplayClockKind kind);
 
 /* Asynchronous events queue */
 
-- 
2.38.1

