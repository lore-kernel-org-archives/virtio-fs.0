From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Thu,  4 Feb 2021 18:34:34 +0000
Message-Id: <20210204183439.546918-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 0/5] virtiofs queue: Security fix
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com, stefanha@redhat.com, groug@kaod.org, qemu-stable@nongnu.org

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

The following changes since commit 1ba089f2255bfdb071be3ce6ac6c3069e8012179:

  Merge remote-tracking branch 'remotes/armbru/tags/pull-qmp-2021-02-04' into staging (2021-02-04 14:15:35 +0000)

are available in the Git repository at:

  https://gitlab.com/dagrh/qemu.git tags/pull-virtiofs-20210204

for you to fetch changes up to cf269ff8032392bbdd700e7bfd21823ad9eee3a9:

  virtiofsd: Add restart_syscall to the seccomp whitelist (2021-02-04 17:50:08 +0000)

----------------------------------------------------------------
virtiofs: Security pull 2021-02-04

This contains an important CVE fix for virtiofsd,
together with two fixes for over-eager seccomp rules.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

----------------------------------------------------------------
Greg Kurz (2):
      virtiofsd: Add _llseek to the seccomp whitelist
      virtiofsd: Add restart_syscall to the seccomp whitelist

Stefan Hajnoczi (3):
      virtiofsd: extract lo_do_open() from lo_open()
      virtiofsd: optionally return inode pointer from lo_do_lookup()
      virtiofsd: prevent opening of special files (CVE-2020-35517)

 tools/virtiofsd/passthrough_ll.c      | 224 ++++++++++++++++++++++------------
 tools/virtiofsd/passthrough_seccomp.c |   2 +
 2 files changed, 150 insertions(+), 76 deletions(-)

