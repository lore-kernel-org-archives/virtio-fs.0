Date: Wed, 22 May 2019 17:26:23 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190522162623.GH2666@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] qemu/virtiofsd dev tree
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
  I uploaded: https://gitlab.com/virtio-fs/qemu/commits/virtio-fs-dev
which has:

   * Fixes from Alibaba, Intel, Red Hat
   * Stefan's security doc
   * support for direct-io from virtiofs to virtiofs (e.g.
     reading a virtiofs file into an mmap'd viritofs dax file)
     - I've just finished this and it's lightly tested, so feedback
     welcome
   * Rebase on bleeding edge qemu.

Let me know how it goes.

Dave

--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

