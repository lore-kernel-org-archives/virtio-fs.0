DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id:in-reply-to:references;
	bh=EbPerR4vYKZ9mNKsErt1uqDhuyrNY87BPp+un5kk7a0=;
	b=Yq7uuJD5XqPtz0+K+gcaqBrZzMSNGQ2rrUHf/ISKhOoRAs1nRiKk9GHBYBSGHYPuLc
	8IMNI4Er4ySKcDdaPyWSBvQBP7fYtp9fFWkNSBVfAJF2rRi12qT8fcBwdNZOOP1PTdki
	PjRYFbTziZyMRrFDexdEL+xU0hgVL/hSMBdRkQjETlMBdJI98xxHJDMa3CALahFOUg1E
	SUw0GHAqa7I7QB+B7o1U3Vy/M8rBvdQc0yp36eKxJNlbT5HsU+kuflaSO9o+BGjBzJy2
	6rs4u1H6x6Es/MZoVZU9iqA9DFBEu8Aqph1AlkhWZE86cyay1Obos+/kEHeo5/CFPB4O
	DBpw==
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Date: Wed, 18 Dec 2019 15:08:33 -0500
Message-Id: <20191218200833.10368-4-msys.mizuma@gmail.com>
In-Reply-To: <20191218200833.10368-1-msys.mizuma@gmail.com>
References: <20191218200833.10368-1-msys.mizuma@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/3] virtiofsd: remove --writeback option from
	the man page
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

'--writeback' options doesn't work for virtiofsd.
'-o writebck' works instead.

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 tools/virtiofsd/virtiofsd.texi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/virtiofsd/virtiofsd.texi b/tools/virtiofsd/virtiofsd.texi
index 76eb219676..45f377d41e 100644
--- a/tools/virtiofsd/virtiofsd.texi
+++ b/tools/virtiofsd/virtiofsd.texi
@@ -73,8 +73,6 @@ Select the desired trade-off between coherency and performance.  @code{none}
 forbids the FUSE client from caching to achieve best coherency at the cost of
 performance.  @code{auto} acts similar to NFS with a 1 second metadata cache
 timeout.  @code{always} sets a long cache lifetime at the expense of coherency.
-@item --writeback
-Enable writeback cache, allowing the FUSE client to buffer and merge write requests.
 @end table
 @c man end
 
-- 
2.18.1


