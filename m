From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Wed, 16 Oct 2019 17:01:55 +0100
Message-Id: <20191016160157.12414-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/2] virtiofsd: add net and pid namespace
	sandboxing
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com

These patches are based on gitlab.com/virtio-fs/qemu.git virtio-fs-dev.

virtiofsd is sandboxed so that it does not have access to the system in the
event that the process is compromised.  At the moment we use seccomp and mount
namespaces to restrict the list of allowed syscalls and only give access to the
shared directory.

This patch series enhances sandboxing by putting virtiofsd into an empty
network and pid namespace.  If the process is compromised it will be unable to
perform network activity, even to localhost services running on the host.  It
will also be unable to see other processes running on the system since it runs
as pid 1 in a new pid namespace.

These enhancements are inspired by the Crosvm virtio-fs device's jail
configuration.

Stefan Hajnoczi (2):
  virtiofsd: move to an empty network namespace
  virtiofsd: move to a new pid namespace

 contrib/virtiofsd/passthrough_ll.c | 109 +++++++++++++++++++++++------
 1 file changed, 86 insertions(+), 23 deletions(-)

-- 
2.21.0

