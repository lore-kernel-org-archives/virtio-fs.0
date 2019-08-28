References: <5abd7616-5351-761c-0c14-21d511251006@huawei.com>
	<20190820091650.GE9855@stefanha-x1.localdomain>
	<CAJfpegs8fSLoUaWKhC1543Hoy9821vq8=nYZy-pw1+95+Yv4gQ@mail.gmail.com>
	<20190821160551.GD9095@stefanha-x1.localdomain>
	<954b5f8a-4007-f29c-f38e-dd5585879541@huawei.com>
	<CAJfpegtBYLJLWM8GJ1h66PMf2J9o38FG6udcd2hmamEEQddf5w@mail.gmail.com>
	<0e8090c7-0c7c-bcbe-af75-33054d3a3efb@huawei.com>
	<CAJfpegurYLAApon5Ai6Q33vEy+GPxtOTUwDCCbJ2JAbg4csDSg@mail.gmail.com>
	<a19866be-3693-648e-ee6c-8d302c830834@huawei.com>
	<CAOssrKd7bKts2tCAZaXLJt+BVoQtqWoJV6HfT76-qxg7W4g9PQ@mail.gmail.com>
	<CAJfpegt574w1Rzge-59-1dRVtfPgCrFuCpJ5DjLQwSWg+G3ArA@mail.gmail.com>
	<fd7a2791-d95c-3bd9-e387-b8778a9eca83@huawei.com>
	<CAJfpegsd7v=DWwhAnNRq+L28xQFaw9EPhLyStnAG8V_hc_TZvg@mail.gmail.com>
From: wangyan <wangyan122@huawei.com>
Message-ID: <9e6b4aab-6939-e129-a048-d2fa272a0e0b@huawei.com>
Date: Wed, 28 Aug 2019 08:57:08 +0800
MIME-Version: 1.0
In-Reply-To: <CAJfpegsd7v=DWwhAnNRq+L28xQFaw9EPhLyStnAG8V_hc_TZvg@mail.gmail.com>
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
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Miklos Szeredi <mszeredi@redhat.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>

On 2019/8/26 20:39, Miklos Szeredi wrote:
> On Sat, Aug 24, 2019 at 10:44 AM wangyan <wangyan122@huawei.com> wrote:
>
>> According to the result, for "-size=1G", it maybe exceed the dirty pages'
>> upper limit, and it frequently triggered pdflush for write-back. And for
>> "-size=700M", it maybe didn't exceed the dirty pages' upper limit, so no
>> extra pdflush was triggered.
>>
>> But for 9p using "-size=1G", the latency 3.94 usec, and the bandwidth is
>> 2305.5MB/s. It is better than virtiofs using "-size=1G". It seems that
>> it is not affected by the dirty pages' upper limit.
>
> I tried to reproduce these results, but failed to get decent
> (>100MB/s) performance out of 9p.  I don't have fscache set up, does
> that play a part in getting high performance cached writes?
Yes, you should open fscache. My mount command is:
mount -t 9p -o 
trans=virtio,version=9p2000.L,rw,dirsync,nodev,msize=1000000000,cache=fscache 
sharedir /mnt/virtiofs/

Thanks,
Yan Wang
>
> What you describe makes sense, and I have a new patch (attached), but
> didn't see drastic improvement in performance of virtio-fs in my
> tests.
>
> Thanks,
> Miklos
>

