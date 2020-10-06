Date: Tue, 6 Oct 2020 15:09:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201006190949.GH5306@redhat.com>
References: <20201005174531.GB4302@redhat.com>
	<20201006153933.GA87345@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006153933.GA87345@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH] virtiofs: Fix false positive warning
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Linux fsdevel mailing list <linux-fsdevel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, CAI Qian <caiqian@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>

On Tue, Oct 06, 2020 at 04:39:33PM +0100, Stefan Hajnoczi wrote:
> On Mon, Oct 05, 2020 at 01:45:31PM -0400, Vivek Goyal wrote:
> > virtiofs currently maps various buffers in scatter gather list and it looks
> > at number of pages (ap->pages) and assumes that same number of pages will
> > be used both for input and output (sg_count_fuse_req()), and calculates
> > total number of scatterlist elements accordingly.
> > 
> > But looks like this assumption is not valid in all the cases. For example,
> > Cai Qian reported that trinity, triggers warning with virtiofs sometimes.
> > A closer look revealed that if one calls ioctl(fd, 0x5a004000, buf), it
> > will trigger following warning.
> > 
> > WARN_ON(out_sgs + in_sgs != total_sgs)
> > 
> > In this case, total_sgs = 8, out_sgs=4, in_sgs=3. Number of pages is 2
> > (ap->pages), but out_sgs are using both the pages but in_sgs are using
> > only one page. (fuse_do_ioctl() sets out_size to one page).
> > 
> > So existing WARN_ON() seems to be wrong. Instead of total_sgs, it should
> > be max_sgs and make sure out_sgs and in_sgs don't cross max_sgs. This
> > will allow input and output pages numbers to be different.
> > 
> > Reported-by: Qian Cai <cai@redhat.com>
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > Link: https://lore.kernel.org/linux-fsdevel/5ea77e9f6cb8c2db43b09fbd4158ab2d8c066a0a.camel@redhat.com/
> > ---
> >  fs/fuse/virtio_fs.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> > index da3ede268604..3f4f2fa0bb96 100644
> > --- a/fs/fuse/virtio_fs.c
> > +++ b/fs/fuse/virtio_fs.c
> > @@ -1110,17 +1110,17 @@ static int virtio_fs_enqueue_req(struct virtio_fs_vq *fsvq,
> >  	unsigned int argbuf_used = 0;
> >  	unsigned int out_sgs = 0;
> >  	unsigned int in_sgs = 0;
> > -	unsigned int total_sgs;
> > +	unsigned int  max_sgs;
> >  	unsigned int i;
> >  	int ret;
> >  	bool notify;
> >  	struct fuse_pqueue *fpq;
> >  
> >  	/* Does the sglist fit on the stack? */
> > -	total_sgs = sg_count_fuse_req(req);
> 
> sg_count_fuse_req() should be exact. It's risky to treat it as a maximum
> unless all cases where in_sgs + out_sgs < total_sgs are understood. Even
> then, it's still possible that new bugs introduced to the code will go
> undetected due to the weaker WARN_ON() condition.
> 
> Do you have the values of the relevant fuse_req and fuse_args_pages
> fields so we can understand exactly what happened? I think the issue is
> that sg_count_fuse_req() doesn't use the fuse_page_desc size field.

Hi Stefan,

I revised the patch. How about following. This calculates number of
sgs accurately by going through ap->descs and size fields.

Thanks
Vivek

>From 24b590ebc2ffc8ed02c013b11818af89d0b135ba Mon Sep 17 00:00:00 2001
From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 6 Oct 2020 14:53:06 -0400
Subject: [PATCH 1/1] virtiofs: Calculate number of scatter-gather elements
 accurately

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
only one page. In this case, fuse_do_ioctl() sets different size values
for input and output.

args->in_args[args->in_numargs - 1].size == 6656
args->out_args[args->out_numargs - 1].size == 4096

So current method of calculating how many scatter-gather list elements
will be used is not accurate. Make calculations more precise by parsing
size and ap->descs.

Reported-by: Qian Cai <cai@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Link: https://lore.kernel.org/linux-fsdevel/5ea77e9f6cb8c2db43b09fbd4158ab2d8c066a0a.camel@redhat.com/
---
 fs/fuse/virtio_fs.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 104f35de5270..f4fbd6afad05 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -833,6 +833,22 @@ __releases(fiq->lock)
 	spin_unlock(&fiq->lock);
 }
 
+/* Count number of scatter-gather elements required */
+static unsigned int sg_count_fuse_pages(struct fuse_page_desc *page_descs,
+				       unsigned int num_pages,
+				       unsigned int total_len)
+{
+	unsigned int i;
+	unsigned int this_len;
+
+	for (i = 0; i < num_pages && total_len; i++) {
+		this_len =  min(page_descs[i].length, total_len);
+		total_len -= this_len;
+	}
+
+	return i;
+}
+
 /* Return the number of scatter-gather list elements required */
 static unsigned int sg_count_fuse_req(struct fuse_req *req)
 {
@@ -843,8 +859,11 @@ static unsigned int sg_count_fuse_req(struct fuse_req *req)
 	if (args->in_numargs - args->in_pages)
 		total_sgs += 1;
 
-	if (args->in_pages)
-		total_sgs += ap->num_pages;
+	if (args->in_pages) {
+		unsigned int size = args->in_args[args->in_numargs - 1].size;
+		total_sgs += sg_count_fuse_pages(ap->descs, ap->num_pages,
+						 size);
+	}
 
 	if (!test_bit(FR_ISREPLY, &req->flags))
 		return total_sgs;
@@ -854,8 +873,11 @@ static unsigned int sg_count_fuse_req(struct fuse_req *req)
 	if (args->out_numargs - args->out_pages)
 		total_sgs += 1;
 
-	if (args->out_pages)
-		total_sgs += ap->num_pages;
+	if (args->out_pages) {
+		unsigned int size = args->out_args[args->out_numargs - 1].size;
+		total_sgs += sg_count_fuse_pages(ap->descs, ap->num_pages,
+						 size);
+	}
 
 	return total_sgs;
 }
-- 
2.25.4

