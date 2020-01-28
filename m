From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Date: Tue, 28 Jan 2020 19:18:17 +0900
Message-ID: <20200128101819.21766-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 0/2] virtiofsd: Fix xattr and ACL
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: vgoyal@redhat.com

Hi,

This is a second version of xattr fix for virtiofsd.
I included ACL fix (which introduces new option posix_acl) in this version
too as ACL mostly depends on xattr.

I run xfstests with XFS backend using "-o xattr -o posix_acl" option and
only new failure is generic/375 which checks if sgid bit is cleared after
setfacl. I'll try to investigate it.

change in v1 -> v2
 - rebased to current dev branch

 - Always chdir for xattr (1st patch)
   In v1, I keep current implementation for regular file/dir since it
   show better performance in my environment. But I notice opening file
   for xattr causes seek sanity test fails (xfstest generic/285, 436).

   I'm not sure what is the fundamental problem here but I believe
   performance can be improved by introducing some caching mechanism
   in general. So I change the code to always fchdir to avoid the
   problem for now. This results in simpler code too.

 - Add ACL fix (2nd patch)
   ACL mostly works if xattr option is enabled.
   To support default ACL behavior, add new option posix_acl which
   handles umasking in virtiofsd instead of guest kernel.

Thanks,
Misono

Misono Tomohiro (2):
  virtiofsd: Fix xattr operations
  virtiofsd: Add support of posix_acl

 tools/virtiofsd/fuse_virtio.c    |  13 +++
 tools/virtiofsd/helper.c         |   3 +
 tools/virtiofsd/passthrough_ll.c | 136 +++++++++++++++++++++----------
 tools/virtiofsd/seccomp.c        |  11 ++-
 4 files changed, 115 insertions(+), 48 deletions(-)

-- 
2.21.1


