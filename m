From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 24 Jul 2020 14:38:11 -0400
Message-Id: <20200724183812.19573-5-vgoyal@redhat.com>
In-Reply-To: <20200724183812.19573-1-vgoyal@redhat.com>
References: <20200724183812.19573-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 4/5] fuse: For sending setattr in case of
	open(O_TRUNC)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, miklos@szeredi.hu
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

open(O_TRUNC) will not kill suid/sgid on server and fuse_open_in does not
have information if caller has CAP_FSETID or not.

So force sending setattr() which is called after open(O_TRUNC) so that
server clears setuid/setgid.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 82747ca4c5c8..0572779abbbe 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1516,7 +1516,7 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
 		/* This is coming from open(..., ... | O_TRUNC); */
 		WARN_ON(!(attr->ia_valid & ATTR_SIZE));
 		WARN_ON(attr->ia_size != 0);
-		if (fc->atomic_o_trunc) {
+		if (fc->atomic_o_trunc && !fc->handle_killpriv_v2) {
 			/*
 			 * No need to send request to userspace, since actual
 			 * truncation has already been done by OPEN.  But still
-- 
2.25.4

