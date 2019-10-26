Date: Sat, 26 Oct 2019 17:49:11 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20191026174745-mutt-send-email-mst@kernel.org>
References: <20191025100152.6638-1-stefanha@redhat.com>
	<20191025100152.6638-2-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025100152.6638-2-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [RFC 1/3] WIP virtiofsd: import Linux <fuse.h>
	header file
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>, Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Paolo Bonzini <pbonzini@redhat.com>, vgoyal@redhat.com

On Fri, Oct 25, 2019 at 12:01:50PM +0200, Stefan Hajnoczi wrote:
> tests/vhost-user-fs-test.c needs fuse.h.  The private copy that
> virtiofsd has can be replaced with a properly imported file using
> update-linux-headers.sh.
> 
> TODO rerun update-linux-headers.sh with upstream kernel tree!
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

OK I would just add this with the virtiofsd patchset.

> ---
>  contrib/virtiofsd/fuse_lowlevel.h                              | 2 +-
>  .../fuse_kernel.h => include/standard-headers/linux/fuse.h     | 0
>  contrib/virtiofsd/fuse_loop_mt.c                               | 2 +-
>  contrib/virtiofsd/fuse_lowlevel.c                              | 2 +-
>  contrib/virtiofsd/fuse_virtio.c                                | 2 +-
>  scripts/update-linux-headers.sh                                | 3 ++-
>  6 files changed, 6 insertions(+), 5 deletions(-)
>  rename contrib/virtiofsd/fuse_kernel.h => include/standard-headers/linux/fuse.h (100%)
> 
> diff --git a/contrib/virtiofsd/fuse_lowlevel.h b/contrib/virtiofsd/fuse_lowlevel.h
> index 79fb30a1c2..a8c92ff7e0 100644
> --- a/contrib/virtiofsd/fuse_lowlevel.h
> +++ b/contrib/virtiofsd/fuse_lowlevel.h
> @@ -23,7 +23,7 @@
>  #endif
>  
>  #include "fuse_common.h"
> -#include "fuse_kernel.h"
> +#include "standard-headers/linux/fuse.h"
>  
>  #include <utime.h>
>  #include <fcntl.h>
> diff --git a/contrib/virtiofsd/fuse_kernel.h b/include/standard-headers/linux/fuse.h
> similarity index 100%
> rename from contrib/virtiofsd/fuse_kernel.h
> rename to include/standard-headers/linux/fuse.h
> diff --git a/contrib/virtiofsd/fuse_loop_mt.c b/contrib/virtiofsd/fuse_loop_mt.c
> index 2000a8902a..af7b501fac 100644
> --- a/contrib/virtiofsd/fuse_loop_mt.c
> +++ b/contrib/virtiofsd/fuse_loop_mt.c
> @@ -11,7 +11,7 @@
>  #include "fuse_i.h"
>  #include "fuse_lowlevel.h"
>  #include "fuse_misc.h"
> -#include "fuse_kernel.h"
> +#include "standard-headers/linux/fuse.h"
>  #include "fuse_virtio.h"
>  
>  #include <stdio.h>
> diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
> index 78ccfe3a27..c1a901cb4d 100644
> --- a/contrib/virtiofsd/fuse_lowlevel.c
> +++ b/contrib/virtiofsd/fuse_lowlevel.c
> @@ -10,7 +10,7 @@
>  */
>  
>  #include "fuse_i.h"
> -#include "fuse_kernel.h"
> +#include "standard-headers/linux/fuse.h"
>  #include "fuse_opt.h"
>  #include "fuse_misc.h"
>  #include "fuse_virtio.h"
> diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
> index 533ef24bb7..7a0d0b2603 100644
> --- a/contrib/virtiofsd/fuse_virtio.c
> +++ b/contrib/virtiofsd/fuse_virtio.c
> @@ -15,7 +15,7 @@
>  #include "qapi/error.h"
>  
>  #include "fuse_i.h"
> -#include "fuse_kernel.h"
> +#include "standard-headers/linux/fuse.h"
>  #include "fuse_misc.h"
>  #include "fuse_opt.h"
>  #include "fuse_virtio.h"
> diff --git a/scripts/update-linux-headers.sh b/scripts/update-linux-headers.sh
> index f76d77363b..1a627ccd73 100755
> --- a/scripts/update-linux-headers.sh
> +++ b/scripts/update-linux-headers.sh
> @@ -184,7 +184,8 @@ EOF
>  
>  rm -rf "$output/include/standard-headers/linux"
>  mkdir -p "$output/include/standard-headers/linux"
> -for i in "$tmpdir"/include/linux/*virtio*.h \
> +for i in "$tmpdir/include/linux/fuse.h" \
> +         "$tmpdir"/include/linux/*virtio*.h \
>           "$tmpdir/include/linux/qemu_fw_cfg.h" \
>           "$tmpdir/include/linux/input.h" \
>           "$tmpdir/include/linux/input-event-codes.h" \
> -- 
> 2.21.0

