References: <5D4CC344.7030706@huawei.com> <5D4CC400.9040606@huawei.com>
	<20190814125235.GC23970@stefanha-x1.localdomain>
From: piaojun <piaojun@huawei.com>
Message-ID: <5c5164e4-86bd-d895-05e8-2ba274b551d6@huawei.com>
Date: Wed, 14 Aug 2019 21:28:37 +0800
MIME-Version: 1.0
In-Reply-To: <20190814125235.GC23970@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v4 2/2] virtiofsd: use fuse_buf_writev to
 replace fuse_buf_write for better performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com



On 2019/8/14 20:52, Stefan Hajnoczi wrote:
> On Fri, Aug 09, 2019 at 08:53:20AM +0800, piaojun wrote:
>> diff --git a/contrib/virtiofsd/buffer.c b/contrib/virtiofsd/buffer.c
>> index cec762f..d127c45 100644
>> --- a/contrib/virtiofsd/buffer.c
>> +++ b/contrib/virtiofsd/buffer.c
>> @@ -318,11 +318,22 @@ static int fuse_bufvec_advance(struct fuse_bufvec *bufv, size_t len)
>>  ssize_t fuse_buf_copy(fuse_req_t req, struct fuse_bufvec *dstv, struct fuse_bufvec *srcv,
>>  		      enum fuse_buf_copy_flags flags)
>>  {
>> +	size_t i;
>>  	size_t copied = 0;
>>
>>  	if (dstv == srcv)
>>  		return fuse_buf_size(dstv);
>>
>> +	/* use writev to improve bandwidth when all the
>> +	 * src buffers already mapped by the daemon
>> +	 * process */
> 
> Some more checks to make this generic:
> 
>> +	for (i = 0; i < srcv->count; i++) {
>> +		if (srcv->buf[i].flags & FUSE_BUF_PHYS_ADDR)
>> +			break;
> 
>                 if (srcv->buf[i].flags & FUSE_BUF_IS_FD)
> 		        break;
> 
>> +	}
>> +	if (i == srcv->count)
> 
> Please verify the preconditions for the destination buffer too:
> 
>   && dstv->count == 1 && dstv->idx == 0 && dstv->off == 0 &&
>   (dstv->buf[0].flags & FUSE_BUF_IS_FD)
> My previous thought was letting lo_write_buf() check all the
preconditions which would make code simpler. But as you said, generic
code comes first, so I will fix them in PATCH v5 later.

Thanks,
Jun

