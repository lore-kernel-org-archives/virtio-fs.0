Date: Thu, 18 Nov 2021 09:46:06 -0600
From: Eric Blake <eblake@redhat.com>
Message-ID: <20211118154606.6mt73we5obw6pvav@redhat.com>
References: <20211118144317.4106651-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211118144317.4106651-1-philmd@redhat.com>
Subject: Re: [Virtio-fs] [PATCH-for-6.2?] docs: Render binary names as
	monospaced text
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>, John G Johnson <john.g.johnson@oracle.com>, Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>, Jagannathan Raman <jag.raman@oracle.com>, qemu-block@nongnu.org, Niek Linnenbank <nieklinnenbank@gmail.com>, qemu-devel@nongnu.org, Elena Ufimtseva <elena.ufimtseva@oracle.com>, virtio-fs@redhat.com, Hanna Reitz <hreitz@redhat.com>, qemu-arm@nongnu.org, Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>

On Thu, Nov 18, 2021 at 03:43:17PM +0100, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---

> +++ b/docs/about/removed-features.rst
> @@ -658,8 +658,8 @@ enforce that any failure to open the backing image (including if the
>  backing file is missing or an incorrect format was specified) is an
>  error when ``-u`` is not used.
>  
> -qemu-img amend to adjust backing file (removed in 6.1)
> -''''''''''''''''''''''''''''''''''''''''''''''''''''''
> +``qemu-img`` amend to adjust backing file (removed in 6.1)
> +''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Why quote just qemu-img here,

>  
>  The use of ``qemu-img amend`` to modify the name or format of a qcow2

when the context is obvious that it is the 'qemu-img amend' subcommand?

>  backing image was never fully documented or tested, and interferes
> @@ -670,8 +670,8 @@ backing chain should be performed with ``qemu-img rebase -u`` either
>  before or after the remaining changes being performed by amend, as
>  appropriate.
>  
> -qemu-img backing file without format (removed in 6.1)
> -'''''''''''''''''''''''''''''''''''''''''''''''''''''
> +``qemu-img`` backing file without format (removed in 6.1)
> +'''''''''''''''''''''''''''''''''''''''''''''''''''''''''

This one makes sense, though, as "backing" is not a qemu-img subcommand.

>  
>  The use of ``qemu-img create``, ``qemu-img rebase``, or ``qemu-img
>  convert`` to create or modify an image that depends on a backing file
> diff --git a/docs/devel/build-system.rst b/docs/devel/build-system.rst
> index 7a83f5fc0db..431caba7aa0 100644
> --- a/docs/devel/build-system.rst
> +++ b/docs/tools/qemu-nbd.rst
> @@ -38,7 +38,7 @@ driver options if ``--image-opts`` is specified.
>    supported. The common object types that it makes sense to define are the
>    ``secret`` object, which is used to supply passwords and/or encryption
>    keys, and the ``tls-creds`` object, which is used to supply TLS
> -  credentials for the qemu-nbd server or client.
> +  credentials for the ``qemu-nbd`` server or client.
>  
>  .. option:: -p, --port=PORT
>  
> @@ -238,7 +238,7 @@ daemon:
>  Expose the guest-visible contents of a qcow2 file via a block device
>  /dev/nbd0 (and possibly creating /dev/nbd0p1 and friends for
>  partitions found within), then disconnect the device when done.
> -Access to bind qemu-nbd to an /dev/nbd device generally requires root
> +Access to bind ``qemu-nbd`` to an /dev/nbd device generally requires root

As long as you're touching this line, s/an/a/.

>  privileges, and may also require the execution of ``modprobe nbd``
>  to enable the kernel NBD client module.  *CAUTION*: Do not use
>  this method to mount filesystems from an untrusted guest image - a

Overall looks like a nice changeset.

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3266
Virtualization:  qemu.org | libvirt.org

