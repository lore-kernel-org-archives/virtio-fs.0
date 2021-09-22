Date: Wed, 22 Sep 2021 08:30:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YUsh2s/oJhVCLpoL@redhat.com>
References: <20210826211937.317558-1-vgoyal@redhat.com>
	<YUsMwfZI3sQyT/Rj@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUsMwfZI3sQyT/Rj@work-vm>
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: Add capability to block
	xattrs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Wed, Sep 22, 2021 at 12:00:17PM +0100, Dr. David Alan Gilbert wrote:
> * Vivek Goyal (vgoyal@redhat.com) wrote:
> > As of now we have a knob "-o xattr/no_xattr" which either enables
> > all xattrs or disables all xattrs.
> 
> Hi Vivek,
>   Thanks for this.
> 
> > We need something more fine grained where we can selectively disable
> > only certain xattrs (and not all).
> > 
> > For example, in some cases we want to disable "security.selinux"
> > xattr. This is equivalent to virtiofs not supporting security.selinux
> > and guest kernel will fallback to a single label for whole fs
> > (virtiofs_t).
> > 
> > So add an option "-o block_xattr=<list-of-xattrs>" which will allow
> > specifying a list of xattrs to block.
> 
> This is quite interesting; I'd not noticed you had the exisitng blocking
> mechanism,

Yes, that's for blocking posix acl xattrs if needed. If xattr map
support blocking, then we could probably insert an internal rule
to block posix acl xattrs. But that's more of a cleanup exercise
I will take up some other time.

> however, as discussed, I think my preference is if this could
> be done as a modification of the xattrmap it would avoid another set of
> options.
> 
> The mapping code already has 'type's of:
> 
>   prefix, ok, bad
> 
> I think you just need to add a 'reject' type
> that produces the error code you need.

How about "unsupported" and then return -EOPNOTSUPP? 

I am looking at selinux kernel code and it expect -EOPNOTSUPP to decide
that selinux xattr is not supported and looks into fallback options.

static int sb_check_xattr_support(struct super_block *sb)
{
        rc = __vfs_getxattr(root, root_inode, XATTR_NAME_SELINUX, NULL, 0);
        if (rc < 0 && rc != -ENODATA) {
                if (rc == -EOPNOTSUPP) {
                        pr_warn("SELinux: (dev %s, type %s) has no security xattr handler\n",
                                sb->s_id, sb->s_type->name);
                        goto fallback;
...
...
}

Vivek

