References: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
	<CAJfpeguw1hMOaxpDmjmijhf=-JEW95aEjxfVo_=D_LyWx8LDgw@mail.gmail.com>
	<YRuCHvhICtTzMK04@work-vm>
	<CAJfpegvM+S5Xru3Yfc88C64mecvco=f99y-TajQBDfkLD-S8zQ@mail.gmail.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <0896b1f6-c8c4-6071-c05b-a333c6cccacd@linux.alibaba.com>
Date: Tue, 17 Aug 2021 21:08:35 +0800
MIME-Version: 1.0
In-Reply-To: <CAJfpegvM+S5Xru3Yfc88C64mecvco=f99y-TajQBDfkLD-S8zQ@mail.gmail.com>
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
To: Miklos Szeredi <miklos@szeredi.hu>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>, virtualization@lists.linux-foundation.org



On 8/17/21 6:09 PM, Miklos Szeredi wrote:
> On Tue, 17 Aug 2021 at 11:32, Dr. David Alan Gilbert
> <dgilbert@redhat.com> wrote:
>>
>> * Miklos Szeredi (miklos@szeredi.hu) wrote:
>>> On Tue, 17 Aug 2021 at 04:22, Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
>>>>
>>>> This patchset adds support of per-file DAX for virtiofs, which is
>>>> inspired by Ira Weiny's work on ext4[1] and xfs[2].
>>>
>>> Can you please explain the background of this change in detail?
>>>
>>> Why would an admin want to enable DAX for a particular virtiofs file
>>> and not for others?
>>
>> Where we're contending on virtiofs dax cache size it makes a lot of
>> sense; it's quite expensive for us to map something into the cache
>> (especially if we push something else out), so selectively DAXing files
>> that are expected to be hot could help reduce cache churn.
> 
> If this is a performance issue, it should be fixed in a way that
> doesn't require hand tuning like you suggest, I think.
> 
> I'm not sure what the  ext4/xfs case for per-file DAX is.  Maybe that
> can help understand the virtiofs case as well.
> 

Some hints why ext4/xfs support per-file DAX can be found [1] and [2].

"Boaz Harrosh wondered why someone might want to turn DAX off for a
persistent memory device. Hellwig said that the performance "could
suck"; Williams noted that the page cache could be useful for some
applications as well. Jan Kara pointed out that reads from persistent
memory are close to DRAM speed, but that writes are not; the page cache
could be helpful for frequent writes. Applications need to change to
fully take advantage of DAX, Williams said; part of the promise of
adding a flag is that users can do DAX on smaller granularities than a
full filesystem."

In summary, page cache is preferable in some cases, and thus more fine
grained way of DAX control is needed.


As for virtiofs, Dr. David Alan Gilbert has mentioned that various files
may compete for limited DAX window resource.

Besides, supporting DAX for small files can be expensive. Small files
can consume DAX window resource rapidly, and if small files are accessed
only once, the cost of mmap/munmap on host can not be ignored.


[1]
https://lore.kernel.org/lkml/20200428002142.404144-1-ira.weiny@intel.com/
[2] https://lwn.net/Articles/787973/

-- 
Thanks,
Jeffle

