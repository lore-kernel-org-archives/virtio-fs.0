DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
	t=1630597438; bh=CMnoZ/z+WCWqz9q0+OWHxHAsEKwK8gfCAByMzG17zlc=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To;
	b=LL1DeJ4PgBoj42RjYAmPM2HZ8gP2b5YRFxo8kfXnmv1W7/liWY7iS8P8vVuQf7+5k/71nF1AvyMrlnyn0PMkOeAK3ELtsYUeoxxMLYQE0Q34YO4IRffq1y8F1p11qVtM85y+niy6j3cvd7dQuppZUjAPfZLSYLSWJPPb1SnB5Mwcl+r/KUu3QqgjEsGB38ugtk70uJs476ndSba7qKqFQWRufdRr3n9D6eq3B/8sxYRMF9CL8x78Kmqu/VXPmUqK1d7WlSFgJAslgOoJ6F7oAtqdUi5TkKXImqoNf2TAKm/jZM2hG9BlseEcykbkjo2gyE14qvDtN8nf561R8anluA==
References: <20210902152228.665959-1-vgoyal@redhat.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <79dcd300-a441-cdba-e523-324733f892ca@schaufler-ca.com>
Date: Thu, 2 Sep 2021 08:43:50 -0700
MIME-Version: 1.0
In-Reply-To: <20210902152228.665959-1-vgoyal@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v3 0/1] Relax restrictions on user.* xattr
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, viro@zeniv.linux.org.uk
Cc: gscrivan@redhat.com, tytso@mit.edu, agruenba@redhat.com, miklos@szeredi.hu, selinux@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>, stephen.smalley.work@gmail.com, david@fromorbit.com, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, casey.schaufler@intel.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, bfields@redhat.com, christian.brauner@ubuntu.com

On 9/2/2021 8:22 AM, Vivek Goyal wrote:
> Hi,
>
> This is V3 of the patch. Previous versions were posted here.
>
> v2:
> https://lore.kernel.org/linux-fsdevel/20210708175738.360757-1-vgoyal@redhat.com/
> v1:
> https://lore.kernel.org/linux-fsdevel/20210625191229.1752531-1-vgoyal@redhat.co
> +m/
>
> Changes since v2
> ----------------
> - Do not call inode_permission() for special files as file mode bits
>   on these files represent permissions to read/write from/to device
>   and not necessarily permission to read/write xattrs. In this case
>   now user.* extended xattrs can be read/written on special files
>   as long as caller is owner of file or has CAP_FOWNER.
>  
> - Fixed "man xattr". Will post a patch in same thread little later. (J.
>   Bruce Fields)
>
> - Fixed xfstest 062. Changed it to run only on older kernels where
>   user extended xattrs are not allowed on symlinks/special files. Added
>   a new replacement test 648 which does exactly what 062. Just that
>   it is supposed to run on newer kernels where user extended xattrs
>   are allowed on symlinks and special files. Will post patch in 
>   same thread (Ted Ts'o).
>
> Testing
> -------
> - Ran xfstest "./check -g auto" with and without patches and did not
>   notice any new failures.
>
> - Tested setting "user.*" xattr with ext4/xfs/btrfs/overlay/nfs
>   filesystems and it works.
>  
> Description
> ===========
>
> Right now we don't allow setting user.* xattrs on symlinks and special
> files at all. Initially I thought that real reason behind this
> restriction is quota limitations but from last conversation it seemed
> that real reason is that permission bits on symlink and special files
> are special and different from regular files and directories, hence
> this restriction is in place. (I tested with xfs user quota enabled and
> quota restrictions kicked in on symlink).
>
> This version of patch allows reading/writing user.* xattr on symlink and
> special files if caller is owner or priviliged (has CAP_FOWNER) w.r.t inode.

This part of your project makes perfect sense. There's no good
security reason that you shouldn't set user.* xattrs on symlinks
and/or special files.

However, your virtiofs use case is unreasonable.

> Who wants to set user.* xattr on symlink/special files
> -----------------------------------------------------
> I have primarily two users at this point of time.
>
> - virtiofs daemon.
>
> - fuse-overlay. Giuseppe, seems to set user.* xattr attrs on unpriviliged
>   fuse-overlay as well and he ran into similar issue. So fuse-overlay
>   should benefit from this change as well.
>
> Why virtiofsd wants to set user.* xattr on symlink/special files
> ----------------------------------------------------------------
> In virtiofs, actual file server is virtiosd daemon running on host.
> There we have a mode where xattrs can be remapped to something else.
> For example security.selinux can be remapped to
> user.virtiofsd.securit.selinux on the host.

As I have stated before, this introduces a breach in security.
It allows an unprivileged process on the host to manipulate the
security state of the guest. This is horribly wrong. It is not
sufficient to claim that the breach requires misconfiguration
to exploit. Don't do this.

> This remapping is useful when SELinux is enabled in guest and virtiofs
> as being used as rootfs. Guest and host SELinux policy might not match
> and host policy might deny security.selinux xattr setting by guest
> onto host. Or host might have SELinux disabled and in that case to
> be able to set security.selinux xattr, virtiofsd will need to have
> CAP_SYS_ADMIN (which we are trying to avoid).

Adding this mapping to virtiofs provides the breach for any
LSM using xattrs.

>  Being able to remap
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

virtiofs could use security.* or system.* xattrs instead of user.*
xattrs. Don't use user.* xattrs.

>
> Thanks
> Vivek
>
> Vivek Goyal (1):
>   xattr: Allow user.* xattr on symlink and special files
>
>  fs/xattr.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
>


