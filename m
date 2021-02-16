From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 16 Feb 2021 18:36:08 -0500
Message-Id: <20210216233611.33400-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/3] virtiofsd: Add options to enable/disable
	posix acl
List-Id: Development discussions about virtio-fs <virtio-fs.listman.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@listman.redhat.com>
List-Help: <mailto:virtio-fs-request@listman.redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@listman.redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: miklos@szeredi.hu, vgoyal@redhat.com

Luis Henriques reported that fstest generic/099 fails with virtiofs.
Little debugging showed that we don't enable acl support. So this
patch series provides option to enable/disable posix acl support. By
default it is disabled.

I have run blogbench and pjdfstests with posix acl enabled and
things work fine. 

Luis, can you please apply these patches, and run virtiofsd with
"-o posix_acl" and see if it fixes the failure you are seeing. I
ran the steps you provided manually and it fixes the issue for
me.

Vivek Goyal (3):
  virtiofsd: Add an option to enable/disable posix acls
  virtiofsd: Add umask to seccom allow list
  virtiofsd: Change umask if posix acls are enabled

 tools/virtiofsd/passthrough_ll.c      | 45 +++++++++++++++++++++++----
 tools/virtiofsd/passthrough_seccomp.c |  1 +
 2 files changed, 40 insertions(+), 6 deletions(-)

-- 
2.25.4

