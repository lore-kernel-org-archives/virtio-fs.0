Date: Fri, 3 Sep 2021 14:31:33 +0800
From: Zorro Lang <zlang@redhat.com>
Message-ID: <20210903063133.ld2benxs3vxemgnb@fedora>
References: <20210902152228.665959-1-vgoyal@redhat.com>
	<YTDyE9wVQQBxS77r@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YTDyE9wVQQBxS77r@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH 3/1] xfstests: generic/062: Do not run on
	newer kernels
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: gscrivan@redhat.com, tytso@mit.edu, agruenba@redhat.com, miklos@szeredi.hu, selinux@vger.kernel.org, stephen.smalley.work@gmail.com, david@fromorbit.com, linux-kernel@vger.kernel.org, fstests@vger.kernel.org, virtio-fs@redhat.com, casey.schaufler@intel.com, linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, bfields@redhat.com, christian.brauner@ubuntu.com

On Thu, Sep 02, 2021 at 11:47:31AM -0400, Vivek Goyal wrote:
> 
> xfstests: generic/062: Do not run on newer kernels
> 
> This test has been written with assumption that setting user.* xattrs will
> fail on symlink and special files. When newer kernels support setting
> user.* xattrs on symlink and special files, this test starts failing.
> 
> Found it hard to change test in such a way that it works on both type of
> kernels. Primary problem is 062.out file which hardcodes the output and
> output will be different on old and new kernels.
> 
> So instead, do not run this test if kernel is new and is expected to
> exhibit new behavior. Next patch will create a new test and run that
> test on new kernel.
> 
> IOW, on old kernels run 062 and on new kernels run new test.
> 
> This is a proposed patch. Will need to be fixed if corresponding
> kernel changes are merged upstream.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tests/generic/062 |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> Index: xfstests-dev/tests/generic/062
> ===================================================================
> --- xfstests-dev.orig/tests/generic/062	2021-08-31 15:51:08.160307982 -0400
> +++ xfstests-dev/tests/generic/062	2021-08-31 16:27:41.678307982 -0400
> @@ -55,6 +55,26 @@ _require_attrs
>  _require_symlinks
>  _require_mknod
>  
> +user_xattr_allowed()
> +{
> +	local kernel_version kernel_patchlevel
> +
> +	kernel_version=`uname -r | awk -F. '{print $1}'`
> +	kernel_patchlevel=`uname -r | awk -F. '{print $2}'`
> +
> +	# Kernel version 5.14 onwards allow user xattr on symlink/special files.
> +	[ $kernel_version -lt 5 ] && return 1
> +	[ $kernel_patchlevel -lt 14 ] && return 1
> +	return 0;
> +}

I don't think this's a good way to judge if run or notrun a test. Many downstream
kernels always backport upstream features. I can't say what's the best way to
deal with this thing, I only can provide two optional methods:

1) Add new requre_* helpers to check if current kernel support to set xattr on
symlink and special files, then let this case only run on support/unsupport
condition.

2) Use _link_out_file() to link the .out file to different golden images (refer to
generic/050 etc), according to different feature implementation.

If anyone has a better method, feel free to talk :)

Thanks,
Zorro

> +
> +
> +# Kernel version 5.14 onwards allow user xattr on symlink/special files.
> +# Do not run this test on newer kernels. Instead run the new test
> +# which has been written with the assumption that user.* xattr
> +# will succeed on symlink and special files.
> +user_xattr_allowed && _notrun "Kernel allows user.* xattrs on symlinks and special files. Skipping this test. Run newer test instead."
> +
>  rm -f $tmp.backup1 $tmp.backup2 $seqres.full
>  
>  # real QA test starts here
> 

