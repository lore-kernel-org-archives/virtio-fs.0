DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=bytedance-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=BsdzygtNAIhHqfvL4QoRsZ7Bh3LnAFT5KG+hsIfeTpU=;
	b=PBBXCGVSK9KuJ38C6iKPoZ+Y2waLq/CQsw43h6S9w6XjGfT3SeNAZeMD/5d6Nvtu1V
	b5M4rphwVBwrKphrPxTlnLYoZK8w8qVvMKkF8syDOPpAK7RMsIGeCpL345i4U4LiDhVp
	IRh447SEbrI9MOEVDxFyKAEYhUXZmo3WOTpoH8JSJKbD79B9DrXnKE6PsvHFy/FTYBNu
	+AN/LoBqI+rSH+FWqtZzFox9+gVuDTnvOnv3V+edCfkau8a7s4r/oQoPkG1tENQ6rVtu
	uoxUTfEUe6C+VSCjFE/92cA89WzXeX4pSdeSnR92InIfT+iSdKFZF0ml7c1ujcHlolYc
	qYDg==
MIME-Version: 1.0
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
	<20201215162119.27360-7-zhangjiachen.jaycee@bytedance.com>
	<20210204120840.GG3039@work-vm>
In-Reply-To: <20210204120840.GG3039@work-vm>
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Date: Thu, 4 Feb 2021 22:16:01 +0800
Message-ID: <CAFQAk7gCDWjrxSSMTdRbFn5BUZcmNZ2qBPpeARbUTKxb-hfqkg@mail.gmail.com>
Content-Type: multipart/alternative; boundary="00000000000070c47f05ba83586c"
Subject: Re: [Virtio-fs] [External] Re: [RFC PATCH 6/9] virtiofsd: Add two
 new options for crash reconnection
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, Xie Yongji <xieyongji@bytedance.com>, QEMU <qemu-devel@nongnu.org>, "Michael S . Tsirkin" <mst@redhat.com>

--00000000000070c47f05ba83586c
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 4, 2021 at 8:09 PM Dr. David Alan Gilbert <dgilbert@redhat.com>
wrote:

> * Jiachen Zhang (zhangjiachen.jaycee@bytedance.com) wrote:
> > We add two options for virtiofsd crash reconnection: reconnect |
> > no_reconnect(default) and
> >
> > User of virtiofsd should set "-o reconnect" for crash reconnection. Note
> > that, when "-o reconnect" is set, some options will not be supported and
> we
> > need to disable them:
> >
> >   - mount namespace: When mount namespace is enabled, reconnected
> >     virtiofsd will failed to link/rename for EXDEV. The reason is, when
> >     virtiofsd is sandboxed by mount namespace, attempts to link/rename
> >     the fds opened before crashing (also recovered from QEMU) will be
> >     considered as across mount operations between mounts, which is not
> >     allowed by host kernel.
> >
> >     So we introduce another option "-o mount_ns|no_mount_ns" (mount_ns
> >     by default, and takes no effect when sandbox=chroot is specified).
> >     The option "-o no_mount_ns" should be used with "-o reconnect".
>
> Why not just use -o sandbox=chroot?
>
>
Yes, thanks. I think this is a good idea, and maybe better than add the new
options
(mount_ns | no_mount_ns). Actually, "-o sandbox=" has not been upstream
when we
add the new options.


> >   - remote locking: As it is hard to determine wether a file is locked or
> >     not when handling inflight locking requests, we should specify "-o
> >     no_posix_lock" (default) and "-o no_flock" (default).
> >
> >   - extended attributes: When handling inflight removexattr requests
> after
> >     reconnecting, it is hard to determine wether a attr is already
> removed
> >     or not. Therefore, we should also use "-o noxattr" (default) with "-o
> >     reconnect".
>
> Can you explain a bit more about why removexattr is hard to restart?
>
>
Consider the following removexattr handling procedure:

    lo_removexattr() {
        (1) // ......
        (2). fremovexattr / removexattr
        (3) // ......
        (4). fuse_reply_err(req, saverr);
    }

If virtiofsd successfully executed (2) but crashes at (3). When new
virtiofsd is
reconnected, as (4) is not executed before crashing, this fuse request will
be
re-executed from (1), and (2) will be executed for the second time. As the
xattr
is already removed by the first execution of (2), this time an ENODATA will
be
returned by (2) and mistakenly replied to fuse by (4).

Jiachen


