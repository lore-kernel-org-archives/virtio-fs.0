References: <20211011030052.98923-1-jefflexu@linux.alibaba.com>
	<20211011030052.98923-5-jefflexu@linux.alibaba.com>
	<YW2E6jaTbv1FcFnu@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <778cd99d-fb40-1135-5d62-58a008c14919@linux.alibaba.com>
Date: Wed, 20 Oct 2021 11:10:30 +0800
MIME-Version: 1.0
In-Reply-To: <YW2E6jaTbv1FcFnu@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v6 4/7] fuse: negotiate per-file DAX in
	FUSE_INIT
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, linux-fsdevel@vger.kernel.org



On 10/18/21 10:30 PM, Vivek Goyal wrote:
> On Mon, Oct 11, 2021 at 11:00:49AM +0800, Jeffle Xu wrote:
>> Among the FUSE_INIT phase, client shall advertise per-file DAX if it's
>> mounted with "-o dax=inode". Then server is aware that client is in
>> per-file DAX mode, and will construct per-inode DAX attribute
>> accordingly.
>>
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>> ---
>>  fs/fuse/inode.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
>> index b4b41683e97e..f4ad99e2415b 100644
>> --- a/fs/fuse/inode.c
>> +++ b/fs/fuse/inode.c
>> @@ -1203,6 +1203,8 @@ void fuse_send_init(struct fuse_mount *fm)
>>  #ifdef CONFIG_FUSE_DAX
>>  	if (fm->fc->dax)
>>  		ia->in.flags |= FUSE_MAP_ALIGNMENT;
>> +	if (fm->fc->dax_mode == FUSE_DAX_INODE)
>> +		ia->in.flags |= FUSE_PERFILE_DAX;
> 
> Are you not keeping track of server's response whether server supports
> per inode dax or not. Client might be new and server might be old and
> server might not support per inode dax. In that case, we probably 
> should error out if user mounted with "-o dax=inode".
> 

Yes, if guest virtiofs is mounted with '-o dax=inode' while virtiofsd is
old and doesn't support per inode dax, then guest virtiofs will never
receive FUSE_ATTR_DAX and actually behaves as '-o dax=never'. So the
whole system works in this case, though the behavior may be beyond the
expectation of users ....

If the behavior really matters, I could change the behavior and fail
directly if virtiofsd doesn't advertise supporting per inode DAX.

-- 
Thanks,
Jeffle

