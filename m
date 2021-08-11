References: <20210730150134.216126-1-mreitz@redhat.com>
	<20210730150134.216126-10-mreitz@redhat.com>
	<YRF2xjwSKOiqB/Al@redhat.com>
	<df64553c-c03d-076a-bcef-bec8554977a4@redhat.com>
	<YRKZ415xrDtcYaQR@redhat.com>
	<4a74bbbd-92f6-a7d1-0c8d-fa8b121b9643@redhat.com>
	<YRKh/fbBntF+GfS8@redhat.com>
From: Hanna Reitz <hreitz@redhat.com>
Message-ID: <6e943ee0-dcb3-6812-3a0b-eb2b72b503ad@redhat.com>
Date: Wed, 11 Aug 2021 08:41:18 +0200
MIME-Version: 1.0
In-Reply-To: <YRKh/fbBntF+GfS8@redhat.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH v3 09/10] virtiofsd: Optionally fill
	lo_inode.fhandle
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, Max Reitz <mreitz@redhat.com>

On 10.08.21 17:57, Vivek Goyal wrote:
> On Tue, Aug 10, 2021 at 05:26:15PM +0200, Hanna Reitz wrote:
>> On 10.08.21 17:23, Vivek Goyal wrote:
>>> On Tue, Aug 10, 2021 at 10:32:55AM +0200, Hanna Reitz wrote:
>>>> On 09.08.21 20:41, Vivek Goyal wrote:
>>>>> On Fri, Jul 30, 2021 at 05:01:33PM +0200, Max Reitz wrote:
>>>>>> When the inode_file_handles option is set, try to generate a file handle
>>>>>> for new inodes instead of opening an O_PATH FD.
>>>>>>
>>>>>> Being able to open these again will require CAP_DAC_READ_SEARCH, so the
>>>>>> description text tells the user they will also need to specify
>>>>>> -o modcaps=+dac_read_search.
>>>>>>
>>>>>> Generating a file handle returns the mount ID it is valid for.  Opening
>>>>>> it will require an FD instead.  We have mount_fds to map an ID to an FD.
>>>>>> get_file_handle() fills the hash map by opening the file we have
>>>>>> generated a handle for.  To verify that the resulting FD indeed
>>>>>> represents the handle's mount ID, we use statx().  Therefore, using file
>>>>>> handles requires statx() support.
>>>>> So opening the file and storing that fd in mount_fds table might be
>>>>> a potential problem with inotify work Ioannis is doing.
>>>>>
>>>>> So say a file foo.txt was opened O_RDONLY and fd stored in mount_fs. Now
>>>>> say user unlinks foo.txt. If notifications are enabled, final notification
>>>>> will not be generated till this mount_fds fd is closed.
>>>>>
>>>>> Now question is when will this fd be closed? If it closed at some
>>>>> later point and then notification is generated, that will break
>>>>> notificaitons.
>>>> Currently, it is never closed.
>>>>
>>>>> In fact even O_PATH fd is delaying notifications due to same reason.
>>>>> But its not too bad as we close O_PATH fd pretty quickly after
>>>>> unlinking. And we were hoping that file handle support will get rid
>>>>> of this problem because we will not keep O_PATH fd open.
>>>>>
>>>>> But, IIUC, mount_fds stuff will make it even worse. I did not see
>>>>> the code which removes this fd from mount_fds. So I am not sure what's
>>>>> the life time of this fd.
>>>> The lifetime is forever.  If we wanted to remove it at some point, we’d need
>>>> to track how many file handles we have open for the given mount fd and then
>>>> remove it from the table once the count reaches 0, so it would still be
>>>> delayed.
>>>>
>>>> I think in practice the first thing that is looked up from some mount will
>>>> probably be the root directory, which cannot be deleted before everything
>>>> else on the mount is gone, so that would work.  We track how many handles
>>>> are there, if the whole mount were to be deleted, I hope all lo_inodes are
>>>> evicted, the count goes to 0, and we can drop the mount fd.
>>> Keeping a reference count on mount_fd object make sense. So we probably
>>> maintain this hash table and lookup using mount_id (as you are already
>>> doing). All subsequent inodes from same filesystem will use same
>>> object. Once all inodes have been flushed out, then mount_fd object
>>> should go away as well (allowing for unmount on host).
>>>
>>>> I think we can make the assumption that the mount fd is the root directory
>>>> certain by, well, looking into mountinfo...  That would result in us always
>>>> opening the root node of the filesystem, so that first the whole filesystem
>>>> needs to disappear before it can be deleted (and our mount fd closed) –
>>>> which should work, I guess?
>>> This seems more reasonable. And I think that's what man page seems to
>>> suggest.
>>>
>>>          The  mount_id  argument  returns an identifier for the filesystem mount
>>>          that corresponds to pathname.  This corresponds to the first  field  in
>>>          one  of  the  records in /proc/self/mountinfo.  Opening the pathname in
>>>          the fifth field of that record yields a file descriptor for  the  mount
>>>          point;  that  file  descriptor  can  be  used  in  a subsequent call to
>>>          open_by_handle_at().
>>>
>>> Fifth field seems to be the mount point. man proc says.
>>>
>>>                 (5)  mount  point:  the  pathname of the mount point relative to
>>>                      the process's root directory.
>>>
>>> So opening mount point and saving as mount_fd (if it is not already
>>> in hash table) and then take a per inode reference count on mount_fd
>>> object looks like will solve the life time issue of mount_fd as
>>> well as the issue of temporary failures arising because we can't
>>> open a device special file.
>> Well, we’ve had this discussion before, and it’s possible that a filesystem
>> has a device file as its mount point.
> Yes. I think you did modified fuse to do some special trickery. Not sure
> where should that be fixed.

I used fuse, but I’m sure a non-fuse filesystem can do the same.  (I 
mean, fuse effectively is a non-fuse filesystem, too.)

I don’t think it needs to be fixed, it just means we need to continue to 
stat the mount point to verify it’s a regular file or directory.

> If filesystem is faking, then it can fake a device node as regular
> file and fool us into opening it as well?

Well, of course opening any file can have side effects, on any filesystem.

>> But given the inotify complications, there’s really a good reason we should
>> use mountinfo.
>>
>>>> It’s a bit tricky because our sandboxing prevents easy access to mountinfo,
>>>> but if that’s the only way...
>>> yes. We already have lo->proc_self_fd. Maybe we need to keep
>>> /proc/self/mountinfo open in lo->proc_self_mountinfo. I am assuming
>>> that any mount table changes will still be visible despite the fact
>>> I have fd open (and don't have to open new fd to notice new mount/unmount
>>> changes).
>> Well, yes, that was my idea.  Unfortunately, I wasn’t quite successful yet;
>> when I tried keeping the fd open, reading from it would just return 0
>> bytes.  Perhaps that’s because we bind-mount /proc/self/fd to /proc so that
>> nothing else in /proc is visible. Perhaps we need to bind-mount
>> /proc/self/mountinfo into /proc/self/fd before that...
> Or perhaps open /proc/self/mountinfo and save fd in lo->proc_mountinfo
> before /proc/self/fd is bind mounted on /proc?

Yes, I tried that, and then reading would just return 0 bytes.

Hanna

