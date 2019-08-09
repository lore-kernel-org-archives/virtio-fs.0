References: <5D4BBDB7.2000005@huawei.com> <5D4BBDFF.6060106@huawei.com>
	<20190808093825.GB31963@stefanha-x1.localdomain>
	<99a1f006-8e5c-0c1c-2cc5-9579ccf0495d@huawei.com>
	<20190809081458.GA25286@stefanha-x1.localdomain>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D4D3463.7010805@huawei.com>
Date: Fri, 9 Aug 2019 16:52:51 +0800
MIME-Version: 1.0
In-Reply-To: <20190809081458.GA25286@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v3 1/2] virtiofsd: add definition of
	fuse_buf_writev()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com

Hi Stefan,

On 2019/8/9 16:14, Stefan Hajnoczi wrote:
> On Thu, Aug 08, 2019 at 10:28:26PM +0800, piaojun wrote:
>> On 2019/8/8 17:38, Stefan Hajnoczi wrote:
>>> On Thu, Aug 08, 2019 at 02:15:27PM +0800, piaojun wrote:
>>>> +{
>>>> +	ssize_t res, i, buf_index, iovcnt;
>>>> +	struct iovec * iov;
>>>> +	int fd = out_buf->buf[0].fd;
>>>> +	off_t pos = out_buf->buf[0].pos;
>>>
>>> A struct fuse_bufvec may have multiple elements but this function
>>> assumes it only has 1.  Please use struct fuse_buf *out_buf instead.
>>> This way it's clear that only 1 fuse_buf will be written.
>>
>> Do you mean that assign *out_buf with &out_buf->buf[0] in
>> fuse_buf_writev() and then operate out_buf in the following process?
> 
> Since this function assumes that out_buf is only a single struct
> fuse_buf, please change the argument to struct fuse_buf instead of
> struct fuse_bufvec.  This way it's clear what the function expects.

Agreed, already fixed in PATCH v4.

> 
>>>
>>>> +
>>>> +	if (in_buf->count > 2)
>>>> +		iovcnt = in_buf->count - 1;
>>>> +	else
>>>> +		iovcnt = 1;
>>>> +
>>>> +	iov = calloc(iovcnt, sizeof(struct iovec));
>>>> +	if (!iov)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	for (i = 0, buf_index = 1; i < iovcnt; i++, buf_index++) {
>>>> +		iov[i].iov_base = in_buf->buf[buf_index].mem;
>>>> +		iov[i].iov_len = in_buf->buf[buf_index].size;
>>>> +	}
>>>
>>> Why is in_buf->buf[0] is skipped?
>>
>> This part of code seems a little complex and in_buf->buf[0].count just
>> tricks me. Maybe I need handle two situations:
>> 1. Iterate from in_buf->buf[0].mem when in_buf->buf[0].count is 1;
>> 2. buf[0].size is set 0 in do_write_buf() when in_buf->buf[0].count > 1,
>> and it's better to skip it. Perhaps it's also ok to iterate from buf[0],
>> as writev skip the iov with zero len. This looks like a hack.
> 
> I would perform writev() with all of in_buf's buffers, even if some of
> them have 0 length.  That way this function does not make any
> assumptions about in_buf's layout.

Agreed, already fixed in PATCH v4.

Jun

> 
> The only requirement is that in_buf buffers are all memory buffers (not
> file descriptors).
> 

