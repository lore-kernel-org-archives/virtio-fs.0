Date: Thu, 11 Feb 2021 10:27:01 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210211152701.GC5014@redhat.com>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-2-dgilbert@redhat.com>
	<20210211095936.GB247031@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211095936.GB247031@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 01/24] DAX: vhost-user: Rework slave return
	values
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, mst@redhat.com, qemu-devel@nongnu.org

On Thu, Feb 11, 2021 at 09:59:36AM +0000, Stefan Hajnoczi wrote:
> On Tue, Feb 09, 2021 at 07:02:01PM +0000, Dr. David Alan Gilbert (git) wrote:
> > +static uint64_t vhost_user_slave_handle_vring_host_notifier(
> > +                struct vhost_dev *dev,
> > +               VhostUserVringArea *area,
> > +               int fd)
> 
> Indentation looks off. Only worth changing if you respin.
> 
> > @@ -1398,7 +1399,8 @@ static void slave_read(void *opaque)
> >      struct vhost_user *u = dev->opaque;
> >      VhostUserHeader hdr = { 0, };
> >      VhostUserPayload payload = { 0, };
> > -    int size, ret = 0;
> > +    int size;
> > +    uint64_t ret = 0;
> >      struct iovec iov;
> >      struct msghdr msgh;
> >      int fd[VHOST_USER_SLAVE_MAX_FDS];
> > @@ -1472,7 +1474,7 @@ static void slave_read(void *opaque)
> >          break;
> >      default:
> >          error_report("Received unexpected msg type: %d.", hdr.request);
> > -        ret = -EINVAL;
> > +        ret = (uint64_t)-EINVAL;
> 
> The !!ret was removed below so it would have previously been true (1).
> Now it has changed value.
> 
> If there is no specific reason to change the value, please keep it true
> (1) just in case a vhost-user device backend depends on that value.

Good catch. I guess it will be nice to send -EINVAL back but we probably
can't change it now due to backward compatibility issue. Just in case,
someone is relying on reading back true (instead of -EINVAL).

Vivek

