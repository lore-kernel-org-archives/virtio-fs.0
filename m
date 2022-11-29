Return-Path: <dgilbert@redhat.com>
Date: Tue, 29 Nov 2022 09:42:21 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <Y4XT/ZxuyU7F5h1n@work-vm>
References: <20221125143946.27717-1-mhartmay@linux.ibm.com>
 <Y4UCPQ0E2ZY15aEq@work-vm> <87wn7ef6cm.fsf@linux.ibm.com>
MIME-Version: 1.0
In-Reply-To: <87wn7ef6cm.fsf@linux.ibm.com>
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
To: Marc Hartmayer <mhartmay@linux.ibm.com>
Cc: qemu-devel@nongnu.org, qemu-s390x <qemu-s390x@nongnu.org>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Stefan Liebler <stli@linux.ibm.com>

* Marc Hartmayer (mhartmay@linux.ibm.com) wrote:
> "Dr. David Alan Gilbert" <dgilbert@redhat.com> writes:
> 
> > * Marc Hartmayer (mhartmay@linux.ibm.com) wrote:
> >> The virtiofsd currently crashes on s390x. This is because of a
> >> `sigreturn` system call. See audit log below:
> >> 
> >> type=SECCOMP msg=audit(1669382477.611:459): auid=4294967295 uid=0 gid=0 ses=4294967295 subj=system_u:system_r:virtd_t:s0-s0:c0.c1023 pid=6649 comm="virtiofsd" exe="/usr/libexec/virtiofsd" sig=31 arch=80000016 syscall=119 compat=0 ip=0x3fff15f748a code=0x80000000AUID="unset" UID="root" GID="root" ARCH=s390x SYSCALL=sigreturn
> >
> > I'm curious; doesn't that mean that some signal is being delivered and
> > you're returning?  Which one?
> 
> code=0x80000000 means that the seccomp action SECCOMP_RET_KILL_PROCESS
> is taken => process is killed by a SIGSYS signal (31) [1].
> 
> At least, that’s my understanding of this log message.
> 
> [1] https://man7.org/linux/man-pages/man2/seccomp.2.html

But isn't that the fallout rather than the cause ? i.e. seccomp
is sending a SIGSYS because the process used sigreturn, my question
is why did the process call sigreturn in the first place - it must
have received a signal to return from?

Dave

> […snip…]
> 
> > -- 
> > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> >
> -- 
> Kind regards / Beste Grüße
>    Marc Hartmayer
> 
> IBM Deutschland Research & Development GmbH
> Vorsitzender des Aufsichtsrats: Gregor Pillen 
> Geschäftsführung: David Faller
> Sitz der Gesellschaft: Böblingen
> Registergericht: Amtsgericht Stuttgart, HRB 243294
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

