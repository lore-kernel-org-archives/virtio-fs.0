DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=stuvus.uni-stuttgart.de; s=20200828.smtp02;
	h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=qddxRKK/Am2+hWt+gYqWMDbuPzwWnHe+PKonl18cm/E=;
	b=oqHYwtx7dFuG+mI5NotKZYgow
	SkM0vbDjFDc26R1OxKTm4BfkHa05jGsr+8ieUnnMXkg1BhVgM2h5VTVxSlgv7qW5AbhnqkGBJB3BE
	S/hwqcWqYMuOpqGtcfSZ/xO+Gd+mRhasaQ2i6htv4iPsLbeM44InZD0ZyX/p7dbgsooKyJOSG7gI1
	ZjOKJTIFKq/g6flEK+g4t9BmpnWBbHl+qsCTqMhlRCFBzvPp/4KtElSHaqbC2BHPGW9K84BLvXCVv
	hFlssh5VzhJD0WhCVWkQjHSxTsP2MMbzqyXF4tjFE0IR6yYAPCY2jj4YiSEi2HEov3vQGATNk4l6x
	dxpi9Wnaw==
From: Sebastian Hasler <sebastian.hasler@stuvus.uni-stuttgart.de>
Date: Tue, 11 Jan 2022 19:10:43 +0100
Message-Id: <20220111181043.435915-1-sebastian.hasler@stuvus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH] virtiofsd: Do not support blocking flock
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, Sebastian Hasler <sebastian.hasler@stuvus.uni-stuttgart.de>

With the current implementation, blocking flock can lead to
deadlock. Thus, it's better to return EOPNOTSUPP if a user attempts
to perform a blocking flock request.

Signed-off-by: Sebastian Hasler <sebastian.hasler@stuvus.uni-stuttgart.de>
---
 tools/virtiofsd/passthrough_ll.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 64b5b4fbb1..f3cc307f6d 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2442,6 +2442,12 @@ static void lo_flock(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi,
     int res;
     (void)ino;
 
+    if (!(op & LOCK_NB)) {
+        /* Blocking flock is not supported */
+        fuse_reply_err(req, EOPNOTSUPP);
+        return;
+    }
+
     res = flock(lo_fi_fd(req, fi), op);
 
     fuse_reply_err(req, res == -1 ? errno : 0);
-- 
2.33.1

