Return-Path: <dgilbert@redhat.com>
Date: Tue, 29 Nov 2022 10:16:39 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <Y4XcByAJBWaCo0sP@work-vm>
References: <20221125143946.27717-1-mhartmay@linux.ibm.com>
 <Y4UCPQ0E2ZY15aEq@work-vm> <87wn7ef6cm.fsf@linux.ibm.com>
 <Y4XT/ZxuyU7F5h1n@work-vm>
 <1a94f96b-d9b6-44af-cedb-aa17eb1a3a84@de.ibm.com>
 <618edde1-31d8-9db8-48d9-137fe81b788b@de.ibm.com>
MIME-Version: 1.0
In-Reply-To: <618edde1-31d8-9db8-48d9-137fe81b788b@de.ibm.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Add `sigreturn` to the seccomp
 whitelist
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Marc Hartmayer <mhartmay@linux.ibm.com>, qemu-devel@nongnu.org, qemu-s390x <qemu-s390x@nongnu.org>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, Sven Schnelle <svens@linux.ibm.com>, Stefan Liebler <stli@linux.ibm.com>

* Christian Borntraeger (borntraeger@de.ibm.com) wrote:
> 
> 
> Am 29.11.22 um 10:52 schrieb Christian Borntraeger:
> > 
> > 
> > Am 29.11.22 um 10:42 schrieb Dr. David Alan Gilbert:
> > > * Marc Hartmayer (mhartmay@linux.ibm.com) wrote:
> > > > "Dr. David Alan Gilbert" <dgilbert@redhat.com> writes:
> > > > 
> > > > > * Marc Hartmayer (mhartmay@linux.ibm.com) wrote:
> > > > > > The virtiofsd currently crashes on s390x. This is because of a
> > > > > > `sigreturn` system call. See audit log below:
> > > > > > 
> > > > > > type=SECCOMP msg=audit(1669382477.611:459): auid=4294967295 uid=0 gid=0 ses=4294967295 subj=system_u:system_r:virtd_t:s0-s0:c0.c1023 pid=6649 comm="virtiofsd" exe="/usr/libexec/virtiofsd" sig=31 arch=80000016 syscall=119 compat=0 ip=0x3fff15f748a code=0x80000000AUID="unset" UID="root" GID="root" ARCH=s390x SYSCALL=sigreturn
> > > > > 
> > > > > I'm curious; doesn't that mean that some signal is being delivered and
> > > > > you're returning?  Which one?
> > > > 
> > > > code=0x80000000 means that the seccomp action SECCOMP_RET_KILL_PROCESS
> > > > is taken => process is killed by a SIGSYS signal (31) [1].
> > > > 
> > > > At least, that’s my understanding of this log message.
> > > > 
> > > > [1] https://man7.org/linux/man-pages/man2/seccomp.2.html
> > > 
> > > But isn't that the fallout rather than the cause ? i.e. seccomp
> > > is sending a SIGSYS because the process used sigreturn, my question
> > > is why did the process call sigreturn in the first place - it must
> > > have received a signal to return from?
> > 
> > Good question. virtiofsd seems to prepare itself for
> > 
> > int fuse_set_signal_handlers(struct fuse_session *se)
> > {
> >      /*
> >       * If we used SIG_IGN instead of the do_nothing function,
> >       * then we would be unable to tell if we set SIG_IGN (and
> >       * thus should reset to SIG_DFL in fuse_remove_signal_handlers)
> >       * or if it was already set to SIG_IGN (and should be left
> >       * untouched.
> >       */
> >      if (set_one_signal_handler(SIGHUP, exit_handler, 0) == -1 ||
> >          set_one_signal_handler(SIGINT, exit_handler, 0) == -1 ||
> >          set_one_signal_handler(SIGTERM, exit_handler, 0) == -1 ||
> >          set_one_signal_handler(SIGPIPE, do_nothing, 0) == -1) {
> >          return -1;
> >      }
> > 
> > 
> > 
> > Given that rt_sigreturn was already on the seccomp list it seems
> > to be expected that those handlers are called.
> 
> For me, it seems to happen on shutdown:
>                 Stack trace of thread 1:
>                 #0  0x000003ffc06f348a __kernel_sigreturn (linux-vdso64.so.1 + 0x48a)
>                 #1  0x000003ffc06f3488 __kernel_sigreturn (linux-vdso64.so.1 + 0x488)
>                 #2  0x000003ff9af1be96 __GI___futex_abstimed_wait_cancelable64 (libc.so.6 + 0x9be96)
>                 #3  0x000003ff9af211b4 __pthread_clockjoin_ex (libc.so.6 + 0xa11b4)
>                 #4  0x000003ff9af2106e pthread_join@GLIBC_2.2 (libc.so.6 + 0xa106e)
>                 #5  0x000002aa35d2fe36 fv_queue_cleanup_thread (virtiofsd + 0x2fe36)
>                 #6  0x000002aa35d3152c stop_all_queues (virtiofsd + 0x3152c)
>                 #7  0x000002aa35d2869c main (virtiofsd + 0x2869c)
>                 #8  0x000003ff9aeb4872 __libc_start_call_main (libc.so.6 + 0x34872)
>                 #9  0x000003ff9aeb4950 __libc_start_main@@GLIBC_2.34 (libc.so.6 + 0x34950)
>                 #10 0x000002aa35d290a0 .annobin_libvhost_user.c_end.startup (virtiofsd + 0x290a0)

<shrug> I guess it could be a SIGCHLD or SIGPIPE or something during
shutdown; I guess especially since we have the SIGPIPE registered.

Dave

> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

