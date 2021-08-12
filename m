From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Thu, 12 Aug 2021 13:46:16 +0800
Message-Id: <20210812054618.26057-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH 0/2] virtiofs: miscellaneous fixes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, virtualization@lists.linux-foundation.org

Some fixes or optimization for virtiofs, which are authored by Liu Bo.

Liu Bo (2):
  virtio-fs: disable atomic_o_trunc if no_open is enabled
  virtiofs: reduce lock contention on fpq->lock

 fs/fuse/file.c      | 11 +++++++++--
 fs/fuse/virtio_fs.c |  3 ---
 2 files changed, 9 insertions(+), 5 deletions(-)

-- 
2.27.0

