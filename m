From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Thu, 25 Jun 2020 17:29:26 +0100
Message-Id: <20200625162929.46672-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/3] virtiofsd capability changes and addition
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com, stefanha@redhat.com, vgoyal@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Hi,
  This is a set of changes relating to the capability restirctions
introduced in virtiofsd back in a59feb483b8.

The first one is a potentially important fix; the missing terminator
could mean extra capabilities are added based on junk on the stack;
although that's not been seen in practice.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>



Dr. David Alan Gilbert (3):
  virtiofsd: Terminate capability list
  virtiofsd: Check capability calls
  virtiofsd: Allow addition or removal of capabilities

 docs/tools/virtiofsd.rst         |  5 +++
 tools/virtiofsd/helper.c         |  2 +
 tools/virtiofsd/passthrough_ll.c | 68 +++++++++++++++++++++++++++++---
 3 files changed, 70 insertions(+), 5 deletions(-)

-- 
2.26.2

