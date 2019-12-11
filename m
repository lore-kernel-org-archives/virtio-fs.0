Date: Wed, 11 Dec 2019 12:16:30 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20191211121630.GD3875@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] Changes in -dev branch
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hi,
  I've just pushed a new version of the virtio-fs-dev branch in
https://gitlab.com/virtio-fs/qemu

some things to note:

  a) It's now rebased on upstream qemu 4.2-rc5
  b) The virtiofsd is now in tools/virtiofsd rather than contrib
     (after a long discussion on qemu-devel about where people
      want it)
  c) I've reformatted all the files to match qemu's coding style
     guidelines; mostly.  This is a mostly automatic process
     with some hand tweaking.  There's the possibility some stuff
     is screwed up so I need to check on it.
  d) It now uses libcap-ng rather libcap; that's the way qemu is
     moving, allthough the change is a bit hairy.
  e) If you're missing either libseccomp or libcapng during build
     it will omit virtiofsd rather than failing the build.

Dave


--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

