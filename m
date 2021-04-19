From: Vivek Goyal <vgoyal@redhat.com>
Date: Mon, 19 Apr 2021 17:36:33 -0400
Message-Id: <20210419213636.1514816-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 0/3] dax: Fix missed wakeup in
	put_unlocked_entry()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com, jack@suse.cz, willy@infradead.org
Cc: linux-nvdimm@lists.01.org, miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, vgoyal@redhat.com

Hi,

This is V3 of patches. Posted V2 here.

https://lore.kernel.org/linux-fsdevel/20210419184516.GC1472665@redhat.com/

Changes since v2:

- Broke down patch in to a patch series (Dan)
- Added an enum to communicate wake mode (Dan)

Thanks
Vivek

Vivek Goyal (3):
  dax: Add an enum for specifying dax wakup mode
  dax: Add a wakeup mode parameter to put_unlocked_entry()
  dax: Wake up all waiters after invalidating dax entry

 fs/dax.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

-- 
2.25.4

