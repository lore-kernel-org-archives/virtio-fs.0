From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Thu, 18 Jul 2019 16:13:53 +0100
Message-Id: <20190718151355.11461-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/2] Fixes to id field for virtio-spec change
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, vgoyal@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Hi,
  The current edition of the virtio spec changes for the
shared memory capability change how we find our DAX
(and version) mappings.

  We now use a byte in the existing capability header
as 'id', and now the new capability structure is a
generic 64 bit structure.

  This set goes with the current -dev qemu/virtiofsd branch.


Dr. David Alan Gilbert (2):
  virito: Add 'id' field to capability header
  virto/shared memory: Rework for standardised id field

 drivers/virtio/virtio_pci_modern.c |  8 ++++----
 include/uapi/linux/virtio_pci.h    | 17 ++++++++---------
 2 files changed, 12 insertions(+), 13 deletions(-)

-- 
2.21.0

