Date: Mon, 4 Oct 2021 09:56:59 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YVsIK/I1/Wm7sela@redhat.com>
References: <YVYI/p1ipDFiQ5OR@redhat.com>
	<YVigrS1Bc8J8bO1Y@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVigrS1Bc8J8bO1Y@zeniv-ca.linux.org.uk>
Subject: Re: [Virtio-fs] [PATCH] security: Return xattr name from
 security_dentry_init_security()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: bfields@fieldses.org, linux-nfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, selinux@vger.kernel.org, stephen.smalley.work@gmail.com, jlayton@kernel.org, virtio-fs@redhat.com, casey@schaufler-ca.com, linux-security-module@vger.kernel.org, chuck.lever@oracle.com, linux-fsdevel@vger.kernel.org, idryomov@gmail.com, ceph-devel@vger.kernel.org

On Sat, Oct 02, 2021 at 06:10:53PM +0000, Al Viro wrote:
> On Thu, Sep 30, 2021 at 02:59:10PM -0400, Vivek Goyal wrote:
> > Right now security_dentry_init_security() only supports single security
> > label and is used by SELinux only. There are two users of of this hook,
> > namely ceph and nfs.
> > 
> > NFS does not care about xattr name. Ceph hardcodes the xattr name to
> > security.selinux (XATTR_NAME_SELINUX).
> > 
> > I am making changes to fuse/virtiofs to send security label to virtiofsd
> > and I need to send xattr name as well. I also hardcoded the name of
> > xattr to security.selinux.
> > 
> > Stephen Smalley suggested that it probably is a good idea to modify
> > security_dentry_init_security() to also return name of xattr so that
> > we can avoid this hardcoding in the callers.
> > 
> > This patch adds a new parameter "const char **xattr_name" to
> > security_dentry_init_security() and LSM puts the name of xattr
> > too if caller asked for it (xattr_name != NULL).
> 
> Umm...  Why not return the damn thing on success and ERR_PTR(-E...)
> on failure, instead of breeding extra arguments?

Because of the way generic security hook infrastructure is written. There
seem to be only two kind of hooks. Either they return "int" or "void".
And this assumption is built into other helper functions. For example
call_int_hook() and call_void_hook().

So I think it much easier to just add additional parameter and stick
to existing convention of returning an "int", instead of trying to
return a "const char *".

Thanks
Vivek

