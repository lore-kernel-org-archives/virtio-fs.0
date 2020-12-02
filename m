Date: Wed, 2 Dec 2020 12:34:10 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201202123410.GD3226@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] virtiofsd-rs: A rust virtiofs daemon
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, slp@redhat.com
Cc: qemu-devel@nongnu.org

Hi,
  Sergio has been working on virtiofsd-rs, a virtiofs daemon
written in rust, and which can be found at:

  https://gitlab.com/virtio-fs/virtiofsd-rs

It started life originally as part of the crosvm project, got
ported to vhost-user as part of the Cloud Hypervisor project, and
has now been split out.

While the C version of virtiofsd isn't going away for now, the hope
is to stabilise virtiofsd-rs, add some missing features and start
preferentially adding new features and new work onto the Rust version
rather than the C version.

So please try it, and let the list (and Sergio!) know how you get on.

Dave

-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

