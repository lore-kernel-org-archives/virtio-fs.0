Date: Thu, 27 May 2021 18:44:41 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YK/aiXx52Oe2HV4C@work-vm>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-19-dgilbert@redhat.com>
	<YJQHRwkUhXT+PLtT@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJQHRwkUhXT+PLtT@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH v3 18/26] DAX/unmap: virtiofsd: Add
	VHOST_USER_SLAVE_FS_IO
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Wed, Apr 28, 2021 at 12:00:52PM +0100, Dr. David Alan Gilbert (git) wrote:
> > @@ -220,6 +222,99 @@ uint64_t vhost_user_fs_slave_unmap(struct vhost_dev *dev, int message_size,
> >      return (uint64_t)res;
> >  }
> >  
> > +uint64_t vhost_user_fs_slave_io(struct vhost_dev *dev, int message_size,
> > +                                VhostUserFSSlaveMsg *sm, int fd)
> > +{
> > +    VHostUserFS *fs = (VHostUserFS *)object_dynamic_cast(OBJECT(dev->vdev),
> > +                          TYPE_VHOST_USER_FS);
> > +    if (!fs) {
> > +        error_report("%s: Bad fs ptr", __func__);
> > +        return (uint64_t)-1;
> > +    }
> > +    if (!check_slave_message_entries(sm, message_size)) {
> > +        return (uint64_t)-1;
> > +    }
> 
> These early error returns don't close(fd).

(as per followup, we don't need it and it's removed)

> > +
> > +    unsigned int i;
> > +    int res = 0;
> > +    size_t done = 0;
> > +
> > +    if (fd < 0) {
> > +        error_report("Bad fd for io");
> > +        return (uint64_t)-1;
> > +    }
> > +
> > +    for (i = 0; i < sm->count && !res; i++) {
> > +        VhostUserFSSlaveMsgEntry *e = &sm->entries[i];
> > +        if (e->len == 0) {
> > +            continue;
> > +        }
> > +
> > +        size_t len = e->len;
> > +        uint64_t fd_offset = e->fd_offset;
> > +        hwaddr gpa = e->c_offset;
> > +
> > +        while (len && !res) {
> > +            hwaddr xlat, xlat_len;
> > +            bool is_write = e->flags & VHOST_USER_FS_FLAG_MAP_W;
> > +            MemoryRegion *mr = address_space_translate(dev->vdev->dma_as, gpa,
> > +                                                       &xlat, &xlat_len,
> > +                                                       is_write,
> > +                                                       MEMTXATTRS_UNSPECIFIED);
> > +            if (!mr || !xlat_len) {
> > +                error_report("No guest region found for 0x%" HWADDR_PRIx, gpa);
> > +                res = -EFAULT;
> > +                break;
> > +            }
> > +
> > +            trace_vhost_user_fs_slave_io_loop(mr->name,
> > +                                          (uint64_t)xlat,
> > +                                          memory_region_is_ram(mr),
> > +                                          memory_region_is_romd(mr),
> > +                                          (size_t)xlat_len);
> > +
> > +            void *hostptr = qemu_map_ram_ptr(mr->ram_block,
> > +                                             xlat);
> > +            ssize_t transferred;
> 
> What happens when the MemoryRegion is not backed by RAM?

I've added a check for mr->ramblock being non-null that I think covers
it.

> > +            if (e->flags & VHOST_USER_FS_FLAG_MAP_R) {
> > +                /* Read from file into RAM */
> > +                if (mr->readonly) {
> > +                    res = -EFAULT;
> > +                    break;
> > +                }
> > +                transferred = pread(fd, hostptr, xlat_len, fd_offset);
> > +            } else if (e->flags & VHOST_USER_FS_FLAG_MAP_W) {
> > +                /* Write into file from RAM */
> > +                transferred = pwrite(fd, hostptr, xlat_len, fd_offset);
> > +            } else {
> > +                transferred = EINVAL;
> 
> I don't see how this is handled below by the error checking code. Should
> this be:
> 
>   errno = EINVAL;
>   transferred = -1;
> 
> ?

Thanks; I've gone with  res = - EINVAL; break;

Dave

> 
> > +            }
> > +
> > +            trace_vhost_user_fs_slave_io_loop_res(transferred);
> > +            if (transferred < 0) {
> > +                res = -errno;
> > +                break;
> > +            }
> > +            if (!transferred) {
> > +                /* EOF */
> > +                break;
> > +            }
> > +
> > +            done += transferred;
> > +            fd_offset += transferred;
> > +            gpa += transferred;
> > +            len -= transferred;
> > +        }
> > +    }
> > +    close(fd);
> > +
> > +    trace_vhost_user_fs_slave_io_exit(res, done);
> > +    if (res < 0) {
> > +        return (uint64_t)res;
> > +    }
> > +    return (uint64_t)done;
> > +}


-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

