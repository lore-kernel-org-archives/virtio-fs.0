From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Thu, 27 Aug 2020 16:36:51 +0100
Message-Id: <20200827153657.111098-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 0/6] virtiofsd xattr name mappings
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, virtio-fs@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

  This is a second cut of a xattr name mapping option for virtiofsd.
It allows the user of virtiofsd to define a fairly flexible mapping
from the view of the xattr names the host fs has and the ones that the
guest sees.

  The hope is this allows things like:
    a) Different selinux attributes on host/guest
    b) separation of trusted. attributes that clash on overlayfs
    c) support for privileged xattr's in guests running with an
       unprivileged virtiofsd.

There's no apparent standard for this kind of mapping, so I made
it flexible by specifying a mapping rule in the option.

Prefix's can be added (selectively or globally), xattr's can be
dropped in either direction or passed through.

Dave

v2
  Switch from cryptic single letter codes to full words in rules
  Allow rules to use any separator character
  Add examples to doc
  Add a couple of fixups for a gcc warning and make gcc spot my
  format errors.

Dr. David Alan Gilbert (6):
  virtiofsd: Silence gcc warning
  virtiofsd: Add printf checking to fuse_log
  tools/virtiofsd: xattr name mappings: Add option
  tools/virtiofsd: xattr name mappings: Map client xattr names
  tools/virtiofsd: xattr name mappings: Map server xattr names
  tools/virtiofsd: xattr name mapping examples

 docs/tools/virtiofsd.rst         | 104 ++++++++++
 tools/virtiofsd/fuse_log.h       |   2 +
 tools/virtiofsd/passthrough_ll.c | 340 ++++++++++++++++++++++++++++++-
 3 files changed, 442 insertions(+), 4 deletions(-)

-- 
2.26.2

