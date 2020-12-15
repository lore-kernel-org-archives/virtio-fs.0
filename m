DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=bytedance-com.20150623.gappssmtp.com; s=20150623;
	h=from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=bqpP+QK4GIBCdeAY8wBqv5k9tOk5+xF27b2NprepG5o=;
	b=hB7RvfOTd2iQQz542/4Thlmv/jt2Hxn7Ck7mctLiZ4b7a1dMhJZS5PqUBiAjNcDZWr
	12W2TfHjbaU01IcOHnbpVf07esRgsB0heZBd25H3D0G5XdOordFSmv1BzMqhTpR4CiAh
	kxXcUUWUL46rATlG0QL5iQJQSqidSq5dCHlNwXAquniWfgL/i7D9tm914yITLzI/ciZk
	VIl5bYBtuL+eu5lD8NDaIP1f8zb/AHJov2ccrV9gDtqdFWMrA7WzuKMUYASK9OWbGJOn
	ZZJi5jNolh3+8jJxYISv9Zxrhk8sfftkVv4HSYuKbDdLPNyWvkClZiI7Oe4WYr95YXsK
	TGqg==
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Date: Wed, 16 Dec 2020 00:21:10 +0800
Message-Id: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [RFC PATCH 0/9] Support for Virtio-fs daemon crash
	reconnection
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr . David Alan Gilbert" <dgilbert@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Xie Yongji <xieyongji@bytedance.com>
Cc: virtio-fs@redhat.com, Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>, qemu-devel@nongnu.org

Hi, all

We implement virtio-fs crash reconnection in this patchset. The crash
reconnection of virtiofsd here is completely transparent to guest, no
remount in guest is needed, even the inflight requests can be handled
normally after reconnection. We are looking forward to any comments. 

Thanks,
Jiachen


OVERVIEW:

To support virtio-fs crash reconnection, we need to support the recovery
of 1) inflight FUSE request, and 2) virtiofsd internal status information.

Fortunately, QEMU's vhost-user reconnection framework already supports
inflight I/O tracking by using VHOST_USER_GET_INFLIGHT_FD and
VHOST_USER_SET_INFLIGHT_FD (see 5ad204bf2 and 5f9ff1eff for details).
As the FUSE requests are transferred by virtqueue I/O requests, by using
the vhost-user inflight I/O tracking, we can recover the inflight FUSE
requests.

To support virtiofsd internal status recovery, we introduce 4 new
vhost-user message types. As shown in the following diagram, two of them
are used to persist shared lo_maps and opened fds to QEMU, the other two
message types are used to restore the status when reconnecting.

                               VHOST_USER_SLAVE_SHM
                               VHOST_USER_SLAVE_FD
    +--------------+       Persist       +--------------------+
    |              <---------------------+                    |
    |     QEMU     |                     |  Virtio-fs Daemon  |
    |              +--------------------->                    |
    +--------------+       Restore       +--------------------+
            VHOST_USER_SET_SHM
            VHOST_USER_SET_FD

Although the 4 newly added message types are to support virtiofsd
reconnection in this patchset, it might be potential in other situation.
So we keep in mind to make them more general when add them to vhost
related source files. VHOST_USER_SLAVE_SHM and VHOST_USER_SET_SHM can be
used for memory sharing between a vhost-user daemon and QEMU,
VHOST_USER_SLAVE_FD and VHOST_USER_SET_FD would be useful if we want to
shared opened fds between QEMU process and vhost-user daemon process.


USAGE and NOTES:

- The commits are rebased to a recent QEMU master commit b4d939133dca0fa2b.

- ",reconnect=1" should be added to the "-chardev socket" of vhost-user-fs-pci
in the QEMU command line, for example:

    qemu-system-x86_64 ... \
    -chardev socket,id=char0,path=/tmp/vhostqemu,reconnect=1 \
    -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs \
    ...

- We add new options for virtiofsd to enable or disable crash reconnection.
And some options are not supported by crash reconnection. So add following
options to virtiofsd to enable reconnection:

    virtiofsd ... -o reconnect -o no_mount_ns -o no_flock -o no_posix_lock
    -o no_xattr ...

- The reasons why virtiofsd-side locking, extended attributes, and mount
namespace are not supported is explained in the commit message of the 6th
patch (virtiofsd: Add two new options for crash reconnection).

- The 9th patch is a work-around that will not affect the overall correctness.
We remove the qsort related codes because we found that when resubmit_num is
larger than 64, seccomp will kill the virtiofsd process.

- Support for dax version virtiofsd is very possible and requires almost no
additional change to this patchset.


Jiachen Zhang (9):
  vhost-user-fs: Add support for reconnection of vhost-user-fs backend
  vhost: Add vhost-user message types for sending shared memory and file
    fds
  vhost-user-fs: Support virtiofsd crash reconnection
  libvhost-user: Add vhost-user message types for sending shared memory
    and file fds
  virtiofsd: Convert the struct lo_map array to a more flatten layout
  virtiofsd: Add two new options for crash reconnection
  virtiofsd: Persist/restore lo_map and opened fds to/from QEMU
  virtiofsd: Ensure crash consistency after reconnection
  virtiofsd: (work around) Comment qsort in inflight I/O tracking

 contrib/libvhost-user/libvhost-user.c | 106 +++-
 contrib/libvhost-user/libvhost-user.h |  70 +++
 docs/interop/vhost-user.rst           |  41 ++
 hw/virtio/vhost-user-fs.c             | 334 ++++++++++-
 hw/virtio/vhost-user.c                | 123 ++++
 hw/virtio/vhost.c                     |  42 ++
 include/hw/virtio/vhost-backend.h     |   6 +
 include/hw/virtio/vhost-user-fs.h     |  16 +-
 include/hw/virtio/vhost.h             |  42 ++
 tools/virtiofsd/fuse_lowlevel.c       |  24 +-
 tools/virtiofsd/fuse_virtio.c         |  44 ++
 tools/virtiofsd/fuse_virtio.h         |   1 +
 tools/virtiofsd/helper.c              |   9 +
 tools/virtiofsd/passthrough_helpers.h |   2 +-
 tools/virtiofsd/passthrough_ll.c      | 830 ++++++++++++++++++--------
 tools/virtiofsd/passthrough_seccomp.c |   1 +
 16 files changed, 1413 insertions(+), 278 deletions(-)

-- 
2.20.1