> Dave
> >
> > Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >  tools/virtiofsd/helper.c         |   9 +++
> >  tools/virtiofsd/passthrough_ll.c | 112 ++++++++++++++++++++++---------
> >  2 files changed, 88 insertions(+), 33 deletions(-)
> >
> > diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
> > index 75ac48dec2..e0d6525b1a 100644
> > --- a/tools/virtiofsd/helper.c
> > +++ b/tools/virtiofsd/helper.c
> > @@ -174,6 +174,10 @@ void fuse_cmdline_help(void)
> >             "                               - chroot: chroot(2) into
> shared\n"
> >             "                                 directory (use in
> containers)\n"
> >             "                               default: namespace\n"
> > +           "    -o mount_ns|no_mount_ns    enable/disable mount
> namespace\n"
> > +           "                               default: mount_ns\n"
> > +           "                               note: if chroot sandbox mode
> is used,\n"
> > +           "                               mount_ns will not take
> effect.\n"
> >             "    -o timeout=<number>        I/O timeout (seconds)\n"
> >             "                               default: depends on cache=
> option.\n"
> >             "    -o writeback|no_writeback  enable/disable writeback
> cache\n"
> > @@ -191,6 +195,11 @@ void fuse_cmdline_help(void)
> >             "                               to virtiofsd from guest
> applications.\n"
> >             "                               default:
> no_allow_direct_io\n"
> >             "    -o announce_submounts      Announce sub-mount points to
> the guest\n"
> > +           "    -o reconnect|no_reconnect  enable/disable crash
> reconnection\n"
> > +           "                               to enable crash
> reconnection, the options\n"
> > +           "                               no_mount_ns, no_flock,
> no_posix_lock, and\n"
> > +           "                               no_xattr should also be
> set.\n"
> > +           "                               default: no_reconnect\n"
> >             );
> >  }
> >
> > diff --git a/tools/virtiofsd/passthrough_ll.c
> b/tools/virtiofsd/passthrough_ll.c
> > index 815b001076..73a50bd7a3 100644
> > --- a/tools/virtiofsd/passthrough_ll.c
> > +++ b/tools/virtiofsd/passthrough_ll.c
> > @@ -170,6 +170,8 @@ struct lo_data {
> >      pthread_mutex_t mutex;
> >      int sandbox;
> >      int debug;
> > +    int mount_ns;
> > +    int reconnect;
> >      int writeback;
> >      int flock;
> >      int posix_lock;
> > @@ -204,8 +206,12 @@ static const struct fuse_opt lo_opts[] = {
> >      { "sandbox=chroot",
> >        offsetof(struct lo_data, sandbox),
> >        SANDBOX_CHROOT },
> > +    { "reconnect", offsetof(struct lo_data, reconnect), 1 },
> > +    { "no_reconnect", offsetof(struct lo_data, reconnect), 0 },
> >      { "writeback", offsetof(struct lo_data, writeback), 1 },
> >      { "no_writeback", offsetof(struct lo_data, writeback), 0 },
> > +    { "mount_ns", offsetof(struct lo_data, mount_ns), 1 },
> > +    { "no_mount_ns", offsetof(struct lo_data, mount_ns), 0 },
> >      { "source=%s", offsetof(struct lo_data, source), 0 },
> >      { "flock", offsetof(struct lo_data, flock), 1 },
> >      { "no_flock", offsetof(struct lo_data, flock), 0 },
> > @@ -3047,8 +3053,14 @@ static void setup_namespaces(struct lo_data *lo,
> struct fuse_session *se)
> >       * an empty network namespace to prevent TCP/IP and other network
> >       * activity in case this process is compromised.
> >       */
> > -    if (unshare(CLONE_NEWPID | CLONE_NEWNS | CLONE_NEWNET) != 0) {
> > -        fuse_log(FUSE_LOG_ERR, "unshare(CLONE_NEWPID | CLONE_NEWNS):
> %m\n");
> > +    int unshare_flag;
> > +    if (lo->mount_ns) {
> > +        unshare_flag = CLONE_NEWPID | CLONE_NEWNS | CLONE_NEWNET;
> > +    } else {
> > +        unshare_flag = CLONE_NEWPID | CLONE_NEWNET;
> > +    }
> > +    if (unshare(unshare_flag) != 0) {
> > +        fuse_log(FUSE_LOG_ERR, "unshare(): %m\n");
> >          exit(1);
> >      }
> >
> > @@ -3083,38 +3095,47 @@ static void setup_namespaces(struct lo_data *lo,
> struct fuse_session *se)
> >      /* Send us SIGTERM when the parent thread terminates, see prctl(2)
> */
> >      prctl(PR_SET_PDEATHSIG, SIGTERM);
> >
> > -    /*
> > -     * If the mounts have shared propagation then we want to opt out so
> our
> > -     * mount changes don't affect the parent mount namespace.
> > -     */
> > -    if (mount(NULL, "/", NULL, MS_REC | MS_SLAVE, NULL) < 0) {
> > -        fuse_log(FUSE_LOG_ERR, "mount(/, MS_REC|MS_SLAVE): %m\n");
> > -        exit(1);
> > -    }
> > +    if (lo->mount_ns) {
> > +        /*
> > +         * If the mounts have shared propagation then we want to opt
> out so our
> > +         * mount changes don't affect the parent mount namespace.
> > +         */
> > +        if (mount(NULL, "/", NULL, MS_REC | MS_SLAVE, NULL) < 0) {
> > +            fuse_log(FUSE_LOG_ERR, "mount(/, MS_REC|MS_SLAVE): %m\n");
> > +            exit(1);
> > +        }
> >
> > -    /* The child must remount /proc to use the new pid namespace */
> > -    if (mount("proc", "/proc", "proc",
> > -              MS_NODEV | MS_NOEXEC | MS_NOSUID | MS_RELATIME, NULL) <
> 0) {
> > -        fuse_log(FUSE_LOG_ERR, "mount(/proc): %m\n");
> > -        exit(1);
> > -    }
> > +        /* The child must remount /proc to use the new pid namespace */
> > +        if (mount("proc", "/proc", "proc",
> > +                  MS_NODEV | MS_NOEXEC | MS_NOSUID | MS_RELATIME, NULL)
> < 0) {
> > +            fuse_log(FUSE_LOG_ERR, "mount(/proc): %m\n");
> > +            exit(1);
> > +        }
> >
> > -    /*
> > -     * We only need /proc/self/fd. Prevent ".." from accessing parent
> > -     * directories of /proc/self/fd by bind-mounting it over /proc.
> Since / was
> > -     * previously remounted with MS_REC | MS_SLAVE this mount change
> only
> > -     * affects our process.
> > -     */
> > -    if (mount("/proc/self/fd", "/proc", NULL, MS_BIND, NULL) < 0) {
> > -        fuse_log(FUSE_LOG_ERR, "mount(/proc/self/fd, MS_BIND): %m\n");
> > -        exit(1);
> > -    }
> > +        /*
> > +         * We only need /proc/self/fd. Prevent ".." from accessing
> parent
> > +         * directories of /proc/self/fd by bind-mounting it over /proc.
> Since
> > +         * / was previously remounted with MS_REC | MS_SLAVE this mount
> change
> > +         * only affects our process.
> > +         */
> > +        if (mount("/proc/self/fd", "/proc", NULL, MS_BIND, NULL) < 0) {
> > +            fuse_log(FUSE_LOG_ERR, "mount(/proc/self/fd, MS_BIND):
> %m\n");
> > +            exit(1);
> > +        }
> >
> > -    /* Get the /proc (actually /proc/self/fd, see above) file
> descriptor */
> > -    lo->proc_self_fd = open("/proc", O_PATH);
> > -    if (lo->proc_self_fd == -1) {
> > -        fuse_log(FUSE_LOG_ERR, "open(/proc, O_PATH): %m\n");
> > -        exit(1);
> > +        /* Get the /proc (actually /proc/self/fd, see above) file
> descriptor */
> > +        lo->proc_self_fd = open("/proc", O_PATH);
> > +        if (lo->proc_self_fd == -1) {
> > +            fuse_log(FUSE_LOG_ERR, "open(/proc, O_PATH): %m\n");
> > +            exit(1);
> > +        }
> > +    } else {
> > +        /* Now we can get our /proc/self/fd directory file descriptor */
> > +        lo->proc_self_fd = open("/proc/self/fd", O_PATH);
> > +        if (lo->proc_self_fd == -1) {
> > +            fuse_log(FUSE_LOG_ERR, "open(/proc/self/fd, O_PATH): %m\n");
> > +            exit(1);
> > +        }
> >      }
> >  }
> >
> > @@ -3347,7 +3368,9 @@ static void setup_sandbox(struct lo_data *lo,
> struct fuse_session *se,
> >  {
> >      if (lo->sandbox == SANDBOX_NAMESPACE) {
> >          setup_namespaces(lo, se);
> > -        setup_mounts(lo->source);
> > +        if (lo->mount_ns) {
> > +            setup_mounts(lo->source);
> > +        }
> >      } else {
> >          setup_chroot(lo);
> >      }
> > @@ -3438,7 +3461,11 @@ static void setup_root(struct lo_data *lo, struct
> lo_inode *root)
> >      struct stat stat;
> >      uint64_t mnt_id;
> >
> > -    fd = open("/", O_PATH);
> > +    if (lo->mount_ns) {
> > +        fd = open("/", O_PATH);
> > +    } else {
> > +        fd = open(lo->source, O_PATH);
> > +    }
> >      if (fd == -1) {
> >          fuse_log(FUSE_LOG_ERR, "open(%s, O_PATH): %m\n", lo->source);
> >          exit(1);
> > @@ -3515,6 +3542,9 @@ int main(int argc, char *argv[])
> >      lo.allow_direct_io = 0,
> >      lo.proc_self_fd = -1;
> >
> > +    lo.reconnect = 0;
> > +    lo.mount_ns = 1;
> > +
> >      /* Don't mask creation mode, kernel already did that */
> >      umask(0);
> >
> > @@ -3577,6 +3607,22 @@ int main(int argc, char *argv[])
> >          goto err_out1;
> >      }
> >
> > +    /* For sandbox mode "chroot", set the mount_ns option to 0. */
> > +    if (lo.sandbox == SANDBOX_CHROOT) {
> > +        lo.mount_ns = 0;
> > +    }
> > +
> > +    if (lo.reconnect) {
> > +        if ((lo.sandbox == SANDBOX_NAMESPACE && lo.mount_ns) || lo.flock
> > +                                               || lo.posix_lock ||
> lo.xattr) {
> > +            printf("Mount namespace, remote lock, and extended
> attributes"
> > +                   " are not supported by reconnection (-o reconnect).
> Please "
> > +                   "specify  -o no_mount_ns, -o no_flock (default), -o"
> > +                   "no_posix_lock (default), and -o no_xattr
> (default).\n");
> > +            exit(1);
> > +        }
> > +    }
> > +
> >      if (opts.log_level != 0) {
> >          current_log_level = opts.log_level;
> >      } else {
> > --
> > 2.20.1
> >
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>
>

--00000000000070c47f05ba83586c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Thu, Feb 4, 2021 at 8:09 PM Dr. Da=
vid Alan Gilbert &lt;<a href=3D"mailto:dgilbert@redhat.com">dgilbert@redhat=
.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1=
ex">* Jiachen Zhang (<a href=3D"mailto:zhangjiachen.jaycee@bytedance.com" t=
arget=3D"_blank">zhangjiachen.jaycee@bytedance.com</a>) wrote:<br>
&gt; We add two options for virtiofsd crash reconnection: reconnect |<br>
&gt; no_reconnect(default) and<br>
&gt; <br>
&gt; User of virtiofsd should set &quot;-o reconnect&quot; for crash reconn=
ection. Note<br>
&gt; that, when &quot;-o reconnect&quot; is set, some options will not be s=
upported and we<br>
&gt; need to disable them:<br>
&gt; <br>
&gt;=C2=A0 =C2=A0- mount namespace: When mount namespace is enabled, reconn=
ected<br>
&gt;=C2=A0 =C2=A0 =C2=A0virtiofsd will failed to link/rename for EXDEV. The=
 reason is, when<br>
&gt;=C2=A0 =C2=A0 =C2=A0virtiofsd is sandboxed by mount namespace, attempts=
 to link/rename<br>
&gt;=C2=A0 =C2=A0 =C2=A0the fds opened before crashing (also recovered from=
 QEMU) will be<br>
&gt;=C2=A0 =C2=A0 =C2=A0considered as across mount operations between mount=
s, which is not<br>
&gt;=C2=A0 =C2=A0 =C2=A0allowed by host kernel.<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0So we introduce another option &quot;-o mount_ns|no=
_mount_ns&quot; (mount_ns<br>
&gt;=C2=A0 =C2=A0 =C2=A0by default, and takes no effect when sandbox=3Dchro=
ot is specified).<br>
&gt;=C2=A0 =C2=A0 =C2=A0The option &quot;-o no_mount_ns&quot; should be use=
d with &quot;-o reconnect&quot;.<br>
<br>
Why not just use -o sandbox=3Dchroot?<br>
<br></blockquote><div><br></div><div>Yes, thanks. I think this is a good id=
ea, and maybe better than add the new options=C2=A0</div><div>(mount_ns | n=
o_mount_ns). Actually, &quot;-o sandbox=3D&quot; has not been upstream when=
 we</div><div>add the new options.</div><div>=C2=A0</div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">
&gt;=C2=A0 =C2=A0- remote locking: As it is hard to determine wether a file=
 is locked or<br>
&gt;=C2=A0 =C2=A0 =C2=A0not when handling inflight locking requests, we sho=
uld specify &quot;-o<br>
&gt;=C2=A0 =C2=A0 =C2=A0no_posix_lock&quot; (default) and &quot;-o no_flock=
&quot; (default).<br>
&gt; <br>
&gt;=C2=A0 =C2=A0- extended attributes: When handling inflight removexattr =
requests after<br>
&gt;=C2=A0 =C2=A0 =C2=A0reconnecting, it is hard to determine wether a attr=
 is already removed<br>
&gt;=C2=A0 =C2=A0 =C2=A0or not. Therefore, we should also use &quot;-o noxa=
ttr&quot; (default) with &quot;-o<br>
&gt;=C2=A0 =C2=A0 =C2=A0reconnect&quot;.<br>
<br>
Can you explain a bit more about why removexattr is hard to restart?<br>
<br></blockquote><div><br></div><div>Consider the following removexattr han=
dling procedure:</div><div><br></div><div>=C2=A0 =C2=A0 lo_removexattr() {<=
/div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 (1) // ......</div><div>=C2=A0 =C2=A0=
 =C2=A0 =C2=A0 (2). fremovexattr=C2=A0/ removexattr</div><div>=C2=A0 =C2=A0=
 =C2=A0 =C2=A0 (3) // ......</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 (4).=C2=
=A0<span class=3D"gmail-n">fuse_reply_err</span><span class=3D"gmail-p">(</=
span><span class=3D"gmail-n">req</span><span class=3D"gmail-p">,</span> <sp=
an class=3D"gmail-n">saverr</span><span class=3D"gmail-p">);</span></div><d=
iv><span class=3D"gmail-p">=C2=A0 =C2=A0 }</span></div><div><span class=3D"=
gmail-p"><br></span></div><div><span class=3D"gmail-p">If virtiofsd success=
fully executed=C2=A0(2)  but crashes at (3). When new virtiofsd is</span></=
div><div><span class=3D"gmail-p">reconnected, as (4) is not executed before=
 crashing, this fuse request will be</span></div><div>re-executed=C2=A0from=
 (1), and (2) will be executed for the second time. As the xattr</div><div>=
is already removed by the first execution of (2), this time=C2=A0<span clas=
s=3D"gmail-p">an=C2=A0</span>ENODATA will be</div><div>returned by (2) and =
mistakenly replied to fuse by (4).</div><div><br></div><div>Jiachen</div><d=
iv>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0p=
x 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
Dave<br>
&gt; <br>
&gt; Signed-off-by: Jiachen Zhang &lt;<a href=3D"mailto:zhangjiachen.jaycee=
@bytedance.com" target=3D"_blank">zhangjiachen.jaycee@bytedance.com</a>&gt;=
<br>
&gt; Signed-off-by: Xie Yongji &lt;<a href=3D"mailto:xieyongji@bytedance.co=
m" target=3D"_blank">xieyongji@bytedance.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 tools/virtiofsd/helper.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=
=A0 =C2=A09 +++<br>
&gt;=C2=A0 tools/virtiofsd/passthrough_ll.c | 112 ++++++++++++++++++++++---=
------<br>
&gt;=C2=A0 2 files changed, 88 insertions(+), 33 deletions(-)<br>
&gt; <br>
&gt; diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c<br>
&gt; index 75ac48dec2..e0d6525b1a 100644<br>
&gt; --- a/tools/virtiofsd/helper.c<br>
&gt; +++ b/tools/virtiofsd/helper.c<br>
&gt; @@ -174,6 +174,10 @@ void fuse_cmdline_help(void)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0- chroot: chroot(2) into shared\n&quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0directory (use in containers)\n&quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0default: namespace\n&quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;=C2=A0 =C2=A0 -o mount=
_ns|no_mount_ns=C2=A0 =C2=A0 enable/disable mount namespace\n&quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0default: mount_ns\n&quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0note: if chroot sandbox mode is used,\n&quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0mount_ns will not take effect.\n&quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;=C2=A0 =C2=A0 -o =
timeout=3D&lt;number&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 I/O timeout (seconds)\n=
&quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0default: depends on cache=3D option.\n&quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;=C2=A0 =C2=A0 -o =
writeback|no_writeback=C2=A0 enable/disable writeback cache\n&quot;<br>
&gt; @@ -191,6 +195,11 @@ void fuse_cmdline_help(void)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0to virtiofsd from guest applications.\n&quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0default: no_allow_direct_io\n&quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;=C2=A0 =C2=A0 -o =
announce_submounts=C2=A0 =C2=A0 =C2=A0 Announce sub-mount points to the gue=
st\n&quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;=C2=A0 =C2=A0 -o recon=
nect|no_reconnect=C2=A0 enable/disable crash reconnection\n&quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0to enable crash reconnection, the options\n&quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0no_mount_ns, no_flock, no_posix_lock, and\n&quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0no_xattr should also be set.\n&quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0default: no_reconnect\n&quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0);<br>
&gt;=C2=A0 }<br>
&gt;=C2=A0 <br>
&gt; diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passth=
rough_ll.c<br>
&gt; index 815b001076..73a50bd7a3 100644<br>
&gt; --- a/tools/virtiofsd/passthrough_ll.c<br>
&gt; +++ b/tools/virtiofsd/passthrough_ll.c<br>
&gt; @@ -170,6 +170,8 @@ struct lo_data {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 pthread_mutex_t mutex;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 int sandbox;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 int debug;<br>
&gt; +=C2=A0 =C2=A0 int mount_ns;<br>
&gt; +=C2=A0 =C2=A0 int reconnect;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 int writeback;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 int flock;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 int posix_lock;<br>
&gt; @@ -204,8 +206,12 @@ static const struct fuse_opt lo_opts[] =3D {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 { &quot;sandbox=3Dchroot&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 offsetof(struct lo_data, sandbox),<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 SANDBOX_CHROOT },<br>
&gt; +=C2=A0 =C2=A0 { &quot;reconnect&quot;, offsetof(struct lo_data, recon=
nect), 1 },<br>
&gt; +=C2=A0 =C2=A0 { &quot;no_reconnect&quot;, offsetof(struct lo_data, re=
connect), 0 },<br>
&gt;=C2=A0 =C2=A0 =C2=A0 { &quot;writeback&quot;, offsetof(struct lo_data, =
writeback), 1 },<br>
&gt;=C2=A0 =C2=A0 =C2=A0 { &quot;no_writeback&quot;, offsetof(struct lo_dat=
a, writeback), 0 },<br>
&gt; +=C2=A0 =C2=A0 { &quot;mount_ns&quot;, offsetof(struct lo_data, mount_=
ns), 1 },<br>
&gt; +=C2=A0 =C2=A0 { &quot;no_mount_ns&quot;, offsetof(struct lo_data, mou=
nt_ns), 0 },<br>
&gt;=C2=A0 =C2=A0 =C2=A0 { &quot;source=3D%s&quot;, offsetof(struct lo_data=
, source), 0 },<br>
&gt;=C2=A0 =C2=A0 =C2=A0 { &quot;flock&quot;, offsetof(struct lo_data, floc=
k), 1 },<br>
&gt;=C2=A0 =C2=A0 =C2=A0 { &quot;no_flock&quot;, offsetof(struct lo_data, f=
lock), 0 },<br>
&gt; @@ -3047,8 +3053,14 @@ static void setup_namespaces(struct lo_data *lo=
, struct fuse_session *se)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0* an empty network namespace to prevent TCP/=
IP and other network<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0* activity in case this process is compromis=
ed.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
&gt; -=C2=A0 =C2=A0 if (unshare(CLONE_NEWPID | CLONE_NEWNS | CLONE_NEWNET) =
!=3D 0) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_log(FUSE_LOG_ERR, &quot;unshare(CLON=
E_NEWPID | CLONE_NEWNS): %m\n&quot;);<br>
&gt; +=C2=A0 =C2=A0 int unshare_flag;<br>
&gt; +=C2=A0 =C2=A0 if (lo-&gt;mount_ns) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 unshare_flag =3D CLONE_NEWPID | CLONE_NEW=
NS | CLONE_NEWNET;<br>
&gt; +=C2=A0 =C2=A0 } else {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 unshare_flag =3D CLONE_NEWPID | CLONE_NEW=
NET;<br>
&gt; +=C2=A0 =C2=A0 }<br>
&gt; +=C2=A0 =C2=A0 if (unshare(unshare_flag) !=3D 0) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_log(FUSE_LOG_ERR, &quot;unshare(): %=
m\n&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 }<br>
&gt;=C2=A0 <br>
&gt; @@ -3083,38 +3095,47 @@ static void setup_namespaces(struct lo_data *l=
o, struct fuse_session *se)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 /* Send us SIGTERM when the parent thread terminat=
es, see prctl(2) */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 prctl(PR_SET_PDEATHSIG, SIGTERM);<br>
&gt;=C2=A0 <br>
&gt; -=C2=A0 =C2=A0 /*<br>
&gt; -=C2=A0 =C2=A0 =C2=A0* If the mounts have shared propagation then we w=
ant to opt out so our<br>
&gt; -=C2=A0 =C2=A0 =C2=A0* mount changes don&#39;t affect the parent mount=
 namespace.<br>
&gt; -=C2=A0 =C2=A0 =C2=A0*/<br>
&gt; -=C2=A0 =C2=A0 if (mount(NULL, &quot;/&quot;, NULL, MS_REC | MS_SLAVE,=
 NULL) &lt; 0) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_log(FUSE_LOG_ERR, &quot;mount(/, MS_=
REC|MS_SLAVE): %m\n&quot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1);<br>
&gt; -=C2=A0 =C2=A0 }<br>
&gt; +=C2=A0 =C2=A0 if (lo-&gt;mount_ns) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* If the mounts have shared propaga=
tion then we want to opt out so our<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* mount changes don&#39;t affect th=
e parent mount namespace.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mount(NULL, &quot;/&quot;, NULL, MS_R=
EC | MS_SLAVE, NULL) &lt; 0) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_log(FUSE_LOG_ERR, &quo=
t;mount(/, MS_REC|MS_SLAVE): %m\n&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt;=C2=A0 <br>
&gt; -=C2=A0 =C2=A0 /* The child must remount /proc to use the new pid name=
space */<br>
&gt; -=C2=A0 =C2=A0 if (mount(&quot;proc&quot;, &quot;/proc&quot;, &quot;pr=
oc&quot;,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MS_NODEV | MS_NOEXEC=
 | MS_NOSUID | MS_RELATIME, NULL) &lt; 0) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_log(FUSE_LOG_ERR, &quot;mount(/proc)=
: %m\n&quot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1);<br>
&gt; -=C2=A0 =C2=A0 }<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* The child must remount /proc to use th=
e new pid namespace */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mount(&quot;proc&quot;, &quot;/proc&q=
uot;, &quot;proc&quot;,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MS_NOD=
EV | MS_NOEXEC | MS_NOSUID | MS_RELATIME, NULL) &lt; 0) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_log(FUSE_LOG_ERR, &quo=
t;mount(/proc): %m\n&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt;=C2=A0 <br>
&gt; -=C2=A0 =C2=A0 /*<br>
&gt; -=C2=A0 =C2=A0 =C2=A0* We only need /proc/self/fd. Prevent &quot;..&qu=
ot; from accessing parent<br>
&gt; -=C2=A0 =C2=A0 =C2=A0* directories of /proc/self/fd by bind-mounting i=
t over /proc. Since / was<br>
&gt; -=C2=A0 =C2=A0 =C2=A0* previously remounted with MS_REC | MS_SLAVE thi=
s mount change only<br>
&gt; -=C2=A0 =C2=A0 =C2=A0* affects our process.<br>
&gt; -=C2=A0 =C2=A0 =C2=A0*/<br>
&gt; -=C2=A0 =C2=A0 if (mount(&quot;/proc/self/fd&quot;, &quot;/proc&quot;,=
 NULL, MS_BIND, NULL) &lt; 0) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_log(FUSE_LOG_ERR, &quot;mount(/proc/=
self/fd, MS_BIND): %m\n&quot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1);<br>
&gt; -=C2=A0 =C2=A0 }<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* We only need /proc/self/fd. Preve=
nt &quot;..&quot; from accessing parent<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* directories of /proc/self/fd by b=
ind-mounting it over /proc. Since<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* / was previously remounted with M=
S_REC | MS_SLAVE this mount change<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* only affects our process.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mount(&quot;/proc/self/fd&quot;, &quo=
t;/proc&quot;, NULL, MS_BIND, NULL) &lt; 0) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_log(FUSE_LOG_ERR, &quo=
t;mount(/proc/self/fd, MS_BIND): %m\n&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt;=C2=A0 <br>
&gt; -=C2=A0 =C2=A0 /* Get the /proc (actually /proc/self/fd, see above) fi=
le descriptor */<br>
&gt; -=C2=A0 =C2=A0 lo-&gt;proc_self_fd =3D open(&quot;/proc&quot;, O_PATH)=
;<br>
&gt; -=C2=A0 =C2=A0 if (lo-&gt;proc_self_fd =3D=3D -1) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_log(FUSE_LOG_ERR, &quot;open(/proc, =
O_PATH): %m\n&quot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Get the /proc (actually /proc/self/fd,=
 see above) file descriptor */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 lo-&gt;proc_self_fd =3D open(&quot;/proc&=
quot;, O_PATH);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (lo-&gt;proc_self_fd =3D=3D -1) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_log(FUSE_LOG_ERR, &quo=
t;open(/proc, O_PATH): %m\n&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt; +=C2=A0 =C2=A0 } else {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Now we can get our /proc/self/fd direc=
tory file descriptor */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 lo-&gt;proc_self_fd =3D open(&quot;/proc/=
self/fd&quot;, O_PATH);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (lo-&gt;proc_self_fd =3D=3D -1) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_log(FUSE_LOG_ERR, &quo=
t;open(/proc/self/fd, O_PATH): %m\n&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 }<br>
&gt;=C2=A0 }<br>
&gt;=C2=A0 <br>
&gt; @@ -3347,7 +3368,9 @@ static void setup_sandbox(struct lo_data *lo, st=
ruct fuse_session *se,<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 if (lo-&gt;sandbox =3D=3D SANDBOX_NAMESPACE) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 setup_namespaces(lo, se);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 setup_mounts(lo-&gt;source);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (lo-&gt;mount_ns) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 setup_mounts(lo-&gt;source)=
;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 } else {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 setup_chroot(lo);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 }<br>
&gt; @@ -3438,7 +3461,11 @@ static void setup_root(struct lo_data *lo, stru=
ct lo_inode *root)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 struct stat stat;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 uint64_t mnt_id;<br>
&gt;=C2=A0 <br>
&gt; -=C2=A0 =C2=A0 fd =3D open(&quot;/&quot;, O_PATH);<br>
&gt; +=C2=A0 =C2=A0 if (lo-&gt;mount_ns) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 fd =3D open(&quot;/&quot;, O_PATH);<br>
&gt; +=C2=A0 =C2=A0 } else {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 fd =3D open(lo-&gt;source, O_PATH);<br>
&gt; +=C2=A0 =C2=A0 }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 if (fd =3D=3D -1) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_log(FUSE_LOG_ERR, &quot;open(%s=
, O_PATH): %m\n&quot;, lo-&gt;source);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1);<br>
&gt; @@ -3515,6 +3542,9 @@ int main(int argc, char *argv[])<br>
&gt;=C2=A0 =C2=A0 =C2=A0 lo.allow_direct_io =3D 0,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 lo.proc_self_fd =3D -1;<br>
&gt;=C2=A0 <br>
&gt; +=C2=A0 =C2=A0 lo.reconnect =3D 0;<br>
&gt; +=C2=A0 =C2=A0 lo.mount_ns =3D 1;<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 /* Don&#39;t mask creation mode, kernel already di=
d that */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 umask(0);<br>
&gt;=C2=A0 <br>
&gt; @@ -3577,6 +3607,22 @@ int main(int argc, char *argv[])<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto err_out1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 }<br>
&gt;=C2=A0 <br>
&gt; +=C2=A0 =C2=A0 /* For sandbox mode &quot;chroot&quot;, set the mount_n=
s option to 0. */<br>
&gt; +=C2=A0 =C2=A0 if (lo.sandbox =3D=3D SANDBOX_CHROOT) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 lo.mount_ns =3D 0;<br>
&gt; +=C2=A0 =C2=A0 }<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 if (lo.reconnect) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((lo.sandbox =3D=3D SANDBOX_NAMESPACE =
&amp;&amp; lo.mount_ns) || lo.flock<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0|| lo.posix_lock || lo.xattr) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printf(&quot;Mount namespac=
e, remote lock, and extended attributes&quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
&quot; are not supported by reconnection (-o reconnect). Please &quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
&quot;specify=C2=A0 -o no_mount_ns, -o no_flock (default), -o&quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
&quot;no_posix_lock (default), and -o no_xattr (default).\n&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt; +=C2=A0 =C2=A0 }<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 if (opts.log_level !=3D 0) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 current_log_level =3D opts.log_level=
;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 } else {<br>
&gt; -- <br>
&gt; 2.20.1<br>
&gt; <br>
-- <br>
Dr. David Alan Gilbert / <a href=3D"mailto:dgilbert@redhat.com" target=3D"_=
blank">dgilbert@redhat.com</a> / Manchester, UK<br>
<br>
</blockquote></div></div>

--00000000000070c47f05ba83586c--

