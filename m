References: <20210730150134.216126-1-mreitz@redhat.com>
	<20210730150134.216126-3-mreitz@redhat.com>
	<YQ1KCya+NHd96kvv@redhat.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <a9b09a33-b8b6-2e9f-42e9-edefb2459653@redhat.com>
Date: Mon, 9 Aug 2021 12:44:00 +0200
MIME-Version: 1.0
In-Reply-To: <YQ1KCya+NHd96kvv@redhat.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH v3 02/10] virtiofsd: Add TempFd structure
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On 06.08.21 16:41, Vivek Goyal wrote:
> On Fri, Jul 30, 2021 at 05:01:26PM +0200, Max Reitz wrote:
>> We are planning to add file handles to lo_inode objects as an
>> alternative to lo_inode.fd.  That means that everywhere where we
>> currently reference lo_inode.fd, we will have to open a temporary file
>> descriptor that needs to be closed after use.
>>
>> So instead of directly accessing lo_inode.fd, there will be a helper
>> function (lo_inode_fd()) that either returns lo_inode.fd, or opens a new
>> file descriptor with open_by_handle_at().  It encapsulates this result
>> in a TempFd structure to let the caller know whether the FD needs to be
>> closed after use (opened from the handle) or not (copied from
>> lo_inode.fd).
> I am wondering why this notion of "owned". Why not have this requirement
> of always closing "fd". If we copied it from lo_inode.fd, then we will
> need to dup() it. Otherwise we opened it from file handle and we will
> need to close it anyway.
>
> I guess you are trying to avoid having to call dup() and that's why
> this notion of "owned" fd.

Yes, I don’t want to dup() it.  One reason is that I’d rather just not.  
It’s something that we can avoid, and dup-ing every time wouldn’t make 
the code that much simpler (I think, without having tried).

One other is because this affects the current behavior (with O_PATH 
FDs), which I don’t want to alter.

Well, and finally, as a pragmatic reason, virtiofsd-rs uses the same 
structure and I don’t really want C virtiofsd and virtiofsd-rs to differ 
too much.

>> By using g_auto(TempFd) to store this result, callers will not even have
>> to care about closing a temporary FD after use.  It will be done
>> automatically once the object goes out of scope.
>>
>> Signed-off-by: Max Reitz <mreitz@redhat.com>
>> Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
>> ---
>>   tools/virtiofsd/passthrough_ll.c | 49 ++++++++++++++++++++++++++++++++
>>   1 file changed, 49 insertions(+)
>>
>> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
>> index 1f27eeabc5..fb5e073e6a 100644
>> --- a/tools/virtiofsd/passthrough_ll.c
>> +++ b/tools/virtiofsd/passthrough_ll.c
>> @@ -178,6 +178,28 @@ struct lo_data {
>>       int user_posix_acl, posix_acl;
>>   };
>>   
>> +/**
>> + * Represents a file descriptor that may either be owned by this
>> + * TempFd, or only referenced (i.e. the ownership belongs to some
>> + * other object, and the value has just been copied into this TempFd).
>> + *
>> + * The purpose of this encapsulation is to be used as g_auto(TempFd)
>> + * to automatically clean up owned file descriptors when this object
>> + * goes out of scope.
>> + *
>> + * Use temp_fd_steal() to get an owned file descriptor that will not
>> + * be closed when the TempFd goes out of scope.
>> + */
>> +typedef struct {
>> +    int fd;
>> +    bool owned; /* fd owned by this object? */
>> +} TempFd;
>> +
>> +#define TEMP_FD_INIT ((TempFd) { .fd = -1, .owned = false })
>> +
>> +static void temp_fd_clear(TempFd *temp_fd);
>> +G_DEFINE_AUTO_CLEANUP_CLEAR_FUNC(TempFd, temp_fd_clear);
>> +
>>   static const struct fuse_opt lo_opts[] = {
>>       { "sandbox=namespace",
>>         offsetof(struct lo_data, sandbox),
>> @@ -255,6 +277,33 @@ static struct lo_data *lo_data(fuse_req_t req)
>>       return (struct lo_data *)fuse_req_userdata(req);
>>   }
>>   
>> +/**
>> + * Clean-up function for TempFds
>> + */
>> +static void temp_fd_clear(TempFd *temp_fd)
>> +{
>> +    if (temp_fd->owned) {
>> +        close(temp_fd->fd);
>> +        *temp_fd = TEMP_FD_INIT;
>> +    }
>> +}
>> +
>> +/**
>> + * Return an owned fd from *temp_fd that will not be closed when
>> + * *temp_fd goes out of scope.
>> + *
>> + * (TODO: Remove __attribute__ once this is used.)
>> + */
>> +static __attribute__((unused)) int temp_fd_steal(TempFd *temp_fd)
>> +{
>> +    if (temp_fd->owned) {
>> +        temp_fd->owned = false;
>> +        return temp_fd->fd;
>> +    } else {
>> +        return dup(temp_fd->fd);
>> +    }
>> +}
> This also will be simpler if we always called dup() and every caller
> will close() fd.
>
> I think only downside is having to call dup()/close(). Not sure if this
> is an expensive operation or not.
>
> Vivek
>

