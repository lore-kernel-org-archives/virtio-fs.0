Return-Path: <hreitz@redhat.com>
Message-ID: <6f42132a-dd93-40bb-5ee3-7d1a23a4b2e1@redhat.com>
Date: Thu, 20 Jul 2023 13:42:40 +0200
MIME-Version: 1.0
References: <20230712111703.28031-1-hreitz@redhat.com>
 <20230712111703.28031-4-hreitz@redhat.com> <20230718184212.GM44841@fedora>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20230718184212.GM44841@fedora>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v2 3/4] vhost: Add high-level state
 save/load functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, "Michael S . Tsirkin" <mst@redhat.com>, German Maglione <gmaglione@redhat.com>, =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>

On 18.07.23 20:42, Stefan Hajnoczi wrote:
> On Wed, Jul 12, 2023 at 01:17:01PM +0200, Hanna Czenczek wrote:
>> vhost_save_backend_state() and vhost_load_backend_state() can be used by
>> vhost front-ends to easily save and load the back-end's state to/from
>> the migration stream.
>>
>> Because we do not know the full state size ahead of time,
>> vhost_save_backend_state() simply reads the data in 1 MB chunks, and
>> writes each chunk consecutively into the migration stream, prefixed by
>> its length.  EOF is indicated by a 0-length chunk.
>>
>> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
>> ---
>>   include/hw/virtio/vhost.h |  35 +++++++
>>   hw/virtio/vhost.c         | 204 ++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 239 insertions(+)
>>
>> diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
>> index d8877496e5..0c282abd4e 100644
>> --- a/include/hw/virtio/vhost.h
>> +++ b/include/hw/virtio/vhost.h
>> @@ -425,4 +425,39 @@ int vhost_set_device_state_fd(struct vhost_dev *dev,
>>    */
>>   int vhost_check_device_state(struct vhost_dev *dev, Error **errp);
>>   
>> +/**
>> + * vhost_save_backend_state(): High-level function to receive a vhost
>> + * back-end's state, and save it in `f`.  Uses
> I think the GtkDoc syntax is @f instead of `f`.

OK, I’ll fix the parameter name references!

>> + * `vhost_set_device_state_fd()` to get the data from the back-end, and
>> + * stores it in consecutive chunks that are each prefixed by their
>> + * respective length (be32).  The end is marked by a 0-length chunk.
>> + *
>> + * Must only be called while the device and all its vrings are stopped
>> + * (`VHOST_TRANSFER_STATE_PHASE_STOPPED`).
>> + *
>> + * @dev: The vhost device from which to save the state
>> + * @f: Migration stream in which to save the state
>> + * @errp: Potential error message
>> + *
>> + * Returns 0 on success, and -errno otherwise.
>> + */
>> +int vhost_save_backend_state(struct vhost_dev *dev, QEMUFile *f, Error **errp);
>> +
>> +/**
>> + * vhost_load_backend_state(): High-level function to load a vhost
>> + * back-end's state from `f`, and send it over to the back-end.  Reads
>> + * the data from `f` in the format used by `vhost_save_state()`, and
>> + * uses `vhost_set_device_state_fd()` to transfer it to the back-end.
>> + *
>> + * Must only be called while the device and all its vrings are stopped
>> + * (`VHOST_TRANSFER_STATE_PHASE_STOPPED`).
>> + *
>> + * @dev: The vhost device to which to send the sate
>> + * @f: Migration stream from which to load the state
>> + * @errp: Potential error message
>> + *
>> + * Returns 0 on success, and -errno otherwise.
>> + */
>> +int vhost_load_backend_state(struct vhost_dev *dev, QEMUFile *f, Error **errp);
>> +
>>   #endif
>> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
>> index 756b6d55a8..332d49a310 100644
>> --- a/hw/virtio/vhost.c
>> +++ b/hw/virtio/vhost.c
>> @@ -2128,3 +2128,207 @@ int vhost_check_device_state(struct vhost_dev *dev, Error **errp)
>>                  "vhost transport does not support migration state transfer");
>>       return -ENOSYS;
>>   }
>> +
>> +int vhost_save_backend_state(struct vhost_dev *dev, QEMUFile *f, Error **errp)
>> +{
>> +    /* Maximum chunk size in which to transfer the state */
>> +    const size_t chunk_size = 1 * 1024 * 1024;
>> +    void *transfer_buf = NULL;
>> +    g_autoptr(GError) g_err = NULL;
>> +    int pipe_fds[2], read_fd = -1, write_fd = -1, reply_fd = -1;
>> +    int ret;
>> +
>> +    /* [0] for reading (our end), [1] for writing (back-end's end) */
>> +    if (!g_unix_open_pipe(pipe_fds, FD_CLOEXEC, &g_err)) {
>> +        error_setg(errp, "Failed to set up state transfer pipe: %s",
>> +                   g_err->message);
>> +        ret = -EINVAL;
>> +        goto fail;
>> +    }
>> +
>> +    read_fd = pipe_fds[0];
>> +    write_fd = pipe_fds[1];
>> +
>> +    /*
>> +     * VHOST_TRANSFER_STATE_PHASE_STOPPED means the device must be stopped.
>> +     * We cannot check dev->suspended, because the back-end may not support
>> +     * suspending.
>> +     */
>> +    assert(!dev->started);
>> +
>> +    /* Transfer ownership of write_fd to the back-end */
>> +    ret = vhost_set_device_state_fd(dev,
>> +                                    VHOST_TRANSFER_STATE_DIRECTION_SAVE,
>> +                                    VHOST_TRANSFER_STATE_PHASE_STOPPED,
>> +                                    write_fd,
>> +                                    &reply_fd,
>> +                                    errp);
>> +    if (ret < 0) {
>> +        error_prepend(errp, "Failed to initiate state transfer: ");
>> +        goto fail;
>> +    }
>> +
>> +    /* If the back-end wishes to use a different pipe, switch over */
>> +    if (reply_fd >= 0) {
>> +        close(read_fd);
>> +        read_fd = reply_fd;
>> +    }
>> +
>> +    transfer_buf = g_malloc(chunk_size);
>> +
>> +    while (true) {
>> +        ssize_t read_ret;
>> +
>> +        read_ret = read(read_fd, transfer_buf, chunk_size);
>> +        if (read_ret < 0) {
> Is it necessary to handle -EINTR?

Yes, indeed, I do believe so.  I’ll wrap this and the write() in 
RETRY_ON_EINTR().

Hanna

