References: <5D53D882.5090803@huawei.com>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D5A4692.9060006@huawei.com>
Date: Mon, 19 Aug 2019 14:49:54 +0800
MIME-Version: 1.0
In-Reply-To: <5D53D882.5090803@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] [PATCH RESEND][RFC] virtiofsd: do not fall back to
 buffer io when cache=auto/always
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

When O_DIRECT flags is set by Guest, virtiofsd will open file with
O_DIRECT, but unset 'fi->direct_io' which makes Guest go buffer io path.
That causes inconsistency between Guest and Host.

The cache option in virtiofsd should not affect the file io mode, so
set 'fi->direct_io' according to 'fi->flags'.

Signed-off-by: Jun Piao <piaojun@huawei.com>
---
 contrib/virtiofsd/passthrough_ll.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index ca11764..a9c98d0 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -1774,8 +1774,10 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
 		fi->fh = fh;
 		err = lo_do_lookup(req, parent, name, &e);
 	}
-	if (lo->cache == CACHE_NONE)
+	if (fi->flags & O_DIRECT)
 		fi->direct_io = 1;
+	if (lo->cache == CACHE_NONE)
+		fi->keep_cache = 0;
 	else if (lo->cache == CACHE_ALWAYS)
 		fi->keep_cache = 1;

@@ -1982,8 +1984,11 @@ static void lo_open(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
 	}

 	fi->fh = fh;
-	if (lo->cache == CACHE_NONE)
+
+	if (fi->flags & O_DIRECT)
 		fi->direct_io = 1;
+	if (lo->cache == CACHE_NONE)
+		fi->keep_cache = 0;
 	else if (lo->cache == CACHE_ALWAYS)
 		fi->keep_cache = 1;
 	fuse_reply_open(req, fi);
-- 

