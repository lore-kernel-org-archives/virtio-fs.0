Date: Mon, 20 Jul 2020 11:41:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200720154112.GC502563@redhat.com>
References: <20200716144032.GC422759@redhat.com>
	<20200716181828.GE422759@redhat.com>
	<CAJfpegt-v6sjm2WyjXMWkObqLdL6TSAi=rjra4KK5sNy6hhhmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegt-v6sjm2WyjXMWkObqLdL6TSAi=rjra4KK5sNy6hhhmA@mail.gmail.com>
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
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, ganesh.mahalingam@intel.com

On Fri, Jul 17, 2020 at 10:53:07AM +0200, Miklos Szeredi wrote:
> On Thu, Jul 16, 2020 at 8:18 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Thu, Jul 16, 2020 at 10:40:33AM -0400, Vivek Goyal wrote:
> > > Ganesh Mahalingam reported that virtiofs is slow with small direct random
> > > writes when virtiofsd is run with cache=always.
> > >
> > > https://github.com/kata-containers/runtime/issues/2815
> > >
> > > Little debugging showed that that file_remove_privs() is called in cached
> > > write path on every write. And everytime it calls
> > > security_inode_need_killpriv() which results in call to
> > > __vfs_getxattr(XATTR_NAME_CAPS). And this goes to file server to fetch
> > > xattr. This extra round trip for every write slows down writes a lot.
> > >
> > > Normally to avoid paying this penalty on every write, vfs has the
> > > notion of caching this information in inode (S_NOSEC). So vfs
> > > sets S_NOSEC, if filesystem opted for it using super block flag
> > > SB_NOSEC. And S_NOSEC is cleared when setuid/setgid bit is set or
> > > when security xattr is set on inode so that next time a write
> > > happens, we check inode again for clearing setuid/setgid bits as well
> > > clear any security.capability xattr.
> > >
> > > This seems to work well for local file systems but for remote file
> > > systems it is possible that VFS does not have full picture and a
> > > different client sets setuid/setgid bit or security.capability xattr
> > > on file and that means VFS information about S_NOSEC on another client
> > > will be stale. So for remote filesystems SB_NOSEC was disabled by
> > > default.
> > >
> > > commit 9e1f1de02c2275d7172e18dc4e7c2065777611bf
> > > Author: Al Viro <viro@zeniv.linux.org.uk>
> > > Date:   Fri Jun 3 18:24:58 2011 -0400
> > >
> > >     more conservative S_NOSEC handling
> > >
> > > That commit mentioned that these filesystems can still make use of
> > > SB_NOSEC as long as they clear S_NOSEC when they are refreshing inode
> > > attriutes from server.
> > >
> > > So this patch tries to enable SB_NOSEC on fuse (regular fuse as well
> > > as virtiofs). And clear SB_NOSEC when we are refreshing inode attributes.
> > >
> > > We need to clear SB_NOSEC either when inode has setuid/setgid bit set
> > > or security.capability xattr has been set. We have the first piece of
> > > information available in FUSE_GETATTR response. But we don't know if
> > > security.capability has been set on file or not. Question is, do we
> > > really need to know about security.capability. file_remove_privs()
> > > always removes security.capability if a file is being written to. That
> > > means when server writes to file, security.capability should be removed
> > > without guest having to tell anything to it.
> >
> >
> > I am assuming that file server will clear security.capability on host
> > upon WRITE. Is it a fair assumption for all filesystems passthrough
> > virtiofsd might be running?
> 
> AFAICS this needs to be gated through handle_killpriv, and with that
> it can become a generic fuse feature, not just virtiofs:
> 
>  * FUSE_HANDLE_KILLPRIV: fs handles killing suid/sgid/cap on write/chown/trunc

Hi Miklos,

That sounds interesting. I have couple of questions though.

I see in VFS that chown() always kills suid/sgid. While truncate() and
write(), will suid/sgid only if caller does not have CAP_FSETID.

How does this work with FUSE_HANDLE_KILLPRIV. IIUC, file server does not
know if caller has CAP_FSETID or not. That means file server will be
forced to kill suid/sgid on every write and truncate. And that will fail
some of the tests.

For WRITE requests now we do have the notion of setting
FUSE_WRITE_KILL_PRIV flag to tell server explicitly to kill suid/sgid.
Probably we could use that in cached write path as well to figure out
whether to kill suid/sgid or not. But truncate() will still continue
to be an issue.

> 
> Even writeback_cache could be handled by this addition, since we call
> fuse_update_attributes() before generic_file_write_iter() :
> 
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -985,6 +985,7 @@ static int fuse_update_get_attr(struct inode
> *inode, struct file *file,
> 
>         if (sync) {
>                 forget_all_cached_acls(inode);
> +               inode->i_flags &= ~S_NOSEC;

Ok, So I was clearing S_NOSEC only if server reports that file has
suid/sgid bit set. This change will clear S_NOSEC whenever we fetch
attrs from host and will force getxattr() when we call file_remove_privs()
and will increase overhead for non cache writeback mode. We probably
could keep both. For cache writeback mode, clear it undonditionally
otherwise not.

What I don't understand is though that how this change will clear
suid/sgid on host in cache=writeback mode. I see fuse_setattr()
will not set ATTR_MODE and clear S_ISUID and S_ISGID if 
fc->handle_killpriv is set. So when server receives setattr request
(if it does), then how will it know it is supposed to kill suid/sgid
bit. (its not chown, truncate and its not write).

What am I missing.

Thanks
Vivek

>                 err = fuse_do_getattr(inode, stat, file);
>         } else if (stat) {
>                 generic_fillattr(inode, stat);
> 
> 
> Thanks,
> Miklos
> 

