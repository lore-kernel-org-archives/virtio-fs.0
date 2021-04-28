From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 28 Apr 2021 12:50:37 -0400
Message-Id: <20210428165040.1856202-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v5 0/3] dax: Fix missed wakeup in
	put_unlocked_entry()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, virtio-fs@redhat.com, dan.j.williams@intel.com
Cc: jack@suse.cz, willy@infradead.org, vgoyal@redhat.com, miklos@szeredi.hu

Hi,

This is V5 of patches. Posted V4 here.

https://lore.kernel.org/linux-fsdevel/20210423130723.1673919-1-vgoyal@redhat.com/

Changes since V4:

- Changed order of WAKE_NEXT and WAKE_ALL entries in enum. (Matthew Wilcox).

Thanks
Vivek

Vivek Goyal (3):
  dax: Add an enum for specifying dax wakup mode
  dax: Add a wakeup mode parameter to put_unlocked_entry()
  dax: Wake up all waiters after invalidating dax entry

 fs/dax.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

-- 
2.25.4

