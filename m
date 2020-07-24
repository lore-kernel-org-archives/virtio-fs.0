From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 24 Jul 2020 14:38:09 -0400
Message-Id: <20200724183812.19573-3-vgoyal@redhat.com>
In-Reply-To: <20200724183812.19573-1-vgoyal@redhat.com>
References: <20200724183812.19573-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/5] fuse: Set FUSE_WRITE_KILL_PRIV in cached
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

If caller does not have CAP_FSETID, we set FUSE_WRITE_KILL_PRIV in direct
I/O path but not in cached write path. Set it there as well so that server
can clear suid/sgid/caps as needed.

Set it only if fc->handle_killpriv_v2 is set. Otherwise client is responsible
for kill suid/sgid. We do it direct I/O path anyway because we do't call
file_remove_privs() there (with cache=none option).

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 83d917f7e542..57899afc7cba 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1083,6 +1083,8 @@ static ssize_t fuse_send_write_pages(struct fuse_io_args *ia,
 
 	fuse_write_args_fill(ia, ff, pos, count);
 	ia->write.in.flags = fuse_write_flags(iocb);
+	if (fc->handle_killpriv_v2 && !capable(CAP_FSETID))
+		ia->write.in.write_flags |= FUSE_WRITE_KILL_PRIV;
 
 	err = fuse_simple_request(fc, &ap->args);
 	if (!err && ia->write.out.size > count)
-- 
2.25.4

