From: Greg Kurz <groug@kaod.org>
Date: Fri, 12 Mar 2021 15:10:00 +0100
Message-Id: <20210312141003.819108-1-groug@kaod.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/3] virtiofsd: Deal with empty filenames
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com

There's no such thing as an empty file name in POSIX-compliant file systems.
The current code base doesn't ensure the client doesn't send requests with
such empty names. I've audited the code and only found one place where
the behavior is somewhat altered in lookup_name() :

    res = do_statx(lo, dir->fd, name, &attr,
                   AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW, &mnt_id);

lookup_name() is used by lo_rmdir(), lo_rename() and lo_unlink() which
all share the same behavior of doing some action on a file or directory
under a given parent directory. But if an empty name reaches the code
above, do_statx() returns the attributes of the parent directory itself
and lookup_name() might return the inode of the parent directory. This
could potentially cause security concerns in the callers.

Fortunately, it doesn't as of today. If the parent directory is the root
inode, lookup_name() returns NULL because lo_find() fails to find an
inode with a matching .st_dev. Otherwise, lookup_name() does return the
parent inode but the empty name then gets passed to either unlinkat(),
renameat() or renameat2(), all of which fail with ENOENT in this case.

Drop AT_EMPTY_PATH from the above code anyway to make it clear empty
names aren't expected by the existing callers. If the need for it
arises in the future, it can be added back but stay safe for now.

The FUSE protocol doesn't have a notion of AT_EMPTY_PATH actually. The
server should hence never see empty names in client requests. Detect
this early and systematically fail the request with ENOENT in this
case.

No regression is observed with the POSIX-oriented pjdfstest file system
test suite (https://github.com/pjd/pjdfstest).

Greg Kurz (3):
  virtiofsd: Don't allow empty paths in lookup_name()
  virtiofsd: Convert some functions to return bool
  virtiofsd: Don't allow empty filenames

 tools/virtiofsd/passthrough_ll.c | 44 ++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 5 deletions(-)

-- 
2.26.2


