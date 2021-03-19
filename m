DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc:content-transfer-encoding;
	bh=F2Te/S8IQN8II87+ruJB6/OZWiTMllLjsdgUQ032A7E=;
	b=iYXj549E1TSXlKplraY6a7uriF3jJn340mEeSfahFmXK2DIwCKLLNAgXEBIiSVkdAl
	zB0tQV4s8N4o/AQJLXCbZSjZlbCWI64Ak2QzRXZVLmNg4VduOFCvh0BfANlonz1raaY6
	y5xo+5mFR0uc5XlfHV5+e06GJuIH997vcwgFkEwgbxylsITLzkRno8RBXinuQK2tYlAT
	wbf5oWuKuC41lkBgWlC4M6MKH5BqzSp+DpGP2oaWVdlEP0iu2cfYi0jeguz5dLYrs1Hy
	Cv7fr6DfrlDDqyRbV/UXRvdSR0uPU6WY2SeldO6kkgTtaDaXi6+gpCX2X/c/FvDL2bjl
	liaA==
MIME-Version: 1.0
References: <20210319195547.427371-1-vgoyal@redhat.com>
	<20210319195547.427371-2-vgoyal@redhat.com>
In-Reply-To: <20210319195547.427371-2-vgoyal@redhat.com>
From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date: Fri, 19 Mar 2021 23:42:48 +0100
Message-ID: <CAHpGcMKhFxotKDxPryfKdhNMMDWO4Ws33s6fEm2NP0u_4vffnQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 1/3] posic_acl: Add a helper determine if
	SGID should be cleared
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, virtio-fs@redhat.com, Seth Forshee <seth.forshee@canonical.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>

Hi,

Am Fr., 19. März 2021 um 20:58 Uhr schrieb Vivek Goyal <vgoyal@redhat.com>:
> posix_acl_update_mode() determines what's the equivalent mode and if SGID
> needs to be cleared or not. I need to make use of this code in fuse
> as well. Fuse will send this information to virtiofs file server and
> file server will take care of clearing SGID if it needs to be done.
>
> Hence move this code in a separate helper so that more than one place
> can call into it.
>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Andreas Gruenbacher <agruenba@redhat.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/posix_acl.c            |  3 +--
>  include/linux/posix_acl.h | 11 +++++++++++
>  2 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/fs/posix_acl.c b/fs/posix_acl.c
> index f3309a7edb49..2d62494c4a5b 100644
> --- a/fs/posix_acl.c
> +++ b/fs/posix_acl.c
> @@ -684,8 +684,7 @@ int posix_acl_update_mode(struct user_namespace *mnt_userns,
>                 return error;
>         if (error == 0)
>                 *acl = NULL;
> -       if (!in_group_p(i_gid_into_mnt(mnt_userns, inode)) &&
> -           !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
> +       if (posix_acl_mode_clear_sgid(mnt_userns, inode))
>                 mode &= ~S_ISGID;
>         *mode_p = mode;
>         return 0;
> diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
> index 307094ebb88c..073c5e546de3 100644
> --- a/include/linux/posix_acl.h
> +++ b/include/linux/posix_acl.h
> @@ -59,6 +59,17 @@ posix_acl_release(struct posix_acl *acl)
>  }
>
>
> +static inline bool
> +posix_acl_mode_clear_sgid(struct user_namespace *mnt_userns,
> +                         struct inode *inode)
> +{
> +       if (!in_group_p(i_gid_into_mnt(mnt_userns, inode)) &&
> +           !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
> +               return true;
> +
> +       return false;

That's just

return !in_group_p(i_gid_into_mnt(mnt_userns, inode)) &&
    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID);

The same pattern we have in posix_acl_update_mode also exists in
setattr_copy and inode_init_owner, and almost the same pattern exists
in setattr_prepare, so can this be cleaned up as well? The function
also isn't POSIX ACL specific, so the function name is misleading.

> +}
> +
>  /* posix_acl.c */
>
>  extern void posix_acl_init(struct posix_acl *, int);
> --
> 2.25.4

Thanks,
Andreas


