Return-Path: <stefanha@redhat.com>
From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu, 20 Apr 2023 08:09:30 -0400
Message-Id: <20230420120948.436661-3-stefanha@redhat.com>
In-Reply-To: <20230420120948.436661-1-stefanha@redhat.com>
References: <20230420120948.436661-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 02/20] block/file-posix: introduce helper
 functions for sysfs attributes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, Markus Armbruster <armbru@redhat.com>, Julia Suvorova <jusual@redhat.com>, Eric Blake <eblake@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Thomas Huth <thuth@redhat.com>, qemu-block@nongnu.org, Cornelia Huck <cohuck@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Fam Zheng <fam@euphon.net>, Aarushi Mehta <mehta.aaru20@gmail.com>, Sam Li <faithilikerun@gmail.com>, Hannes Reinecke <hare@suse.de>, Damien Le Moal <damien.lemoal@opensource.wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>

From: Sam Li <faithilikerun@gmail.com>

Use get_sysfs_str_val() to get the string value of device
zoned model. Then get_sysfs_zoned_model() can convert it to
BlockZoneModel type of QEMU.

Use get_sysfs_long_val() to get the long value of zoned device
information.

Signed-off-by: Sam Li <faithilikerun@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Acked-by: Kevin Wolf <kwolf@redhat.com>
Message-id: 20230324090605.28361-3-faithilikerun@gmail.com
[Adjust commit message prefix as suggested by Philippe Mathieu-Daudé
<philmd@linaro.org>.
--Stefan]
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/block/block_int-common.h |   3 +
 block/file-posix.c               | 130 ++++++++++++++++++++++---------
 2 files changed, 95 insertions(+), 38 deletions(-)

diff --git a/include/block/block_int-common.h b/include/block/block_int-common.h
index f01bb8b617..06dd89031f 100644
--- a/include/block/block_int-common.h
+++ b/include/block/block_int-common.h
@@ -861,6 +861,9 @@ typedef struct BlockLimits {
      * an explicit monitor command to load the disk inside the guest).
      */
     bool has_variable_length;
+
+    /* device zone model */
+    BlockZoneModel zoned;
 } BlockLimits;
 
 typedef struct BdrvOpBlocker BdrvOpBlocker;
diff --git a/block/file-posix.c b/block/file-posix.c
index c2dee3f056..2697cb6699 100644
--- a/block/file-posix.c
+++ b/block/file-posix.c
@@ -1202,15 +1202,93 @@ static int hdev_get_max_hw_transfer(int fd, struct stat *st)
 #endif
 }
 
-static int hdev_get_max_segments(int fd, struct stat *st)
+/*
+ * Get a sysfs attribute value as character string.
+ */
+static int get_sysfs_str_val(struct stat *st, const char *attribute,
+                             char **val) {
+#ifdef CONFIG_LINUX
+    g_autofree char *sysfspath = NULL;
+    int ret;
+    size_t len;
+
+    if (!S_ISBLK(st->st_mode)) {
+        return -ENOTSUP;
+    }
+
+    sysfspath = g_strdup_printf("/sys/dev/block/%u:%u/queue/%s",
+                                major(st->st_rdev), minor(st->st_rdev),
+                                attribute);
+    ret = g_file_get_contents(sysfspath, val, &len, NULL);
+    if (ret == -1) {
+        return -ENOENT;
+    }
+
+    /* The file is ended with '\n' */
+    char *p;
+    p = *val;
+    if (*(p + len - 1) == '\n') {
+        *(p + len - 1) = '\0';
+    }
+    return ret;
+#else
+    return -ENOTSUP;
+#endif
+}
+
+static int get_sysfs_zoned_model(struct stat *st, BlockZoneModel *zoned)
+{
+    g_autofree char *val = NULL;
+    int ret;
+
+    ret = get_sysfs_str_val(st, "zoned", &val);
+    if (ret < 0) {
+        return ret;
+    }
+
+    if (strcmp(val, "host-managed") == 0) {
+        *zoned = BLK_Z_HM;
+    } else if (strcmp(val, "host-aware") == 0) {
+        *zoned = BLK_Z_HA;
+    } else if (strcmp(val, "none") == 0) {
+        *zoned = BLK_Z_NONE;
+    } else {
+        return -ENOTSUP;
+    }
+    return 0;
+}
+
+/*
+ * Get a sysfs attribute value as a long integer.
+ */
+static long get_sysfs_long_val(struct stat *st, const char *attribute)
 {
 #ifdef CONFIG_LINUX
-    char buf[32];
+    g_autofree char *str = NULL;
     const char *end;
-    char *sysfspath = NULL;
+    long val;
+    int ret;
+
+    ret = get_sysfs_str_val(st, attribute, &str);
+    if (ret < 0) {
+        return ret;
+    }
+
+    /* The file is ended with '\n', pass 'end' to accept that. */
+    ret = qemu_strtol(str, &end, 10, &val);
+    if (ret == 0 && end && *end == '\0') {
+        ret = val;
+    }
+    return ret;
+#else
+    return -ENOTSUP;
+#endif
+}
+
+static int hdev_get_max_segments(int fd, struct stat *st)
+{
+#ifdef CONFIG_LINUX
     int ret;
-    int sysfd = -1;
-    long max_segments;
 
     if (S_ISCHR(st->st_mode)) {
         if (ioctl(fd, SG_GET_SG_TABLESIZE, &ret) == 0) {
@@ -1218,39 +1296,7 @@ static int hdev_get_max_segments(int fd, struct stat *st)
         }
         return -ENOTSUP;
     }
-
-    if (!S_ISBLK(st->st_mode)) {
-        return -ENOTSUP;
-    }
-
-    sysfspath = g_strdup_printf("/sys/dev/block/%u:%u/queue/max_segments",
-                                major(st->st_rdev), minor(st->st_rdev));
-    sysfd = open(sysfspath, O_RDONLY);
-    if (sysfd == -1) {
-        ret = -errno;
-        goto out;
-    }
-    ret = RETRY_ON_EINTR(read(sysfd, buf, sizeof(buf) - 1));
-    if (ret < 0) {
-        ret = -errno;
-        goto out;
-    } else if (ret == 0) {
-        ret = -EIO;
-        goto out;
-    }
-    buf[ret] = 0;
-    /* The file is ended with '\n', pass 'end' to accept that. */
-    ret = qemu_strtol(buf, &end, 10, &max_segments);
-    if (ret == 0 && end && *end == '\n') {
-        ret = max_segments;
-    }
-
-out:
-    if (sysfd != -1) {
-        close(sysfd);
-    }
-    g_free(sysfspath);
-    return ret;
+    return get_sysfs_long_val(st, "max_segments");
 #else
     return -ENOTSUP;
 #endif
@@ -1260,6 +1306,8 @@ static void raw_refresh_limits(BlockDriverState *bs, Error **errp)
 {
     BDRVRawState *s = bs->opaque;
     struct stat st;
+    int ret;
+    BlockZoneModel zoned;
 
     s->needs_alignment = raw_needs_alignment(bs);
     raw_probe_alignment(bs, s->fd, errp);
@@ -1297,6 +1345,12 @@ static void raw_refresh_limits(BlockDriverState *bs, Error **errp)
             bs->bl.max_hw_iov = ret;
         }
     }
+
+    ret = get_sysfs_zoned_model(&st, &zoned);
+    if (ret < 0) {
+        zoned = BLK_Z_NONE;
+    }
+    bs->bl.zoned = zoned;
 }
 
 static int check_for_dasd(int fd)
-- 
2.39.2

