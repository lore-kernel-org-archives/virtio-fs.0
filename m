MIME-Version: 1.0
References: <20190821085659.8448-1-eguan@linux.alibaba.com>
	<20190821150429.GH3309@work-vm>
	<3ca44559-d2ad-f72c-62ae-f44d13c1e0e4@huawei.com>
	<20190822141603.GA4553@stefanha-x1.localdomain>
In-Reply-To: <20190822141603.GA4553@stefanha-x1.localdomain>
From: =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>
Date: Thu, 22 Aug 2019 18:33:05 +0400
Message-ID: <CAMxuvaw2Mh97QQJojQ2uGTZP9hxHG8ya7x=RCsvc=iYGzFH+SA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: add support to change log level
	on fly
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, Daniel Berrange <berrange@redhat.com>

Hi

On Thu, Aug 22, 2019 at 6:16 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Thu, Aug 22, 2019 at 01:07:18PM +0800, piaojun wrote:
> > On 2019/8/21 23:04, Dr. David Alan Gilbert wrote:
> > > * Eryu Guan (eguan@linux.alibaba.com) wrote:
> > >> Introduce a file which contains the target log level, and
> > >> current_log_level will be reloaded to the target log level on SIGHUP.
> > >>
> > >> The file is set to "/run/virtiofsd/log_level.<pid>". Due to
> > >> sandboxing in virtiofsd, this file can only be read/write via
> > >> /proc/<pid>/fd/<fd> for now.
> > >>
> > >> Example usage:
> > >>
> > >>   # view current log level
> > >>   cat /proc/<pid>/fd/<fd>
> > >>   # change log level to debug
> > >>   echo debug > /proc/<pid>/fd/<fd>
> > >>   kill -HUP <pid>
> > >>
> > >> Signed-off-by: Eryu Guan <eguan@linux.alibaba.com>
> > >
> > > This looks really complex for something that can only be used for
> > > changing log levels.
> >
> > I have the same opinion with Dave, and I wonder if we have some easier
> > channel to tell virtiofsd to change log level. And making the channel
> > more generic is good for the expansibility of virtiofsd.
>
> Adding Dan and Marc-André, who have dealt with DBus and QMP.  They can
> share their experience.
>
> The long-term concern we should think about is whether vhost-user
> backends should have standardized management commands.  They would be
> defined in docs/interop/vhost-user.rst and all backends implementing a
> device type would implement a subset of them (plus additional
> "vendor-specific commands" if they really don't fit into the vhost-user
> specification).
>
> In order to have standard commands we need to choose a standard RPC
> mechanism.  I'm pretty sure that DBus is a good choice based on my
> previous discussions with Dan and Marc-André.  It is easy to use from
> most programming languages and therefore easier to integrate than a
> custom management channel.
>
> Dan and Marc-André: The first commands we would like to offer in
> virtiofsd are:
>
>   get-log-level -> NUM
>   Return the current logging threshold level.
>
>   set-log-level NUM
>   Set the logging threshold level.
>
> If you have time to give a quick overview of how this looks in DBus that
> would be very helpful.  The virtiofsd code is written in C and currently

Well that depends how generic we want the interface to be :)

https://dbus.freedesktop.org/doc/dbus-api-design.html

service-name: none, or org.qemu.VhostUser1 or even org.qemu.VirtioFs1 ?
iface: org.qemu.VhostUser1, org.qemu.VirtioFs1 ?
path: /org/qemu/VhostUser1
property: "LogLevel", readwrite, string. If you follow systemd/syslogd:
"this accepts a numerical log level or the well-known syslog(3)
symbolic names (lowercase): emerg, alert, crit, err, warning, notice,
info, debug."

Systemd also has "LogTarget" and a bunch of other options/properties
that are settable from command line and at runtime with dbus (see man
page).


> does not use glib/gobject/gio heavily, so I think we'd prefer a
> lightweight approach without a lot of gobject boilerplate, if possible.

If you can afford GIO, I would highly recommend it. Even if you have
to run it in a seperate thread, that may be easier to maintain.

Otherwise, sdbus or libdbus.

