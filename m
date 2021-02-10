From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 10 Feb 2021 13:27:43 -0500
Message-Id: <20210210182744.27324-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/1] virtiofsd: Do not use a thread pool by
	default
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: vgoyal@redhat.com

Hi,

This is a proposal to not use a thread pool by default. It hurts
performance in most of the cases. Hence lets switch default so
that most of the users get better performance out of the box.

I have run virtiofs-tests with and without thread pool and posted
results here.

https://github.com/rhvgoyal/virtiofs-tests/tree/master/performance-results/feb-10-2021

One can notice, that except few cases, results are much better with
no thread pool.

Vivek


Vivek Goyal (1):
  virtiofsd: Do not use a thread pool by default

 tools/virtiofsd/fuse_lowlevel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.25.4

