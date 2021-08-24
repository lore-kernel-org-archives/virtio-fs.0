From: Sergio Lopez <slp@redhat.com>
Date: Tue, 24 Aug 2021 15:11:58 +0200
Message-Id: <20210824131158.39970-1-slp@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] virtiofsd: Reverse req_list before processing it
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

With the thread pool disabled, we add the requests in the queue to a
GList, processing by iterating over there afterwards.

For adding them, we're using "g_list_prepend()", which is more
efficient but causes the requests to be processed in reverse order,
breaking the read-ahead and request-merging optimizations in the host
for sequential operations.

According to the documentation, if you need to process the request
in-order, using "g_list_prepend()" and then reversing the list with
"g_list_reverse()" is more efficient than using "g_list_append()", so
let's do it that way.

Testing on a spinning disk (to boost the increase of read-ahead and
request-merging) shows a 4x improvement on sequential write fio test:

Test:
fio --directory=/mnt/virtio-fs --filename=fio-file1 --runtime=20
--iodepth=16 --size=4G --direct=1 --blocksize=4K --ioengine libaio
--rw write --name seqwrite-libaio

Without "g_list_reverse()":
...
Jobs: 1 (f=1): [W(1)][100.0%][w=22.4MiB/s][w=5735 IOPS][eta 00m:00s]
seqwrite-libaio: (groupid=0, jobs=1): err= 0: pid=710: Tue Aug 24 12:58:16 2021
  write: IOPS=5709, BW=22.3MiB/s (23.4MB/s)(446MiB/20002msec); 0 zone resets
...

With "g_list_reverse()":
...
Jobs: 1 (f=1): [W(1)][100.0%][w=84.0MiB/s][w=21.5k IOPS][eta 00m:00s]
seqwrite-libaio: (groupid=0, jobs=1): err= 0: pid=716: Tue Aug 24 13:00:15 2021
  write: IOPS=21.3k, BW=83.1MiB/s (87.2MB/s)(1663MiB/20001msec); 0 zone resets
...

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
 tools/virtiofsd/fuse_virtio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index fc2564a603..8f4fd165b9 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -716,6 +716,7 @@ static void *fv_queue_thread(void *opaque)
 
         /* Process all the requests. */
         if (!se->thread_pool_size && req_list != NULL) {
+            req_list = g_list_reverse(req_list);
             g_list_foreach(req_list, fv_queue_worker, qi);
             g_list_free(req_list);
             req_list = NULL;
-- 
2.26.2

