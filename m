From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 30 Jul 2020 15:47:31 -0400
Message-Id: <20200730194736.173994-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 0/5] virtiofsd: Add a unprivileged
	passthrough mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: berrange@redhat.com, vromanso@redhat.com, virtio-fs@redhat.com, vgoyal@redhat.com

Hi,

This is V2 of patches. Only change since last version is handling of
lock/pid file creation as per the comments from Daniel Berrange.

I can't think of any more changes needed. As a unpriviliged user
inside VM I can do simple operations like create/remove/read/write
files.

For more testing, I probably need a testsuite which runs as unpriviliged
user. pjdfstests needs to run as root and this does not work in this
setup as creation of files as root fails. (On host, daemon tries to
switch to root uid and that fails).

So as of now, I think these are the minimum changes needed to support
unprivileged passthrough mode of virtiofsd.

Thanks
Vivek

Vivek Goyal (5):
  virtiofsd: Add notion of unprivileged mode
  virtiofsd: create lock/pid file in per user cache dir
  virtiofsd: open /proc/self/fd/ in sandbox=NONE mode
  virtiofsd: Open lo->source while setting up root in sandbox=NONE mode
  virtiofsd: Skip setup_capabilities() in sandbox=NONE mode

 tools/virtiofsd/fuse_virtio.c    | 15 ++++++++++++++-
 tools/virtiofsd/passthrough_ll.c | 29 ++++++++++++++++++++++++++---
 2 files changed, 40 insertions(+), 4 deletions(-)

-- 
2.25.4

