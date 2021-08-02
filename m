References: <CAA2ifQwwtNQwChMKUSM=6B+XEtdcf+Y--a0OxSwE2pmnd+6TAg@mail.gmail.com>
	<YQfKtddIodKSx7NZ@work-vm>
	<CAA2ifQxv5VE-w5SUBmKeggAhx7VuCH5MEMttJRrF2ej0_6r8Xw@mail.gmail.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <ee1653e6-dac1-916d-dfd8-3a5271aac79f@redhat.com>
Date: Mon, 2 Aug 2021 12:49:49 +0200
MIME-Version: 1.0
In-Reply-To: <CAA2ifQxv5VE-w5SUBmKeggAhx7VuCH5MEMttJRrF2ej0_6r8Xw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] Deleting files when using NFS as a shared folder
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Gal Hammer <ghammer@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com

On 02.08.21 12:44, Gal Hammer wrote:
>
>
> On Mon, 2 Aug 2021 at 13:36, Dr. David Alan Gilbert 
> <dgilbert@redhat.com <mailto:dgilbert@redhat.com>> wrote:
>
>     * Gal Hammer (ghammer@redhat.com <mailto:ghammer@redhat.com>) wrote:
>     > Hello,
>     >
>     > When using NFS as a shared folder (mount type nfs4) with a Linux
>     guest I
>     > have the following issue:
>     >
>     > Guest:
>     > $ ls -la /mnt/shared
>     > total 8
>     > drwxr-xrwx.  2  135  135 4096 Aug  2 13:08 .
>     > dr-xr-xr-x. 17 root   root    224 May 23 10:58 ..
>     > -rw-r--rw-.  1  135  135   27 Aug  2 13:07 readme.txt
>     >
>     > Host:
>     > $ rm readme.txt
>     >
>     > Guest:
>     > $ ls -la /mnt/shared
>     > total 8
>     > drwxr-xrwx.  2  135  135 4096 Aug  2 13:10 .
>     > dr-xr-xr-x. 17 root   root    224 May 23 10:58 ..
>     > -rw-r--rw-.  1  135  135   27 Aug  2 13:07
>     .nfs0000000001b600d000000005
>     >
>     > Guest:
>     > $ cat /mnt/shared/readme.txt
>     > This is a readme.txt file.
>     >
>     > So it seems that the virtiofsd has a reference to the file which
>     the guest
>     > is not aware of and is unable to send a FUSE_FORGET message.
>     This results
>     > in a file not actually deleted (renamed to .nfsXXX) and is still
>     accessible
>     > by the guest.
>     >
>     > I have a similar problem when deleting a file from a Windows
>     guest side.
>     > The FUSE_READDIR(PLUS) commands add a reference count to files
>     which the OS
>     > doesn't have a file context for. However I was able to solve it
>     (for now?)
>     > by keeping track of returned files' inodes.
>     >
>     > Is this behaviour current and by design?
>
>     Current problem, not really by design; the problem is the O_PATH files
>     that we have open for the inodes.  I thought if the guest sent the
>     forget for the file then it got closed.
>
>
> So if I understand then sending forget message for each inode returned 
> by readdir won't solve the problem because you need the open files for 
> inodes?

virtiofsd internally keeps an lo_inode object for every inode that has 
been looked up at some point, and every such lo_inode contains an O_PATH 
fd referencing that inode.  I don’t know by heart what the conditions 
for dropping those lo_inode objects are.

However, once it’s possible to use file handles to reference inodes 
instead of O_PATH fds (already in virtiofsd-rs, for virtiofsd there’s 
this series: 
https://listman.redhat.com/archives/virtio-fs/2021-July/msg00050.html), 
then giving the appropriate options (-o inode_file_handles -o 
modcaps=+dac_read_search) should result in no O_PATH fds being kept 
around anymore, so that deleting an inode on the host will result in the 
inode being truly deleted (unless the guest still has it open).

But with O_PATH fds, it’s kind of by design, I would say.

Max

