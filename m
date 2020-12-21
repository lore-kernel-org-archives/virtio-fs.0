References: <599fd4bd-2f62-1ce5-2b9c-0512ee7ead6e@redhat.com>
	<0208dde6-df57-c27a-418f-57cb3c0173f2@redhat.com>
From: Laszlo Ersek <lersek@redhat.com>
Message-ID: <60f161b8-3380-7020-7cbf-7897fcfa0525@redhat.com>
Date: Mon, 21 Dec 2020 13:23:54 +0100
MIME-Version: 1.0
In-Reply-To: <0208dde6-df57-c27a-418f-57cb3c0173f2@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] virtiofsd: sshfs as submount?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>, Miklos Szeredi <mszeredi@redhat.com>
Cc: "=?UTF-8?Q?Daniel_P._Berrang=c3=a9?=" <berrange@redhat.com>, qemu devel list <qemu-devel@nongnu.org>, virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>

On 12/21/20 13:06, Max Reitz wrote:
> On 20.12.20 00:41, Laszlo Ersek wrote:
>> Hi Miklos,
> 
> (I hope it’s OK for me not to be Miklos, even though I don’t have much
> to add)

:)

Thank you, Max!
Laszlo

>> the following 2019 presentation on Stefan's website:
>>
>>    https://vmsplice.net/
>>    virtio-fs: A Shared File System for Virtual Machines at KVM Forum 2019
>>   
>> https://vmsplice.net/~stefan/virtio-fs_%20A%20Shared%20File%20System%20for%20Virtual%20Machines.pdf
>>
>>
>> has a slide called "Use case: File system-as-a-service" (slide#4). It
>> seems to confirm my "grand" idea to expose an sshfs submount to the
>> guest, via virtiofsd. (The guest need not / should not know it's a
>> submount, just see the files.) Beyond the pure utility of this, it feels
>> exciting to chain FUSE to FUSE. :)
>>
>> I've tried it; the FUSE_READDIRPLUS request fails.
>>
>> [2020-12-20 00:32:08.64+0100] [ID: 00000006] unique: 83, opcode:
>> READDIRPLUS (44), nodeid: 1, insize: 80, pid: 1
>> [2020-12-20 00:32:08.64+0100] [ID: 00000006]    unique: 83, error: -13
>> (Permission denied), outsize: 16
>>
>> More precisely, it fails on the directory entry in the containing
>> directory that is the sshfs mount point, when listing the containing
>> directory.
> 
> I see the same.
> 
>> I've skimmed the following thread:
>>
>>    [PATCH] virtiofsd: Show submounts
>>    https://www.redhat.com/archives/virtio-fs/2020-April/msg00023.html
>>
>> (which is now QEMU commit ace0829c0d08), and I vaguely suspect it should
>> work -- the MS_REC flag is present, and the MS_REC flag seems to be so
>> old that I think my host kernel (latest RHEL7) must support it too.
> 
> It works (for me) with other mounts (like XFS or ext4), so submounts
> shouldn’t be the problem.
> 
>> So... does the sshfs filesystem present itself as unshareable? Is it
>> supposed to work? Does it break for others too?
> 
> I can share sshfs through sshfs, so it must be something virtiofs-specific.
> 
> I tried to debug it, but I could only find that the fstatat()/statx() on
> it (FD opened, then stat called with that FD, an empty pathname, and
> AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW) fails with EPERM.  I tried
> disabling all the sandboxing, but still got that error.
> 
> FWIW, I get the same error with virtiofsd-rs (and there, too, the
> fstatat64() yields the EPERM).
> 
> So far, I couldn’t reproduce it outside of virtiofsd, though...  (Like,
> just invoking stat on the command line works; and a simple program that
> opens the mount point FD and then stats it works, too.)
> 
> Max

