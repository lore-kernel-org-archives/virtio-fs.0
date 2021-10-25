Date: Mon, 25 Oct 2021 11:55:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YXbTeb3G810yo216@redhat.com>
References: <20211012180624.447474-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012180624.447474-1-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 0/2] fuse: Send file/inode security
 context during creation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: miklos@szeredi.hu
Cc: stephen.smalley.work@gmail.com, omosnace@redhat.com, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, casey@schaufler-ca.com, selinux@vger.kernel.org

On Tue, Oct 12, 2021 at 02:06:22PM -0400, Vivek Goyal wrote:
> Hi,
> 
> This is V2 of patches. Posted V1 here.

Hi Miklos,

Wondering how do these patches look to you. Can you please consider these
for inclusion.

These patches are dependent on following patch which Paul Moore is now
carrying in this tree.

https://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/selinux.git/commit/?h=next&id=15bf32398ad488c0df1cbaf16431422c87e4feea

Thanks
Vivek
> 
> https://lore.kernel.org/linux-fsdevel/20210924192442.916927-1-vgoyal@redhat.com/
> 
> Changes since v1:
> 
> - Added capability to send multiple security contexts in fuse protocol.
>   Miklos suggestd this. So now protocol can easily carry multiple
>   security labels. Just that right now we only send one. When a security
>   hook becomes available which can handle multiple security labels,
>   it should be easy to send those.
> 
> This patch series is dependent on following patch I have posted to
> change signature of security_dentry_init_security().
> 
> https://lore.kernel.org/linux-fsdevel/YWWMO%2FZDrvDZ5X4c@redhat.com/
> 
> Description
> -----------
> When a file is created (create, mknod, mkdir, symlink), typically file
> systems call  security_inode_init_security() to initialize security
> context of an inode. But this does not very well with remote filesystems
> as inode is not there yet. Client will send a creation request to
> server and once server has created the file, client will instantiate
> the inode.
> 
> So filesystems like nfs and ceph use security_dentry_init_security()
> instead. This takes in a dentry and returns the security context of
> file if any.
> 
> These patches call security_dentry_init_security() and send security
> label of file along with creation request (FUSE_CREATE, FUSE_MKDIR,
> FUSE_MKNOD, FUSE_SYMLINK). This will give server an opportunity
> to create new file and also set security label (possibly atomically
> where possible).
> 
> These patches are based on the work Chirantan Ekbote did some time
> back but it never got upstreamed. So I have taken his patches,
> and made modifications on top.
> 
> https://listman.redhat.com/archives/virtio-fs/2020-July/msg00014.html
> https://listman.redhat.com/archives/virtio-fs/2020-July/msg00015.html
> 
> These patches will allow us to support SELinux on virtiofs.
> 
> Vivek Goyal (2):
>   fuse: Add a flag FUSE_SECURITY_CTX
>   fuse: Send security context of inode on file creation
> 
>  fs/fuse/dir.c             | 115 ++++++++++++++++++++++++++++++++++++--
>  fs/fuse/fuse_i.h          |   3 +
>  fs/fuse/inode.c           |   4 +-
>  include/uapi/linux/fuse.h |  29 +++++++++-
>  4 files changed, 144 insertions(+), 7 deletions(-)
> 
> -- 
> 2.31.1
> 

