Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1681488277; x=1684080277;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=87Eys71a5bFDwpsmcqiXjalsGOMTQZkXpUaxljHCLjI=;
 b=Lkv7hQWdIlA2sElrxSUtHPNg4UUF+/pMmmAB5iBfBiSP6hz/+L1/iAytdkjdaALLr8
 F1GVjHMQ99qOBDE23t2pXSpoFe0kUvHQBbNg7jPSYR/BVBtOo3hRjuhRfNcd88/luB9N
 rBpCIzB1Y9tY+p72b+QRHqRtXGJC+4USvPU9TqNQZbbwJEfMPD0ivv8p/sNwonnMdH76
 2IrAaCqe7w7YVX8cHy543Q2idXIgyZZDDDlg6pxvpUQMMzbCmVhfle3Clmw7mYNcKfE5
 ANOQFG9xHDCz5+tkO6hd9ozTrgmcX9boEez6MwSvCZt4YwKcXBMe3PgChfnO+LdSdwG/
 YmMw==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Fri, 14 Apr 2023 17:04:29 +0100
Message-Id: <20230414160433.2096866-9-alex.bennee@linaro.org>
In-Reply-To: <20230414160433.2096866-1-alex.bennee@linaro.org>
References: <20230414160433.2096866-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 08/12] qom: allow for properties to become
 "fixed"
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "Gonglei (Arei)" <arei.gonglei@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, Erik Schilling <erik.schilling@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Stefan Hajnoczi <stefanha@redhat.com>, Eric Blake <eblake@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, Markus Armbruster <armbru@redhat.com>

When specialising general purpose objects it is sometimes useful to
"fix" some of the properties that were configurable by the base
classes. We will use this facility when specialising
vhost-user-device.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 qapi/qom.json           |  2 ++
 include/qom/object.h    | 16 +++++++++++++++-
 qom/object.c            | 14 ++++++++++++++
 qom/object_interfaces.c |  9 ++++++---
 qom/qom-qmp-cmds.c      |  1 +
 softmmu/qdev-monitor.c  |  1 +
 6 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/qapi/qom.json b/qapi/qom.json
index a877b879b9..4cda191f00 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -33,12 +33,14 @@
 # @description: if specified, the description of the property.
 #
 # @default-value: the default value, if any (since 5.0)
+# @fixed: if specified if value has been fixed (since 8.1)
 #
 # Since: 1.2
 ##
 { 'struct': 'ObjectPropertyInfo',
   'data': { 'name': 'str',
             'type': 'str',
+            'fixed': 'bool',
             '*description': 'str',
             '*default-value': 'any' } }
 
diff --git a/include/qom/object.h b/include/qom/object.h
index ef7258a5e1..f18d1a8254 100644
--- a/include/qom/object.h
+++ b/include/qom/object.h
@@ -97,6 +97,8 @@ struct ObjectProperty
     ObjectPropertyInit *init;
     void *opaque;
     QObject *defval;
+    /** @fixed: if the property has been fixed at its default */
+    bool fixed;
 };
 
 /**
@@ -1111,6 +1113,17 @@ void object_property_set_default_int(ObjectProperty *prop, int64_t value);
  */
 void object_property_set_default_uint(ObjectProperty *prop, uint64_t value);
 
+/**
+ * object_property_fix_default_uint:
+ * @prop: the property to be fixed
+ * @value: the fixed value to be written to the property
+ *
+ * When specialising an object it may make send to fix some values and
+ * not allow them to be changed. This can only be applied to
+ * properties that previously had a default and now cannot be changed.
+ */
+void object_property_fix_default_uint(ObjectProperty *prop, uint64_t value);
+
 /**
  * object_property_find:
  * @obj: the object
@@ -1961,13 +1974,14 @@ size_t object_type_get_instance_size(const char *typename);
  * object_property_help:
  * @name: the name of the property
  * @type: the type of the property
+ * @fixed: has the value been fixed
  * @defval: the default value
  * @description: description of the property
  *
  * Returns: a user-friendly formatted string describing the property
  * for help purposes.
  */
