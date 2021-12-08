Message-ID: <98ec5a66-4809-bf79-5135-2564b53ab95e@linux.alibaba.com>
Date: Wed, 8 Dec 2021 09:36:54 +0800
MIME-Version: 1.0
References: <20211125070530.79602-1-jefflexu@linux.alibaba.com>
	<20211125070530.79602-7-jefflexu@linux.alibaba.com>
	<Ya+FIsGgn4wsYG+4@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
In-Reply-To: <Ya+FIsGgn4wsYG+4@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v8 6/7] fuse: mark inode DONT_CACHE when per
 inode DAX hint changes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, joseph.qi@linux.alibaba.com, miklos@szeredi.hu



On 12/8/21 12:00 AM, Vivek Goyal wrote:
> On Thu, Nov 25, 2021 at 03:05:29PM +0800, Jeffle Xu wrote:
>> When the per inode DAX hint changes while the file is still *opened*, it
>> is quite complicated and maybe fragile to dynamically change the DAX
>> state.
>>
>> Hence mark the inode and corresponding dentries as DONE_CACHE once the
>> per inode DAX hint changes, so that the inode instance will be evicted
>> and freed as soon as possible once the file is closed and the last
>> reference to the inode is put. And then when the file gets reopened next
>> time, the new instantiated inode will reflect the new DAX state.
>>
>> In summary, when the per inode DAX hint changes for an *opened* file, the
>> DAX state of the file won't be updated until this file is closed and
>> reopened later.
> 
> Is this true for cache=always mode as well? If inode continues to be
> cached in guest cache, I am assuming we will not refresh inode attrs
> due to cache=always mode and will not get new DAX state from server.
> 
> IOW, changing DAX state of file is combination of two things.
> 
> A. Client comes to know about it using GETATTR.
> B. Once client knows about updated state, it will take affect when
>    existing inode is released and new inode is instantiated.
> 
> And step A might take time depending on cache mode as well as when
> is GETATTR actually initiated by the client. Its not deterministic
> and can't be guaranteed. Right?
> 

Right.

If it is virtiofsd that determines to *change* the DAX state, then guest
kernel has no way knowing that. If the notify queue is ready, maybe a
notify event can be sent to guest kernel to notify that the DAX state is
to be changed, if it is really needed later.

If it is the user inside guest that changes the DAX state, e.g. by
SETFLAGS ioctl, then we can mark the inode/dentry DONTCACHE following
the SETFLAGS ioctl, though it's not included in this patch.

-- 
Thanks,
Jeffle

