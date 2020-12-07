Date: Mon, 7 Dec 2020 15:28:19 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201207202819.GC3107@redhat.com>
References: <f0944d13-19d4-d4c2-8e38-be96cfba84a1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0944d13-19d4-d4c2-8e38-be96cfba84a1@redhat.com>
Subject: Re: [Virtio-fs] bug in lo_do_readdir()?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Laszlo Ersek <lersek@redhat.com>
Cc: virtio-fs@redhat.com

On Mon, Dec 07, 2020 at 06:32:26PM +0100, Laszlo Ersek wrote:
> Hi,
> 
> I believe lo_do_readdir() has a bug: for FUSE_READDIR (not
> FUSE_READDIRPLUS), it does not call lo_do_lookup() -- which seems fine
> in itself --, but then it doesn't load the inode into the inode map (?)
> *at all*.
> 
> A subsequent FUSE_GETATTR that refers to one of the inode(s) learned via
> FUSE_READDIR (not FUSE_READDIRPLUS) gets -EBADF, because the requested
> inode is not in the map.
> 
> Because the inode is shared with the client through the normal (not
> "plus") dirent format too (that is, via FUSE_READDIR and not
> FUSE_READDIRPLUS), the server should remember the inode(s) from the
> FUSE_READDIR request as well, in my opinion.
> 

tools/virtiofsd/fuse_lowlevel.h documents that readdir() does not
affect lookup count.

     * Returning a directory entry from readdir() does not affect
     * its lookup count.

While, readdirplus() does change it.

     * In contrast to readdir() (which does not affect the lookup counts),
     * the lookup count of every entry returned by readdirplus(), except "."
     * and "..", is incremented by one.


Thanks
Vivek

> Sorry if I'm mistaken.
> 
> The reason I'm not using FUSE_READDIRPLUS is three-fold:
> 
> - one fewer wrapper to implement (I need FUSE_READ anyway, for reading
> regular files, and FUSE_READDIR is identical, except for the opcode,
> while FUSE_READDIRPLUS isn't),
> 
> - FUSE_READDIRPLUS requires feature negotiation, while FUSE_READDIR
> doesn't, as far as I understand,
> 
> - performance for the firmware is not critical, so I'm fine calling a
> separate FUSE_GETATTR on each inode learned through FUSE_READDIR -- I
> don't need the attributes to come back together with the dirent.
> 
> Unfortunately, I'm not familiar enough with the virtiofsd internals at
> this point to propose a patch. It feels like adding a lookup-like, but
> lighter-weight, call, to the non-plus branch in lo_do_readdir(), should
> do the trick.
> 
> Thanks!
> Laszlo
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

