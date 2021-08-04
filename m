Date: Wed, 4 Aug 2021 09:35:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YQqXnySk8yLXkAdB@redhat.com>
References: <CAA2ifQwwtNQwChMKUSM=6B+XEtdcf+Y--a0OxSwE2pmnd+6TAg@mail.gmail.com>
	<YQfKtddIodKSx7NZ@work-vm>
	<CAA2ifQxv5VE-w5SUBmKeggAhx7VuCH5MEMttJRrF2ej0_6r8Xw@mail.gmail.com>
	<ee1653e6-dac1-916d-dfd8-3a5271aac79f@redhat.com>
	<CAA2ifQxiTa5nuGc=u00qaeOyXsqpro_gFpjLxpbbHdaoGXYJ-w@mail.gmail.com>
	<854b3e0c-9140-4f9f-93f8-1fe93d061be7@redhat.com>
	<YQhgfZNfgANlrExk@redhat.com>
	<CAA2ifQwfZKOYCHaaqqHxL1FraEwm3mrNqiUfMTwYr4VvDTHUUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA2ifQwfZKOYCHaaqqHxL1FraEwm3mrNqiUfMTwYr4VvDTHUUQ@mail.gmail.com>
Subject: Re: [Virtio-fs] Deleting files when using NFS as a shared folder
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Gal Hammer <ghammer@redhat.com>
Cc: virtio-fs@redhat.com, Max Reitz <mreitz@redhat.com>

On Wed, Aug 04, 2021 at 12:08:38PM +0300, Gal Hammer wrote:

[..]
> > > >     virtiofsd internally keeps an lo_inode object for every inode that
> > > >     has
> > > >     been looked up at some point, and every such lo_inode contains an
> > > >     O_PATH
> > > >     fd referencing that inode.  I don’t know by heart what the
> > conditions
> > > >     for dropping those lo_inode objects are.
> > > >
> > > >
> > > > I think it depends on the guest's forget message.
> > >
> > > Yes, it looks like it.
> > >
> > > >     However, once it’s possible to use file handles to reference inodes
> > > >     instead of O_PATH fds (already in virtiofsd-rs, for virtiofsd
> > there’s
> > > >     this series:
> > > >
> > https://listman.redhat.com/archives/virtio-fs/2021-July/msg00050.html
> > > >     <
> > https://listman.redhat.com/archives/virtio-fs/2021-July/msg00050.html>),
> > > >
> > > >     then giving the appropriate options (-o inode_file_handles -o
> > > >     modcaps=+dac_read_search) should result in no O_PATH fds being kept
> > > >     around anymore, so that deleting an inode on the host will result
> > > >     in the
> > > >     inode being truly deleted (unless the guest still has it open).
> > > >
> > > >
> > > > Will the guest will still need to send forget messages with this new
> > > > feature?
> > >
> > > I don’t think so.  With file handles, FDs should only be opened (and kept
> > > open) when the guest actually opens some file.  (Aside from temporary
> > O_PATH
> > > FDs e.g. during a lookup.)
> >
> > I guess FORGET messages will still have to be sent so that virtiofsd can
> > free lo_inode() and associated data structrues when reference count
> > reaches zero. So FORGET message is more like a dropping guest's reference
> > count on lo_inode.
> >
> 
> I can live with that as long as I won't need to send FORGET messages for
> files that the guest didn't open or create.

FORGET message will need to be sent for every inode looked up by guest. So
you don't have to necessarily open/create the file. Any action (say
readdir), which triggers lookup from guest, will return inode info
and will require a FORGET message to be sent to virtiofsd so that
virtiofsd knows that inode is not being used anymore and it can
free data structures associated with that.

IOW, FORGET message seems to be essential part of FUSE protocol. I 
am not sure what's the problem in sending FORGET message.

Also I am not sure what FORGET message has to do with nfs problem
you are facing.

> 
> 
> >
> > Gal, I think we had discussed this nfs issue in the past. And problem
> > probably is that dentry/inode is cached in guest. And that's why
> > lo_inode is around hence O_PATH fd is around. If you do drop caches
> > in guest, that might lead to removal of this temp file (sync; echo 3 >
> > /proc/sys/vm/drop_caches).
> >
> 
> Even though I wrote the driver and implemented an inodes' cache, I can't be
> sure that Windows or WinFSP (the user-space file system library that I use)
> is having some kind of internal cache. Saying that, the problem that I have
> is that virtiofsd is increasing its own reference count on READDIR when the
> guest doesn't hold a files' context for.

IIUC, it is FUSE_READDIRPLUS (and not FUSE_READDIR) which takes the
reference on inodes of the directory being read, hence requires a
FORGET message. I see that linux guest is adding those inodes to the
inode cache. So when inode is dropped from inode cache, we will end
up sending a FORGET message for that inode.

fuse_lowleve.h also mentions this.

========================
     * In contrast to readdir() (which does not affect the lookup counts),
     * the lookup count of every entry returned by readdirplus(), except "."
     * and "..", is incremented by one.
==================

So if windows guest is using READDIRPLUS, then you will have to send
FORGET messages for every inode returned.

W.r.t caching in windows guest, I have no idea how it works. Linux
does cache inodes in inode cache and these are freed later and FORGET
message sent.

You can try using "cache=none" option in virtiofsd. And that should
tell client to not cache data and metadata and that means client
should send FORGET right away as soon as it is done using inode and
you should not see this nfs temporary file issue.

But if there are issues w.r.t FORGET and proper FORGET messages are
not being sent as needed by protocol, then that's a different issue
in windows client and will need to be fixed.

Thanks
Vivek

