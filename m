Date: Thu, 2 Sep 2021 11:38:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YTDwCFbO9Jl6a7vP@redhat.com>
References: <20210902152228.665959-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902152228.665959-1-vgoyal@redhat.com>
Subject: [Virtio-fs] [PATCH 2/1] man-pages: xattr.7: Update text for user
 extended xattr behavior change
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-api@vger.kernel.org, mtk.manpages@gmail.com
Cc: gscrivan@redhat.com, tytso@mit.edu, agruenba@redhat.com, miklos@szeredi.hu, selinux@vger.kernel.org, stephen.smalley.work@gmail.com, david@fromorbit.com, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, casey.schaufler@intel.com, linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, bfields@redhat.com, christian.brauner@ubuntu.com

I have proposed a patch to relax restrictions on user extended xattrs and
allow file owner (or CAP_FOWNER) to get/set user extended xattrs on symlink
and device files.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 man7/xattr.7 |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: man-pages/man7/xattr.7
===================================================================
--- man-pages.orig/man7/xattr.7	2021-09-01 13:46:16.165016463 -0400
+++ man-pages/man7/xattr.7	2021-09-01 16:31:51.038016463 -0400
@@ -129,8 +129,13 @@ a way not controllable by disk quotas fo
 special files and directories.
 .PP
 For this reason,
-user extended attributes are allowed only for regular files and directories,
-and access to user extended attributes is restricted to the
+user extended attributes are allowed only for regular files and directories
+till kernel 5.14. In newer kernel (5.15 onwards), restrictions have been
+relaxed a bit and user extended attributes are also allowed on symlinks
+and special files as long as caller is either owner of the file or is
+privileged (CAP_FOWNER).
+
+Access to user extended attributes is restricted to the
 owner and to users with appropriate capabilities for directories with the
 sticky bit set (see the
 .BR chmod (1)

