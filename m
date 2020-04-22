From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 22 Apr 2020 09:08:48 -0400
Message-Id: <20200422130850.59900-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/2] overlayfs: Fix overlayfs on virtiofs
	open(O_TRUNC) issue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-unionfs@vger.kernel.org, miklos@szeredi.hu
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

Hi Miklos,

Here are couple of fixes solving open(O_TRUNC) issue while overlayfs
is layered on top of virtiofs.

These are also available here.

https://github.com/rhvgoyal/linux/commits/ovl-setattr-fix

Thanks
Vivek

Vivek Goyal (2):
  overlayfs: ovl_setattr() should clear ATTR_FILE from attr->ia_valid
  overlayfs: ovl_setattr() should clear ATTR_OPEN

 fs/overlayfs/inode.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

-- 
2.25.3

