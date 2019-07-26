From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Fri, 26 Jul 2019 09:33:22 +0100
Message-Id: <20190726083322.13637-4-stefanha@redhat.com>
In-Reply-To: <20190726083322.13637-1-stefanha@redhat.com>
References: <20190726083322.13637-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/3] virtiofsd: implement FUSE_INIT
	map_alignment field
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com

Communicate the host page size to the FUSE client so that
FUSE_SETUPMAPPING/FUSE_REMOVEMAPPING requests are aware of our alignment
constraints.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 contrib/virtiofsd/fuse_lowlevel.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
index dbbfda78bf..452dd6b2b0 100644
--- a/contrib/virtiofsd/fuse_lowlevel.c
+++ b/contrib/virtiofsd/fuse_lowlevel.c
@@ -2131,6 +2131,12 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
 	}
 	if (se->conn.proto_minor >= 23)
 		outarg.time_gran = se->conn.time_gran;
+	if (arg->flags & FUSE_MAP_ALIGNMENT) {
+		outarg.flags |= FUSE_MAP_ALIGNMENT;
+
+		/* This constraint comes from mmap(2) and munmap(2) */
+		outarg.map_alignment = sysconf(_SC_PAGE_SIZE);
+	}
 
 	if (se->debug) {
 		fuse_debug("   INIT: %u.%u\n", outarg.major, outarg.minor);
@@ -2144,6 +2150,8 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
 			   outarg.congestion_threshold);
 		fuse_debug("   time_gran=%u\n",
 			   outarg.time_gran);
+		fuse_debug("   map_alignment=%u\n",
+			   outarg.map_alignment);
 	}
 	if (arg->minor < 5)
 		outargsize = FUSE_COMPAT_INIT_OUT_SIZE;
-- 
2.21.0

