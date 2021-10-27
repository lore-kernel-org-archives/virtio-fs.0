References: <20211011030052.98923-1-jefflexu@linux.alibaba.com>
	<20211011030052.98923-7-jefflexu@linux.alibaba.com>
	<YW2QeIdS2X48FOHk@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <8d741b29-c116-fbf8-2126-4ba183b7ccf6@linux.alibaba.com>
Date: Wed, 27 Oct 2021 13:05:30 +0800
MIME-Version: 1.0
In-Reply-To: <YW2QeIdS2X48FOHk@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v6 6/7] fuse: mark inode DONT_CACHE when
 per-file DAX hint changes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, miklos@szeredi.hub, linux-fsdevel@vger.kernel.org

Sorry for the late reply, as your previous reply was moved to junk box
by the algorithm...

On 10/18/21 11:19 PM, Vivek Goyal wrote:
> On Mon, Oct 11, 2021 at 11:00:51AM +0800, Jeffle Xu wrote:
>> When the per-file DAX hint changes while the file is still *opened*, it
>> is quite complicated and maybe fragile to dynamically change the DAX
>> state.
>>
>> Hence mark the inode and corresponding dentries as DONE_CACHE once the
>> per-file DAX hint changes, so that the inode instance will be evicted
>> and freed as soon as possible once the file is closed and the last
>> reference to the inode is put. And then when the file gets reopened next
>> time, the new instantiated inode will reflect the new DAX state.
>>
>> In summary, when the per-file DAX hint changes for an *opened* file, the
>> DAX state of the file won't be updated until this file is closed and
>> reopened later.
>>
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>> ---
>>  fs/fuse/dax.c    | 9 +++++++++
>>  fs/fuse/fuse_i.h | 1 +
>>  fs/fuse/inode.c  | 3 +++
>>  3 files changed, 13 insertions(+)
>>
>> diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
>> index 15bde36829b8..ca083c13f5e8 100644
>> --- a/fs/fuse/dax.c
>> +++ b/fs/fuse/dax.c
>> @@ -1364,6 +1364,15 @@ void fuse_dax_inode_init(struct inode *inode, unsigned int flags)
>>  	inode->i_data.a_ops = &fuse_dax_file_aops;
>>  }
>>  
>> +void fuse_dax_dontcache(struct inode *inode, unsigned int flags)
>> +{
>> +	struct fuse_conn *fc = get_fuse_conn(inode);
>> +
>> +	if (fc->dax_mode == FUSE_DAX_INODE &&
>> +	    (!!IS_DAX(inode) != !!(flags & FUSE_ATTR_DAX)))
>> +		d_mark_dontcache(inode);
>> +}
>> +
>>  bool fuse_dax_check_alignment(struct fuse_conn *fc, unsigned int map_alignment)
>>  {
>>  	if (fc->dax && (map_alignment > FUSE_DAX_SHIFT)) {
>> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
>> index 0270a41c31d7..bb2c11e0311a 100644
>> --- a/fs/fuse/fuse_i.h
>> +++ b/fs/fuse/fuse_i.h
>> @@ -1270,6 +1270,7 @@ void fuse_dax_conn_free(struct fuse_conn *fc);
>>  bool fuse_dax_inode_alloc(struct super_block *sb, struct fuse_inode *fi);
>>  void fuse_dax_inode_init(struct inode *inode, unsigned int flags);
>>  void fuse_dax_inode_cleanup(struct inode *inode);
>> +void fuse_dax_dontcache(struct inode *inode, unsigned int flags);
>>  bool fuse_dax_check_alignment(struct fuse_conn *fc, unsigned int map_alignment);
>>  void fuse_dax_cancel_work(struct fuse_conn *fc);
>>  
>> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
>> index 73f19cd6e702..cf934c2ba761 100644
>> --- a/fs/fuse/inode.c
>> +++ b/fs/fuse/inode.c
>> @@ -268,6 +268,9 @@ void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
>>  		if (inval)
>>  			invalidate_inode_pages2(inode->i_mapping);
>>  	}
>> +
>> +	if (IS_ENABLED(CONFIG_FUSE_DAX))
>> +		fuse_dax_dontcache(inode, attr->flags);
> 
> Should we give this function more generic name. Say
> fuse_dax_change_attributes(). And let that function decide what attributes
> have changed and does it need to take any action.
> 

But currently we only need to handle 'attr->flags & FUSE_ATTR_DAX'. If
other attributes need to be handled later, then we can expand this
function and give it a more generic name. But as for now, I prefer to
keep it simple.


-- 
Thanks,
Jeffle

