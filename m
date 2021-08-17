References: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
	<CAJfpeguw1hMOaxpDmjmijhf=-JEW95aEjxfVo_=D_LyWx8LDgw@mail.gmail.com>
	<YRut5sioYfc2M1p7@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <6043c0b8-0ff1-2e11-0dd0-e23f9ff6b952@linux.alibaba.com>
Date: Tue, 17 Aug 2021 21:22:53 +0800
MIME-Version: 1.0
In-Reply-To: <YRut5sioYfc2M1p7@redhat.com>
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
To: Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: virtualization@lists.linux-foundation.org, virtio-fs-list <virtio-fs@redhat.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, linux-fsdevel@vger.kernel.org



On 8/17/21 8:39 PM, Vivek Goyal wrote:
> On Tue, Aug 17, 2021 at 10:06:53AM +0200, Miklos Szeredi wrote:
>> On Tue, 17 Aug 2021 at 04:22, Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
>>>
>>> This patchset adds support of per-file DAX for virtiofs, which is
>>> inspired by Ira Weiny's work on ext4[1] and xfs[2].
>>
>> Can you please explain the background of this change in detail?
>>
>> Why would an admin want to enable DAX for a particular virtiofs file
>> and not for others?
> 
> Initially I thought that they needed it because they are downloading
> files on the fly from server. So they don't want to enable dax on the file
> till file is completely downloaded. 

Right, it's our initial requirement.


> But later I realized that they should
> be able to block in FUSE_SETUPMAPPING call and make sure associated
> file section has been downloaded before returning and solve the problem.
> So that can't be the primary reason.

Saying we want to access 4KB of one file inside guest, if it goes
through FUSE request routine, then the fuse daemon only need to download
this 4KB from remote server. But if it goes through DAX, then the fuse
daemon need to download the whole DAX window (e.g., 2MB) from remote
server, so called amplification. Maybe we could decrease the DAX window
size, but it's a trade off.

> 
> Other reason mentioned I think was that only certain files benefit
> from DAX. But not much details are there after that. It will be nice
> to hear a more concrete use case and more details about this usage.
> 

Apart from our internal requirement, more fine grained control for DAX
shall be general and more flexible. Glad to hear more discussion from
community.


-- 
Thanks,
Jeffle

