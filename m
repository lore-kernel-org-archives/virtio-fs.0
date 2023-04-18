Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1681834904; x=1684426904;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=uMkpUFkutd+rkxciDVz0OwgC4E2pyiYQdv8Xz2UBqBQ=;
 b=pYO2bM/HxOUrYC2DCsCRsjUUil5wQCYuoiMIhEF3v/4pvUZw5SxTR7GpxY2ZJ++QAw
 oPlH6J74QUxKDX2bcgL2k2W5n1rnYaLSnBCD0xpyAqUaM5DGpkcwL5fBqFZ0IoK97QN/
 biv1o3AT+5wDuC2L2ewl1wv8Vt9YsNUgAko0HRw7QGGBTb7e23NClAdTMtFSKZQRJtWV
 1BYFEkSJ0axr1mLY/wzHlubuAh8kWI6w9616SLVuGb+wPGZqWk5r1AQMAaPdWcajJuY5
 3zWODqYBwvT6bKsIuZG/Yf4UQtzHE514S8e7WxxiQP/Yz+tMbDb35wWY/5IM4a2+HhmU
 AK2w==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Tue, 18 Apr 2023 17:21:33 +0100
Message-Id: <20230418162140.373219-7-alex.bennee@linaro.org>
In-Reply-To: <20230418162140.373219-1-alex.bennee@linaro.org>
References: <20230418162140.373219-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 06/13] include/hw/virtio: document some more
 usage of notifiers
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Markus Armbruster <armbru@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, Jason Wang <jasowang@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Gerd Hoffmann <kraxel@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Eric Blake <eblake@redhat.com>

Lets document some more of the core VirtIODevice structure.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/hw/virtio/virtio.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index 1ba7a9dd74..ef77e9ef0e 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -150,10 +150,18 @@ struct VirtIODevice
     VMChangeStateEntry *vmstate;
     char *bus_name;
     uint8_t device_endian;
+    /**
+     * @user_guest_notifier_mask: gate usage of ->guest_notifier_mask() callback.
+     * This is used to suppress the masking of guest updates for
+     * vhost-user devices which are asynchronous by design.
+     */
     bool use_guest_notifier_mask;
     AddressSpace *dma_as;
     QLIST_HEAD(, VirtQueue) *vector_queues;
     QTAILQ_ENTRY(VirtIODevice) next;
+    /**
+     * @config_notifier: the event notifier that handles config events
+     */
     EventNotifier config_notifier;
 };
 
-- 
2.39.2

