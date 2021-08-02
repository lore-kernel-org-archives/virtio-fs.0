Date: Mon, 2 Aug 2021 17:15:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YQhgfZNfgANlrExk@redhat.com>
References: <CAA2ifQwwtNQwChMKUSM=6B+XEtdcf+Y--a0OxSwE2pmnd+6TAg@mail.gmail.com>
	<YQfKtddIodKSx7NZ@work-vm>
	<CAA2ifQxv5VE-w5SUBmKeggAhx7VuCH5MEMttJRrF2ej0_6r8Xw@mail.gmail.com>
	<ee1653e6-dac1-916d-dfd8-3a5271aac79f@redhat.com>
	<CAA2ifQxiTa5nuGc=u00qaeOyXsqpro_gFpjLxpbbHdaoGXYJ-w@mail.gmail.com>
	<854b3e0c-9140-4f9f-93f8-1fe93d061be7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <854b3e0c-9140-4f9f-93f8-1fe93d061be7@redhat.com>
Subject: Re: [Virtio-fs] Deleting files when using NFS as a shared folder
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: Gal Hammer <ghammer@redhat.com>, virtio-fs@redhat.com

On Mon, Aug 02, 2021 at 06:34:17PM +0200, Max Reitz wrote:
> On 02.08.21 13:30, Gal Hammer wrote:
> > 
> > 
> > On Mon, 2 Aug 2021 at 13:49, Max Reitz <mreitz@redhat.com
> > <mailto:mreitz@redhat.com>> wrote:
> > 
> >     On 02.08.21 12:44, Gal Hammer wrote:
> >     >
> >     >
> >     > On Mon, 2 Aug 2021 at 13:36, Dr. David Alan Gilbert
> >     > <dgilbert@redhat.com <mailto:dgilbert@redhat.com>
> >     <mailto:dgilbert@redhat.com <mailto:dgilbert@redhat.com>>> wrote:
> >     >
> >     >     * Gal Hammer (ghammer@redhat.com <mailto:ghammer@redhat.com>
> >     <mailto:ghammer@redhat.com <mailto:ghammer@redhat.com>>) wrote:
> >     >     > Hello,
> >     >     >
> >     >     > When using NFS as a shared folder (mount type nfs4) with a
> >     Linux
> >     >     guest I
> >     >     > have the following issue:
> >     >     >
> >     >     > Guest:
> >     >     > $ ls -la /mnt/shared
> >     >     > total 8
> >     >     > drwxr-xrwx.  2  135  135 4096 Aug  2 13:08 .
> >     >     > dr-xr-xr-x. 17 root   root    224 May 23 10:58 ..
> >     >     > -rw-r--rw-.  1  135  135   27 Aug  2 13:07 readme.txt
> >     >     >
> >     >     > Host:
> >     >     > $ rm readme.txt
> >     >     >
> >     >     > Guest:
> >     >     > $ ls -la /mnt/shared
> >     >     > total 8
> >     >     > drwxr-xrwx.  2  135  135 4096 Aug  2 13:10 .
> >     >     > dr-xr-xr-x. 17 root   root    224 May 23 10:58 ..
> >     >     > -rw-r--rw-.  1  135  135   27 Aug  2 13:07
> >     >     .nfs0000000001b600d000000005
> >     >     >
> >     >     > Guest:
> >     >     > $ cat /mnt/shared/readme.txt
> >     >     > This is a readme.txt file.
> >     >     >
> >     >     > So it seems that the virtiofsd has a reference to the file
> >     which
> >     >     the guest
> >     >     > is not aware of and is unable to send a FUSE_FORGET message.
> >     >     This results
> >     >     > in a file not actually deleted (renamed to .nfsXXX) and is
> >     still
> >     >     accessible
> >     >     > by the guest.
> >     >     >
> >     >     > I have a similar problem when deleting a file from a Windows
> >     >     guest side.
> >     >     > The FUSE_READDIR(PLUS) commands add a reference count to files
> >     >     which the OS
> >     >     > doesn't have a file context for. However I was able to
> >     solve it
> >     >     (for now?)
> >     >     > by keeping track of returned files' inodes.
> >     >     >
> >     >     > Is this behaviour current and by design?
> >     >
> >     >     Current problem, not really by design; the problem is the
> >     O_PATH files
> >     >     that we have open for the inodes.  I thought if the guest
> >     sent the
> >     >     forget for the file then it got closed.
> >     >
> >     >
> >     > So if I understand then sending forget message for each inode
> >     returned
> >     > by readdir won't solve the problem because you need the open
> >     files for
> >     > inodes?
> > 
> >     virtiofsd internally keeps an lo_inode object for every inode that
> >     has
> >     been looked up at some point, and every such lo_inode contains an
> >     O_PATH
> >     fd referencing that inode.  I don’t know by heart what the conditions
> >     for dropping those lo_inode objects are.
> > 
> > 
> > I think it depends on the guest's forget message.
> 
> Yes, it looks like it.
> 
> >     However, once it’s possible to use file handles to reference inodes
> >     instead of O_PATH fds (already in virtiofsd-rs, for virtiofsd there’s
> >     this series:
> >     https://listman.redhat.com/archives/virtio-fs/2021-July/msg00050.html
> >     <https://listman.redhat.com/archives/virtio-fs/2021-July/msg00050.html>),
> > 
> >     then giving the appropriate options (-o inode_file_handles -o
> >     modcaps=+dac_read_search) should result in no O_PATH fds being kept
> >     around anymore, so that deleting an inode on the host will result
> >     in the
> >     inode being truly deleted (unless the guest still has it open).
> > 
> > 
> > Will the guest will still need to send forget messages with this new
> > feature?
> 
> I don’t think so.  With file handles, FDs should only be opened (and kept
> open) when the guest actually opens some file.  (Aside from temporary O_PATH
> FDs e.g. during a lookup.)

I guess FORGET messages will still have to be sent so that virtiofsd can
free lo_inode() and associated data structrues when reference count
reaches zero. So FORGET message is more like a dropping guest's reference
count on lo_inode.

Gal, I think we had discussed this nfs issue in the past. And problem
probably is that dentry/inode is cached in guest. And that's why
lo_inode is around hence O_PATH fd is around. If you do drop caches
in guest, that might lead to removal of this temp file (sync; echo 3 >
/proc/sys/vm/drop_caches).

Max, interesting point that using file handles should help with this
situation.

Vivek

