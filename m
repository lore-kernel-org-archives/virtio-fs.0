Message-ID: <5E605B5F.6050204@cn.fujitsu.com>
Date: Thu, 5 Mar 2020 09:52:31 +0800
From: Xiao Yang <yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
References: <20200210104451.20036-1-ice_yangxiao@163.com>
	<20200304185420.GJ4104@work-vm>
In-Reply-To: <20200304185420.GJ4104@work-vm>
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd/helper: Add shared/no_shared
 options to help message
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

On 2020/3/5 2:54, Dr. David Alan Gilbert wrote:
> * Xiao Yang (ice_yangxiao@163.com) wrote:
>> From: Xiao Yang<yangx.jy@cn.fujitsu.com>
>>
>> Also add a hint that user should start 'ireg' daemon before using shared cache.
>
> Apologies for the delay; I've squashed that into 'add initial support
> for shared versions'.
Hi Dave,

Thanks for your reply.  Your change is ok for me.

Thanks,
Xiao Yang

>
> Dave
>
>> Signed-off-by: Xiao Yang<yangx.jy@cn.fujitsu.com>
>> ---
>>   tools/virtiofsd/helper.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
>> index 819c2bc13c..0aa02b99b0 100644
>> --- a/tools/virtiofsd/helper.c
>> +++ b/tools/virtiofsd/helper.c
>> @@ -171,6 +171,10 @@ void fuse_cmdline_help(void)
>>              "                               default: no_writeback\n"
>>              "    -o xattr|no_xattr          enable/disable xattr\n"
>>              "                               default: no_xattr\n"
>> +           "    -o shared|no_shared        enable/disable shared cache\n"
>> +           "                               default: no_shared\n"
>> +           "                               please start 'ireg' daemon before "
>> +           "using shared cache\n"
>>              );
>>   }
>>
>> --
>> 2.21.0
>>
>>
>>
>> _______________________________________________
>> Virtio-fs mailing list
>> Virtio-fs@redhat.com
>> https://www.redhat.com/mailman/listinfo/virtio-fs
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
>
>
>
> .
>




