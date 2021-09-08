References: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
	<20210817022347.18098-1-jefflexu@linux.alibaba.com>
	<20210817022347.18098-5-jefflexu@linux.alibaba.com>
	<YRwHRmL/jUSqgkIU@work-vm>
	<29627110-e4bf-836f-2343-1faeb36ad4d3@linux.alibaba.com>
	<YR5Xzw02IuVAN94b@work-vm>
	<4494052b-aff1-e2e3-e704-c8743168f62e@linux.alibaba.com>
	<20210824121515.5419d6a7@bahia.lan>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <88041d90-d170-3ae1-903e-2fa32e51027f@linux.alibaba.com>
Date: Wed, 8 Sep 2021 18:34:53 +0800
MIME-Version: 1.0
In-Reply-To: <20210824121515.5419d6a7@bahia.lan>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [virtiofsd PATCH v4 4/4] virtiofsd: support
 per-file DAX in FUSE_LOOKUP
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: miklos@szeredi.hu, virtualization@lists.linux-foundation.org, virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com



On 8/24/21 6:15 PM, Greg Kurz wrote:
> On Fri, 20 Aug 2021 13:03:23 +0800
> JeffleXu <jefflexu@linux.alibaba.com> wrote:
>>
>> Fine. Got it. However the returned fd (opened without O_PATH) is only
>> used for FS_IOC_GETFLAGS/FS_IOC_FSGETXATTR ioctl, while in most cases
>> for special device files, these two ioctls should return -ENOTTY.
>>
> 
> The actual problem is that a FIFO will cause openat() to block until
> the other end of the FIFO is open for writing...

Got it.

> 
>> If it's really a security issue, then lo_inode_open() could be used to
> 
> ... and cause a DoS on virtiofsd. So yes, this is a security issue and
> lo_inode_open() was introduced specifically to handle this.
> 
>> get a temporary fd, i.e., check if it's a special file before opening.
>> After all, FUSE_OPEN also handles in this way. Besides, I can't
>> understand what "race-free way" means.
>>
> 
> "race-free way" means a way that guarantees that file type
> cannot change between the time you check it and the time
> you open it (TOCTOU error). For example, doing a plain stat(),
> checking st_mode and proceeding to open() is wrong : nothing
> prevents the file to be unlinked and replaced by something
> else between stat() and open().
> 
> We avoid that by keeping O_PATH fds around and using
> lo_inode_open() instead of openat().

Thanks for the detailed explanation. Got it.

> 
> In your case, it seems that you should do the checking after
> you have an actual lo_inode for the target file, and pass
> that to lo_should_enable_dax() instead of the parent lo_inode
> and target name.
> 

Yes, that will be more reasonable. Thanks.

-- 
Thanks,
Jeffle

