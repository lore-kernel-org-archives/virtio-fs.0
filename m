From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu,  5 Sep 2019 09:29:45 +0100
Message-Id: <20190905082947.6633-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH RESEND 0/2] virtiofsd: use "fuse_log.h" APIs
	instead of <err.h>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com

warn(3), warnx(3), err(3), and errx(3) print to stderr even when the --syslog
option was given.  In this case messages to stderr are likely to be lost and
this makes troubleshooting hard.  Use "fuse_log.h" APIs instead of <err.h>.

Stefan Hajnoczi (2):
  virtiofsd: replace warn(3) and warnx(3) with fuse_warning()
  virtiofsd: replace err(3) and errx(3) with fuse_err()

 contrib/virtiofsd/passthrough_ll.c | 143 ++++++++++++++++++-----------
 contrib/virtiofsd/seccomp.c        |  15 ++-
 2 files changed, 99 insertions(+), 59 deletions(-)

-- 
2.21.0

