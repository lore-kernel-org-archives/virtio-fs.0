Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1689003324; x=1691595324;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=2VTCVQrd6KCn5j7u4ggdRsXsalHDUZEasAWYhlhI0Zk=;
 b=j+WDoZ1iK16umdVplpNjyby+C0HXEitODI37kGwJGXP8HLOVKe7rt/a/fw7jXjba2v
 zs1wAHlxk/Q0gaA1/EiJk1gIej/DaDqErNIuRsyn+V1aYx2zPQYHF82wztebpRwOgDdR
 wDqaRu8ZbrT7AmcnqHRt5hh/t3t9ctn/KE0KuSYJ1MRNrZYGPsAaBSC6EWxhxA/ELSah
 ssLutXIIMBRxXlihjutw4bgwVOv+fE2at4V0BKhYv7N3unwblarbHdJ1Zs11Q/JzVm2K
 nGkk3S7WpCKhBVvOhtq0iL4/XKlTn9C4IYBO7y1oNaY9ibZp27R/VNPsJVXR0gDmkWip
 wm2A==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Mon, 10 Jul 2023 16:35:03 +0100
Message-Id: <20230710153522.3469097-2-alex.bennee@linaro.org>
In-Reply-To: <20230710153522.3469097-1-alex.bennee@linaro.org>
References: <20230710153522.3469097-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 01/20] include: attempt to document
 device_class_set_props
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, qemu-block@nongnu.org, Eric Blake <eblake@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Kevin Wolf <kwolf@redhat.com>, Markus Armbruster <armbru@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Hanna Reitz <hreitz@redhat.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Erik Schilling <erik.schilling@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Eduardo Habkost <eduardo@habkost.net>, Fam Zheng <fam@euphon.net>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>

I'm still not sure how I achieve by use case of the parent class
defining the following properties:

  static Property vud_properties[] = {
      DEFINE_PROP_CHR("chardev", VHostUserDevice, chardev),
      DEFINE_PROP_UINT16("id", VHostUserDevice, id, 0),
      DEFINE_PROP_UINT32("num_vqs", VHostUserDevice, num_vqs, 1),
      DEFINE_PROP_END_OF_LIST(),
  };

But for the specialisation of the class I want the id to default to
the actual device id, e.g.:

  static Property vu_rng_properties[] = {
      DEFINE_PROP_UINT16("id", VHostUserDevice, id, VIRTIO_ID_RNG),
      DEFINE_PROP_UINT32("num_vqs", VHostUserDevice, num_vqs, 1),
      DEFINE_PROP_END_OF_LIST(),
  };

And so far the API for doing that isn't super clear.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/hw/qdev-core.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/hw/qdev-core.h b/include/hw/qdev-core.h
index 06cadfc492..196ebf6d91 100644
--- a/include/hw/qdev-core.h
+++ b/include/hw/qdev-core.h
@@ -926,6 +926,15 @@ BusState *sysbus_get_default(void);
 char *qdev_get_fw_dev_path(DeviceState *dev);
 char *qdev_get_own_fw_dev_path_from_handler(BusState *bus, DeviceState *dev);
 
+/**
+ * device_class_set_props(): add a set of properties to an device
+ * @dc: the parent DeviceClass all devices inherit
+ * @props: an array of properties, terminate by DEFINE_PROP_END_OF_LIST()
+ *
+ * This will add a set of properties to the object. It will fault if
+ * you attempt to add an existing property defined by a parent class.
+ * To modify an inherited property you need to use????
+ */
 void device_class_set_props(DeviceClass *dc, Property *props);
 
 /**
-- 
2.39.2

