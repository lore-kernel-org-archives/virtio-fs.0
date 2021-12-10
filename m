Message-ID: <4a67dd65-c3e7-d2dc-51ff-7abc8714a400@linux.alibaba.com>
Date: Fri, 10 Dec 2021 11:02:54 +0800
MIME-Version: 1.0
References: <20211102055646.103337-1-jefflexu@linux.alibaba.com>
	<20211102055646.103337-4-jefflexu@linux.alibaba.com>
	<YbJgdNSaMnQuZgO/@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
In-Reply-To: <YbJgdNSaMnQuZgO/@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v7 3/6] virtiofsd: add 'dax=' option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, miklos@szeredi.hu



On 12/10/21 4:00 AM, Vivek Goyal wrote:
> On Tue, Nov 02, 2021 at 01:56:43PM +0800, Jeffle Xu wrote:
>> This option is used to specify the policy of constructing per-inode DAX
>> attribute when guest virtiofs is mounted with "-o dax=inode".
>>
>> Currently there are two valid policies, "inode" and "filesize".
> 
> General thoughts.
> 
> I think additional policies like "dax=always" and "dax=none" will
> also make sense. "dax=always" will set ATTR_FLAG_DAX on all inodes.
> "dax=none" is default as of now but if somebody wants to enforce
> it, they can pass it explicitly, just in case default changes later
> down the line.
> 
> It should be trivial to add these two policies as well now.

Make sense. I will add "dax=always" and "dax=none" in the next version.

> 
> I am little concenred with "dax=filesize". It has implicit threshold
> of 32KB. What if somebody wants threshold of 64KB or 1MB or even
> higher? One option would be to add another option say,
> --dax-filesize-threshold=<foo> and that will allow one to override
> default. Or we could hardcode threshold in policy name say
> filesize_32KB or filesize_1MB etc.
> 
> I guess adding a separate option to modify filesize threshold
> is better because it will allow wide range of values. So "dax=filesize"
> will just mean that there is an inbuilt threshold of 32KB to enable
> dax and and user can override it by passing new option
> --dax-filesize-threshold (TBD in future when somebody needs it).
> 

Yes, at least for now, the "--dax-filesize-threshold" shall be more
flexible.

-- 
Thanks,
Jeffle

