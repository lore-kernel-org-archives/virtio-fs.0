References: <20190603024651.47305-1-tao.peng@linux.alibaba.com>
	<20190603212005.GB8955@redhat.com>
From: Peng Tao <tao.peng@linux.alibaba.com>
Message-ID: <f8f16612-bf0a-2af2-66ad-5378252aa616@linux.alibaba.com>
Date: Tue, 4 Jun 2019 14:25:52 +0800
MIME-Version: 1.0
In-Reply-To: <20190603212005.GB8955@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH-v2] virtiofs: FUSE_REMOVEMAPPING remove
 multiple entries in one call
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com



On 2019/6/4 05:20, Vivek Goyal wrote:
> On Mon, Jun 03, 2019 at 10:46:51AM +0800, Peng Tao wrote:
>> Enhance FUSE_REMOVEMAPPING wire protocol to remove multiple mappings
>> in one call. So that fuse_removemapping() can send just one fuse request
>> for many dmap entries.
>>
>> Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
>> ---
>> v1-v2: make fuse_removemapping_in count fuse_removemapping_one
>>
>> This works with corresponding qemu virtiofsd patch:
>> "[PATCH-v3] virtiofsd: make FUSE_REMOVEMAPPING support multiple entries".
>>
>>   fs/fuse/file.c            | 195 +++++++++++++++++++++++++++-----------
>>   include/uapi/linux/fuse.h |   7 ++
>>   2 files changed, 145 insertions(+), 57 deletions(-)
>>
> 
> Hi Tao Peng,
> 
> This patch looks more or less good to me. I have made quite a few cosmetic
> changes to it. Please have a look. I have done some basic testing with it.
> Will stress it little bit more tomorrow. If nothing breaks, will merge it.
> 
> Thanks
> Vivek
> 
> 
> Enhance FUSE_REMOVEMAPPING wire protocol to remove multiple mappings
> in one call. So that fuse_removemapping() can send just one fuse request
> for many dmap entries.
> 
> Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
> ---
> v1-v2: make fuse_removemapping_in count fuse_removemapping_one
> 
> This works with corresponding qemu virtiofsd patch:
> "[PATCH-v3] virtiofsd: make FUSE_REMOVEMAPPING support multiple entries".
> 
>   fs/fuse/file.c            |  203 +++++++++++++++++++++++++++++++++-------------
>   fs/fuse/fuse_i.h          |    2
>   fs/fuse/inode.c           |    2
>   include/uapi/linux/fuse.h |    7 +
>   4 files changed, 155 insertions(+), 59 deletions(-)
> 
> Index: rhvgoyal-linux-fuse/fs/fuse/file.c
> ===================================================================
> --- rhvgoyal-linux-fuse.orig/fs/fuse/file.c	2019-06-03 15:31:47.754645455 -0400
> +++ rhvgoyal-linux-fuse/fs/fuse/file.c	2019-06-03 17:16:35.930742301 -0400
> @@ -27,6 +27,9 @@ INTERVAL_TREE_DEFINE(struct fuse_dax_map
>   
>   static struct fuse_dax_mapping *alloc_dax_mapping_reclaim(struct fuse_conn *fc,
>   				struct inode *inode);
> +static void fuse_dax_free_mappings_range(struct fuse_conn *fc,
> +				struct inode *inode, loff_t start, loff_t end);
> +
>   static int fuse_send_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
>   			  int opcode, struct fuse_open_out *outargp)
>   {
> @@ -319,75 +322,87 @@ static int fuse_setup_one_mapping(struct
>   	return 0;
>   }
>   
> -static int fuse_removemapping_one(struct inode *inode,
> -					struct fuse_dax_mapping *dmap)
> +static int
> +fuse_send_removemapping(struct inode *inode,
> +			struct fuse_removemapping_in *inargp,
> +			struct fuse_removemapping_one *forget_one)
>   {
>   	struct fuse_inode *fi = get_fuse_inode(inode);
>   	struct fuse_conn *fc = get_fuse_conn(inode);
> -	struct fuse_removemapping_in inarg;
>   	FUSE_ARGS(args);
>   
> -	memset(&inarg, 0, sizeof(inarg));
> -	inarg.moffset = dmap->window_offset;
> -	inarg.len = dmap->length;
>   	args.in.h.opcode = FUSE_REMOVEMAPPING;
>   	args.in.h.nodeid = fi->nodeid;
> -	args.in.numargs = 1;
> -	args.in.args[0].size = sizeof(inarg);
> -	args.in.args[0].value = &inarg;
> +	args.in.numargs = 2;
> +	args.in.args[0].size = sizeof(*inargp);
> +	args.in.args[0].value = inargp;
> +	args.in.args[1].size = inargp->count * sizeof(*forget_one);
> +	args.in.args[1].value = forget_one;
>   	return fuse_simple_request(fc, &args);
>   }
>   
> -/*
> - * It is called from evict_inode() and by that time inode is going away. So
> - * this function does not take any locks like fi->i_dmap_sem for traversing
> - * that fuse inode interval tree. If that lock is taken then lock validator
> - * complains of deadlock situation w.r.t fs_reclaim lock.
> - */
> -void fuse_removemapping(struct inode *inode)
> +static int dmap_list_send_removemappings(struct inode *inode, unsigned num,
> +					    struct list_head *to_remove)
>   {
> -	struct fuse_conn *fc = get_fuse_conn(inode);
> -	struct fuse_inode *fi = get_fuse_inode(inode);
> -	ssize_t err;
> +	struct fuse_removemapping_one *remove_one, *ptr;
> +	struct fuse_removemapping_in inarg;
>   	struct fuse_dax_mapping *dmap;
> +	int ret, i = 0, nr_alloc;
>   
> -	/* Clear the mappings list */
> -	while (true) {
> -		WARN_ON(fi->nr_dmaps < 0);
> +	nr_alloc = min_t(unsigned int, num, FUSE_REMOVEMAPPING_MAX_ENTRY);
> +	remove_one = kmalloc_array(nr_alloc, sizeof(*remove_one), GFP_NOIO);
> +	if (!remove_one)
> +		return -ENOMEM;
>   
> -		dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, 0,
> -								-1);
> -		if (dmap) {
> -			fuse_dax_interval_tree_remove(dmap, &fi->dmap_tree);
> -			fi->nr_dmaps--;
> -			dmap_remove_busy_list(fc, dmap);
> +	ptr = remove_one;
> +	list_for_each_entry(dmap, to_remove, list) {
> +		ptr->moffset = dmap->window_offset;
> +		ptr->len = dmap->length;
> +		ptr++;
> +		i++;
> +		num--;
> +		if (i >= nr_alloc || num == 0) {
> +			memset(&inarg, 0, sizeof(inarg));
> +			inarg.count = i;
> +			ret = fuse_send_removemapping(inode, &inarg,
> +						  	remove_one);
						^^^
Here is a mix of space and tab as 'git am' complained:
Applying: virtiofs: FUSE_REMOVEMAPPING remove multiple entries in one call
.git/rebase-apply/patch:102: space before tab in indent.
						  	remove_one);
warning: 1 line applied after fixing whitespace errors.


Otherwise it looks good. I've also ran some tests and dmap removal is 
working as expected.

Thanks,
Tao

