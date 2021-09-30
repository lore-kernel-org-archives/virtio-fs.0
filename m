From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 30 Sep 2021 10:38:48 -0400
Message-Id: <20210930143850.1188628-7-vgoyal@redhat.com>
In-Reply-To: <20210930143850.1188628-1-vgoyal@redhat.com>
References: <20210930143850.1188628-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 6/8] virtiofs: Add a helper to end request and
	decrement inflight number
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, miklos@szeredi.hu, stefanha@redhat.com
Cc: vgoyal@redhat.com

Add a helper function to end fuse request and decrement number of
inflight requests. This pattern is already used at two places and
I am planning to use it two more times in later patches. Adding
a helper reduces number of lines of code and improves readability.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/virtio_fs.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index b70a22a79901..8d33879d62fb 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -380,6 +380,15 @@ static void virtio_fs_hiprio_done_work(struct work_struct *work)
 	spin_unlock(&fsvq->lock);
 }
 
+static void end_req_dec_in_flight(struct fuse_req *req,
+				  struct virtio_fs_vq *fsvq)
+{
+	fuse_request_end(req);
+	spin_lock(&fsvq->lock);
+	dec_in_flight_req(fsvq);
+	spin_unlock(&fsvq->lock);
+}
+
 static void virtio_fs_request_dispatch_work(struct work_struct *work)
 {
 	struct fuse_req *req;
@@ -425,12 +434,9 @@ static void virtio_fs_request_dispatch_work(struct work_struct *work)
 				return;
 			}
 			req->out.h.error = ret;
-			spin_lock(&fsvq->lock);
-			dec_in_flight_req(fsvq);
-			spin_unlock(&fsvq->lock);
 			pr_err("virtio-fs: virtio_fs_enqueue_req() failed %d\n",
 			       ret);
-			fuse_request_end(req);
+			end_req_dec_in_flight(req, fsvq);
 		}
 	}
 }
@@ -709,10 +715,7 @@ static void virtio_fs_request_complete(struct fuse_req *req,
 		}
 	}
 
-	fuse_request_end(req);
-	spin_lock(&fsvq->lock);
-	dec_in_flight_req(fsvq);
-	spin_unlock(&fsvq->lock);
+	end_req_dec_in_flight(req, fsvq);
 }
 
 static void virtio_fs_complete_req_work(struct work_struct *work)
-- 
2.31.1

