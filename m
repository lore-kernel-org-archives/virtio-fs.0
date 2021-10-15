Date: Fri, 15 Oct 2021 11:07:18 +0200
From: Christian Brauner <christian.brauner@ubuntu.com>
Message-ID: <20211015090718.4xwdnyujw354hnxe@wittgenstein>
References: <YWWMO/ZDrvDZ5X4c@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YWWMO/ZDrvDZ5X4c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v2] security: Return xattr name from
 security_dentry_init_security()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: bfields@fieldses.org, linux-nfs@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, selinux@vger.kernel.org, stephen.smalley.work@gmail.com, jlayton@kernel.org, jmorris@namei.org, anna.schumaker@netapp.com, virtio-fs@redhat.com, casey@schaufler-ca.com, linux-security-module@vger.kernel.org, chuck.lever@oracle.com, linux-fsdevel@vger.kernel.org, idryomov@gmail.com, ceph-devel@vger.kernel.org, trond.myklebust@hammerspace.com, serge@hallyn.com

On Tue, Oct 12, 2021 at 09:23:07AM -0400, Vivek Goyal wrote:
> Right now security_dentry_init_security() only supports single security
> label and is used by SELinux only. There are two users of of this hook,
> namely ceph and nfs.
> 
> NFS does not care about xattr name. Ceph hardcodes the xattr name to
> security.selinux (XATTR_NAME_SELINUX).
> 
> I am making changes to fuse/virtiofs to send security label to virtiofsd
> and I need to send xattr name as well. I also hardcoded the name of
> xattr to security.selinux.
> 
> Stephen Smalley suggested that it probably is a good idea to modify
> security_dentry_init_security() to also return name of xattr so that
> we can avoid this hardcoding in the callers.
> 
> This patch adds a new parameter "const char **xattr_name" to
> security_dentry_init_security() and LSM puts the name of xattr
> too if caller asked for it (xattr_name != NULL).
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> ---

Looks good to me.
Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>

