Date: Wed, 23 Sep 2020 13:28:48 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200923122848.GA2820@work-vm>
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

There's no major changes from the virtiofs world in there, but it is
based on a bleeding edge qemu build, which has some major changes in
it's build system.

Note that the virtiofsd binary ends up in ./tools/virtiofsd/virtiofsd
rather than the top level where the existing build system puts it.

Dave

-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

