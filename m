From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Date: Mon, 20 Jan 2020 21:43:05 +0900
Message-ID: <20200120124307.20020-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/2] virtiofsd: Remove fuse_loop_mt.c and
	clone_fd option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

While reviewing virtiofsd code, I noticed fuse_loop_mt.c became not
needed for virtiofs. As it seems that it is easier to remove them on top
of current virtiofs branch, I made these patches.
Feel free to squash or rebase if convenient.

Thanks,
Misono

Misono Tomohiro (2):
  virtiofsd: fuse_lowevel: remove call of fuse_chan_{get,put}
  virtiofsd: Remove fuse_loop_mt.c

 tools/virtiofsd/Makefile.objs   |  1 -
 tools/virtiofsd/fuse.h          | 38 ----------------------
 tools/virtiofsd/fuse_common.h   | 24 --------------
 tools/virtiofsd/fuse_i.h        | 19 -----------
 tools/virtiofsd/fuse_loop_mt.c  | 56 ---------------------------------
 tools/virtiofsd/fuse_lowlevel.c |  3 +-
 tools/virtiofsd/fuse_lowlevel.h | 20 ------------
 tools/virtiofsd/fuse_virtio.c   |  1 -
 tools/virtiofsd/helper.c        |  3 --
 9 files changed, 1 insertion(+), 164 deletions(-)
 delete mode 100644 tools/virtiofsd/fuse_loop_mt.c

-- 
2.21.1


