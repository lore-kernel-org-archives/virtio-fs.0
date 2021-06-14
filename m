From: Vivek Goyal <vgoyal@redhat.com>
Date: Mon, 14 Jun 2021 13:44:52 -0400
Message-Id: <20210614174454.903555-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 0/2] Add support to boot virtiofs and 9pfs as
	rootfs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com
Cc: hch@infradead.org, miklos@szeredi.hu, richard.weinberger@gmail.com, asmadeus@codewreck.org, dhowells@redhat.com, viro@zeniv.linux.org.uk, v9fs-developer@lists.sourceforge.net, vgoyal@redhat.com

Hi,

We want to be able to compile in virtiofs/9pfs in kernel and then
boot kernel and mount virtiofs/9pfs as root filesystem.

Currently there does not seem to be any good way to be able to do
that. There seem to be some hacky ways like prefixing filesystem
tag with "mtd" or naming the filesystem tag as "/dev/root" to
mount viritofs.

Both viritofs and 9pfs have the notion of a "tag" to mount a filesystem
and they take this "tag" as a source argument of the mount. Filesystem
understands how to handle the tag.

Current code already has hooks to mount mtd/ubi/cifs/nfs root
filesystems (apart of regular block based filesystems). So intead
of creating two separate hooks for two filesystems, I have tried
creating a hook for tag based filesystems. And now both the filesystems
benefit from it.

This is generic enough that I think many more use cases might be
able to take advantage of it down the line.

Vivek Goyal (2):
  init/do_mounts.c: Add a path to boot from tag based filesystems
  init/do_mounts.c: Add 9pfs to the list of tag based filesystems

 init/do_mounts.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

-- 
2.25.4

