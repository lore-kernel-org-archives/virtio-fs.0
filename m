From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 13 Aug 2019 15:29:40 -0400
Message-Id: <20190813192944.26009-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/4] Drop CAP_FSETID if client needs to kill
	setuid/setgid bits
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

If a file has setuid/setuid bit set and a writer writes to file without
having CAP_FSETID capability, kernel clears setuid/setgid bit on file.

pjdfstest test chmod/12.t tests for this. With moving to 5.3 kernel and
cache=none this test fails. 

Now Miklos has introducd a commit where if client thinks that
setuid/setgid bit should be cleared, it sets FUSE_KILL_PRIV flag
in fuse_write_in->write_flags. This is an indication to daemon to
clear setuid/setgid bit atomically.

So drop CAP_FSETID capability and then proceed with write and that
should automatically clear setuid bit.

Vivek Goyal (4):
  virtiofsd: Fix number of padding bits in fuse_file_info
  virtiofsd: Use macros for write_flag parsing
  virtiofsd: Parse flag FUSE_WRITE_KILL_PRIV
  virtiofsd: Drop CAP_FSETID if client asked for it

 contrib/virtiofsd/Makefile.objs    |   2 +
 contrib/virtiofsd/fuse_common.h    |   5 +-
 contrib/virtiofsd/fuse_kernel.h    |   1 +
 contrib/virtiofsd/fuse_lowlevel.c  |   6 +-
 contrib/virtiofsd/passthrough_ll.c | 127 +++++++++++++++++++++++++++++
 contrib/virtiofsd/seccomp.c        |   2 +
 6 files changed, 140 insertions(+), 3 deletions(-)

-- 
2.17.2

