References: <20210708175738.360757-1-vgoyal@redhat.com>
From: Daniel Walsh <dwalsh@redhat.com>
Message-ID: <76d4a0ed-7582-cc73-a447-5f2d133c3c24@redhat.com>
Date: Fri, 9 Jul 2021 12:00:07 -0400
MIME-Version: 1.0
In-Reply-To: <20210708175738.360757-1-vgoyal@redhat.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [RFC PATCH v2 0/1] Relax restrictions on user.*
	xattr
Reply-To: dwalsh@redhat.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Cc: gscrivan@redhat.com, tytso@mit.edu, miklos@szeredi.hu, selinux@vger.kernel.org, virtio-fs@redhat.com, linux-security-module@vger.kernel.org, casey.schaufler@intel.com, jack@suse.cz, christian.brauner@ubuntu.com

On 7/8/21 13:57, Vivek Goyal wrote:
> Hi,
>
> This is V2 of the patch. Posted V1 here.
>
> https://lore.kernel.org/linux-fsdevel/20210625191229.1752531-1-vgoyal@redhat.com/
>
> Right now we don't allow setting user.* xattrs on symlinks and special
> files at all. Initially I thought that real reason behind this
> restriction is quota limitations but from last conversation it seemed
> that real reason is that permission bits on symlink and special files
> are special and different from regular files and directories, hence
> this restriction is in place.
>
> Given it probably is not a quota issue (I tested with xfs user quota
> enabled and quota restrictions kicked in on symlink), I dropped the
> idea of allowing user.* xattr if process has CAP_SYS_RESOURCE.
>
> Instead this version of patch allows reading/writing user.* xattr
> on symlink and special files if caller is owner or priviliged (has
> CAP_FOWNER) w.r.t inode.
>
> We need this for virtiofs daemon. I also found one more user. Giuseppe,
> seems to set user.* xattr attrs on unpriviliged fuse-overlay as well
> and he ran into similar issue. So fuse-overlay should benefit from
> this change as well.
>
> Who wants to set user.* xattr on symlink/special files
> -----------------------------------------------------
>
> In virtiofs, actual file server is virtiosd daemon running on host.
> There we have a mode where xattrs can be remapped to something else.
> For example security.selinux can be remapped to
> user.virtiofsd.securit.selinux on the host.
>
> This remapping is useful when SELinux is enabled in guest and virtiofs
> as being used as rootfs. Guest and host SELinux policy might not match
> and host policy might deny security.selinux xattr setting by guest
> onto host. Or host might have SELinux disabled and in that case to
> be able to set security.selinux xattr, virtiofsd will need to have
> CAP_SYS_ADMIN (which we are trying to avoid). Being able to remap
> guest security.selinux (or other xattrs) on host to something else
> is also better from security point of view.
>
> But when we try this, we noticed that SELinux relabeling in guest
> is failing on some symlinks. When I debugged a little more, I
> came to know that "user.*" xattrs are not allowed on symlinks
> or special files.
>
> So if we allow owner (or CAP_FOWNER) to set user.* xattr, it will
> allow virtiofs to arbitrarily remap guests's xattrs to something
> else on host and that solves this SELinux issue nicely and provides
> two SELinux policies (host and guest) to co-exist nicely without
> interfering with each other.
>
> Thanks
> Vivek
>
>
> Vivek Goyal (1):
>    xattr: Allow user.* xattr on symlink and special files
>
>   fs/xattr.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
>
I just wanted to point out that the work Giuseppe is doing is to support 
nfs homedirs with container runtimes like Rootless Podman.


Basically fuse-overlayfs on top of NFS homedir needs to be able to use 
user xattrs to set file permissions and ownership fields to be 
represented to containers.

Currently NFS Servers do not understand User Namespace and seeing a 
client user attempting to chown to a different user, is blocked on the 
server, even though user namespace on the client allows it.  
fuse-overlay intercepts the chown from the container and writes out the 
user.Xattr the permissions and owner/group as user.Xattrs.  And all the 
server sees is the user modifying the xattrs now chowning the real UID 
of the file.


