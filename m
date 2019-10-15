From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 15 Oct 2019 13:46:21 -0400
Message-Id: <20191015174626.11593-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/5] virtiofs: Fix couple of deadlocks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com
Cc: miklos@szeredi.hu, virtualization@lists.linux-foundation.org, vgoyal@redhat.com

Hi,

We have couple of places which can result in deadlock. This patch series
fixes these.

We can be called with fc->bg_lock (for background requests) while
submitting a request. This leads to two constraints.

- We can't end requests in submitter's context and call fuse_end_request()
  as it tries to take fc->bg_lock as well. So queue these requests on a
  list and use a worker to end these requests.

- If virtqueue is full, we can wait with fc->bg_lock held for queue to
  have space. Worker which is completing the request gets blocked on
  fc->bg_lock as well. And that means requests are not completing, that
  means descriptors are not being freed and that means submitter can't
  make progress. Deadlock. 

  Fix this by punting the requests to a list and retry submission later
  with the help of a worker.

Thanks
Vivek

Vivek Goyal (5):
  virtiofs: Do not end request in submission context
  virtiofs: No need to check fpq->connected state
  virtiofs: Set FR_SENT flag only after request has been sent
  virtiofs: Count pending forgets as in_flight forgets
  virtiofs: Retry request submission from worker context

 fs/fuse/virtio_fs.c | 165 +++++++++++++++++++++++++++++---------------
 1 file changed, 111 insertions(+), 54 deletions(-)

-- 
2.20.1

