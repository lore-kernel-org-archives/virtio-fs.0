From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue,  3 Dec 2019 13:14:21 +0000
Message-Id: <20191203131423.40962-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/2] Convert to cap-ng
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
  This changes virtiofsd to use cap-ng rather than cap
(qemu is moving in that direction).  It's a little painful
because of an interaction with our sandboxing.

I intend to flatten the conversion into Vivek's patch that
adds the libcap use.

Dave

Dr. David Alan Gilbert (2):
  virtiofsd: cap-ng helpers
  virtiofsd: Convert to libcap-ng

 Makefile                           |   2 +-
 contrib/virtiofsd/Makefile.objs    |   2 -
 contrib/virtiofsd/passthrough_ll.c | 162 +++++++++++++++++++----------
 3 files changed, 106 insertions(+), 60 deletions(-)

-- 
2.23.0

