From: Greg Kurz <groug@kaod.org>
Date: Thu, 20 May 2021 17:46:53 +0200
Message-Id: <20210520154654.1791183-5-groug@kaod.org>
In-Reply-To: <20210520154654.1791183-1-groug@kaod.org>
References: <20210520154654.1791183-1-groug@kaod.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 4/5] virtiofs: Skip submounts in sget_fc()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, Max Reitz <mreitz@redhat.com>, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>

All submounts share the same virtio-fs device instance as the root
mount. If the same virtiofs filesystem is mounted again, sget_fc()
is likely to pick up any of these submounts and reuse it instead of
the root mount.

On the server side:

# mkdir ${some_dir}
# mkdir ${some_dir}/mnt1
# mount -t tmpfs none ${some_dir}/mnt1
# touch ${some_dir}/mnt1/THIS_IS_MNT1
# mkdir ${some_dir}/mnt2
# mount -t tmpfs none ${some_dir}/mnt2
# touch ${some_dir}/mnt2/THIS_IS_MNT2

On the client side:

# mkdir /mnt/virtiofs1
# mount -t virtiofs myfs /mnt/virtiofs1
# ls /mnt/virtiofs1
mnt1 mnt2
# grep virtiofs /proc/mounts
myfs /mnt/virtiofs1 virtiofs rw,seclabel,relatime 0 0
none on /mnt/mnt1 type virtiofs (rw,relatime,seclabel)
none on /mnt/mnt2 type virtiofs (rw,relatime,seclabel)

And now remount it again:

# mount -t virtiofs myfs /mnt/virtiofs2
# grep virtiofs /proc/mounts
myfs /mnt/virtiofs1 virtiofs rw,seclabel,relatime 0 0
none on /mnt/mnt1 type virtiofs (rw,relatime,seclabel)
none on /mnt/mnt2 type virtiofs (rw,relatime,seclabel)
myfs /mnt/virtiofs2 virtiofs rw,seclabel,relatime 0 0
# ls /mnt/virtiofs2
THIS_IS_MNT2

Submount mnt2 was picked-up instead of the root mount.

Just skip submounts in virtio_fs_test_super().

Signed-off-by: Greg Kurz <groug@kaod.org>
---
 fs/fuse/virtio_fs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index e12e5190352c..8962cd033016 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1408,6 +1408,11 @@ static int virtio_fs_test_super(struct super_block *sb,
 	struct fuse_mount *fsc_fm = fsc->s_fs_info;
 	struct fuse_mount *sb_fm = get_fuse_mount_super(sb);
 
+
+	/* Skip submounts */
+	if (!list_is_first(&sb_fm->fc_entry, &sb_fm->fc->mounts))
+		return 0;
+
 	return fsc_fm->fc->iq.priv == sb_fm->fc->iq.priv;
 }
 
-- 
2.26.3

