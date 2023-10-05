Return-Path: <vgoyal@fedora.redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu,  5 Oct 2023 16:30:30 -0400
Message-ID: <20231005203030.223489-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] virtiofs: Export filesystem tags through sysfs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com
Cc: vgoyal@redhat.com, miklos@szeredi.hu, stefanha@redhat.com, mzxreary@0pointer.de, gmaglione@redhat.com

virtiofs filesystem is mounted using a "tag" which is exported by the
virtiofs device. virtiofs driver knows about all the available tags but
these are not exported to user space.

People have asked these tags to be exported to user space. Most recently
Lennart Poettering has asked for it as he wants to scan the tags and mount
virtiofs automatically in certain cases.

https://gitlab.com/virtio-fs/virtiofsd/-/issues/128

This patch exports tags through sysfs. One tag is associated with each
virtiofs device. A new "tag" file appears under virtiofs device dir.
Actual filesystem tag can be obtained by reading this "tag" file.

For example, if a virtiofs device exports tag "myfs", a new file "tag"
will show up here.

/sys/bus/virtio/devices/virtio<N>/tag

# cat /sys/bus/virtio/devices/virtio<N>/tag
myfs

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 5f1be1da92ce..a5b11e18f331 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -107,6 +107,21 @@ static const struct fs_parameter_spec virtio_fs_parameters[] = {
 	{}
 };
 
+/* Forward Declarations */
+static void virtio_fs_stop_all_queues(struct virtio_fs *fs);
+
+/* sysfs related */
+static ssize_t tag_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct virtio_device *vdev = container_of(dev, struct virtio_device,
+						  dev);
+	struct virtio_fs *fs = vdev->priv;
+
+	return sysfs_emit(buf, "%s", fs->tag);
+}
+static DEVICE_ATTR_RO(tag);
+
 static int virtio_fs_parse_param(struct fs_context *fsc,
 				 struct fs_parameter *param)
 {
@@ -265,6 +280,15 @@ static int virtio_fs_add_instance(struct virtio_fs *fs)
 	return 0;
 }
 
+static void virtio_fs_remove_instance(struct virtio_fs *fs)
+{
+	mutex_lock(&virtio_fs_mutex);
+	list_del_init(&fs->list);
+	virtio_fs_stop_all_queues(fs);
+	virtio_fs_drain_all_queues_locked(fs);
+	mutex_unlock(&virtio_fs_mutex);
+}
+
 /* Return the virtio_fs with a given tag, or NULL */
 static struct virtio_fs *virtio_fs_find_instance(const char *tag)
 {
@@ -891,8 +915,15 @@ static int virtio_fs_probe(struct virtio_device *vdev)
 	if (ret < 0)
 		goto out_vqs;
 
+	/* Export tag through sysfs */
+	ret = device_create_file(&vdev->dev, &dev_attr_tag);
+	if (ret < 0)
+		goto out_sysfs_attr;
+
 	return 0;
 
+out_sysfs_attr:
+	virtio_fs_remove_instance(fs);
 out_vqs:
 	virtio_reset_device(vdev);
 	virtio_fs_cleanup_vqs(vdev);
@@ -922,6 +953,9 @@ static void virtio_fs_remove(struct virtio_device *vdev)
 	struct virtio_fs *fs = vdev->priv;
 
 	mutex_lock(&virtio_fs_mutex);
+	/* Remove tag attr from sysfs */
+	device_remove_file(&vdev->dev, &dev_attr_tag);
+
 	/* This device is going away. No one should get new reference */
 	list_del_init(&fs->list);
 	virtio_fs_stop_all_queues(fs);
-- 
2.41.0

