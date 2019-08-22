References: <5abd7616-5351-761c-0c14-21d511251006@huawei.com>
	<20190820091650.GE9855@stefanha-x1.localdomain>
	<CAJfpegs8fSLoUaWKhC1543Hoy9821vq8=nYZy-pw1+95+Yv4gQ@mail.gmail.com>
	<20190821160551.GD9095@stefanha-x1.localdomain>
From: wangyan <wangyan122@huawei.com>
Message-ID: <954b5f8a-4007-f29c-f38e-dd5585879541@huawei.com>
Date: Thu, 22 Aug 2019 08:59:04 +0800
MIME-Version: 1.0
In-Reply-To: <20190821160551.GD9095@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [QUESTION] A performance problem for buffer write
 compared with 9p
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, Miklos Szeredi <mszeredi@redhat.com>

On 2019/8/22 0:05, Stefan Hajnoczi wrote:
> On Wed, Aug 21, 2019 at 09:51:20AM +0200, Miklos Szeredi wrote:
>> On Tue, Aug 20, 2019 at 11:16 AM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>>>
>>> On Thu, Aug 15, 2019 at 08:30:43AM +0800, wangyan wrote:
>>>> Hi all,
>>>>
>>>> I met a performance problem when I tested buffer write compared with 9p.
>>>
>>> CCing Miklos, FUSE maintainer, since this is mostly a FUSE file system
>>> writeback question.
>>
>> This is expected.   FUSE contains lots of complexity in the buffered
>> write path related to preventing DoS caused by the userspace server.
>>
>> This added complexity, which causes the performance issue, could be
>> disabled in virtio-fs, since the server lives on a different kernel
>> than the filesystem.
>>
>> I'll do a patch..
>
> Great, thanks!  Maybe wangyan can try your patch to see how the numbers
> compare to 9P.
>
> Stefan
>
I will test it when I get the patch, and post the compared result with
9p.

Thanks,
Yan Wang

