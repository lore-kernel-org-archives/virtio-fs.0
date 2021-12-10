Message-ID: <d8449b45-c0db-266e-ff4d-885e931c5652@linux.alibaba.com>
Date: Fri, 10 Dec 2021 11:13:06 +0800
MIME-Version: 1.0
References: <20211102055646.103337-1-jefflexu@linux.alibaba.com>
	<20211102055646.103337-6-jefflexu@linux.alibaba.com>
	<YbJkB/11x/Wq6lHS@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
In-Reply-To: <YbJkB/11x/Wq6lHS@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v7 5/6] virtiofsd: implement xflag based dax
	policy
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



On 12/10/21 4:16 AM, Vivek Goyal wrote:
> On Tue, Nov 02, 2021 at 01:56:45PM +0800, Jeffle Xu wrote:
>> The per inode DAX feature in ext4/xfs uses the persistent inode flag,
>> i.e. FS_DAX_FL/FS_XFLAG_DAX, to indicate if DAX shall be enabled for
>> this file or not when filesystem is mounted in per inode DAX mode.
>>
>> To keep compatible with this feature in ext4/xfs, virtiofs also supports
>> enabling DAX depending on the persistent inode flag, which may be
>> set/cleared by users inside guest or admin on host.
>>
>> This policy is used when '-o dax=inode' option is specified for
>> virtiofsd.
>>
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>> ---
>>  tools/virtiofsd/passthrough_ll.c | 33 ++++++++++++++++++++++++++++++++
>>  1 file changed, 33 insertions(+)
>>
>> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
>> index 999c906da2..dac5063594 100644
>> --- a/tools/virtiofsd/passthrough_ll.c
>> +++ b/tools/virtiofsd/passthrough_ll.c
>> @@ -1026,6 +1026,35 @@ static int do_statx(struct lo_data *lo, int dirfd, const char *pathname,
>>      return 0;
>>  }
>>  
>> +static bool lo_should_enable_dax(struct lo_data *lo, struct lo_inode *inode,
>> +                                 struct fuse_entry_param *e)
>> +{
>> +    if (lo->dax == INODE_DAX_NONE || !S_ISREG(e->attr.st_mode)) {
>> +        return false;
>> +    }
>> +
>> +    if (lo->dax == INODE_DAX_INODE) {
>> +        int res, fd;
>> +        int ret = false;
>> +        unsigned int attr;
>> +
>> +        fd = lo_inode_open(lo, inode, O_RDONLY);
>> +        if (fd == -1) {
>> +            return false;
>> +        }
> 
> So we can't call this ioctl() on an O_PATH fd, and that's why you
> are opening the file O_RDONLY?

Yes. We can't call ioctl() on O_PATH fd, so lo_inode_open() is needed;
we only need to query the file flag, thus O_RDONLY is adequate.

> 
> Concerned about error handling. If we fail to open file, you are
> not returning error to client. Instead simply falling back to
> not enabling DAX (and hiding an error in the process).
> 
> I am not sure about this fallback behavior. I would rather capture
> error and return to client. A user has configured system to
> enable DAX on inode and if we can't open that inode or can't
> query the state of FS_XFLAG_DAX, then its an error and should
> be reported back.

OK, just report an error to make the error handling consistent.

> 
>> +
>> +        res = ioctl(fd, FS_IOC_GETFLAGS, &attr);
>> +        if (!res && (attr & FS_DAX_FL)) {
>> +            ret = true;
>> +        }
> 
> Same here. What if ioctl() fails. Shouldn't we return error to
> caller? That way if there is something wrong with configuration,
> user can fix it. (Instead of silently not enabling DAX).
> 

-- 
Thanks,
Jeffle

