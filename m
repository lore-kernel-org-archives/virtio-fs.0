From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Tue, 27 Aug 2019 10:54:33 +0100
Message-Id: <20190827095437.18819-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/4] virtiofsd: implement vhost-user.rst
	"Backend program conventions"
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org
Cc: =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>

This series implements the conventions for vhost-user backend programs
described in vhost-user.rst:
1. Run in the foreground by default.
2. Show vhost-user.json capabilities when --print-capabilities is given.
3. Ship a vhost-user.json file so the program can be discovered.

No command-line options or VHostUserBackendCapabilities are defined for the
'fs' backend type yet.  Let's until it becomes clear what should be standard
for all 'fs' backends and what is specific to virtiofsd.

Stefan Hajnoczi (4):
  virtiofsd: make -f (foreground) the default
  virtiofsd: add --print-capabilities option
  virtiofsd: install virtiofsd in libexec
  virtiofsd: add vhost-user.json file

 docs/interop/vhost-user.json                |  4 +++-
 Makefile                                    |  3 +++
 contrib/virtiofsd/fuse_lowlevel.h           |  1 +
 contrib/virtiofsd/helper.c                  |  5 +++++
 contrib/virtiofsd/passthrough_ll.c          | 12 ++++++++++++
 .gitignore                                  |  1 +
 contrib/virtiofsd/50-qemu-virtiofsd.json.in |  5 +++++
 7 files changed, 30 insertions(+), 1 deletion(-)
 create mode 100644 contrib/virtiofsd/50-qemu-virtiofsd.json.in

-- 
2.21.0

