From: Peng Tao <tao.peng@linux.alibaba.com>
Date: Thu,  6 Jun 2019 14:52:47 +0800
Message-Id: <1559803967-40290-1-git-send-email-tao.peng@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH] virtio-fs: fix kill_sb panic
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Peng Tao <tao.peng@linux.alibaba.com>, Vivek Goyal <vgoyal@redhat.com>

->kill_sb might be called when mount fails, in which case
sb->s_fs_info is NULL and virtio-fs will panic like:

[ 1493.415267] BUG: unable to handle kernel NULL pointer dereference at 0000000000000148
[ 1493.416881] #PF error: [normal kernel read fault]
[ 1493.417785] PGD 0 P4D 0
[ 1493.418284] Oops: 0000 [#1] SMP PTI
[ 1493.418968] CPU: 1 PID: 7635 Comm: mount Not tainted 5.1.0+ #21
[ 1493.420125] RIP: 0010:virtio_kill_sb+0x12/0x100
[ 1493.421009] Code: 00 00 00 00 00 00 83 c5 01 41 3b 2c 24 72 ad 5b 5d 41 5c 41 5d c3 66 90 41 56 49 89 fe 41 55 41 54 55 53 48 8b 87 28 07 00 00 <4c> 8b a8 48 01 00 00 49 8b 6d 18 48 89 ef e8 7b 3e 6c 00 c6 85 70
[ 1493.424599] RSP: 0018:ffffc9000054bd88 EFLAGS: 00010286
[ 1493.425617] RAX: 0000000000000000 RBX: ffff88807a67a000 RCX: 0000000000000006
[ 1493.426987] RDX: 0000000000000006 RSI: ffff888073a0cc48 RDI: ffff88807a67a000
[ 1493.428376] RBP: ffffffff8229f3c0 R08: 0000000000000000 R09: 0000000000000000
[ 1493.429752] R10: 0000000000000001 R11: 0000000000000001 R12: ffffffff812f8a00
[ 1493.431136] R13: 0000000000000000 R14: ffff88807a67a000 R15: 0000000000000020
[ 1493.432518] FS:  00007f2ea867b080(0000) GS:ffff88807da00000(0000) knlGS:0000000000000000
[ 1493.434044] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1493.435127] CR2: 0000000000000148 CR3: 0000000076098003 CR4: 00000000003606a0
[ 1493.436480] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1493.437826] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1493.439181] Call Trace:
[ 1493.439669]  ? virtio_fs_hiprio_dispatch_work+0x210/0x210
[ 1493.440705]  deactivate_locked_super+0x35/0x60
[ 1493.441641]  mount_nodev+0x53/0x90
[ 1493.442299]  legacy_get_tree+0x1f/0x40
[ 1493.443019]  vfs_get_tree+0x20/0xe0
[ 1493.443709]  do_mount+0xa1b/0xdd0
[ 1493.444356]  ? memdup_user+0x39/0x60
[ 1493.445042]  ksys_mount+0x89/0xb0
[ 1493.445685]  __x64_sys_mount+0x1c/0x20
[ 1493.446408]  do_syscall_64+0x288/0x429
[ 1493.447141]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[ 1493.448068]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
---
 fs/fuse/virtio_fs.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index e5955a6..d94fe72 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1115,8 +1115,14 @@ static int virtio_fs_fill_super(struct super_block *sb, void *data,
 static void virtio_kill_sb(struct super_block *sb)
 {
 	struct fuse_conn *fc = get_fuse_conn_super(sb);
-	struct virtio_fs *vfs = fc->iq.priv;
-	struct virtio_fs_vq *fsvq = &vfs->vqs[VQ_HIPRIO];
+	struct virtio_fs *vfs;
+	struct virtio_fs_vq *fsvq;
+
+	if (!fc)
+		return fuse_kill_sb_anon(sb);
+
+	vfs = fc->iq.priv;
+	fsvq = &vfs->vqs[VQ_HIPRIO];
 
 	/* Stop forget queue. Soon destroy will be sent */
 	spin_lock(&fsvq->lock);
-- 
1.8.3.1