-char *object_property_help(const char *name, const char *type,
+char *object_property_help(const char *name, const char *type, bool fixed,
                            QObject *defval, const char *description);
 
 G_DEFINE_AUTOPTR_CLEANUP_FUNC(Object, object_unref)
diff --git a/qom/object.c b/qom/object.c
index e25f1e96db..b5aba3ffc8 100644
--- a/qom/object.c
+++ b/qom/object.c
@@ -1584,6 +1584,20 @@ void object_property_set_default_uint(ObjectProperty *prop, uint64_t value)
     object_property_set_default(prop, QOBJECT(qnum_from_uint(value)));
 }
 
+static void object_property_fix_default(ObjectProperty *prop, QObject *defval)
+{
+    g_assert(prop->init == object_property_init_defval);
+    g_assert(!prop->fixed);
+
+    prop->defval = defval;
+    prop->fixed = true;
+}
+
+void object_property_fix_default_uint(ObjectProperty *prop, uint64_t value)
+{
+    object_property_fix_default(prop, QOBJECT(qnum_from_uint(value)));
+}
+
 bool object_property_set_uint(Object *obj, const char *name,
                               uint64_t value, Error **errp)
 {
diff --git a/qom/object_interfaces.c b/qom/object_interfaces.c
index 7d31589b04..e351938f8f 100644
--- a/qom/object_interfaces.c
+++ b/qom/object_interfaces.c
@@ -161,7 +161,7 @@ void user_creatable_add_qapi(ObjectOptions *options, Error **errp)
     visit_free(v);
 }
 
-char *object_property_help(const char *name, const char *type,
+char *object_property_help(const char *name, const char *type, bool fixed,
                            QObject *defval, const char *description)
 {
     GString *str = g_string_new(NULL);
@@ -179,7 +179,9 @@ char *object_property_help(const char *name, const char *type,
     if (defval) {
         g_autofree char *def_json = g_string_free(qobject_to_json(defval),
                                                   false);
-        g_string_append_printf(str, " (default: %s)", def_json);
+        g_string_append_printf(str, " (%s: %s)",
+                               fixed ? "fixed" : "default",
+                               def_json);
     }
 
     return g_string_free(str, false);
@@ -220,7 +222,8 @@ bool type_print_class_properties(const char *type)
 
         g_ptr_array_add(array,
                         object_property_help(prop->name, prop->type,
-                                             prop->defval, prop->description));
+                                             prop->fixed, prop->defval,
+                                             prop->description));
     }
     g_ptr_array_sort(array, (GCompareFunc)qemu_pstrcmp0);
     if (array->len > 0) {
diff --git a/qom/qom-qmp-cmds.c b/qom/qom-qmp-cmds.c
index 7c087299de..f4cdf4ddde 100644
--- a/qom/qom-qmp-cmds.c
+++ b/qom/qom-qmp-cmds.c
@@ -55,6 +55,7 @@ ObjectPropertyInfoList *qmp_qom_list(const char *path, Error **errp)
 
         value->name = g_strdup(prop->name);
         value->type = g_strdup(prop->type);
+        value->fixed = prop->fixed;
     }
 
     return props;
diff --git a/softmmu/qdev-monitor.c b/softmmu/qdev-monitor.c
index b8d2c4dadd..b56b2af2f2 100644
--- a/softmmu/qdev-monitor.c
+++ b/softmmu/qdev-monitor.c
@@ -315,6 +315,7 @@ int qdev_device_help(QemuOpts *opts)
         g_ptr_array_add(array,
                         object_property_help(prop->value->name,
                                              prop->value->type,
+                                             prop->value->fixed,
                                              prop->value->default_value,
                                              prop->value->description));
     }
-- 
2.39.2

