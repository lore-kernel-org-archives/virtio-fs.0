Date: Mon, 28 Jun 2021 11:00:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210628150020.GD1803896@redhat.com>
References: <20210625191229.1752531-1-vgoyal@redhat.com>
	<20210625191229.1752531-2-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210625191229.1752531-2-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 1/1] xattr: Allow user.* xattr on
 symlink/special files with CAP_SYS_RESOURCE
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Cc: virtio-fs@redhat.com, oliver.sang@intel.com, berrange@redhat.com

On Fri, Jun 25, 2021 at 03:12:29PM -0400, Vivek Goyal wrote:
> As of now user.* xattrs are allowed only on regular files and directories.
> And in case of directories if sticky bit is set, then it is allowed
> only if caller is owner or has CAP_FOWNER.
> 
> "man xattr" suggests that primary reason behind this restrcition is that
> users can set unlimited amount of "user.*" xattrs on symlinks and special
> files and bypass quota checks. Following is from man page.
> 
> "These differences would allow users to consume filesystem resources  in
>  a  way not controllable by disk quotas for group or world writable spe‐
>  cial files and directories"
> 
> Capability CAP_SYS_RESOURCE allows for overriding disk quota limits. If
> being able to bypass quota is primary reason behind these restrictions,
> can we relax these restrictions if caller has CAP_SYS_RESOURCE.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Got an email from intel kernel test robot that xfstest generic/062 breaks
due to this change.

I think I will have to fix the test case because test is working with
previous behvior where "user.*" xattr will not be permitted on
non-regular/non-dir file. 

Thanks
Vivek

> ---
>  fs/xattr.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 5c8c5175b385..10bb918029dd 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -124,7 +124,8 @@ xattr_permission(struct user_namespace *mnt_userns, struct inode *inode,
>  	 * extended attributes. For sticky directories, only the owner and
>  	 * privileged users can write attributes.
>  	 */
> -	if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)) {
> +	if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) &&
> +	    !capable(CAP_SYS_RESOURCE)) {
>  		if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
>  			return (mask & MAY_WRITE) ? -EPERM : -ENODATA;
>  		if (S_ISDIR(inode->i_mode) && (inode->i_mode & S_ISVTX) &&
> -- 
> 2.25.4
> 

