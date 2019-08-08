References: <5D4BBDB7.2000005@huawei.com> <5D4BBDFF.6060106@huawei.com>
	<20190808093825.GB31963@stefanha-x1.localdomain>
From: piaojun <piaojun@huawei.com>
Message-ID: <99a1f006-8e5c-0c1c-2cc5-9579ccf0495d@huawei.com>
Date: Thu, 8 Aug 2019 22:28:26 +0800
MIME-Version: 1.0
In-Reply-To: <20190808093825.GB31963@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
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

On 2019/8/8 17:38, Stefan Hajnoczi wrote:
> On Thu, Aug 08, 2019 at 02:15:27PM +0800, piaojun wrote:
>> @@ -71,6 +72,42 @@ static ssize_t fuse_buf_write(const struct fuse_buf *dst, size_t dst_off,
>>  	return copied;
>>  }
>>
>> +ssize_t fuse_buf_writev(fuse_req_t req,
>> +			     struct fuse_bufvec *out_buf,
>> +			     struct fuse_bufvec *in_buf,
>> +			     enum fuse_buf_copy_flags flags)
> 
> FUSE_BUF_FD_SEEK is defined in enum fuse_buf_flags, not enum
> fuse_buf_copy_flags.  This argument can be removed and the check below
> can be changed from:
> 
>   if (flags & FUSE_BUF_FD_SEEK)
> 
> to
> 
>   if (out_buf->buf[0].flags & FUSE_BUF_FD_SEEK)

Accepted, and will be fixed in PATCH v4.

> 
>> +{
>> +	ssize_t res, i, buf_index, iovcnt;
>> +	struct iovec * iov;
>> +	int fd = out_buf->buf[0].fd;
>> +	off_t pos = out_buf->buf[0].pos;
> 
> A struct fuse_bufvec may have multiple elements but this function
> assumes it only has 1.  Please use struct fuse_buf *out_buf instead.
> This way it's clear that only 1 fuse_buf will be written.

Do you mean that assign *out_buf with &out_buf->buf[0] in
fuse_buf_writev() and then operate out_buf in the following process?

> 
>> +
>> +	if (in_buf->count > 2)
>> +		iovcnt = in_buf->count - 1;
>> +	else
>> +		iovcnt = 1;
>> +
>> +	iov = calloc(iovcnt, sizeof(struct iovec));
>> +	if (!iov)
>> +		return -ENOMEM;
>> +
>> +	for (i = 0, buf_index = 1; i < iovcnt; i++, buf_index++) {
>> +		iov[i].iov_base = in_buf->buf[buf_index].mem;
>> +		iov[i].iov_len = in_buf->buf[buf_index].size;
>> +	}
> 
> Why is in_buf->buf[0] is skipped?

This part of code seems a little complex and in_buf->buf[0].count just
tricks me. Maybe I need handle two situations:
1. Iterate from in_buf->buf[0].mem when in_buf->buf[0].count is 1;
2. buf[0].size is set 0 in do_write_buf() when in_buf->buf[0].count > 1,
and it's better to skip it. Perhaps it's also ok to iterate from buf[0],
as writev skip the iov with zero len. This looks like a hack.

> 
>> +
>> +	if (flags & FUSE_BUF_FD_SEEK)
>> +		res = pwritev(fd, iov, iovcnt, pos);
> 
> Please move off_t pos = out_buf->buf[0].pos into this if statement body
> to avoid a possible uninitialized memory access when !(flags &
> FUSE_BUF_FD_SEEK).  This makes valgrind and other tools happy.

Accepted.

Thanks,
Jun

> 

