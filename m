References: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
	<CAJfpeguw1hMOaxpDmjmijhf=-JEW95aEjxfVo_=D_LyWx8LDgw@mail.gmail.com>
	<YRuCHvhICtTzMK04@work-vm> <YRuuRo8jEs5dkfw9@redhat.com>
	<299689e9-bdeb-a715-3f31-8c70369cf0ba@linux.alibaba.com>
	<YUeTP1B+JE5gGudq@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <ef66622c-586c-81e0-86a6-85e01af316c2@linux.alibaba.com>
Date: Wed, 22 Sep 2021 16:16:16 +0800
MIME-Version: 1.0
In-Reply-To: <YUeTP1B+JE5gGudq@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v4 0/8] fuse,virtiofs: support per-file DAX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, virtualization@lists.linux-foundation.org, virtio-fs-list <virtio-fs@redhat.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, linux-fsdevel@vger.kernel.org

Thanks for the replying and suggesting. ;)


On 9/20/21 3:45 AM, Vivek Goyal wrote:
> On Thu, Sep 16, 2021 at 04:21:59PM +0800, JeffleXu wrote:
>> Hi, I add some performance statistics below.
>>
>>
>> On 8/17/21 8:40 PM, Vivek Goyal wrote:
>>> On Tue, Aug 17, 2021 at 10:32:14AM +0100, Dr. David Alan Gilbert wrote:
>>>> * Miklos Szeredi (miklos@szeredi.hu) wrote:
>>>>> On Tue, 17 Aug 2021 at 04:22, Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
>>>>>>
>>>>>> This patchset adds support of per-file DAX for virtiofs, which is
>>>>>> inspired by Ira Weiny's work on ext4[1] and xfs[2].
>>>>>
>>>>> Can you please explain the background of this change in detail?
>>>>>
>>>>> Why would an admin want to enable DAX for a particular virtiofs file
>>>>> and not for others?
>>>>
>>>> Where we're contending on virtiofs dax cache size it makes a lot of
>>>> sense; it's quite expensive for us to map something into the cache
>>>> (especially if we push something else out), so selectively DAXing files
>>>> that are expected to be hot could help reduce cache churn.
>>
>> Yes, the performance of dax can be limited when the DAX window is
>> limited, where dax window may be contended by multiple files.
>>
>> I tested kernel compiling in virtiofs, emulating the scenario where a
>> lot of files contending dax window and triggering dax window reclaiming.
>>
>> Environment setup:
>> - guest vCPU: 16
>> - time make vmlinux -j128
>>
>> type    | cache  | cache-size | time
>> ------- | ------ | ---------- | ----
>> non-dax | always |   --       | real 2m48.119s
>> dax     | always | 64M        | real 4m49.563s
>> dax     | always |   1G       | real 3m14.200s
>> dax     | always |   4G       | real 2m41.141s
>>
>>
>> It can be seen that there's performance drop, comparing to the normal
>> buffered IO, when dax window resource is restricted and dax window
>> relcaiming is triggered. The smaller the cache size is, the worse the
>> performance is. The performance drop can be alleviated and eliminated as
>> cache size increases.
>>
>> Though we may not compile kernel in virtiofs, indeed we may access a lot
>> of small files in virtiofs and suffer this performance drop.
> 
> Hi Jeffle,
> 
> If you access lot of big files or a file bigger than dax window, still
> you will face performance drop due to reclaim. IOW, if data being
> accessed is bigger than dax window, then reclaim will trigger and
> performance drop will be observed. So I think its not fair to assciate
> performance drop with big for small files as such.

Yes, it is. Actually what I mean is that small files (with size smaller
than dax window chunk size) is more likely to consume more dax windows
compared to large files, under the same total file size.


> 
> What makes more sense is that memomry usage argument you have used
> later in the email. That is, we have a fixed chunk size of 2MB. And
> that means we use 512 * 64 = 32K of memory per chunk. So if a file
> is smaller than 32K in size, it might be better to just access it
> without DAX and incur the cost of page cache in guest instead. Even this
> argument also works only if dax window is being utilized fully.

Yes, agreed. In this case, the meaning of per-file dax is that, admin
could control the size of overall dax window under a limited number,
while still sustaining a reasonable performance. But at least, users are
capable of tuning it now.

> 
> Anyway, I think Miklos already asked you to send patches so that
> virtiofs daemon specifies which file to use dax on. So are you
> planning to post patches again for that. (And drop patches to
> read dax attr from per inode from filesystem in guest).

OK. I will send a new version, disabling dax based on the file size on
the host daemon side. Besides, I'm afraid the negotiation phase is also
not needed anymore, since currently the hint whether dax shall be
enabled or not is completely feeded from host daemon, and the guest side
needn't set/clear per inode dax attr now.

-- 
Thanks,
Jeffle

