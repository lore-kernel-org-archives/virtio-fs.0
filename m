Date: Fri, 10 Jan 2020 19:03:47 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200110190347.GA3855@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
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
=20
some things to note:

  a) The old '-o vhost_user_socket' syntax has now been replaced
     by the syntax matching qemu's standardised vhost-user interface
     which is;

     ./virtiofsd --socket-path=3D/path/whereever

  b) It's got about 64 of the main patches reviewed by Daniel Berrang=E9
     - about another 40 that need reviewing; please leap in
     and review any patches on the qemu-devel thread for any patches
     that are missing reviews.

  c) The set that I've just pushed has fixes for all the things
     Daniel spotted; so there's a bunch of mostly minor changes.

  d) It's also got patches that were received on list since
     mid December.

Dave

--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

