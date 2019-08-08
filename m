References: <5D4A7952.4010707@huawei.com> <20190807153747.GG2867@work-vm>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D4B7A28.4090504@huawei.com>
Date: Thu, 8 Aug 2019 09:26:00 +0800
MIME-Version: 1.0
In-Reply-To: <20190807153747.GG2867@work-vm>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v2 2/2][RFC] use fuse_buf_writev to replace
 fuse_buf_write for better performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com

Hi Dave,

On 2019/8/7 23:37, Dr. David Alan Gilbert wrote:
> * piaojun (piaojun@huawei.com) wrote:
>> fuse_buf_writev() only handles the normal write in which src is buffer
>> and dest is fd. Specially if src buffer represents guest physical
>> address that can't be mapped by the daemon process, IO must be bounced
>> back to the VMM to do it by fuse_buf_copy().
>>
>> Signed-off-by: Jun Piao <piaojun@huawei.com>
>> Suggested-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
>> ---
>>  contrib/virtiofsd/passthrough_ll.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
>> index cc9c175..c1bbc53 100644
>> --- a/contrib/virtiofsd/passthrough_ll.c
>> +++ b/contrib/virtiofsd/passthrough_ll.c
>> @@ -2023,7 +2023,10 @@ static void lo_write_buf(fuse_req_t req, fuse_ino_t ino,
>>  		fuse_debug("lo_write_buf(ino=%" PRIu64 ", size=%zd, off=%lu)\n",
>>  			   ino, out_buf.buf[0].size, (unsigned long) off);
>>
>> -	res = fuse_buf_copy(req, &out_buf, in_buf, 0);
>> +	if (!(in_buf->buf[0].flags & FUSE_BUF_PHYS_ADDR))
> 
> I don't think you can assume that the flags in in_buf[0] represent the
> state of the entire vector; I'm pretty sure we had a case of an
> application that did a writev() in the guest where the first element was
> on the stack and the other was in an mmap, and it was only the 2nd one
> that had the flag.

Yes, this assumption is idealized, and perhaps I need check all the
flags of entire vector before doing writev, right?

Thanks,
Jun

> 
> But also you're not checking any of the other flags either.
> 
> Dave
> 
>> +		res = fuse_buf_writev(req, &out_buf, in_buf, out_buf.buf[0].flags);
>> +	else
>> +		res = fuse_buf_copy(req, &out_buf, in_buf, 0);
>>  	if(res < 0) {
>>  		fuse_reply_err(req, -res);
>>  	} else {
>> -- 
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> .
> 

