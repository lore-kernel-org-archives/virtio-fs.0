Date: Mon, 28 Jun 2021 14:33:33 +0200
From: Christian Brauner <christian.brauner@ubuntu.com>
Message-ID: <20210628123333.4lueag2a5uhdsfor@wittgenstein>
References: <20210625191229.1752531-1-vgoyal@redhat.com>
	<20210625191229.1752531-2-vgoyal@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210625191229.1752531-2-vgoyal@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: berrange@redhat.com, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org

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
> ---

I think this change is fine especially since it seems to solve a real
problem there since it prevents relabeling for virtiofsd.

