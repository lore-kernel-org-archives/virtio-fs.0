Date: Wed, 28 Oct 2020 19:00:18 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201028190018.GA4858@work-vm>
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

This is based off a very recent qemu tree, and we've got some new
virtiofs features in (thanks to all contributors):

  a) A new sandbox option that uses chroot rather than pivot_root
    and namespacing

  b) A mechanism that lets xattr names be translated between the
    host and guest.

  c) an explicit configure option (--enable-virtiofsd) to force
   compilation of virtiofsd - the build system will then tell
   you if you're missing build dependencies rather than quietly
   disabling it.

Dave

-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

