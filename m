Date: Thu, 5 Sep 2019 18:12:48 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190905171248.GP2700@work-vm>
References: <20190905152136.30637-1-stefanha@redhat.com>
	<20190905152136.30637-4-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905152136.30637-4-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [RFC 3/3] virtiofsd: add virtiofsctl command-line
	management tool
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, qemu-devel@nongnu.org

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> virtiofsctl can control a running virtiofsd process:
> 
>   usage: ./virtiofsctl COMMAND [args...]
> 
>   Commands:
>     get-log-level       - show current log level
>     set-log-level LEVEL - set current log level to one of
>                           "err", "warning", "info", "debug"
> 
> Make sure it is running in the same DBus session as virtiofsd.  This may
> require setting the DBUS_SESSION_BUS_ADDRESS environment variable to the
> same value as used by virtiofsd.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  Makefile                        |  3 ++
>  Makefile.objs                   |  1 +
>  contrib/virtiofsd/Makefile.objs |  3 ++
>  contrib/virtiofsd/virtiofsctl.c | 55 +++++++++++++++++++++++++++++++++
>  4 files changed, 62 insertions(+)
>  create mode 100644 contrib/virtiofsd/virtiofsctl.c
> 
> diff --git a/Makefile b/Makefile
> index 6b1af33348..d7ed9e7669 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -419,6 +419,7 @@ dummy := $(call unnest-vars,, \
>                  ivshmem-client-obj-y \
>                  ivshmem-server-obj-y \
>                  virtiofsd-obj-y \
> +                virtiofsctl-obj-y \
>                  rdmacm-mux-obj-y \
>                  libvhost-user-obj-y \
>                  vhost-user-scsi-obj-y \
> @@ -661,6 +662,8 @@ contrib/virtiofsd/gdbus_generated.c-timestamp: $(SRC_PATH)/contrib/virtiofsd/org
>  
>  virtiofsd$(EXESUF): $(virtiofsd-obj-y) libvhost-user.a $(COMMON_LDADDS)
>  	$(call LINK, $^)
> +virtiofsctl$(EXESUF): $(virtiofsctl-obj-y)
> +	$(call LINK, $^)
>  endif
>  
>  vhost-user-gpu$(EXESUF): $(vhost-user-gpu-obj-y) $(libvhost-user-obj-y) libqemuutil.a libqemustub.a
> diff --git a/Makefile.objs b/Makefile.objs
> index dfdd7d56ea..326a8abb8e 100644
> --- a/Makefile.objs
> +++ b/Makefile.objs
> @@ -126,6 +126,7 @@ rdmacm-mux-obj-y = contrib/rdmacm-mux/
>  vhost-user-input-obj-y = contrib/vhost-user-input/
>  vhost-user-gpu-obj-y = contrib/vhost-user-gpu/
>  virtiofsd-obj-y = contrib/virtiofsd/
> +virtiofsctl-obj-y = contrib/virtiofsd/
>  
>  ######################################################################
>  trace-events-subdirs =
> diff --git a/contrib/virtiofsd/Makefile.objs b/contrib/virtiofsd/Makefile.objs
> index d59ab60f3d..3f944d493e 100644
> --- a/contrib/virtiofsd/Makefile.objs
> +++ b/contrib/virtiofsd/Makefile.objs
> @@ -11,6 +11,9 @@ virtiofsd-obj-y = buffer.o \
>                    gdbus_generated.o \
>                    dbus.o
>  
> +virtiofsctl-obj-y = virtiofsctl.o \
> +                    gdbus_generated.o
> +
>  seccomp.o-cflags := $(SECCOMP_CFLAGS)
>  seccomp.o-libs := $(SECCOMP_LIBS)
>  
> diff --git a/contrib/virtiofsd/virtiofsctl.c b/contrib/virtiofsd/virtiofsctl.c
> new file mode 100644
> index 0000000000..39bee2b881
> --- /dev/null
> +++ b/contrib/virtiofsd/virtiofsctl.c
> @@ -0,0 +1,55 @@
> +#include <stdio.h>
> +#include "gdbus_generated.h"
> +
> +static void get_log_level(Virtiofsd *virtiofsd)
> +{
> +    const char *value = virtiofsd_get_log_level(virtiofsd);
> +
> +    printf("%s\n", value ? value : "(null)");
> +}
> +
> +static void set_log_level(Virtiofsd *virtiofsd, const char *value)
> +{
> +    virtiofsd_set_log_level(virtiofsd, value);
> +}
> +
> +static void usage(const char *progname)
> +{
> +    printf("usage: %s COMMAND [args...]\n", progname);
> +    printf("\n");
> +    printf("Commands:\n");
> +    printf("  get-log-level       - show current log level\n");
> +    printf("  set-log-level LEVEL - set current log level to one of\n");
> +    printf("                        \"err\", \"warning\", \"info\", \"debug\"\n");
> +    exit(0);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +    Virtiofsd *virtiofsd;
> +    GError *error = NULL;
> +
> +    if (argc < 2) {
> +        usage(argv[0]);
> +    }
> +
> +    virtiofsd = virtiofsd_proxy_new_for_bus_sync(G_BUS_TYPE_SESSION,
> +            G_DBUS_PROXY_FLAGS_NONE, "org.qemu.virtiofsd",
> +            "/org/qemu/virtiofsd", NULL, &error);
> +    if (error) {
> +        fprintf(stderr, "%s\n", error->message);
> +        g_error_free(error);
> +        return 1;
> +    }
> +
> +    if (strcmp(argv[0], "get-log-level") == 0) {

This and the one below works a lot better with argv[1] !

(I wonder if a little python script would be better for these type of
wrappers).

Dave

> +        get_log_level(virtiofsd);
> +    } else if (strcmp(argv[0], "set-log-level") == 0) {

> +        if (argc != 3) {
> +            usage(argv[0]);
> +        }
> +        set_log_level(virtiofsd, argv[2]);
> +    }
> +    g_object_unref(virtiofsd);
> +    return 0;
> +}
> -- 
> 2.21.0
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

