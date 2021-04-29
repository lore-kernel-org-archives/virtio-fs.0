Date: Thu, 29 Apr 2021 16:48:19 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YIrVQ8TUkgropuOw@work-vm>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-7-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428110100.27757-7-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 06/26] DAX subprojects/libvhost-user: Add
 virtio-fs slave types
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, groug@kaod.org, chirantan@chromium.org
Cc: virtio-fs@redhat.com

* Dr. David Alan Gilbert (git) (dgilbert@redhat.com) wrote:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> 
> Add virtio-fs definitions to libvhost-user
> 
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

I'm going to need to rework this

> +/* Structures carried over the slave channel back to QEMU */
> +#define VHOST_USER_FS_SLAVE_MAX_ENTRIES 32
> +
> +/* For the flags field of VhostUserFSSlaveMsg */
> +#define VHOST_USER_FS_FLAG_MAP_R (1u << 0)
> +#define VHOST_USER_FS_FLAG_MAP_W (1u << 1)
> +
> +typedef struct {
> +    /* Offsets within the file being mapped */
> +    uint64_t fd_offset;
> +    /* Offsets within the cache */
> +    uint64_t c_offset;
> +    /* Lengths of sections */
> +    uint64_t len;
> +    /* Flags, from VHOST_USER_FS_FLAG_* */
> +    uint64_t flags;
> +} VhostUserFSSlaveMsgEntry;
> +
> +typedef struct {
> +    /* Number of entries */
> +    uint16_t count;
> +    /* Spare */
> +    uint16_t align;
> +
> +    VhostUserFSSlaveMsgEntry entries[];
> +} VhostUserFSSlaveMsg;
> +
>  typedef struct VhostUserMemoryRegion {
>      uint64_t guest_phys_addr;
>      uint64_t memory_size;
> @@ -197,6 +224,7 @@ typedef struct VhostUserMsg {
>          VhostUserConfig config;
>          VhostUserVringArea area;
>          VhostUserInflight inflight;
> +        VhostUserFSSlaveMsg fs;
>      } payload;
>  
>      int fds[VHOST_MEMORY_BASELINE_NREGIONS];

This fails Clang's build; because 'fs' is part of a union and
given it's entries[] is a variable length type, and is not
at the end of the union.   It's got a good point - I really don't know
how gcc copes here; but also, what are vhost-user's rules
on the length of 'payload' - it looks like me putting
a larger message in there will break other demons.

I'd changed it from a fixed size array to variable size based
on Chirantan's comments on v1; but now I'm not even convinced
the fixed size was right, given that I'm not convinced I'm
allowed to change the length of payload.

Dave

> @@ -693,4 +721,16 @@ void vu_queue_get_avail_bytes(VuDev *vdev, VuVirtq *vq, unsigned int *in_bytes,
>  bool vu_queue_avail_bytes(VuDev *dev, VuVirtq *vq, unsigned int in_bytes,
>                            unsigned int out_bytes);
>  
> +/**
> + * vu_fs_cache_request: Send a slave message for an fs client
> + * @dev: a VuDev context
> + * @req: The request type (map, unmap, sync)
> + * @fd: an fd (only required for map, else must be -1)
> + * @fsm: The body of the message
> + *
> + * Returns: 0 or above for success, nevative errno on error
> + */
> +int64_t vu_fs_cache_request(VuDev *dev, VhostUserSlaveRequest req, int fd,
> +                            VhostUserFSSlaveMsg *fsm);
> +
>  #endif /* LIBVHOST_USER_H */
> -- 
> 2.31.1
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

