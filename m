From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 29 Jul 2020 18:14:05 -0400
Message-Id: <20200729221410.147556-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC PATCH 0/5] virtiofsd: Add notion of unprivileged
	mode
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

Daniel Berrange mentioned that having a unpriviliged mode in virtiofsd 
might be useful for certain use cases. Hence I decided to give it
a try.

This is RFC patch series to allow running virtiofsd as unpriviliged
user. This is still work in progress. I am posting it to get
some early feedback.

These patches are dependent on Stefan's patch series for sandbox=chroot.

https://www.redhat.com/archives/virtio-fs/2020-July/msg00078.html

I can now run virtiofsd as user "test" and also export a directory
into a VM running as user test.

This is ideally for the cases where user "test" inside VM will operate
on this virtiofs mount point. Any filesystem operations which can't
be done with the creds of "test" user on host, will fail.

Thanks
Vivek

Vivek Goyal (5):
  virtiofsd: Add notion of unprivileged mode
  virtiofsd: create lock/pid file in per user cache dir
  virtiofsd: open /proc/self/fd/ in sandbox=NONE mode
  virtiofsd: Open lo->source while setting up root in sandbox=NONE mode
  virtiofsd: Skip setup_capabilities() in sandbox=NONE mode

 tools/virtiofsd/fuse_virtio.c    | 40 ++++++++++++++++++++++++++++----
 tools/virtiofsd/passthrough_ll.c | 29 ++++++++++++++++++++---
 2 files changed, 61 insertions(+), 8 deletions(-)

-- 
2.25.4

