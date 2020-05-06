From: Max Reitz <mreitz@redhat.com>
Date: Wed,  6 May 2020 17:38:32 +0200
Message-Id: <20200506153832.240812-1-mreitz@redhat.com>
In-Reply-To: <20200506153258.238687-1-mreitz@redhat.com>
References: <20200506153258.238687-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC 0/2] virtiofsd: Announce submounts
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

As explained in the common cover letter
(<20200506153258.238687-1-mreitz@redhat.com>),
we want to let the guest mirror the mount structure on the host.

To do so, we need to set st_rdev to a non-zero value[1] for mount
points, and this is what this series makes virtiofsd do (optionally,
because some users may prefer not to pass this information through to
the guest).

[1] In practice, any non-zero value will do, but we might want it to be
    st_dev so the guest might in the future special-case duplicate
    mounts (by using a single block device for them, so they all get the
    same st_dev).


Max Reitz (2):
  virtiofsd: Store every lo_inode's parent_dev
  virtiofsd: Set st_rdev for sub-mount points

 tools/virtiofsd/passthrough_ll.c | 79 ++++++++++++++++++++++++++++----
 1 file changed, 70 insertions(+), 9 deletions(-)

-- 
2.26.2

