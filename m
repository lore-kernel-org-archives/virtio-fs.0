Return-Path: <hreitz@redhat.com>
Message-ID: <44fac0de-d651-1b1b-e263-161587c40d3b@redhat.com>
Date: Thu, 13 Apr 2023 11:04:29 +0200
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-4-hreitz@redhat.com> <20230412211447.GD2813183@fedora>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20230412211447.GD2813183@fedora>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 3/4] vhost: Add high-level state save/load
 functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>

On 12.04.23 23:14, Stefan Hajnoczi wrote:
> On Tue, Apr 11, 2023 at 05:05:14PM +0200, Hanna Czenczek wrote:
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
>>   hw/virtio/vhost.c         | 196 ++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 231 insertions(+)
>>
>> diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
>> index 29449e0fe2..d1f1e9e1f3 100644
>> --- a/include/hw/virtio/vhost.h
>> +++ b/include/hw/virtio/vhost.h
>> @@ -425,4 +425,39 @@ int vhost_set_device_state_fd(struct vhost_dev *dev,
>>    */
>>   int vhost_check_device_state(struct vhost_dev *dev, Error **errp);
>>   
>> +/**
>> + * vhost_save_backend_state(): High-level function to receive a vhost
>> + * back-end's state, and save it in `f`.  Uses
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
>> index 90099d8f6a..d08849c691 100644
>> --- a/hw/virtio/vhost.c
>> +++ b/hw/virtio/vhost.c
>> @@ -2125,3 +2125,199 @@ int vhost_check_device_state(struct vhost_dev *dev, Error **errp)
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
>> +    /* VHOST_TRANSFER_STATE_PHASE_STOPPED means the device must be stopped */
>> +    assert(!dev->started && !dev->enable_vqs);
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
>> +            ret = -errno;
>> +            error_setg_errno(errp, -ret, "Failed to receive state");
>> +            goto fail;
>> +        }
>> +
>> +        assert(read_ret <= chunk_size);
>> +        qemu_put_be32(f, read_ret);
>> +
>> +        if (read_ret == 0) {
>> +            /* EOF */
>> +            break;
>> +        }
>> +
>> +        qemu_put_buffer(f, transfer_buf, read_ret);
>> +    }
> I think this synchronous approach with a single contiguous stream of
> chunks is okay for now.
>
> Does this make the QEMU monitor unresponsive if the backend is slow?

Oh, absolutely.  But as far as I can tell that’s also the case if the 
back-end doesn’t respond (or responds slowly) to vhost-user messages, 
because they’re generally sent/received synchronously. (So, notably, 
these synchronous read()/write() calls aren’t worse than the previous 
model of transferring data through shared memory, but awaiting the 
back-end via vhost-user calls between each chunk.)

I don’t know whether it’s even possible to do it better (while keeping 
it all in the switch-over phase).  The VMState functions aren’t 
coroutines or AIO, so I can’t think of a way to improve this.

(Well, except:)

> In the future the interface could be extended to allow participating in
> the iterative phase of migration. Then chunks from multiple backends
> (plus guest RAM) would be interleaved and there would be some
> parallelism.

Sure.  That would also definitely help with an unintentionally slow 
back-end.  If the back-end making qemu unresponsive is a deal-breaker, 
then we’d have to do this now.

Hanna

