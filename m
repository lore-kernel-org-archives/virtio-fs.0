References: <20210303182027.GA3793@redhat.com>
	<d205a848-845c-bea0-25bf-a10db1f3fafc@redhat.com>
	<YEENM+SP4TPg6T6M@work-vm>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <d8ddbe5e-e726-b679-8f2d-7af7db354e24@redhat.com>
Date: Thu, 4 Mar 2021 17:58:55 +0100
MIME-Version: 1.0
In-Reply-To: <YEENM+SP4TPg6T6M@work-vm>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] Query about announce_submounts and ro/rw mounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On 04.03.21 17:39, Dr. David Alan Gilbert wrote:
> * Max Reitz (mreitz@redhat.com) wrote:
>> On 03.03.21 19:20, Vivek Goyal wrote:
>>> Hi Max,
>>
>> Hi Vivek,
>>
>>> I was playing with "announce_submounts". I have a read-only bind mounted
>>> mount point in shared directory. Inside guest, when I step into that
>>> directory, I see that a mount point got created but its "rw" and not "ro".
>>>
>>> Is that intentional.
>>
>> No, that isn’t intentional.  I just didn’t think of sharing such information
>> with the guest.
>>
>>> Can we send property of mount also to guest when
>>> notifying guest about mount point.
>>
>> I suppose we can send it (by adding a new flag alongside
>> FUSE_ATTR_SUBMOUNT), and we can make the mount ro by setting the SB_RDONLY
>> flag in fuse_dentry_automount().
>>
>> If we implemented this for RDONLY, are there other flags that we might want
>> to consider as well?  (e.g. nodev etc.)
>>
>> OTOH, I just tested NFS, and it doesn’t pass through the RO flag:
>>
>> [...]
>> /tmp/xfs.img on ~/tmp/test-nfs/mount type xfs (ro,...)
>> [...]
>> 127.0.0.1:~/tmp/test-nfs on /mnt/tmp type nfs4 (rw,...)
>> 127.0.0.1:~/tmp/test-nfs/mount on /mnt/tmp/mount type nfs4 (rw,...)
>>
>> So is it really important or more a matter of style?
> 
> So what happens if you try and write a file in /mnt/tmp/mount ?

Well, the EROFS gets passed through from host to client:

$ LANG=C sudo touch /mnt/tmp/mount/foo
touch: cannot touch '/mnt/tmp/mount/foo': Read-only file system
$ mount
[...]
127.0.0.1:~/tmp/test-nfs on /mnt/tmp type nfs4 (rw,...)
127.0.0.1:~/tmp/test-nfs/mount on /mnt/tmp/mount type nfs4 (rw,...)

(So the submount still appears rw – NFS doesn’t reevaluate when it 
receives EROFS.)


On virtio-fs, it’s the same:

$ LANG=C sudo touch /mnt/mnt1
touch: cannot touch '/mnt/mnt1/foo': Read-only file system
$ mount
[...]
host on /mnt type virtiofs (rw,relatime)
none on /mnt/mnt1 type virtiofs (rw,relatime)

Max

