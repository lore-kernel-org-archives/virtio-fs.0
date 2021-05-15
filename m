References: <20210505103702.521457-1-berrange@redhat.com>
	<20210505103702.521457-7-berrange@redhat.com>
From: Laurent Vivier <laurent@vivier.eu>
Message-ID: <adc01acf-b473-b16b-2b1e-99a8e498ccb5@vivier.eu>
Date: Sat, 15 May 2021 21:51:07 +0200
MIME-Version: 1.0
In-Reply-To: <20210505103702.521457-7-berrange@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: fr
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 6/7] linux-user: use GDateTime for
 formatting timestamp for core file
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>, qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Jiri Pirko <jiri@resnulli.us>, qemu-block@nongnu.org, Juan Quintela <quintela@redhat.com>, Jason Wang <jasowang@redhat.com>, Markus Armbruster <armbru@redhat.com>, Max Reitz <mreitz@redhat.com>, virtio-fs@redhat.com, Gerd Hoffmann <kraxel@redhat.com>, Brad Smith <brad@comstyle.com>

Le 05/05/2021 à 12:37, Daniel P. Berrangé a écrit :
> The GDateTime APIs provided by GLib avoid portability pitfalls, such
> as some platforms where 'struct timeval.tv_sec' field is still 'long'
> instead of 'time_t'. When combined with automatic cleanup, GDateTime
> often results in simpler code too.
> 
> Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
> ---
>  linux-user/elfload.c | 36 +++++++++---------------------------
>  1 file changed, 9 insertions(+), 27 deletions(-)
> 
> diff --git a/linux-user/elfload.c b/linux-user/elfload.c
> index c6731013fd..c38b7b4d37 100644
> --- a/linux-user/elfload.c
> +++ b/linux-user/elfload.c
> @@ -3386,7 +3386,6 @@ static size_t note_size(const struct memelfnote *);
>  static void free_note_info(struct elf_note_info *);
>  static int fill_note_info(struct elf_note_info *, long, const CPUArchState *);
>  static void fill_thread_info(struct elf_note_info *, const CPUArchState *);
> -static int core_dump_filename(const TaskState *, char *, size_t);
>  
>  static int dump_write(int, const void *, size_t);
>  static int write_note(struct memelfnote *, int);
> @@ -3685,32 +3684,16 @@ static void fill_auxv_note(struct memelfnote *note, const TaskState *ts)
>   * for the name:
>   *     qemu_<basename-of-target-binary>_<date>-<time>_<pid>.core
>   *
> - * Returns 0 in case of success, -1 otherwise (errno is set).
> + * Returns the filename
>   */
> -static int core_dump_filename(const TaskState *ts, char *buf,
> -                              size_t bufsize)
> +static char *core_dump_filename(const TaskState *ts)
>  {
> -    char timestamp[64];
> -    char *base_filename = NULL;
> -    struct timeval tv;
> -    struct tm tm;
> +    g_autoptr(GDateTime) now = g_date_time_new_now_local();
> +    g_autofree char *nowstr = g_date_time_format(now, "%Y%m%d-%H%M%S");
> +    g_autofree char *base_filename = g_path_get_basename(ts->bprm->filename);
>  
> -    assert(bufsize >= PATH_MAX);
> -
> -    if (gettimeofday(&tv, NULL) < 0) {
> -        (void) fprintf(stderr, "unable to get current timestamp: %s",
> -                       strerror(errno));
> -        return (-1);
> -    }
> -
> -    base_filename = g_path_get_basename(ts->bprm->filename);
> -    (void) strftime(timestamp, sizeof (timestamp), "%Y%m%d-%H%M%S",
> -                    localtime_r(&tv.tv_sec, &tm));
> -    (void) snprintf(buf, bufsize, "qemu_%s_%s_%d.core",
> -                    base_filename, timestamp, (int)getpid());
> -    g_free(base_filename);
> -
> -    return (0);
> +    return g_strdup_printf("qemu_%s_%s_%d.core",
> +                           base_filename, nowstr, (int)getpid());
>  }
>  
>  static int dump_write(int fd, const void *ptr, size_t size)
> @@ -3938,7 +3921,7 @@ static int elf_core_dump(int signr, const CPUArchState *env)
>      const CPUState *cpu = env_cpu((CPUArchState *)env);
>      const TaskState *ts = (const TaskState *)cpu->opaque;
>      struct vm_area_struct *vma = NULL;
> -    char corefile[PATH_MAX];
> +    g_autofree char *corefile = NULL;
>      struct elf_note_info info;
>      struct elfhdr elf;
>      struct elf_phdr phdr;
> @@ -3955,8 +3938,7 @@ static int elf_core_dump(int signr, const CPUArchState *env)
>      if (dumpsize.rlim_cur == 0)
>          return 0;
>  
> -    if (core_dump_filename(ts, corefile, sizeof (corefile)) < 0)
> -        return (-errno);
> +    corefile = core_dump_filename(ts);
>  
>      if ((fd = open(corefile, O_WRONLY | O_CREAT,
>                     S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH)) < 0)
> 

Applied to my linux-user-for-6.1 branch.

Thanks,
Laurent


