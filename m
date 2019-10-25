From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Fri, 25 Oct 2019 12:01:49 +0200
Message-Id: <20191025100152.6638-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC 0/3] tests/vhost-user-fs-test: add vhost-user-fs
	test case
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, virtio-fs@redhat.com, Paolo Bonzini <pbonzini@redhat.com>, vgoyal@redhat.com

This patch series adds an automated test for the vhost-user-fs device using
virtiofsd.  This makes low-level testing of FUSE messages and even VIRTIO
possible.  These things can be hard to do inside a normal guest environment
where such tests require building kernel modules and can result in kernel
panics.

To get a feel for how vhost-user-fs-test.c test cases work, here is an example:

  /* Create file on host and check its contents and metadata in guest */
  static void test_file_from_host(void *parent, void *arg, QGuestAllocator *alloc)
  {
      g_autofree gchar *filename = g_strdup_printf("%s/%s", shared_dir, "foo");
      const char *str = "This is a test\n";
      char buf[strlen(str)];
      QVirtioFS *vfs = parent;
      struct fuse_entry_out entry;
      int32_t error;
      uint64_t nodeid;
      uint64_t fh;
      ssize_t nread;
      gboolean ok;

      SKIP_TEST_IF_CROSS_ENDIAN();

      /* Create the test file in the shared directory */
      ok = g_file_set_contents(filename, str, strlen(str), NULL);
      g_assert(ok);

      fuse_init(vfs);

      error = fuse_lookup(vfs, FUSE_ROOT_ID, "foo", &entry);
      g_assert_cmpint(error, ==, 0);
      g_assert_cmpint(guest64(entry.attr.size), ==, strlen(str));
      nodeid = guest64(entry.nodeid);

      error = fuse_open(vfs, nodeid, O_RDONLY, &fh);
      g_assert_cmpint(error, ==, 0);

      nread = fuse_read(vfs, fh, 0, buf, sizeof(buf));
      g_assert_cmpint(nread, ==, sizeof(buf));
      g_assert_cmpint(memcmp(buf, str, sizeof(buf)), ==, 0);

      fuse_release(vfs, fh);
      fuse_forget(vfs, nodeid);
  }

This patch series is based on "[PATCH v4 00/16] libqos: add VIRTIO PCI 1.0
support" and the https://gitlab.com/virtio-fs/qemu virtio-fs-dev branch.  I
expect conflicts and will resend again once these dependencies have landed in
qemu.git/master.

Stefan Hajnoczi (3):
  WIP virtiofsd: import Linux <fuse.h> header file
  qgraph: add an "after" test callback function
  tests/vhost-user-fs-test: add vhost-user-fs test case

 tests/Makefile.include                        |   8 +-
 contrib/virtiofsd/fuse_lowlevel.h             |   2 +-
 .../standard-headers/linux/fuse.h             |   0
 tests/libqos/qgraph.h                         |   2 +
 tests/libqos/qgraph_internal.h                |   1 +
 tests/libqos/virtio-fs.h                      |  46 ++
 contrib/virtiofsd/fuse_loop_mt.c              |   2 +-
 contrib/virtiofsd/fuse_lowlevel.c             |   2 +-
 contrib/virtiofsd/fuse_virtio.c               |   2 +-
 tests/libqos/qgraph.c                         |   1 +
 tests/libqos/virtio-fs.c                      | 104 +++
 tests/qos-test.c                              |   6 +
 tests/vhost-user-fs-test.c                    | 660 ++++++++++++++++++
 scripts/update-linux-headers.sh               |   3 +-
 14 files changed, 832 insertions(+), 7 deletions(-)
 rename contrib/virtiofsd/fuse_kernel.h => include/standard-headers/linux/fuse.h (100%)
 create mode 100644 tests/libqos/virtio-fs.h
 create mode 100644 tests/libqos/virtio-fs.c
 create mode 100644 tests/vhost-user-fs-test.c

-- 
2.21.0

