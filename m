From: Max Reitz <mreitz@redhat.com>
Date: Thu, 29 Oct 2020 18:17:39 +0100
Message-Id: <20201029171744.150726-3-mreitz@redhat.com>
In-Reply-To: <20201029171744.150726-1-mreitz@redhat.com>
References: <20201029171744.150726-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 2/7] virtiofsd: Add attr_flags to
	fuse_entry_param
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, Max Reitz <mreitz@redhat.com>

fuse_entry_param is converted to fuse_attr on the line (by
fill_entry()), so it should have a member that mirrors fuse_attr.flags.

fill_entry() should then copy this fuse_entry_param.attr_flags to
fuse_attr.flags.

Signed-off-by: Max Reitz <mreitz@redhat.com>
---
 tools/virtiofsd/fuse_lowlevel.h | 5 +++++
 tools/virtiofsd/fuse_lowlevel.c | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
index 562fd5241e..9c06240f9e 100644
--- a/tools/virtiofsd/fuse_lowlevel.h
+++ b/tools/virtiofsd/fuse_lowlevel.h
@@ -102,6 +102,11 @@ struct fuse_entry_param {
      *  large value.
      */
     double entry_timeout;
+
+    /**
+     * Flags for fuse_attr.flags that do not fit into attr.
+     */
+    uint32_t attr_flags;
 };
 
 /**
diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 370222339b..c70fb16a9a 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -341,6 +341,8 @@ static void fill_entry(struct fuse_entry_out *arg,
         .attr_valid_nsec = calc_timeout_nsec(e->attr_timeout),
     };
     convert_stat(&e->attr, &arg->attr);
+
+    arg->attr.flags = e->attr_flags;
 }
 
 /*
-- 
2.26.2

