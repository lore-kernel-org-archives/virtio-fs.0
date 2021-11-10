From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 10 Nov 2021 18:17:22 -0500
Message-Id: <20211110231728.50385-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 0/6] virtiofsd: Add support for file security
	context at creation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com, dgilbert@redhat.com
Cc: casey@schaufler-ca.com, omosnace@redhat.com, vgoyal@redhat.com

Hi,

This is V3 of the patches. I posted V2 here.

https://lore.kernel.org/qemu-devel/20211014153126.575173-1-vgoyal@redhat.com/

Kernel patches are not upstream yet. So header files will need to be
updated once kernel patches are merged. I posted V3 of kernel patches
here.

https://lore.kernel.org/linux-fsdevel/20211110225528.48601-1-vgoyal@redhat.com/T/#m08352d3d46f948c6c507c28f9db83098d175ca54

Changes since v2:

- Renamed "struct fuse_secctxs" to "struct fuse_secctx_header".
- Added a size field to fuse_secctx_header.    

Thanks
Vivek

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

