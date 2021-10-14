From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 14 Oct 2021 11:31:20 -0400
Message-Id: <20211014153126.575173-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 0/6] virtiofsd: Add support for file security
	context at creation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: miklos@szeredi.hu, stephen.smalley.work@gmail.com, omosnace@redhat.com, casey@schaufler-ca.com, vgoyal@redhat.com

Hi,

This is v2 of patches. I posted v1 here.

https://lore.kernel.org/qemu-devel/20210924194854.919414-1-vgoyal@redhat.com/

Posted corresponding kernel patches here.

https://lore.kernel.org/linux-fsdevel/20211012180624.447474-1-vgoyal@redhat.com/

changes since v1:

- Modified patches to handle changes to fuse protocol which allowed
  protocol to send multiple security lables. As of now we can handle
  only one label and we expect it to be selinux label.

- Added an option (-o security_label/no_security_label) to
  enable/disable security label. It is disabled by default.

- Did a fix to not use fscreate if host does not have selinux enabled.   

Description
-----------
These patches add support to receive and set file security context at
the time of file creation. This is one of the components needed to
support SELinux on virtiofs.

These patches will allow users to configure virtiofsd in multiple modes
to set security context.

A. Guest and host selinux policies can work with each other.
        - virtiofsd will use /proc/thread-self/attr/fscreate knob to
          set security context before file creation.

B. Remap guest selinux security xattr to something else say,
   trusted.virtiofs.security.selinux.
        - Give CAP_SYS_ADMIN to virtiofsd.
        - "-o -o xattrmap=:map:security.selinux:trusted.virtiofsd.:"

C. If no SELinux on host.
        - Give CAP_SYS_ADMIN to virtiofsd and security xattr will be
	  saved in security.selinux xattr on host.

With these patches, I am able to boot a guest VM with rootfs on virtiofs
and with SELinux enabled in guest.


Vivek Goyal (6):
  fuse: Header file changes for FUSE_SECURITY_CTX
  virtiofsd, fuse_lowlevel.c: Add capability to parse security context
  virtiofsd: Move core file creation code in separate function
  virtiofsd: Create new file with fscreate set
  virtiofsd: Create new file using O_TMPFILE and set security context
  virtiofsd: Add an option to enable/disable security label

 docs/tools/virtiofsd.rst              |   7 +
 include/standard-headers/linux/fuse.h |  19 +-
 tools/virtiofsd/fuse_common.h         |   5 +
 tools/virtiofsd/fuse_i.h              |   7 +
 tools/virtiofsd/fuse_lowlevel.c       |  91 ++++++
 tools/virtiofsd/helper.c              |   1 +
 tools/virtiofsd/passthrough_ll.c      | 414 ++++++++++++++++++++++++--
 7 files changed, 514 insertions(+), 30 deletions(-)

-- 
2.31.1

