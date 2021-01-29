Date: Fri, 29 Jan 2021 10:45:07 +0100
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210129104507.1ade37a7@bahia.lan>
In-Reply-To: <20210125180115.22936-4-vgoyal@redhat.com>
References: <20210125180115.22936-1-vgoyal@redhat.com>
	<20210125180115.22936-4-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 3/6] vhost-user: Return error code from
	slave_read()
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

On Mon, 25 Jan 2021 13:01:12 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

> Right now slave_read() is called through main event loop and does not
> return error. In next few patches I want to call slave_read() from
> vhost device shutdown path as well and want to know if an error
> happened so that caller can give up and return error accordingly.
> 
> Hence, create helper function do_slave_read(), which returns an
> integer. Success is 0 and negative number is error code. slave_read()
> calls do_slave_read() and ignores error code.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  hw/virtio/vhost-user.c | 43 ++++++++++++++++++++++++++++++++++++------
>  1 file changed, 37 insertions(+), 6 deletions(-)
> 
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index d95dbc39e3..867cac034f 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -1401,7 +1401,7 @@ static uint64_t vhost_user_slave_handle_vring_host_notifier(
>      return false;
>  }
>  
> -static void slave_read(void *opaque)
> +static int do_slave_read(void *opaque)
>  {
>      struct vhost_dev *dev = opaque;
>      struct vhost_user *u = dev->opaque;
> @@ -1432,13 +1432,22 @@ static void slave_read(void *opaque)
>          size = recvmsg(u->slave_fd, &msgh, 0);
>      } while (size < 0 && (errno == EINTR || errno == EAGAIN));
>  
> -    if (size != VHOST_USER_HDR_SIZE) {
> +    if (size < 0) {
> +        ret = -errno;
>          error_report("Failed to read from slave.");
>          goto err;
>      }
>  
> +    if (size != VHOST_USER_HDR_SIZE) {
> +        error_report("Failed to read %lu bytes from slave.",
> +                     VHOST_USER_HDR_SIZE);

Maybe also print size ?

And, question from a newbie : any idea why short reads are
considered as errors instead of retrying ? Same question
stands for the other locations where we check the numbers
of read/written bytes in this function.

> +        ret = -EBADMSG;
> +        goto err;
> +    }
> +
>      if (msgh.msg_flags & MSG_CTRUNC) {
>          error_report("Truncated message.");
> +        ret = -EBADMSG;
>          goto err;
>      }
>  
> @@ -1456,6 +1465,7 @@ static void slave_read(void *opaque)
>          error_report("Failed to read msg header."
>                  " Size %d exceeds the maximum %zu.", hdr.size,
>                  VHOST_USER_PAYLOAD_SIZE);
> +        ret = -EBADMSG;
>          goto err;
>      }
>  
> @@ -1464,8 +1474,15 @@ static void slave_read(void *opaque)
>          size = read(u->slave_fd, &payload, hdr.size);
>      } while (size < 0 && (errno == EINTR || errno == EAGAIN));
>  
> -    if (size != hdr.size) {
> +    if (size == -1) {

Maybe make it (size < 0) for consistency with the error checking
added above ? And this seems to be the preferred way in the QEMU
tree :)

>          error_report("Failed to read payload from slave.");
> +        ret = errno;

    ret = -errno;

And this should be done before error_report() to ensure errno
isn't cloberred.

> +        goto err;
> +    }
> +
> +    if (size != hdr.size) {
> +        error_report("Failed to read %d payload bytes from slave.", hdr.size);
> +        ret = -EBADMSG;
>          goto err;
>      }
>  
> @@ -1529,13 +1546,22 @@ static void slave_read(void *opaque)
>              size = writev(u->slave_fd, iovec, ARRAY_SIZE(iovec));
>          } while (size < 0 && (errno == EINTR || errno == EAGAIN));
>  
> -        if (size != VHOST_USER_HDR_SIZE + hdr.size) {
> +        if (size == -1) {

size < 0

>              error_report("Failed to send msg reply to slave.");
> +            ret = -errno;

Move before error_report()

> +            goto err;
> +        }
> +
> +        if (size != VHOST_USER_HDR_SIZE + hdr.size) {
> +            error_report("Failed to send msg reply to slave. Wrote %d bytes"
> +                         " expected %lu bytes.", size,
> +                         VHOST_USER_HDR_SIZE + hdr.size);
> +            ret = -EIO;
>              goto err;
>          }
>      }
>  
> -    return;
> +    return 0;
>  
>  err:
>      qemu_set_fd_handler(u->slave_fd, NULL, NULL, NULL);
> @@ -1546,7 +1572,12 @@ err:
>              close(fd[i]);
>          }
>      }
> -    return;
> +    return ret;
> +}
> +
> +static void slave_read(void *opaque)
> +{
> +    do_slave_read(opaque);
>  }
>  
>  static int vhost_setup_slave_channel(struct vhost_dev *dev)

