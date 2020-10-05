Date: Mon, 5 Oct 2020 13:45:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201005174531.GB4302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [PATCH] virtiofs: Fix false positive warning
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Linux fsdevel mailing list <linux-fsdevel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
Cc: virtio-fs-list <virtio-fs@redhat.com>, CAI Qian <caiqian@redhat.com>

virtiofs currently maps various buffers in scatter gather list and it looks
at number of pages (ap->pages) and assumes that same number of pages will
be used both for input and output (sg_count_fuse_req()), and calculates
total number of scatterlist elements accordingly.

But looks like this assumption is not valid in all the cases. For example,
Cai Qian reported that trinity, triggers warning with virtiofs sometimes.
A closer look revealed that if one calls ioctl(fd, 0x5a004000, buf), it
will trigger following warning.

WARN_ON(out_sgs + in_sgs != total_sgs)

In this case, total_sgs = 8, out_sgs=4, in_sgs=3. Number of pages is 2
(ap->pages), but out_sgs are using both the pages but in_sgs are using
only one page. (fuse_do_ioctl() sets out_size to one page).

So existing WARN_ON() seems to be wrong. Instead of total_sgs, it should
be max_sgs and make sure out_sgs and in_sgs don't cross max_sgs. This
will allow input and output pages numbers to be different.

Reported-by: Qian Cai <cai@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Link: https://lore.kernel.org/linux-fsdevel/5ea77e9f6cb8c2db43b09fbd4158ab2d8c066a0a.camel@redhat.com/
---
 fs/fuse/virtio_fs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index da3ede268604..3f4f2fa0bb96 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1110,17 +1110,17 @@ static int virtio_fs_enqueue_req(struct virtio_fs_vq *fsvq,
 	unsigned int argbuf_used = 0;
 	unsigned int out_sgs = 0;
 	unsigned int in_sgs = 0;
-	unsigned int total_sgs;
+	unsigned int  max_sgs;
 	unsigned int i;
 	int ret;
 	bool notify;
 	struct fuse_pqueue *fpq;
 
 	/* Does the sglist fit on the stack? */
-	total_sgs = sg_count_fuse_req(req);
-	if (total_sgs > ARRAY_SIZE(stack_sgs)) {
-		sgs = kmalloc_array(total_sgs, sizeof(sgs[0]), GFP_ATOMIC);
-		sg = kmalloc_array(total_sgs, sizeof(sg[0]), GFP_ATOMIC);
+	max_sgs = sg_count_fuse_req(req);
+	if (max_sgs > ARRAY_SIZE(stack_sgs)) {
+		sgs = kmalloc_array(max_sgs, sizeof(sgs[0]), GFP_ATOMIC);
+		sg = kmalloc_array(max_sgs, sizeof(sg[0]), GFP_ATOMIC);
 		if (!sgs || !sg) {
 			ret = -ENOMEM;
 			goto out;
@@ -1149,9 +1149,9 @@ static int virtio_fs_enqueue_req(struct virtio_fs_vq *fsvq,
 					    req->argbuf + argbuf_used, NULL);
 	}
 
-	WARN_ON(out_sgs + in_sgs != total_sgs);
+	WARN_ON(out_sgs + in_sgs > max_sgs);
 
-	for (i = 0; i < total_sgs; i++)
+	for (i = 0; i < (out_sgs + in_sgs); i++)
 		sgs[i] = &sg[i];
 
 	spin_lock(&fsvq->lock);
-- 
2.25.4

