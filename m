From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 24 Sep 2021 15:48:49 -0400
Message-Id: <20210924194854.919414-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/5] virtiofsd: Add support for file security
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
Cc: miklos@szeredi.hu, stephen.smalley.work@gmail.com, vgoyal@redhat.com

Hi,

These patches add support to receive and set file security context at
the time of file creation. This is one of the components needed to
support SELinux on virtiofs.

I have posted kernel patches here just now.

https://lore.kernel.org/linux-fsdevel/20210924192442.916927-1-vgoyal@redhat.com/T/#m971f9001dd622b3f7a96a65899e3f146d2185841

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
	- Give CAP_SYS_ADMIN to virtiofsd. 

I have tested mode A and B but yet to test mode C.

I think either mode B or mode C will be most commonly used mode when
guest does need SELinux support in virtiofs.

With these patches, I am able to boot a guest VM with rootfs on virtiofs
and with SELinux enabled in guest. 

Please review.

Thanks
Vivek


Vivek Goyal (5):
  fuse: Header file changes for FUSE_SECURITY_CTX
  fuse_lowlevel.c: Add capability to parse security context
  virtiofsd: Move core file creation code in separate function
  virtiofsd: Create new file with fscreate set
  virtiofsd: Create new file using O_TMPFILE and set security context

 include/standard-headers/linux/fuse.h |  14 +-
 tools/virtiofsd/fuse_common.h         |   5 +
 tools/virtiofsd/fuse_i.h              |   7 +
 tools/virtiofsd/fuse_lowlevel.c       |  74 ++++++
 tools/virtiofsd/passthrough_ll.c      | 366 ++++++++++++++++++++++++--
 5 files changed, 436 insertions(+), 30 deletions(-)

-- 
2.31.1

