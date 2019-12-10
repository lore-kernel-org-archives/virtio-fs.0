From: Fabiano Rosas <farosas@linux.ibm.com>
Date: Tue, 10 Dec 2019 11:51:03 -0300
Message-Id: <20191210145105.329680-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/2] virtio-fs-ci: build-rootfs tweaks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Some improvements for the rootfs build:

- first patch fixes the rootfs build in Fedora

- second patch makes the bootstrap tool selection according to distro
  automatically


Fabiano Rosas (2):
  build-rootfs: Fix fedora build
  build-rootfs: Select bootstrap command based on build machine distro

 build-rootfs.sh | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--
2.23.0


