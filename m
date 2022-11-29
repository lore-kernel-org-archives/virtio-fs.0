Return-Path: <mhartmay@linux.ibm.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Z6bYehhqZZtobMu+v574NMN2Bnl7X83wkx2tH7UB0H4=;
 b=VI0z7weRj3Bg/kBwbaYaykcC+sw73JW5GuG1w2+B221e983nYaayLeQGMOcKfHlmk845
 xVJTw6vhmocRMwTGHsJHqniQpzzzsyXnjrTyhEp2S/cSORwVLm0oluFlPhQRccEOc6oB
 PFe3EH0LzRdcWHOTtilup8GSKoY7liGFQRZeJ1CALAjyR9KOQK16spjHyFQAaHtj0fGz
 ybMdi2uPXOo8o5sTn1iQ1anAF+Gq3OVoB/Th9IwZnV8U2IC6yqzXNzQzdcYJBoDN2GN2
 y2XHpiHOAMyK1BGDH9YM8bD0mEC+5Oyx3aWOJGjIWCy7sDatdSKYnrVf1tX/wOWrn5tj Vw==
From: Marc Hartmayer <mhartmay@linux.ibm.com>
In-Reply-To: <618edde1-31d8-9db8-48d9-137fe81b788b@de.ibm.com>
References: <20221125143946.27717-1-mhartmay@linux.ibm.com>
 <Y4UCPQ0E2ZY15aEq@work-vm> <87wn7ef6cm.fsf@linux.ibm.com>
 <Y4XT/ZxuyU7F5h1n@work-vm>
 <1a94f96b-d9b6-44af-cedb-aa17eb1a3a84@de.ibm.com>
 <618edde1-31d8-9db8-48d9-137fe81b788b@de.ibm.com>
Date: Tue, 29 Nov 2022 11:16:47 +0100
Message-ID: <87sfi2f4kw.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
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
To: Christian Borntraeger <borntraeger@de.ibm.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: qemu-devel@nongnu.org, qemu-s390x <qemu-s390x@nongnu.org>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, Sven Schnelle <svens@linux.ibm.com>, Stefan Liebler <stli@linux.ibm.com>

Christian Borntraeger <borntraeger@de.ibm.com> writes:

> Am 29.11.22 um 10:52 schrieb Christian Borntraeger:
>>=20
>>=20
>> Am 29.11.22 um 10:42 schrieb Dr. David Alan Gilbert:
>>> * Marc Hartmayer (mhartmay@linux.ibm.com) wrote:
>>>> "Dr. David Alan Gilbert" <dgilbert@redhat.com> writes:
>>>>
>>>>> * Marc Hartmayer (mhartmay@linux.ibm.com) wrote:
>>>>>> The virtiofsd currently crashes on s390x. This is because of a
>>>>>> `sigreturn` system call. See audit log below:
>>>>>>
>>>>>> type=3DSECCOMP msg=3Daudit(1669382477.611:459): auid=3D4294967295 ui=
d=3D0 gid=3D0 ses=3D4294967295 subj=3Dsystem_u:system_r:virtd_t:s0-s0:c0.c1=
023 pid=3D6649 comm=3D"virtiofsd" exe=3D"/usr/libexec/virtiofsd" sig=3D31 a=
rch=3D80000016 syscall=3D119 compat=3D0 ip=3D0x3fff15f748a code=3D0x8000000=
0AUID=3D"unset" UID=3D"root" GID=3D"root" ARCH=3Ds390x SYSCALL=3Dsigreturn
>>>>>
>>>>> I'm curious; doesn't that mean that some signal is being delivered an=
d
>>>>> you're returning?=C2=A0 Which one?
>>>>
>>>> code=3D0x80000000 means that the seccomp action SECCOMP_RET_KILL_PROCE=
SS
>>>> is taken =3D> process is killed by a SIGSYS signal (31) [1].
>>>>
>>>> At least, that=E2=80=99s my understanding of this log message.
>>>>
>>>> [1] https://man7.org/linux/man-pages/man2/seccomp.2.html
>>>
>>> But isn't that the fallout rather than the cause ? i.e. seccomp
>>> is sending a SIGSYS because the process used sigreturn, my question
>>> is why did the process call sigreturn in the first place - it must
>>> have received a signal to return from?
>>=20
>> Good question. virtiofsd seems to prepare itself for
>>=20
>> int fuse_set_signal_handlers(struct fuse_session *se)
>> {
>>  =C2=A0=C2=A0=C2=A0 /*
>>  =C2=A0=C2=A0=C2=A0=C2=A0 * If we used SIG_IGN instead of the do_nothing=
 function,
>>  =C2=A0=C2=A0=C2=A0=C2=A0 * then we would be unable to tell if we set SI=
G_IGN (and
>>  =C2=A0=C2=A0=C2=A0=C2=A0 * thus should reset to SIG_DFL in fuse_remove_=
signal_handlers)
>>  =C2=A0=C2=A0=C2=A0=C2=A0 * or if it was already set to SIG_IGN (and sho=
uld be left
>>  =C2=A0=C2=A0=C2=A0=C2=A0 * untouched.
>>  =C2=A0=C2=A0=C2=A0=C2=A0 */
>>  =C2=A0=C2=A0=C2=A0 if (set_one_signal_handler(SIGHUP, exit_handler, 0) =
=3D=3D -1 ||
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_one_signal_handler(SIGIN=
T, exit_handler, 0) =3D=3D -1 ||
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_one_signal_handler(SIGTE=
RM, exit_handler, 0) =3D=3D -1 ||
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_one_signal_handler(SIGPI=
PE, do_nothing, 0) =3D=3D -1) {
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -1;
>>  =C2=A0=C2=A0=C2=A0 }
>>=20
>>=20
>>=20
>> Given that rt_sigreturn was already on the seccomp list it seems
>> to be expected that those handlers are called.
>
> For me, it seems to happen on shutdown:
>                  Stack trace of thread 1:
>                  #0  0x000003ffc06f348a __kernel_sigreturn (linux-vdso64.=
so.1 + 0x48a)
>                  #1  0x000003ffc06f3488 __kernel_sigreturn (linux-vdso64.=
so.1 + 0x488)
>                  #2  0x000003ff9af1be96 __GI___futex_abstimed_wait_cancel=
able64 (libc.so.6 + 0x9be96)
>                  #3  0x000003ff9af211b4 __pthread_clockjoin_ex (libc.so.6=
 + 0xa11b4)
>                  #4  0x000003ff9af2106e pthread_join@GLIBC_2.2 (libc.so.6=
 + 0xa106e)
>                  #5  0x000002aa35d2fe36 fv_queue_cleanup_thread (virtiofs=
d + 0x2fe36)
>                  #6  0x000002aa35d3152c stop_all_queues (virtiofsd + 0x31=
52c)
>                  #7  0x000002aa35d2869c main (virtiofsd + 0x2869c)
>                  #8  0x000003ff9aeb4872 __libc_start_call_main (libc.so.6=
 + 0x34872)
>                  #9  0x000003ff9aeb4950 __libc_start_main@@GLIBC_2.34 (li=
bc.so.6 + 0x34950)
>                  #10 0x000002aa35d290a0 .annobin_libvhost_user.c_end.star=
tup (virtiofsd + 0x290a0)
>
>

That=E2=80=99s also what I see.

--
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

