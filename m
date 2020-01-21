MIME-Version: 1.0
References: <20191213175733.txnfv6bxxf4vauzb@gabell>
	<20191216145458.GB6106@redhat.com>
	<20191217210225.tnnudbdbxgxee7oh@gabell>
In-Reply-To: <20191217210225.tnnudbdbxgxee7oh@gabell>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Tue, 21 Jan 2020 09:37:16 +0100
Message-ID: <CAOssrKde+4QTxBW8=SHhUvDQC0kdUJu++GEq5H9xLbP5SVeMzA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] Question: atime update behavior of virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Tue, Dec 17, 2019 at 10:02 PM Masayoshi Mizuma <msys.mizuma@gmail.com> wrote:

> I created a patch for virtiofs.rst to add the mount options and the
> atime behavior as following.
> Does it make sense?

Definitely would be good to see more clearly in this area.

Atime behavior is a somewhat complex topic, and not very well
understood.  This is (I guess) mostly because it's not relevant to the
vast majority of applications and hence basically very few users
actually care about it.

More comment below.

> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> Date: Tue, 17 Dec 2019 15:55:20 -0500
> Subject: [PATCH] virtio-fs: Add mount option and atime behavior to the doc
>
> Add a section to show the mount option and a subsection to show
> the atime behavior.
>
> Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> ---
>  Documentation/filesystems/virtiofs.rst | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/Documentation/filesystems/virtiofs.rst b/Documentation/filesystems/virtiofs.rst
> index 4f338e3cb3f7..8b04160061fd 100644
> --- a/Documentation/filesystems/virtiofs.rst
> +++ b/Documentation/filesystems/virtiofs.rst
> @@ -37,6 +37,20 @@ Mount file system with tag ``myfs`` on ``/mnt``:
>  Please see https://virtio-fs.gitlab.io/ for details on how to configure QEMU
>  and the virtiofsd daemon.
>
> +Mount options
> +-------------
> +
> +virtiofs supports general VFS mount options, for example, remount,
> +ro, rw, context, etc. It also supports FUSE mount options.
> +
> +atime behavior
> +^^^^^^^^^^^^^^
> +
> +The atime-related mount options, for example, noatime, strictatime,
> +are ignored. The atime behavior for virtiofs is the same as the
> +underlying filesystem of the directory that has been exported
> +on the host.

This is true in the "cache=none" case, because then each and every
operation performed on virtio fs will be forwarded to the host
filesystem, which will take care of updating atime.

However in the "cache=(auto|always)" cases reads may be satisfied out
of the cache in which case the atime will not be touched, regadless of
the options used on the host filesystem.

Also the DAX case will introduce additional subtleties, because mmaped
reads may not update the atime on host fs.

Thanks,
Miklos


