From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 24 Feb 2021 11:58:34 -0500
Message-Id: <20210224165837.21983-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 0/3] virtiofsd: Add support to enable/disable
	posix acls
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: vgoyal@redhat.com, miklos@szeredi.hu

Hi,

This is V4 of patches.

In V3 I enabled posix_acl by default. Then I tested with cache=none and
a simple "cat foo.txt" results in two extra GETXATTR(system.posix_acl)
calls. (Note, this happens only if caller is not owner of file). And
this happens on every call of "cat foo.txt" because cache=none does
not cache anything in guest.

So this make me rethink the idea of enabling posix_acl by default. I
prefer not to have any performance regressions in any of the mode
out of the box.

Hence proposing this V4 where posix_acls are disabled by default and
user needs to enable it explicitly if the want posix acls. This probably
can change down the line once somebody can prove enabling it by deafult
really does not impact us much.

Change since V3.

- Do not enable posix_acl by default.
- Error out if user wants to enable it but xattr are disabled.
- Modified help message and docs/tools/virtiofsd.rst to add
  documentation for this new knob (Luis Henriques).
- Captured Reviewed-by tags from Stefan from V3.

Thanks
Vivek

Vivek Goyal (3):
  virtiofsd: Add umask to seccom allow list
  virtiofsd: Add capability to change/restore umask
  virtiofsd: Add an option to enable/disable posix acls

 docs/tools/virtiofsd.rst              |   3 +
 tools/virtiofsd/helper.c              |   1 +
 tools/virtiofsd/passthrough_ll.c      | 125 ++++++++++++++++++++++++--
 tools/virtiofsd/passthrough_seccomp.c |   1 +
 4 files changed, 123 insertions(+), 7 deletions(-)

-- 
2.25.4

