From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 26 Jan 2022 10:51:11 +0000
Message-Id: <20220126105112.28711-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 0/1] virtiofs queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, shawtao1125@gmail.com, vgoyal@redhat.com
Cc: mcascell@redhat.com, virtio-fs@redhat.com, pj.pandit@yahoo.co.in

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

The following changes since commit aeb0ae95b7f18c66158792641cb6ba0cde5789ab:

  Merge remote-tracking branch 'remotes/jsnow-gitlab/tags/python-pull-request' into staging (2022-01-22 12:03:22 +0000)

are available in the Git repository at:

  https://gitlab.com/dagrh/qemu.git tags/pull-virtiofs-20220126

for you to fetch changes up to 449e8171f96a6a944d1f3b7d3627ae059eae21ca:

  virtiofsd: Drop membership of all supplementary groups (CVE-2022-0358) (2022-01-26 10:32:05 +0000)

----------------------------------------------------------------
virtiofsd: Security fix

Fixes: CVE-2022-0358

----------------------------------------------------------------
Vivek Goyal (1):
      virtiofsd: Drop membership of all supplementary groups (CVE-2022-0358)

 tools/virtiofsd/passthrough_ll.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

