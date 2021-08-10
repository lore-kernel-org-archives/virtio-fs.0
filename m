References: <20210730150134.216126-1-mreitz@redhat.com>
	<20210730150134.216126-10-mreitz@redhat.com>
	<YRF2xjwSKOiqB/Al@redhat.com>
From: Hanna Reitz <hreitz@redhat.com>
Message-ID: <df64553c-c03d-076a-bcef-bec8554977a4@redhat.com>
Date: Tue, 10 Aug 2021 10:32:55 +0200
MIME-Version: 1.0
In-Reply-To: <YRF2xjwSKOiqB/Al@redhat.com>
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
To: Vivek Goyal <vgoyal@redhat.com>, Max Reitz <mreitz@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On 09.08.21 20:41, Vivek Goyal wrote:
> On Fri, Jul 30, 2021 at 05:01:33PM +0200, Max Reitz wrote:
>> When the inode_file_handles option is set, try to generate a file handle
>> for new inodes instead of opening an O_PATH FD.
>>
>> Being able to open these again will require CAP_DAC_READ_SEARCH, so the
>> description text tells the user they will also need to specify
>> -o modcaps=+dac_read_search.
>>
>> Generating a file handle returns the mount ID it is valid for.  Opening
>> it will require an FD instead.  We have mount_fds to map an ID to an FD.
>> get_file_handle() fills the hash map by opening the file we have
>> generated a handle for.  To verify that the resulting FD indeed
>> represents the handle's mount ID, we use statx().  Therefore, using file
>> handles requires statx() support.
> So opening the file and storing that fd in mount_fds table might be
> a potential problem with inotify work Ioannis is doing.
>
> So say a file foo.txt was opened O_RDONLY and fd stored in mount_fs. Now
> say user unlinks foo.txt. If notifications are enabled, final notification
> will not be generated till this mount_fds fd is closed.
>
> Now question is when will this fd be closed? If it closed at some
> later point and then notification is generated, that will break
> notificaitons.

Currently, it is never closed.

> In fact even O_PATH fd is delaying notifications due to same reason.
> But its not too bad as we close O_PATH fd pretty quickly after
> unlinking. And we were hoping that file handle support will get rid
> of this problem because we will not keep O_PATH fd open.
>
> But, IIUC, mount_fds stuff will make it even worse. I did not see
> the code which removes this fd from mount_fds. So I am not sure what's
> the life time of this fd.

The lifetime is forever.  If we wanted to remove it at some point, we’d 
need to track how many file handles we have open for the given mount fd 
and then remove it from the table once the count reaches 0, so it would 
still be delayed.

I think in practice the first thing that is looked up from some mount 
will probably be the root directory, which cannot be deleted before 
everything else on the mount is gone, so that would work.  We track how 
many handles are there, if the whole mount were to be deleted, I hope 
all lo_inodes are evicted, the count goes to 0, and we can drop the 
mount fd.

I think we can make the assumption that the mount fd is the root 
directory certain by, well, looking into mountinfo...  That would result 
in us always opening the root node of the filesystem, so that first the 
whole filesystem needs to disappear before it can be deleted (and our 
mount fd closed) – which should work, I guess?

It’s a bit tricky because our sandboxing prevents easy access to 
mountinfo, but if that’s the only way...

Hanna

