References: <5D4A7771.8010207@huawei.com> <20190807154245.GH2867@work-vm>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D4BC0B8.7020106@huawei.com>
Date: Thu, 8 Aug 2019 14:27:04 +0800
MIME-Version: 1.0
In-Reply-To: <20190807154245.GH2867@work-vm>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v2 1/2][RFC] virtiofsd: virtiofsd: add
 definition of fuse_buf_writev()
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

Hi Dave,

As Stefan's suggestion, I make the patch set in one thread [PATCH v3]
which is more convenient for reviewing. Please make comments on the new
patch set if you have any question. I'll be very grateful for your
advice.

Thanks,
Jun

On 2019/8/7 23:42, Dr. David Alan Gilbert wrote:
> * piaojun (piaojun@huawei.com) wrote:
>> Define fuse_buf_writev() which use pwritev and writev to improve io
>> bandwidth.
>>
>> Signed-off-by: Jun Piao <piaojun@huawei.com>
>> Suggested-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
>> ---
>>  contrib/virtiofsd/buffer.c      | 37 +++++++++++++++++++++++++++++++++++++
>>  contrib/virtiofsd/fuse_common.h | 14 ++++++++++++++
>>  contrib/virtiofsd/seccomp.c     |  2 ++
>>  3 files changed, 53 insertions(+)
>>
>> diff --git a/contrib/virtiofsd/buffer.c b/contrib/virtiofsd/buffer.c
>> index 655be137..642830f 100644
>> --- a/contrib/virtiofsd/buffer.c
>> +++ b/contrib/virtiofsd/buffer.c
>> @@ -15,6 +15,7 @@
>>  #include <unistd.h>
>>  #include <errno.h>
>>  #include <assert.h>
>> +#include <stdlib.h>
>>
>>  size_t fuse_buf_size(const struct fuse_bufvec *bufv)
>>  {
>> @@ -71,6 +72,42 @@ static ssize_t fuse_buf_write(const struct fuse_buf *dst, size_t dst_off,
>>  	return copied;
>>  }
>>
>> +ssize_t fuse_buf_writev(fuse_req_t req,
>> +			     struct fuse_bufvec *out_buf,
>> +			     struct fuse_bufvec *in_buf,
>> +			     enum fuse_buf_copy_flags flags)
>> +{
>> +	ssize_t res, i, buf_index, iovcnt;
>> +	struct iovec * iov;
>> +	int fd = out_buf->buf[0].fd;
>> +	off_t pos = out_buf->buf[0].pos;
> 
> That's again assuming that the 'pos' in subsequent elements of out_buf
> is sequential; is it?
> What about any other flags on in_buf?
> 
>> +	if (in_buf->count > 2)
>> +		iovcnt = in_buf->count - 1;
>> +	else
>> +		iovcnt = 1;
>> +
>> +	iov = malloc(iovcnt * sizeof(struct iovec));
> 
> You could use calloc.
> 
>> +	if (!iov)
>> +		return -ENOMEM;
>> +
>> +	for (i = 0, buf_index = 1; i < iovcnt; i++, buf_index++) {
>> +		iov[i].iov_base = in_buf->buf[buf_index].mem;
>> +		iov[i].iov_len = in_buf->buf[buf_index].size;
>> +	}
>> +
>> +	if (flags & FUSE_BUF_FD_SEEK)
>> +		res = pwritev(fd, iov, iovcnt, pos);
>> +	else
>> +		res = writev(fd, iov, iovcnt);
>> +
>> +	if (res == -1 || res == 0)
>> +		res = -errno;
> 
> Does errno get set on a res == 0 ?
> 
> Dave
> 
>> +	free(iov);
>> +	return res;
>> +}
>> +
>>  static ssize_t fuse_buf_read(const struct fuse_buf *dst, size_t dst_off,
>>  			     const struct fuse_buf *src, size_t src_off,
>>  			     size_t len)
>> diff --git a/contrib/virtiofsd/fuse_common.h b/contrib/virtiofsd/fuse_common.h
>> index 001e6d6..7c07da7 100644
>> --- a/contrib/virtiofsd/fuse_common.h
>> +++ b/contrib/virtiofsd/fuse_common.h
>> @@ -730,6 +730,20 @@ ssize_t fuse_buf_copy(fuse_req_t req,
>>  		      enum fuse_buf_copy_flags flags);
>>
>>  /**
>> + * Write data from one buffer vector to another
>> + *
>> + * @param req The request this copy is part of
>> + * @param out_buf destination buffer vector
>> + * @param in_buf source buffer vector
>> + * @param flags flags controlling the copy
>> + * @return actual number of bytes written or -errno on error
>> + */
>> +ssize_t fuse_buf_writev(fuse_req_t req,
>> +		      struct fuse_bufvec *out_buf,
>> +		      struct fuse_bufvec *in_buf,
>> +		      enum fuse_buf_copy_flags flags);
>> +
>> +/**
>>   * Memory buffer iterator
>>   *
>>   */
>> diff --git a/contrib/virtiofsd/seccomp.c b/contrib/virtiofsd/seccomp.c
>> index 5f1c873..4bba30b 100644
>> --- a/contrib/virtiofsd/seccomp.c
>> +++ b/contrib/virtiofsd/seccomp.c
>> @@ -60,6 +60,7 @@ static const int syscall_whitelist[] = {
>>  	SCMP_SYS(ppoll),
>>  	SCMP_SYS(prctl), /* TODO restrict to just PR_SET_NAME? */
>>  	SCMP_SYS(preadv),
>> +	SCMP_SYS(pwritev),
>>  	SCMP_SYS(pwrite64),
>>  	SCMP_SYS(read),
>>  	SCMP_SYS(readlinkat),
>> @@ -78,6 +79,7 @@ static const int syscall_whitelist[] = {
>>  	SCMP_SYS(unlinkat),
>>  	SCMP_SYS(utimensat),
>>  	SCMP_SYS(write),
>> +	SCMP_SYS(writev),
>>  };
>>
>>  /* Syscalls used when --syslog is enabled */
>> -- 
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> .
> 

