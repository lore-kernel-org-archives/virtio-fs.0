References: <1565636335-120345-1-git-send-email-bo.liu@linux.alibaba.com>
	<f48e0d71-d633-79a6-8b17-94ae9274ff6f@huawei.com>
	<20190813182438.sbkpt4ps62iwzrbg@US-160370MP2.local>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D5355FB.4000801@huawei.com>
Date: Wed, 14 Aug 2019 08:29:47 +0800
MIME-Version: 1.0
In-Reply-To: <20190813182438.sbkpt4ps62iwzrbg@US-160370MP2.local>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 1/2] Virtio-fs: fix hang due to ENOSPC in
 shared backend fs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: bo.liu@linux.alibaba.com
Cc: virtio-fs@redhat.com



On 2019/8/14 2:24, Liu Bo wrote:
> On Tue, Aug 13, 2019 at 11:41:23PM +0800, piaojun wrote:
>> Hi Bo,
>>
>> On 2019/8/13 2:58, Liu Bo wrote:
>>> Currently fuse/virtio-fs de-allocation doesn't clean up dax mapping range,
>>> which may result in hang problems when the shared backend fs experiences
>>> "NO Space Error".
>>>
>>> The root cause is that the first writing to a dax mapping range triggers a
>>> WRITE page fault on host side, which calls ->page_mkwrite() where block
>>> allocation is required, if the fs is already full, ->page_mkwrite() returns
>>> error so that page fault fails, however, for kvm is not able to propogate
>>> errors while handling EPT_VIOLATION, thus guest keeps trying to resolve the
>>> fault.
>>>
>>> Fortunately, we can fix/work around the problem by dropping dax mapping
>>> range for de-allocation operations.
>>>
>>> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
>>> ---
>>>  fs/fuse/dir.c    | 3 +++
>>>  fs/fuse/file.c   | 9 +++++++--
>>>  fs/fuse/fuse_i.h | 2 +-
>>>  fs/fuse/inode.c  | 2 +-
>>>  4 files changed, 12 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
>>> index ed740a5..99a218c 100644
>>> --- a/fs/fuse/dir.c
>>> +++ b/fs/fuse/dir.c
>>> @@ -1805,6 +1805,9 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
>>>  
>>>  		truncate_pagecache(inode, outarg.attr.size);
>>>  		invalidate_inode_pages2(inode->i_mapping);
>>> +		if (IS_DAX(inode) && oldsize > outarg.attr.size)
>>> +			fuse_cleanup_inode_mappings(inode, outarg.attr.size,
>>> +						    (loff_t)-1);
>>>  		up_write(&fi->i_mmap_sem);
>>>  	}
>>>  
>>> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
>>> index c52260c..4f2d908 100644
>>> --- a/fs/fuse/file.c
>>> +++ b/fs/fuse/file.c
>>> @@ -417,6 +417,7 @@ static void inode_reclaim_dmap_range(struct fuse_conn *fc, struct inode *inode,
>>>  	start = ALIGN(start, FUSE_DAX_MEM_RANGE_SZ);
>>>  	end = ALIGN_DOWN(end, FUSE_DAX_MEM_RANGE_SZ);
>>>  
>>> +	down_write(&fi->i_dmap_sem);
>>
>> I'm not sure if this is related with the hang bug. Or it's another lock
>> missing bug which could be extracted as a new patch.
>>
> 
> inode_reclaim_dmap_range was only used in inode evict path where
> others are unable to access fi->dmap_tree.
> 
> This patch adds two callers for the function, as such we need the lock
> to protect the tree operations.

Got it, thanks.

> 
>>>  	while (1) {
>>>  		dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, start,
>>>  							 end);
>>> @@ -426,6 +427,7 @@ static void inode_reclaim_dmap_range(struct fuse_conn *fc, struct inode *inode,
>>>  		num++;
>>>  		list_add(&dmap->list, &to_remove);
>>>  	}
>>> +	up_write(&fi->i_dmap_sem);
>>>  
>>>  	/* Nothing to remove */
>>>  	if (list_empty(&to_remove))
>>> @@ -478,7 +480,7 @@ static int dmap_removemapping_one(struct inode *inode,
>>>   * that fuse inode interval tree. If that lock is taken then lock validator
>>>   * complains of deadlock situation w.r.t fs_reclaim lock.
>>>   */
>>> -void fuse_cleanup_inode_mappings(struct inode *inode)
>>> +void fuse_cleanup_inode_mappings(struct inode *inode, loff_t start, loff_t end)
>>>  {
>>>  	struct fuse_conn *fc = get_fuse_conn(inode);
>>>  	/*
>>> @@ -486,7 +488,7 @@ void fuse_cleanup_inode_mappings(struct inode *inode)
>>>  	 * before we arrive here. So we should not have to worry about
>>>  	 * any pages/exception entries still associated with inode.
>>>  	 */
>>> -	inode_reclaim_dmap_range(fc, inode, 0, -1);
>>> +	inode_reclaim_dmap_range(fc, inode, start, end);
>>>  }
>>>  
>>>  void fuse_finish_open(struct inode *inode, struct file *file)
>>> @@ -3867,6 +3869,9 @@ static long __fuse_file_fallocate(struct file *file, int mode,
>>
>> It's strange that I could not find *__fuse_file_fallocate()* at
>> virtio-fs-dev-5.1 code.
>>
> 
> Oh OK, I didn't realize that this piece of code has been refactored,
> it was also used by dax write path, anyway __fuse_file_fallocate() was
> basically identical to fuse_file_fallocate().
> 
>>>  		}
>>>  
>>>  		truncate_pagecache_range(inode, offset, offset + length - 1);
>>> +		if (IS_DAX(inode))
>>> +			fuse_cleanup_inode_mappings(inode, offset,
>>> +						    offset + length - 1);
>>
>> I prefer using "loff_t endbyte" to replace "offset + length - 1" which
>> makes code easier.
>>
> 
> Well, I'd like to leave it for a later cleanup patch in which I'll
> convert all (offset+length-1) here.

OK, that will be good to me.

Jun

