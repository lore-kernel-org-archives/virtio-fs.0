From: Max Reitz <mreitz@redhat.com>
Date: Wed,  6 May 2020 17:32:58 +0200
Message-Id: <20200506153258.238687-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC] Duplicate submounts in the guest
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Max Reitz <mreitz@redhat.com>

Hi,

This RFC consists of two patch series, one for virtiofsd (i.e., to be
applied to the qemu repo), and one for Linux.

The problem it wants to solve is that virtiofsd just passes through the
stat.st_ino value from the host to the guest, without taking stat.st_dev
into account.  Therefore, it is generally impossible to uniquely
identify nodes in the guest by their st_dev/st_ino combinations.

One way to fix this would be to derive some algorithm to derive a unique
st_ino value from the st_dev/st_ino combination on the host, but this is
not always possible.

So what this series does it basically passing through st_dev alongside
st_ino: We can let the guest create auto-mounted submounts for every
host mount point, so that they get their own dedicated st_dev.  This is
similar to what NFS does with the crossmnt option.

Announcing submounts to the guest (the FUSE client) is done by the FUSE
server (virtiofsd) of setting st_rdev to a non-zero value (e.g. st_dev)
for every mount point.

In this version here, duplicate mounts on the host (same st_dev) will
not necessarily have the same st_dev in the guest.  That would be more
complicated to implement, and there is probably no real need to.

Furthermore, note that virtiofsd identifies files based on
st_dev/st_ino, so if you do have duplicate mounts on the guest, it is
very much possible that you will run into problems when trying to pass
them through to the guest (because virtiofsd may treat them as one and
the same tree).

-- 
2.26.2

