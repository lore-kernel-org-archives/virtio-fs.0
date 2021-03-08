Date: Mon, 8 Mar 2021 11:44:49 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YEYOMfPNceP/kCLr@work-vm>
References: <34a26a91-c73d-18cb-95ad-9b2c6192091c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <34a26a91-c73d-18cb-95ad-9b2c6192091c@redhat.com>
Subject: Re: [Virtio-fs] Securing file handles
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

* Max Reitz (mreitz@redhat.com) wrote:
> Hi,
> 
> We want virtio-fs to support persistent file handles.  There’s a
> problem, though: If the guest can give arbitrary file handles for
> virtiofsd to open, it may be able to open host files that are not inside
> of the shared directory.
> 
> I’m aware of two general ways that can solve this problem:
> 
> (1) We can ensure that the guest can only use file handles that
>     virtiofsd has generated, or
> 
> (2) When receiving a file handle from the guest, verify that it resides
>     within the exported directory.

Can we cc in some NFS people?  I'd like to benefit from their pain of
implementing this in the past; especially in their old userspace cases.

Dave

> Implementation-wise, (1) can be done by adding a cryptographic signature
> or rather a message authentication code (MAC) with a secret (persistent)
> key, which is checked before a file handle is used to open a file.
> 
> (2) can be done either by attempting to reconstruct the path that leads
> to the file (and thus checking whether it is under the exported
> directory or not – this is what NFS’s subtree_check option does); or by
> having the exported directory be the root of a mount, so that we can
> check whether file handles (which are bound to a specific mount ID)
> refer to a mount under that directory.  The only practical way to have
> such mounts are bind mounts.
> 
> Let’s look at the various implementations in more detail.
> 
> 
> == Adding a MAC ==
> 
> We can keep a private key in virtiofsd (needs to be persistent, though,
> i.e. stored on the host somewhere), and then for every file handle we
> pass on to the guest, add something like an 8-byte MAC.  When we receive
> a file handle from the guest to open the corresponding file, we can
> verify that the MAC is valid and so that this file handle must have been
> created by a virtiofsd instance in possession of the private key.
> 
> The advantage is that it'll work without any special hacks.
> 
> The disadvantages I can think of are:
> - If a file is moved, it retains its handle.  If it is moved outside of
>   the exported directory, it will remain accessible through the handle.
> 
> - It increases the handle size.  Probably not a real problem, we will
>   most likely have to store some metadata in the handle anyway, and
>   spending eight bytes on the MAC shouldn’t be too bad.
> 
> - It isn’t very elegant.  It is still possible to access file handles
>   outside of the shared directory, you “just” have to guess the MAC.
>   (64 bits of entropy should be enough, but still.)
> 
> 
> == Reconstructing the file path ==
> 
> This is what NFS does with subtree_check.
> 
> There is no way to get a file’s parent.  (One practical reason is that
> files may be hard-linked, so they can have multiple parents.)  So to
> reconstruct a file’s path, you need to store its parent when the handle
> is created (when you usually know its full path).
> 
> For comparison, an NFS file handle (with subtree_check) looks something
> like this:
> 
> 00 00 00 00 85 00 00 00 – NFS file ID (the inode ID), split into low u32
>                           and high u32: 0x85
> 00 80 00 00             – NFS file type: 0x8000 = S_IFREG
> 34 00                   – Length of the embedded file handle: 0x34 bytes
> 01                      – File handle version: 1 (this is always 1)
> 00                      – Auth type: 0 (this is always 0)
> 07                      – FS ID type: 7 = u64 parent inode ID +
>                           16-byte FS UUID
> 82                      – Host FS file handle type: 0x82
>                           = u64 inode ID, u32 generation, u64 parent
>                             inode ID, u32 parent generation
> 84 00 00 00 00 00 00 00 – Parent inode ID: 0x84
> xx xx xx xx xx xx xx xx
> xx xx xx xx xx xx xx xx – Host FS UUID
> [The actual XFS file handle begins here]
> 85 00 00 00 00 00 00 00 – Inode ID: 0x85
> 48 95 e1 8c             – Generation: 0x8ce19548
> 84 00 00 00 00 00 00 00 – Parent inode ID: 0x84
> b4 6a 36 92             – Parent generation: 0x92366ab4
> 
> (The NFS file ID is equal to the inode ID, and the parent inode ID
> before the XFS handle is equal to the parent inode ID within.)
> 
> When opening this file handle, the kernel tries to make a connected
> path, i.e. it tries to obtain the file’s path back to a VFS entry that
> is already connected (at the worst back to the FS root).  For
> directories, you can just obtain the parent, so this is easy.  For
> files, not so much.
> 
> What happens for files is this: The parent is opened based on the parent
> information in the handle, and then the kernel (generally) iterates
> through that directory to find the file.  If it doesn’t find it, that’s
> an error[1].  If it’s found, the parent is indeed a parent of the file,
> and we can go up the path to the FS root just like normal.
> 
> [1] This is contrary to what I said in the virtio-fs call on Wednesday.
>     I said you could just replace the inode ID and generation by some
>     other file on the same file system (regardless of where it is
>     located), and NFS would open it for you.  Indeed, I can see that
>     behavior on my normal system; but in a guest, where I could debug
>     it, such file handles are not accepted.
> 
> I think we could emulate the same behavior in virtiofsd in user-space.
> While there are some special functions only available in the kernel to
> generate file handles that contain parent information, and to get a
> directory’s parent, we should be able to emulate the same in user-space:
> 
> - File handles that include parent information are generally just two
>   file handles squished together.  File handles of type 0x81 are
>   “u64 inode ID + u32 generation”, and file handles of type 0x82 are two
>   0x81 file handles concatenated (one for the file, one for the parent).
>   We can just generate a file handle for the parent and glue it together
>   with the actual file handle, we don’t need special filesystem support
>   for that.
> 
> - To go to a directory’s parent, you can statat(dirfd, "..") or
>   openat(dirfd, "..").
> 
> The advantage of this approach is that I feel it’s kind of elegant,
> because it really checks the path when the file handle is to be opened.
> This allows us to safely handled files moved around, because the parent
> information will become noticeably stale.  (Though if you move a file
> into some other directory under the shared directory, the file handle
> will stop to work, which may be considered a problem.)
> 
> I see two disadvantages:
> - Iterating the parent to find the file to verify that it is indeed the
>   current parent of the file is kind of not nice.  But it is what NFS
>   does with subtree_check, so...
> 
> - NFS no longer has subtree_check as the default.  The man page says
>   “subtree_checking tends to cause more problems than it is worth.”  As
>   far as I could find out, that’s precisely because renaming/moving a
>   file will invalidate its handle.
> 
> 
> == Constricting files to bind mounts ==
> 
> With no_subtree_check being the default for NFS nowadays, users are
> encouraged to use a bind mount as the root of an NFS export.
> Incidentally, AFAIU, virtiofsd and virtiofsd-rs do the same on their own
> already, so this might seem like the natural solution for us, too.
> (Spoiler: I don’t think it is, though.)
> 
> File handles are characterized by the following (meta)data:
> (1) The mount to which they belong[2],
> (2) An FS-specific file handle type,
> (3) The file handle itself.
> 
> [2] When you generate a handle (name_to_handle_at()), you receive the
>     respective mount ID.  When you open a file handle
>     (open_by_handle_at()), you have to specify any FD to any entry in
>     the respective mount.
> 
> So it may seem like a file handle would be bound to a specific mount: If
> you open a file handle on a bind mount, it will only allow you to open
> files that are inside of that bind mount.
> 
> But that’s not what happens.  A bind mount is not actually different
> from the original file system, so all handle operations operate on that
> original FS.  That means (if you have the respective handle) you can
> open all files that reside on the original FS.  Bind mounts do not
> restrict that.
> 
> So, from a security standpoint, I don’t see how bind mounts would
> restrict accessing file handles.  (And, in fact, when I let virtiofsd-rs
> basically just pass through file handles, the guest can open any file
> handle on the file system the exported directory is on.)
> 
> So while at the first glance perhaps the obvious solution, I don’t think
> they can help us for file handles.
> 
> 
> == Summary ==
> 
> So, my current position is:
> 
> - Bind mounts don’t help with restricting file handles to the exported
>   directory.
> 
> - A MAC is not very elegant, and we might encounter problems where a
>   file may be moved outside of the shared directory, but remains
>   accessible (because moving a file doesn’t change its handle).
>   (If we consider that a problem.  NFS evidently doesn’t, because
>   without subtree_check, it has absolutely no protection against
>   arbitrary file handles being opened (on the FS where the export
>   resides), so valid file handles always remain valid.)
> 
> - A solution such as NFS’s subtree_check (i.e., storing the file’s
>   parent’s handle in addition to the file’s handle itself, then
>   verifying that the file does still reside in that directory when the
>   handle is opened, and then going up the tree to see whether we can
>   trace it back to the shared directory) is interesting and can perhaps
>   be considered elegant, but it requires iterating the directory the
>   file resides in when it is opened, and it will result in file handles
>   being invalidated whenever a file is moved (outside of its directory).
>   Perhaps also other issues.  In any case, there are reasons why NFS has
>   basically deprecated this.
> 
> Opinions? :)
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

