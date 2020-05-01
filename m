From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Fri,  1 May 2020 15:06:42 +0100
Message-Id: <20200501140644.220940-1-stefanha@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 0/2] virtiofsd: stay under fs.file-max sysctl
	limit (CVE-2020-10717)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, vgoyal@redhat.com, pjp@redhat.com

This patch series introduces the --rlimit-nofile=NUM option for setting the
number of open files on the virtiofsd process.  This gives users and management
tools more control over resource limits.

Previously it was possible for FUSE clients on machines with less than ~10 GB
of RAM to exhaust the system-wide open file limit.  This is a denial of service
attack against other processes running on the host.

This patch series updates the default RLIMIT_NOFILE calculation to take the
fs.file-max sysctl value into account.  This solves the fs.file-max DoS.

Stefan Hajnoczi (2):
  virtiofsd: add --rlimit-nofile=NUM option
  virtiofsd: stay below fs.file-max sysctl value (CVE-2020-10717)

 tools/virtiofsd/fuse_lowlevel.h  |  1 +
 tools/virtiofsd/helper.c         | 47 ++++++++++++++++++++++++++++++++
 tools/virtiofsd/passthrough_ll.c | 22 ++++++---------
 3 files changed, 56 insertions(+), 14 deletions(-)

-- 
2.25.3


