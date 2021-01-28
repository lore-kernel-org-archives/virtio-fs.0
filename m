Date: Thu, 28 Jan 2021 16:06:25 +0100
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210128160625.45cf09fc@bahia.lan>
In-Reply-To: <20210128144835.GA3342@redhat.com>
References: <20210125180115.22936-1-vgoyal@redhat.com>
	<20210125180115.22936-3-vgoyal@redhat.com>
	<20210128153123.4aba231c@bahia.lan>
	<20210128144835.GA3342@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 2/6] libvhost-user: Use slave_mutex in all
 slave messages
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: mst@redhat.com, qemu-devel@nongnu.org, virtio-fs@redhat.com, marcandre.lureau@redhat.com

On Thu, 28 Jan 2021 09:48:35 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Thu, Jan 28, 2021 at 03:31:23PM +0100, Greg Kurz wrote:
> > On Mon, 25 Jan 2021 13:01:11 -0500
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > dev->slave_mutex needs to be taken when sending messages on slave_fd.
> > > Currently _vu_queue_notify() does not do that.
> > > 
> > > Introduce a helper vu_message_slave_send_receive() which sends as well
> > > as receive response. Use this helper in all the paths which send
> > > message on slave_fd channel.
> > > 
> > 
> > Does this fix any known bug ?
> 
> I am not aware of any bug. This fix is based on code inspection.
> 
> Also I wanted a central place/function to send messages on slave channel
> so that I can check state of slave channel (open/close) and act
> accordingly. Otherwise I will have to do the check at every place
> which is trying to send/receive message on slave channel.
> 

Makes sense. Thanks for the clarification.

> Vivek
> 
> > 
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > ---
> > 
> > LGTM
> > 
> > Reviewed-by: Greg Kurz <groug@kaod.org>
> > 
> > >  subprojects/libvhost-user/libvhost-user.c | 50 ++++++++++++-----------
> > >  1 file changed, 27 insertions(+), 23 deletions(-)
> > > 
> > > diff --git a/subprojects/libvhost-user/libvhost-user.c b/subprojects/libvhost-user/libvhost-user.c
> > > index 4cf4aef63d..7a56c56dc8 100644
> > > --- a/subprojects/libvhost-user/libvhost-user.c
> > > +++ b/subprojects/libvhost-user/libvhost-user.c
> > > @@ -403,7 +403,7 @@ vu_send_reply(VuDev *dev, int conn_fd, VhostUserMsg *vmsg)
> > >   * Processes a reply on the slave channel.
> > >   * Entered with slave_mutex held and releases it before exit.
> > >   * Returns true on success.
> > > - * *payload is written on success
> > > + * *payload is written on success, if payload is not NULL.
> > >   */
> > >  static bool
> > >  vu_process_message_reply(VuDev *dev, const VhostUserMsg *vmsg,
> > > @@ -427,7 +427,9 @@ vu_process_message_reply(VuDev *dev, const VhostUserMsg *vmsg,
> > >          goto out;
> > >      }
> > >  
> > > -    *payload = msg_reply.payload.u64;
> > > +    if (payload) {
> > > +        *payload = msg_reply.payload.u64;
> > > +    }
> > >      result = true;
> > >  
> > >  out:
> > > @@ -435,6 +437,25 @@ out:
> > >      return result;
> > >  }
> > >  
> > > +/* Returns true on success, false otherwise */
> > > +static bool
> > > +vu_message_slave_send_receive(VuDev *dev, VhostUserMsg *vmsg, uint64_t *payload)
> > > +{
> > > +    pthread_mutex_lock(&dev->slave_mutex);
> > > +    if (!vu_message_write(dev, dev->slave_fd, vmsg)) {
> > > +        pthread_mutex_unlock(&dev->slave_mutex);
> > > +        return false;
> > > +    }
> > > +
> > > +    if ((vmsg->flags & VHOST_USER_NEED_REPLY_MASK) == 0) {
> > > +        pthread_mutex_unlock(&dev->slave_mutex);
> > > +        return true;
> > > +    }
> > > +
> > > +    /* Also unlocks the slave_mutex */
> > > +    return vu_process_message_reply(dev, vmsg, payload);
> > > +}
> > > +
> > >  /* Kick the log_call_fd if required. */
> > >  static void
> > >  vu_log_kick(VuDev *dev)
> > > @@ -1340,16 +1361,8 @@ bool vu_set_queue_host_notifier(VuDev *dev, VuVirtq *vq, int fd,
> > >          return false;
> > >      }
> > >  
> > > -    pthread_mutex_lock(&dev->slave_mutex);
> > > -    if (!vu_message_write(dev, dev->slave_fd, &vmsg)) {
> > > -        pthread_mutex_unlock(&dev->slave_mutex);
> > > -        return false;
> > > -    }
> > > -
> > > -    /* Also unlocks the slave_mutex */
> > > -    res = vu_process_message_reply(dev, &vmsg, &payload);
> > > +    res = vu_message_slave_send_receive(dev, &vmsg, &payload);
> > >      res = res && (payload == 0);
> > > -
> > >      return res;
> > >  }
> > >  
> > > @@ -2395,10 +2408,7 @@ static void _vu_queue_notify(VuDev *dev, VuVirtq *vq, bool sync)
> > >              vmsg.flags |= VHOST_USER_NEED_REPLY_MASK;
> > >          }
> > >  
> > > -        vu_message_write(dev, dev->slave_fd, &vmsg);
> > > -        if (ack) {
> > > -            vu_message_read_default(dev, dev->slave_fd, &vmsg);
> > > -        }
> > > +        vu_message_slave_send_receive(dev, &vmsg, NULL);
> > >          return;
> > >      }
> > >  
> > > @@ -2942,17 +2952,11 @@ int64_t vu_fs_cache_request(VuDev *dev, VhostUserSlaveRequest req, int fd,
> > >          return -EINVAL;
> > >      }
> > >  
> > > -    pthread_mutex_lock(&dev->slave_mutex);
> > > -    if (!vu_message_write(dev, dev->slave_fd, &vmsg)) {
> > > -        pthread_mutex_unlock(&dev->slave_mutex);
> > > -        return -EIO;
> > > -    }
> > > -
> > > -    /* Also unlocks the slave_mutex */
> > > -    res = vu_process_message_reply(dev, &vmsg, &payload);
> > > +    res = vu_message_slave_send_receive(dev, &vmsg, &payload);
> > >      if (!res) {
> > >          return -EIO;
> > >      }
> > > +
> > >      /*
> > >       * Payload is delivered as uint64_t but is actually signed for
> > >       * errors.
> > 
> 

