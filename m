Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1681834901; x=1684426901;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=nVPcgNqV4+yTyF7JyxZthOMz/9y/APO3HAlemN7QWn4=;
 b=lh3DoEscXnSGZYVJilsLz7CrDv9jETtkrvXu+/jcvnYRChkSlFa0gMBrojRPrqfezm
 zcULKjJGS8RaT8aZhvGHhlkLwhnBEgfqiccMtVwvOrVhOM8VUDce9BEqe817a3fV++AF
 b8Fzoasw4jnYQEpCZZQA9Whf7zjpTx8k1hoMSuYQLXpB5O6aW94aX+BsxZcaWgcCtWFj
 GwHTSAjzwlWw0WxXnQ3Epi7KoMVB7gmS06TJ8BAcwtRpChb0T6/HFiPc7icqh5IbhDwx
 7PWEGuQupe02XWKsNW52Us+WswQre3G1SkNN+/T+GlTiENr8BfRHfqOR7a+nTr1QLoOg
 vyUg==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Tue, 18 Apr 2023 17:21:28 +0100
Message-Id: <20230418162140.373219-2-alex.bennee@linaro.org>
In-Reply-To: <20230418162140.373219-1-alex.bennee@linaro.org>
References: <20230418162140.373219-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 01/13] include: attempt to document
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
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Markus Armbruster <armbru@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, Jason Wang <jasowang@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Gerd Hoffmann <kraxel@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Eric Blake <eblake@redhat.com>

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
index bd50ad5ee1..d4bbc30c92 100644
--- a/include/hw/qdev-core.h
+++ b/include/hw/qdev-core.h
@@ -776,6 +776,15 @@ BusState *sysbus_get_default(void);
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

