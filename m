References: <20210604161337.16048-1-mreitz@redhat.com>
	<20210604161337.16048-9-mreitz@redhat.com> <YL9J2Oyjq2ok0/BM@work-vm>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <92ba88d8-46f3-ffd5-8a22-0c44f40bcc73@redhat.com>
Date: Tue, 8 Jun 2021 13:05:20 +0200
MIME-Version: 1.0
In-Reply-To: <YL9J2Oyjq2ok0/BM@work-vm>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH 8/9] virtiofsd: Optionally fill
	lo_inode.fhandle
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On 08.06.21 12:43, Dr. David Alan Gilbert wrote:
> * Max Reitz (mreitz@redhat.com) wrote:
>> When the inode_file_handles option is set, try to generate a file handle
>> for new inodes instead of opening an O_PATH FD.
>>
>> Being able to open these again will require CAP_DAC_READ_SEARCH, so the
>> description text tells the user they will also need to specify
>> -o modcaps=+dac_read_search.
>>
>> Generating a file handle returns the mount ID it is valid for.  Opening
>> it will require an FD instead.  We have mount_fds to map an ID to an FD.
>> get_file_handle() fills the hash map by opening the file we have
>> generated a handle for.  To verify that the resulting FD indeed
>> represents the handle's mount ID, we use statx().  Therefore, using file
>> handles requires statx() support.
>>
>> Signed-off-by: Max Reitz <mreitz@redhat.com>
>> ---
>>   tools/virtiofsd/helper.c              |   3 +
>>   tools/virtiofsd/passthrough_ll.c      | 170 ++++++++++++++++++++++++--
>>   tools/virtiofsd/passthrough_seccomp.c |   1 +
>>   3 files changed, 165 insertions(+), 9 deletions(-)
>>
>> diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
>> index 5e98ed702b..954f8639e6 100644
>> --- a/tools/virtiofsd/helper.c
>> +++ b/tools/virtiofsd/helper.c
>> @@ -186,6 +186,9 @@ void fuse_cmdline_help(void)
>>              "                               to virtiofsd from guest applications.\n"
>>              "                               default: no_allow_direct_io\n"
>>              "    -o announce_submounts      Announce sub-mount points to the guest\n"
>> +           "    -o inode_file_handles      Use file handles to reference inodes\n"
>> +           "                               instead of O_PATH file descriptors\n"
>> +           "                               (requires -o modcaps=+dac_read_search)\n"
>>              );
>>   }
>>   
>> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
>> index 793d2c333e..d01f9d3a59 100644
>> --- a/tools/virtiofsd/passthrough_ll.c
>> +++ b/tools/virtiofsd/passthrough_ll.c
>> @@ -190,6 +190,7 @@ struct lo_data {
>>       /* An O_PATH file descriptor to /proc/self/fd/ */
>>       int proc_self_fd;
>>       int user_killpriv_v2, killpriv_v2;
>> +    int inode_file_handles;
>>   };
>>   
>>   /**
>> @@ -244,6 +245,10 @@ static const struct fuse_opt lo_opts[] = {
>>       { "announce_submounts", offsetof(struct lo_data, announce_submounts), 1 },
>>       { "killpriv_v2", offsetof(struct lo_data, user_killpriv_v2), 1 },
>>       { "no_killpriv_v2", offsetof(struct lo_data, user_killpriv_v2), 0 },
>> +    { "inode_file_handles", offsetof(struct lo_data, inode_file_handles), 1 },
>> +    { "no_inode_file_handles",
>> +      offsetof(struct lo_data, inode_file_handles),
>> +      0 },
>>       FUSE_OPT_END
>>   };
>>   static bool use_syslog = false;
>> @@ -315,6 +320,108 @@ static int temp_fd_steal(TempFd *temp_fd)
>>       }
>>   }
>>   
>> +/**
>> + * Generate a file handle for the given dirfd/name combination.
>> + *
>> + * If mount_fds does not yet contain an entry for the handle's mount
>> + * ID, (re)open dirfd/name in O_RDONLY mode and add it to mount_fds
>> + * as the FD for that mount ID.  (That is the file that we have
>> + * generated a handle for, so it should be representative for the
>> + * mount ID.  However, to be sure (and to rule out races), we use
>> + * statx() to verify that our assumption is correct.)
>> + */
>> +static struct lo_fhandle *get_file_handle(struct lo_data *lo,
>> +                                          int dirfd, const char *name)
>> +{
>> +    /* We need statx() to verify the mount ID */
>> +#if defined(CONFIG_STATX) && defined(STATX_MNT_ID)
>> +    struct lo_fhandle *fh;
>> +    int ret;
>> +
>> +    if (!lo->use_statx || !lo->inode_file_handles) {
>> +        return NULL;
>> +    }
>> +
>> +    fh = g_new0(struct lo_fhandle, 1);
>> +
>> +    fh->handle.handle_bytes = sizeof(fh->padding) - sizeof(fh->handle);
>> +    ret = name_to_handle_at(dirfd, name, &fh->handle, &fh->mount_id,
>> +                            AT_EMPTY_PATH);
>> +    if (ret < 0) {
>> +        goto fail;
>> +    }
>> +
>> +    if (pthread_rwlock_rdlock(&mount_fds_lock)) {
>> +        goto fail;
>> +    }
>> +    if (!g_hash_table_contains(mount_fds, GINT_TO_POINTER(fh->mount_id))) {
>> +        struct statx stx;
>> +        int fd;
>> +
>> +        pthread_rwlock_unlock(&mount_fds_lock);
>> +
>> +        if (name[0]) {
>> +            fd = openat(dirfd, name, O_RDONLY);
> But can't that be a device file or other special file that you must not
> open?

Yes. So I think the right thing to do here is to use O_PATH (which 
should be safe), then statx() to find out what we need to know (now not 
only the mount ID, but the file type, too), and if it’s safe, we can 
then openat(proc_self_fd, str(fd), O_RDONLY) (and close the O_PATH fd).

If it isn’t safe, we just return an error, and the inode gets an O_PATH fd.

Max

