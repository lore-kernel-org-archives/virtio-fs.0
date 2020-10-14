From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 14 Oct 2020 19:02:04 +0100
Message-Id: <20201014180209.49299-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 0/5] virtiofsd xattr name mappings
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com, dinechin@redhat.com, virtio-fs@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

This is a 3rd cut of an xattr name mapping option for virtiofsd.
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

The major change for v3 is the addition of a 'map' simple syntax
that should cover a lot of the simple cases without people needing
to use the more complex rule syntax.  There's also some cleanups
basedon reviews by Christophe.

Dave


Dr. David Alan Gilbert (5):
  tools/virtiofsd: xattr name mappings: Add option
  tools/virtiofsd: xattr name mappings: Map client xattr names
  tools/virtiofsd: xattr name mappings: Map server xattr names
  tools/virtiofsd: xattr name mapping examples
  tools/virtiofsd: xattr name mappings: Simple 'map'

 docs/tools/virtiofsd.rst         | 122 ++++++++
 tools/virtiofsd/passthrough_ll.c | 476 ++++++++++++++++++++++++++++++-
 2 files changed, 595 insertions(+), 3 deletions(-)

-- 
2.28.0

