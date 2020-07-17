DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=sepW1MS/244yRuMm//K9S5ChlKO04q+uSw0y80a65rg=;
	b=KSBnq8ckwuIMY+eOle/raGsanI1xcfX9Dr9CLYQjGVzmnmkRKA2AcTO3SsX7ymuFxZ
	n9Tu0GRWZESNQZMvqoqrFfYHkOtw9fBReJAD6p5pTIUDf8DFzM8sJZ+13xqAnR8UWL86
	7w5tPz3/LRnPHJZlGL2jvW6ioBgzbmHZIAInc=
MIME-Version: 1.0
References: <20200716144032.GC422759@redhat.com>
	<20200716181828.GE422759@redhat.com>
In-Reply-To: <20200716181828.GE422759@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 17 Jul 2020 10:53:07 +0200
Message-ID: <CAJfpegt-v6sjm2WyjXMWkObqLdL6TSAi=rjra4KK5sNy6hhhmA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] virtiofs: Enable SB_NOSEC flag to improve
	small write performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, ganesh.mahalingam@intel.com

On Thu, Jul 16, 2020 at 8:18 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Thu, Jul 16, 2020 at 10:40:33AM -0400, Vivek Goyal wrote:
> > Ganesh Mahalingam reported that virtiofs is slow with small direct random
> > writes when virtiofsd is run with cache=always.
> >
> > https://github.com/kata-containers/runtime/issues/2815
> >
> > Little debugging showed that that file_remove_privs() is called in cached
> > write path on every write. And everytime it calls
> > security_inode_need_killpriv() which results in call to
> > __vfs_getxattr(XATTR_NAME_CAPS). And this goes to file server to fetch
> > xattr. This extra round trip for every write slows down writes a lot.
> >
> > Normally to avoid paying this penalty on every write, vfs has the
> > notion of caching this information in inode (S_NOSEC). So vfs
> > sets S_NOSEC, if filesystem opted for it using super block flag
> > SB_NOSEC. And S_NOSEC is cleared when setuid/setgid bit is set or
> > when security xattr is set on inode so that next time a write
> > happens, we check inode again for clearing setuid/setgid bits as well
> > clear any security.capability xattr.
> >
> > This seems to work well for local file systems but for remote file
> > systems it is possible that VFS does not have full picture and a
> > different client sets setuid/setgid bit or security.capability xattr
> > on file and that means VFS information about S_NOSEC on another client
> > will be stale. So for remote filesystems SB_NOSEC was disabled by
> > default.
> >
> > commit 9e1f1de02c2275d7172e18dc4e7c2065777611bf
> > Author: Al Viro <viro@zeniv.linux.org.uk>
> > Date:   Fri Jun 3 18:24:58 2011 -0400
> >
> >     more conservative S_NOSEC handling
> >
> > That commit mentioned that these filesystems can still make use of
> > SB_NOSEC as long as they clear S_NOSEC when they are refreshing inode
> > attriutes from server.
> >
> > So this patch tries to enable SB_NOSEC on fuse (regular fuse as well
> > as virtiofs). And clear SB_NOSEC when we are refreshing inode attributes.
> >
> > We need to clear SB_NOSEC either when inode has setuid/setgid bit set
> > or security.capability xattr has been set. We have the first piece of
> > information available in FUSE_GETATTR response. But we don't know if
> > security.capability has been set on file or not. Question is, do we
> > really need to know about security.capability. file_remove_privs()
> > always removes security.capability if a file is being written to. That
> > means when server writes to file, security.capability should be removed
> > without guest having to tell anything to it.
>
>
> I am assuming that file server will clear security.capability on host
> upon WRITE. Is it a fair assumption for all filesystems passthrough
> virtiofsd might be running?

AFAICS this needs to be gated through handle_killpriv, and with that
it can become a generic fuse feature, not just virtiofs:

 * FUSE_HANDLE_KILLPRIV: fs handles killing suid/sgid/cap on write/chown/trunc

Even writeback_cache could be handled by this addition, since we call
fuse_update_attributes() before generic_file_write_iter() :

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -985,6 +985,7 @@ static int fuse_update_get_attr(struct inode
*inode, struct file *file,

        if (sync) {
                forget_all_cached_acls(inode);
+               inode->i_flags &= ~S_NOSEC;
                err = fuse_do_getattr(inode, stat, file);
        } else if (stat) {
                generic_fillattr(inode, stat);


Thanks,
Miklos

