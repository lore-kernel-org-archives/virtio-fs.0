From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Tue,  2 Nov 2021 13:26:04 +0800
Message-Id: <20211102052604.59462-8-jefflexu@linux.alibaba.com>
In-Reply-To: <20211102052604.59462-1-jefflexu@linux.alibaba.com>
References: <20211102052604.59462-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v7 7/7] Documentation/filesystem/dax: record DAX
	on virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu
Cc: virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, joseph.qi@linux.alibaba.com

Record DAX on virtiofs and the semantic difference with that on ext4
and xfs.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 Documentation/filesystems/dax.rst | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/dax.rst b/Documentation/filesystems/dax.rst
index 9a1b8fd9e82b..e3b30429d703 100644
--- a/Documentation/filesystems/dax.rst
+++ b/Documentation/filesystems/dax.rst
@@ -23,8 +23,8 @@ on it as usual.  The `DAX` code currently only supports files with a block
 size equal to your kernel's `PAGE_SIZE`, so you may need to specify a block
 size when creating the filesystem.
 
-Currently 3 filesystems support `DAX`: ext2, ext4 and xfs.  Enabling `DAX` on them
-is different.
+Currently 4 filesystems support `DAX`: ext2, ext4, xfs and virtiofs.
+Enabling `DAX` on them is different.
 
 Enabling DAX on ext2
 --------------------
@@ -168,6 +168,22 @@ if the underlying media does not support dax and/or the filesystem is
 overridden with a mount option.
 
 
+Enabling DAX on virtiofs
+----------------------------
+The semantic of DAX on virtiofs is basically equal to that on ext4 and xfs,
+except that when '-o dax=inode' is specified, virtiofs client derives the hint
+whether DAX shall be enabled or not from virtiofs server through FUSE protocol,
+rather than the persistent `FS_XFLAG_DAX` flag. That is, whether DAX shall be
+enabled or not is completely determined by virtiofs server, while virtiofs
+server itself may deploy various algorithm making this decision, e.g. depending
+on the persistent `FS_XFLAG_DAX` flag on the host.
+
+It is still supported to set or clear persistent `FS_XFLAG_DAX` flag inside
+guest, but it is not guaranteed that DAX will be enabled or disabled for
+corresponding file then. Users inside guest still need to call statx(2) and
+check the statx flag `STATX_ATTR_DAX` to see if DAX is enabled for this file.
+
+
 Implementation Tips for Block Driver Writers
 --------------------------------------------
 
-- 
2.27.0

