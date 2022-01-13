DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=stuvus.uni-stuttgart.de; s=20200828.smtp01;
	h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=K47Phf+baWik1OtUpOcdWSSeVU2rZCJrwMNuGUWLoqk=;
	b=Jz3+T9hCz85lKlAX5QIyVhCOo
	e1RLDcZTNMltf3EJvTcIr5OZWJq8RZIaEJMsxJRXCd1rZmIGyy2rLya7K5iHP/PwcbyFixJBbCUMA
	gNajrBiqw9x6Wb/mjKiPVM3io6+Ti98C4RCsNO5XwBq+HP7X6Enk/8YkKqKH/xdoZfhsuIiuaRkId
	fpejRtmWX5Cx+RJde4ecFAVwCh2MHj0CiTiP3DbD+Ofq2clBQphspBFpO1O3BjRrMoTke0QWJcgNd
	YEWyJXoCahC/czs02htGLhDV1hGnmsbs5AQN6qQP+oAlPIsPvYNsjKkUwvXmhdHB2FenPw+KwDS0A
	CaIElVkoQ==
From: Sebastian Hasler <sebastian.hasler@stuvus.uni-stuttgart.de>
Date: Thu, 13 Jan 2022 16:32:49 +0100
Message-Id: <20220113153249.710216-1-sebastian.hasler@stuvus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v2] virtiofsd: Do not support blocking flock
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com

With the current implementation, blocking flock can lead to
deadlock. Thus, it's better to return EOPNOTSUPP if a user attempts
to perform a blocking flock request.

Signed-off-by: Sebastian Hasler <sebastian.hasler@stuvus.uni-stuttgart.de>
---
 tools/virtiofsd/passthrough_ll.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 64b5b4fbb1..faa62278c5 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2442,6 +2442,15 @@ static void lo_flock(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi,
     int res;
     (void)ino;
 
+    if (!(op & LOCK_NB)) {
+        /*
+         * Blocking flock can deadlock as there is only one thread
+         * serving the queue.
+         */
+        fuse_reply_err(req, EOPNOTSUPP);
+        return;
+    }
+
     res = flock(lo_fi_fd(req, fi), op);
 
     fuse_reply_err(req, res == -1 ? errno : 0);
-- 
2.33.1

