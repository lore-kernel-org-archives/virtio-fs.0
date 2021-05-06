From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Thu,  6 May 2021 19:56:29 +0100
Message-Id: <20210506185641.284821-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 00/12] virtiofs queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, groug@kaod.org, jose.carlos.venegas.munoz@intel.com, ma.mandourr@gmail.com
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

The following changes since commit d90f154867ec0ec22fd719164b88716e8fd48672:

  Merge remote-tracking branch 'remotes/dg-gitlab/tags/ppc-for-6.1-20210504' into staging (2021-05-05 20:29:14 +0100)

are available in the Git repository at:

  https://gitlab.com/dagrh/qemu.git tags/pull-virtiofs-20210506

for you to fetch changes up to 67a010f64cc9e33ba19ab389dedaa52013a9de8a:

  virtiofsd/fuse_virtio.c: Changed allocations of locals to GLib (2021-05-06 19:47:44 +0100)

----------------------------------------------------------------
virtiofsd pull 2021-05-06

A pile of cleanups:

  Use of glib allocators from Mahmoud
  Virtio spec compliance and printf cleanup from me.
  Sugar to turn on xattr when defining xattr mapping from Carlos
  an assert cleanup from Greg

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

----------------------------------------------------------------
Carlos Venegas (2):
      virtiofsd: Allow use "-o xattrmap" without "-o xattr"
      virtiofsd: Add help for -o xattr-mapping

Dr. David Alan Gilbert (2):
      virtiofs: Fixup printf args
      virtiofsd: Don't assume header layout

Greg Kurz (1):
      virtiofsd: Fix side-effect in assert()

Mahmoud Mandour (7):
      virtiofsd: Changed allocations of fuse_req to GLib functions
      virtiofsd: Changed allocations of iovec to GLib's functions
      virtiofsd: Changed allocations of fuse_session to GLib's functions
      virtiofsd: Changed allocation of lo_map_elems to GLib's functions
      virtiofsd: Changed allocations of fv_VuDev & its internals to GLib functions
      virtiofsd/passthrough_ll.c: Changed local allocations to GLib functions
      virtiofsd/fuse_virtio.c: Changed allocations of locals to GLib

 tools/virtiofsd/fuse_lowlevel.c  |  43 ++++++-------
 tools/virtiofsd/fuse_virtio.c    | 129 ++++++++++++++++++++++++++-------------
 tools/virtiofsd/helper.c         |   3 +
 tools/virtiofsd/passthrough_ll.c |  64 +++++++++----------
 4 files changed, 139 insertions(+), 100 deletions(-)

