References: <20190524065413.10978-1-tao.peng@linux.alibaba.com>
	<20190531161834.GJ3169@work-vm>
From: Tao Peng <tao.peng@linux.alibaba.com>
Message-ID: <b07f7b03-76fe-175c-fdce-31047be16489@linux.alibaba.com>
Date: Mon, 3 Jun 2019 10:12:36 +0800
MIME-Version: 1.0
In-Reply-To: <20190531161834.GJ3169@work-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH-v2] virtiofsd: make FUSE_REMOVEMAPPING
 support multiple entries
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



On 2019/6/1 00:18, Dr. David Alan Gilbert wrote:
> * Peng Tao (tao.peng@linux.alibaba.com) wrote:
>> The fuse wire protocol is changed so that we can unmap multiple
>> mappings in a single call.
>>
>> Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
> 
> Hi Peng,
>    Thanks for this.
> 
>> ---
>>   contrib/virtiofsd/fuse_kernel.h    |  9 +++++++--
>>   contrib/virtiofsd/fuse_lowlevel.c  | 21 ++++++++++++++------
>>   contrib/virtiofsd/fuse_lowlevel.h  |  5 +++--
>>   contrib/virtiofsd/passthrough_ll.c | 31 ++++++++++++++++++++----------
>>   4 files changed, 46 insertions(+), 20 deletions(-)
>>
>> diff --git a/contrib/virtiofsd/fuse_kernel.h b/contrib/virtiofsd/fuse_kernel.h
>> index ce46046a4f..12e1d06826 100644
>> --- a/contrib/virtiofsd/fuse_kernel.h
>> +++ b/contrib/virtiofsd/fuse_kernel.h
>> @@ -830,9 +830,14 @@ struct fuse_setupmapping_out {
>>           uint64_t        len[FUSE_SETUPMAPPING_ENTRIES];
>>   };
>>   
>> -struct fuse_removemapping_in {
>> +struct fuse_removemapping_in_header {
>>           /* An already open handle */
>> -	uint64_t	fh;
>> +        uint64_t        fh;
>> +        /* number of fuse_removemapping_in follows */
>> +        uint32_t        count;
> 
> OK, good that fixes the count.
> 
> However, see my message from 22nd May replying to Miklos
> wherewe talk about how there's a:
>     fuse_batch_forget_in and 'count' fuse_forget_one
> 
> we should name these using the same scheme, i.e.
>     fuse_removemapping_in and 'count'  fuse_removemapping_one
> 
> If you can respin with that then I think we're good.
> 
oops, sorry for missing that one. I'll respin and resend.

Thanks,
Tao

