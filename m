References: <20210812054618.26057-1-jefflexu@linux.alibaba.com>
	<20210812054618.26057-2-jefflexu@linux.alibaba.com>
	<CAJfpegs3QGVNa4CXt0Hayr=G50cQb1TWowRDuVf0pZv6FYV3kw@mail.gmail.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <3afa0ef8-8f69-c34a-9302-c1ea927668f6@linux.alibaba.com>
Date: Wed, 8 Sep 2021 17:41:57 +0800
MIME-Version: 1.0
In-Reply-To: <CAJfpegs3QGVNa4CXt0Hayr=G50cQb1TWowRDuVf0pZv6FYV3kw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 1/2] fuse: disable atomic_o_trunc if no_open
	is enabled
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: virtualization@lists.linux-foundation.org, virtio-fs-list <virtio-fs@redhat.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>



On 9/7/21 4:34 PM, Miklos Szeredi wrote:
> On Thu, 12 Aug 2021 at 07:46, Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
>>
>> From: Liu Bo <bo.liu@linux.alibaba.com>
>>
>> When 'no_open' is used by virtiofsd, guest kernel won't send OPEN request
>> any more.  However, with atomic_o_trunc, SETATTR request is also omitted in
>> OPEN(O_TRUNC) so that the backend file is not truncated.  With a following
>> GETATTR, inode size on guest side is updated to be same with that on host
>> side, the end result is that O_TRUNC semantic is broken.
>>
>> This disables atomic_o_trunc as well if with no_open.
> 
> I don't quite get it why one would want to enable atomic_o_trunc with
> no_open in the first place?

Oops..We didn't realize that it could also be worked around by fuse
daemon side. Please ignore this.

-- 
Thanks,
Jeffle

