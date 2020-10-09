From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri,  9 Oct 2020 14:15:08 -0400
Message-Id: <20201009181512.65496-3-vgoyal@redhat.com>
In-Reply-To: <20201009181512.65496-1-vgoyal@redhat.com>
References: <20201009181512.65496-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 2/6] fuse: Set FUSE_WRITE_KILL_PRIV in cached
	write path
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

With HANDLE_KILLPRIV_V2, server will need to kill suid/sgid if caller
does not have CAP_FSETID. We already have a flag FUSE_WRITE_KILL_PRIV
in WRITE request and we already set it in direct I/O path.

To make it work in cached write path also, start setting FUSE_WRITE_KILL_PRIV
in this path too.

Set it only if fc->handle_killpriv_v2 is set. Otherwise client is responsible
for kill suid/sgid.

In case of direct I/O we set FUSE_WRITE_KILL_PRIV unconditionally because
we do't call file_remove_privs() in that path (with cache=none option).

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 172a0b1aa634..e40428f3d0f1 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1095,6 +1095,8 @@ static ssize_t fuse_send_write_pages(struct fuse_io_args *ia,
 
 	fuse_write_args_fill(ia, ff, pos, count);
 	ia->write.in.flags = fuse_write_flags(iocb);
+	if (fc->handle_killpriv_v2 && !capable(CAP_FSETID))
+		ia->write.in.write_flags |= FUSE_WRITE_KILL_PRIV;
 
 	err = fuse_simple_request(fc, &ap->args);
 	if (!err && ia->write.out.size > count)
-- 
2.25.4

