Date: Mon, 2 Aug 2021 11:36:37 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YQfKtddIodKSx7NZ@work-vm>
References: <CAA2ifQwwtNQwChMKUSM=6B+XEtdcf+Y--a0OxSwE2pmnd+6TAg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAA2ifQwwtNQwChMKUSM=6B+XEtdcf+Y--a0OxSwE2pmnd+6TAg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
Cc: virtio-fs@redhat.com

* Gal Hammer (ghammer@redhat.com) wrote:
> Hello,
> 
> When using NFS as a shared folder (mount type nfs4) with a Linux guest I
> have the following issue:
> 
> Guest:
> $ ls -la /mnt/shared
> total 8
> drwxr-xrwx.  2  135  135 4096 Aug  2 13:08 .
> dr-xr-xr-x. 17 root   root    224 May 23 10:58 ..
> -rw-r--rw-.  1  135  135   27 Aug  2 13:07 readme.txt
> 
> Host:
> $ rm readme.txt
> 
> Guest:
> $ ls -la /mnt/shared
> total 8
> drwxr-xrwx.  2  135  135 4096 Aug  2 13:10 .
> dr-xr-xr-x. 17 root   root    224 May 23 10:58 ..
> -rw-r--rw-.  1  135  135   27 Aug  2 13:07 .nfs0000000001b600d000000005
> 
> Guest:
> $ cat /mnt/shared/readme.txt
> This is a readme.txt file.
> 
> So it seems that the virtiofsd has a reference to the file which the guest
> is not aware of and is unable to send a FUSE_FORGET message. This results
> in a file not actually deleted (renamed to .nfsXXX) and is still accessible
> by the guest.
> 
> I have a similar problem when deleting a file from a Windows guest side.
> The FUSE_READDIR(PLUS) commands add a reference count to files which the OS
> doesn't have a file context for. However I was able to solve it (for now?)
> by keeping track of returned files' inodes.
> 
> Is this behaviour current and by design?

Current problem, not really by design; the problem is the O_PATH files
that we have open for the inodes.  I thought if the guest sent the
forget for the file then it got closed.

Dave


> Thanks,
> 
>     Gal.

> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs

-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