>
> >
> > Jun
> >
> > >
> > > Perhaps it's time we started reading stdin for some sort of simple
> > > commands?
> > >
> > > Dave
> > >
> > >> ---
> > >>  contrib/virtiofsd/fuse_log.c       | 144 +++++++++++++++++++++++++++++++++++++
> > >>  contrib/virtiofsd/fuse_log.h       |   4 ++
> > >>  contrib/virtiofsd/fuse_signals.c   |   4 +-
> > >>  contrib/virtiofsd/passthrough_ll.c |   4 ++
> > >>  4 files changed, 154 insertions(+), 2 deletions(-)
> > >>
> > >> diff --git a/contrib/virtiofsd/fuse_log.c b/contrib/virtiofsd/fuse_log.c
> > >> index d54b64099a2b..adfcbb84bfb3 100644
> > >> --- a/contrib/virtiofsd/fuse_log.c
> > >> +++ b/contrib/virtiofsd/fuse_log.c
> > >> @@ -6,12 +6,24 @@
> > >>   * See the COPYING.LIB file in the top-level directory.
> > >>   */
> > >>
> > >> +#include <sys/stat.h>
> > >> +#include <sys/types.h>
> > >> +#include <errno.h>
> > >> +#include <fcntl.h>
> > >> +#include <limits.h>
> > >>  #include <stdbool.h>
> > >>  #include <stdio.h>
> > >>  #include <stdarg.h>
> > >> +#include <stdlib.h>
> > >> +#include <string.h>
> > >> +#include <unistd.h>
> > >>  #include "fuse_log.h"
> > >>
> > >> +#define FUSE_DYN_LOG_BASE "/run/virtiofsd"
> > >> +
> > >>  static bool use_syslog;
> > >> +static char *dyn_log_file = NULL;
> > >> +static int dyn_log_fd = -1;
> > >>  int current_log_level = LOG_INFO;
> > >>
> > >>  void fuse_log_enable_syslog(void)
> > >> @@ -71,3 +83,135 @@ void fuse_debug(const char *fmt, ...)
> > >>      fuse_vlog(LOG_DEBUG, fmt, ap);
> > >>      va_end(ap);
> > >>  }
> > >> +
> > >> +static const char *fuse_log_level_str(int level)
> > >> +{
> > >> +    switch (level) {
> > >> +    case LOG_DEBUG:
> > >> +        return "debug";
> > >> +    case LOG_INFO:
> > >> +        return "info";
> > >> +    case LOG_WARNING:
> > >> +        return "warn";
> > >> +    case LOG_ERR:
> > >> +        return "err";
> > >> +    default:
> > >> +        return NULL;
> > >> +    }
> > >> +}
> > >> +
> > >> +void fuse_dyn_log_init(void)
> > >> +{
> > >> +    struct stat stbuf;
> > >> +    char buf[PATH_MAX];
> > >> +    const char *p;
> > >> +
> > >> +    /* Prepare FUSE_DYN_LOG_BASE */
> > >> +    if (mkdir(FUSE_DYN_LOG_BASE, 0755) == -1) {
> > >> +        if (errno != EEXIST) {
> > >> +            fuse_warning("Fail to mkdir(%s): %s\n", FUSE_DYN_LOG_BASE,
> > >> +                         strerror(errno));
> > >> +            goto err;
> > >> +        }
> > >> +    }
> > >> +    if (stat(FUSE_DYN_LOG_BASE, &stbuf) == -1) {
> > >> +        fuse_warning("Fail to stat(%s): %s\n", FUSE_DYN_LOG_BASE,
> > >> +                     strerror(errno));
> > >> +        goto err;
> > >> +    }
> > >> +    if (!S_ISDIR(stbuf.st_mode)) {
> > >> +        fuse_warning("%s is not a directory\n", FUSE_DYN_LOG_BASE);
> > >> +        goto err;
> > >> +    }
> > >> +    if (!(stbuf.st_mode & S_IRUSR) || !(stbuf.st_mode & S_IWUSR)) {
> > >> +        fuse_warning("Require rw permission on %s\n", FUSE_DYN_LOG_BASE);
> > >> +        goto err;
> > >> +    }
> > >> +
> > >> +    /* Prepare log level file */
> > >> +    snprintf(buf, sizeof(buf), FUSE_DYN_LOG_BASE "/log_level.%d",
> > >> +             getpid());
> > >> +    dyn_log_file = strdup(buf);
> > >> +    if (dyn_log_file == NULL) {
> > >> +        fuse_warning("Fail to duplicate str %s: %s\n", buf, strerror(errno));
> > >> +        goto err;
> > >> +    }
> > >> +    dyn_log_fd = open(dyn_log_file, O_CREAT | O_TRUNC | O_RDWR, 0644);
> > >> +    if (dyn_log_fd == -1) {
> > >> +        fuse_warning("Fail to open %s: %s\n", dyn_log_file, strerror(errno));
> > >> +        goto err;
> > >> +    }
> > >> +    /*
> > >> +     * TODO: Due to sandboxing, unlink won't work in
> > >> +     * fuse_dyn_log_fin(), we have to unlink log file here and access
> > >> +     * it via /proc/<pid>/fd/<fd>
> > >> +     */
> > >> +    if (unlink(dyn_log_file) == -1)
> > >> +        fuse_warning("Fail to unlink %s: %s\n", dyn_log_file, strerror(errno));
> > >> +
> > >> +    p = fuse_log_level_str(current_log_level);
> > >> +    if (p == NULL) {
> > >> +        fuse_warning("Unknown initial log level %d\n", current_log_level);
> > >> +        goto err;
> > >> +    }
> > >> +    if (write(dyn_log_fd, p, strlen(p)) == -1) {
> > >> +        fuse_warning("Fail to write (\"%s\") to %s: %s\n", p, dyn_log_file,
> > >> +                     strerror(errno));
> > >> +    }
> > >> +
> > >> +    fuse_info("Dynamic log level adjustment is enabled, entry file %s\n",
> > >> +              dyn_log_file);
> > >> +    return;
> > >> +err:
> > >> +    fuse_warning("Dynamic log level adjustment is disabled\n");
> > >> +    return;
> > >> +}
> > >> +
> > >> +void fuse_dyn_log_fin(void)
> > >> +{
> > >> +    if (dyn_log_fd != -1) {
> > >> +        close(dyn_log_fd);
> > >> +        dyn_log_fd = -1;
> > >> +    }
> > >> +    if (dyn_log_file) {
> > >> +        free(dyn_log_file);
> > >> +        dyn_log_file = NULL;
> > >> +    }
> > >> +    return;
> > >> +}
> > >> +
> > >> +void fuse_log_handler(int sig)
> > >> +{
> > >> +    char buf[16] = { 0 };
> > >> +
> > >> +    /* FIXME: pread() causes read to hang, use lseek & read here */
> > >> +    if (lseek(dyn_log_fd, 0, SEEK_SET) == -1) {
> > >> +        fuse_warning("Fail to seek %s: %s\n", dyn_log_file, strerror(errno));
> > >> +        goto err;
> > >> +    }
> > >> +    if (read(dyn_log_fd, buf, 16) == -1 ) {
> > >> +        fuse_warning("Fail to read %s: %s\n", dyn_log_file, strerror(errno));
> > >> +        goto err;
> > >> +    }
> > >> +    buf[15] = '\0';
> > >> +    buf[strcspn(buf, "\n")] = '\0';
> > >> +
> > >> +    if (!strncmp(buf, "debug", 5)) {
> > >> +        current_log_level = LOG_DEBUG;
> > >> +    } else if (!strncmp(buf, "info", 4)) {
> > >> +        current_log_level = LOG_INFO;
> > >> +    } else if (!strncmp(buf, "warn", 4)) {
> > >> +        current_log_level = LOG_WARNING;
> > >> +    } else if (!strncmp(buf, "err", 3)) {
> > >> +        current_log_level = LOG_ERR;
> > >> +    } else {
> > >> +        fuse_warning("Unknown log level \"%s\"\n", buf);
> > >> +        goto err;
> > >> +    }
> > >> +
> > >> +    fuse_info("Changed current log level to %s(%d)\n", buf, current_log_level);
> > >> +    return;
> > >> +err:
> > >> +    fuse_warning("Reload log level failed\n");
> > >> +    return;
> > >> +}
> > >> diff --git a/contrib/virtiofsd/fuse_log.h b/contrib/virtiofsd/fuse_log.h
> > >> index c4dfc921b6d8..532a6d66e296 100644
> > >> --- a/contrib/virtiofsd/fuse_log.h
> > >> +++ b/contrib/virtiofsd/fuse_log.h
> > >> @@ -21,4 +21,8 @@ void fuse_warning(const char *fmt, ...) GCC_FMT_ATTR(1, 2);
> > >>  void fuse_info(const char *fmt, ...) GCC_FMT_ATTR(1, 2);
> > >>  void fuse_debug(const char *fmt, ...) GCC_FMT_ATTR(1, 2);
> > >>
> > >> +void fuse_dyn_log_init(void);
> > >> +void fuse_dyn_log_fin(void);
> > >> +void fuse_log_handler(int sig);
> > >> +
> > >>  #endif /* FUSE_LOG_H */
> > >> diff --git a/contrib/virtiofsd/fuse_signals.c b/contrib/virtiofsd/fuse_signals.c
> > >> index 9d34f6b04025..862ba1852eff 100644
> > >> --- a/contrib/virtiofsd/fuse_signals.c
> > >> +++ b/contrib/virtiofsd/fuse_signals.c
> > >> @@ -69,7 +69,7 @@ int fuse_set_signal_handlers(struct fuse_session *se)
> > >>       thus should reset to SIG_DFL in fuse_remove_signal_handlers)
> > >>       or if it was already set to SIG_IGN (and should be left
> > >>       untouched. */
> > >> -  if (set_one_signal_handler(SIGHUP, exit_handler, 0) == -1 ||
> > >> +  if (set_one_signal_handler(SIGHUP, fuse_log_handler, 0) == -1 ||
> > >>        set_one_signal_handler(SIGINT, exit_handler, 0) == -1 ||
> > >>        set_one_signal_handler(SIGTERM, exit_handler, 0) == -1 ||
> > >>        set_one_signal_handler(SIGPIPE, do_nothing, 0) == -1)
> > >> @@ -86,7 +86,7 @@ void fuse_remove_signal_handlers(struct fuse_session *se)
> > >>    else
> > >>            fuse_instance = NULL;
> > >>
> > >> -  set_one_signal_handler(SIGHUP, exit_handler, 1);
> > >> +  set_one_signal_handler(SIGHUP, fuse_log_handler, 1);
> > >>    set_one_signal_handler(SIGINT, exit_handler, 1);
> > >>    set_one_signal_handler(SIGTERM, exit_handler, 1);
> > >>    set_one_signal_handler(SIGPIPE, do_nothing, 1);
> > >> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
> > >> index ca11764feb88..5f32227a0712 100644
> > >> --- a/contrib/virtiofsd/passthrough_ll.c
> > >> +++ b/contrib/virtiofsd/passthrough_ll.c
> > >> @@ -2987,6 +2987,9 @@ int main(int argc, char *argv[])
> > >>            get_shared(&lo, &lo.root);
> > >>    }
> > >>
> > >> +  /* Initialize dynamic log level infra, after SIGHUP handler is set. */
> > >> +  fuse_dyn_log_init();
> > >> +
> > >>    /* Must be after daemonize to get the right /proc/self/fd */
> > >>    setup_proc_self_fd(&lo);
> > >>
> > >> @@ -2997,6 +3000,7 @@ int main(int argc, char *argv[])
> > >>    /* Block until ctrl+c or fusermount -u */
> > >>          ret = virtio_loop(se);
> > >>
> > >> +  fuse_dyn_log_fin();
> > >>  err_out4:
> > >>    fuse_session_unmount(se);
> > >>  err_out3:
> > >> --
> > >> 2.14.4.44.g2045bb6
> > >>
> > >> _______________________________________________
> > >> Virtio-fs mailing list
> > >> Virtio-fs@redhat.com
> > >> https://www.redhat.com/mailman/listinfo/virtio-fs
> > > --
> > > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> > >
> > > _______________________________________________
> > > Virtio-fs mailing list
> > > Virtio-fs@redhat.com
> > > https://www.redhat.com/mailman/listinfo/virtio-fs
> > > .
> > >
> >
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs

