Date: Tue, 20 Aug 2019 09:45:45 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190820134545.GA4233@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [PATCH] virtiofsd: Reset O_DIRECT flag during file open
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>

If an application wants to do direct IO and opens a file with O_DIRECT
in guest, that does not necessarily mean that we need to bypass page
cache on host as well. So reset this flag on host.

If somebody needs to bypass page cache on host as well (and it is safe to
do so), we can add a knob in daemon later to control this behavior.

I check virtio-9p and they do reset O_DIRECT flag.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 contrib/virtiofsd/passthrough_ll.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: qemu/contrib/virtiofsd/passthrough_ll.c
===================================================================
--- qemu.orig/contrib/virtiofsd/passthrough_ll.c	2019-08-20 09:33:07.900975145 -0400
+++ qemu/contrib/virtiofsd/passthrough_ll.c	2019-08-20 09:35:45.829414412 -0400
@@ -1967,6 +1967,13 @@ static void lo_open(fuse_req_t req, fuse
 	if (lo->writeback && (fi->flags & O_APPEND))
 		fi->flags &= ~O_APPEND;
 
+	/*
+	 * O_DIRECT in guest should not necessarily mean bypassing page
+	 * cache on host as well. If somebody needs that behavior, it
+	 * probably should be a configuration knob in daemon.
+	 */
+	fi->flags &= ~O_DIRECT;
+
 	sprintf(buf, "%i", lo_fd(req, ino));
 	fd = openat(lo->proc_self_fd, buf, fi->flags & ~O_NOFOLLOW);
 	if (fd == -1)

