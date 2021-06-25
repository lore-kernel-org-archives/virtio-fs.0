From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 25 Jun 2021 15:12:28 -0400
Message-Id: <20210625191229.1752531-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC PATCH 0/1] xattr: Allow user.* xattr on
	symlink/special files if caller has CAP_SYS_RESOURCE
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Cc: virtio-fs@redhat.com, berrange@redhat.com, vgoyal@redhat.com

Hi,

In virtiofs, actual file server is virtiosd daemon running on host.
There we have a mode where xattrs can be remapped to something else.
For example security.selinux can be remapped to
user.virtiofsd.securit.selinux on the host.

This remapping is useful when SELinux is enabled in guest and virtiofs
as being used as rootfs. Guest and host SELinux policy might not match
and host policy might deny security.selinux xattr setting by guest
onto host. Or host might have SELinux disabled and in that case to
be able to set security.selinux xattr, virtiofsd will need to have
CAP_SYS_ADMIN (which we are trying to avoid). Being able to remap
guest security.selinux (or other xattrs) on host to something else
is also better from security point of view.

But when we try this, we noticed that SELinux relabeling in guest
is failing on some symlinks. When I debugged a little more, I 
came to know that "user.*" xattrs are not allowed on symlinks
or special files.

"man xattr" seems to suggest that primary reason to disallow is
that arbitrary users can set unlimited amount of "user.*" xattrs
on these files and bypass quota check.

If that's the primary reason, I am wondering is it possible to relax
the restrictions if caller has CAP_SYS_RESOURCE. This capability
allows caller to bypass quota checks. So it should not be
a problem atleast from quota perpective.

That will allow me to give CAP_SYS_RESOURCE to virtiofs deamon
and remap xattrs arbitrarily. 

Thanks
Vivek

Vivek Goyal (1):
  xattr: Allow user.* xattr on symlink/special files with
    CAP_SYS_RESOURCE

 fs/xattr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.25.4

