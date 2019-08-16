References: <5D4CC344.7030706@huawei.com> <5D4CC400.9040606@huawei.com>
	<20190814125235.GC23970@stefanha-x1.localdomain>
	<5D54B155.90101@huawei.com>
	<20190815145038.GI10996@stefanha-x1.localdomain>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D55FD7B.3080909@huawei.com>
Date: Fri, 16 Aug 2019 08:48:59 +0800
MIME-Version: 1.0
In-Reply-To: <20190815145038.GI10996@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"
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



On 2019/8/15 22:50, Stefan Hajnoczi wrote:
> On Thu, Aug 15, 2019 at 09:11:49AM +0800, piaojun wrote:
>> Hi Stefan,
>>
>> On 2019/8/14 20:52, Stefan Hajnoczi wrote:
>>> On Fri, Aug 09, 2019 at 08:53:20AM +0800, piaojun wrote:
>>>> diff --git a/contrib/virtiofsd/buffer.c b/contrib/virtiofsd/buffer.c
>>>> index cec762f..d127c45 100644
>>>> --- a/contrib/virtiofsd/buffer.c
>>>> +++ b/contrib/virtiofsd/buffer.c
>>>> @@ -318,11 +318,22 @@ static int fuse_bufvec_advance(struct fuse_bufvec *bufv, size_t len)
>>>>  ssize_t fuse_buf_copy(fuse_req_t req, struct fuse_bufvec *dstv, struct fuse_bufvec *srcv,
>>>>  		      enum fuse_buf_copy_flags flags)
>>>>  {
>>>> +	size_t i;
>>>>  	size_t copied = 0;
>>>>
>>>>  	if (dstv == srcv)
>>>>  		return fuse_buf_size(dstv);
>>>>
>>>> +	/* use writev to improve bandwidth when all the
>>>> +	 * src buffers already mapped by the daemon
>>>> +	 * process */
>>>
>>> Some more checks to make this generic:
>>>
>>>> +	for (i = 0; i < srcv->count; i++) {
>>>> +		if (srcv->buf[i].flags & FUSE_BUF_PHYS_ADDR)
>>>> +			break;
>>>
>>>                 if (srcv->buf[i].flags & FUSE_BUF_IS_FD)
>>> 		        break;
>>>
>>>> +	}
>>>> +	if (i == srcv->count)
>>>
>>> Please verify the preconditions for the destination buffer too:
>>>
>>>   && dstv->count == 1 && dstv->idx == 0 && dstv->off == 0 &&
>>>   (dstv->buf[0].flags & FUSE_BUF_IS_FD)
>>
>> Thanks for your comments, and I prefer adding checker just for
>> FUSE_BUF_IS_FD as fuse_buf_writev() does not care much about the other
>> parts. And I personally think so many preconditions will make
>> fuse_buf_writev() so specific.
> 
> I think these preconditions are necessary.  This function won't do the
> right thing if dstv has multiple elements or has been previously
> modified (idx/off).
> 
> Can you explain why these cases will never happen or why the code is
> correct under these cases?
> 
> Stefan
> 

We have already reached an agreement with the src buf and need discuss
with the dst buf. So I spent some time looking into libfuse code, and
found your suggestion really make sense. My previous thought was that
idx/off only works when dst is buf. So I will make these preconditions
more generic like this:

In fuse_buf_copy():
if (i == srcv->count) {
dstv->buf[0].pos += dstv->off; // add dst offset even if it's always 0
fuse_buf_writev(req, &dstv->buf[0], srcv);
}

In fuse_buf_writev():

// modify the preconditions
if (i == srcv->count && dstv->count == 1 &&
dstv->idx == 0 && (dstv->buf[0].flags & FUSE_BUF_IS_FD))

Jun

