Return-Path: <borntraeger@de.ibm.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=VXBRE9UFofXu87BMcV+BmtB0ddmW/ePYb1JYYtfNI0E=;
 b=YTzOXWzZjek4qAbL991bY8hF/sUQ7zgu8UyYTEaNABTxSXDl5cstU0z/CKH7I96X6JD3
 A5H2+sQtwEmY68I0oHBre1OC7paAVs1wz4Xn+zPhADUXmq5/PA7w7DsVvBxP5xCrxb/Z
 n8l8ewQIjU+0VF/Ix3XnpxdqzOpOx8iwFvYqDi/VmKbih+t4wSFk2CG+tMJAvz48pSXd
 y+XQpUwgRaDzodbSE27KS1qnzE054BCf28bGi8qf8OZvy6a8ah8r0OwVLv4t2xIId0Q4
 hpODYKiXc1YBtL6bXJpjDT4DY528ekO80TY/SuLCfLufClblQ5GCOcD3FQvxi/bCW9pA Iw==
Message-ID: <618edde1-31d8-9db8-48d9-137fe81b788b@de.ibm.com>
Date: Tue, 29 Nov 2022 10:57:24 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
References: <20221125143946.27717-1-mhartmay@linux.ibm.com>
 <Y4UCPQ0E2ZY15aEq@work-vm> <87wn7ef6cm.fsf@linux.ibm.com>
 <Y4XT/ZxuyU7F5h1n@work-vm> <1a94f96b-d9b6-44af-cedb-aa17eb1a3a84@de.ibm.com>
In-Reply-To: <1a94f96b-d9b6-44af-cedb-aa17eb1a3a84@de.ibm.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
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
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Marc Hartmayer <mhartmay@linux.ibm.com>
Cc: qemu-devel@nongnu.org, qemu-s390x <qemu-s390x@nongnu.org>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, Sven Schnelle <svens@linux.ibm.com>, Stefan Liebler <stli@linux.ibm.com>



Am 29.11.22 um 10:52 schrieb Christian Borntraeger:
>=20
>=20
> Am 29.11.22 um 10:42 schrieb Dr. David Alan Gilbert:
>> * Marc Hartmayer (mhartmay@linux.ibm.com) wrote:
>>> "Dr. David Alan Gilbert" <dgilbert@redhat.com> writes:
>>>
>>>> * Marc Hartmayer (mhartmay@linux.ibm.com) wrote:
>>>>> The virtiofsd currently crashes on s390x. This is because of a
>>>>> `sigreturn` system call. See audit log below:
>>>>>
>>>>> type=3DSECCOMP msg=3Daudit(1669382477.611:459): auid=3D4294967295 uid=
=3D0 gid=3D0 ses=3D4294967295 subj=3Dsystem_u:system_r:virtd_t:s0-s0:c0.c10=
23 pid=3D6649 comm=3D"virtiofsd" exe=3D"/usr/libexec/virtiofsd" sig=3D31 ar=
ch=3D80000016 syscall=3D119 compat=3D0 ip=3D0x3fff15f748a code=3D0x80000000=
AUID=3D"unset" UID=3D"root" GID=3D"root" ARCH=3Ds390x SYSCALL=3Dsigreturn
>>>>
>>>> I'm curious; doesn't that mean that some signal is being delivered and
>>>> you're returning?=C2=A0 Which one?
>>>
>>> code=3D0x80000000 means that the seccomp action SECCOMP_RET_KILL_PROCES=
S
>>> is taken =3D> process is killed by a SIGSYS signal (31) [1].
>>>
>>> At least, that=E2=80=99s my understanding of this log message.
>>>
>>> [1] https://man7.org/linux/man-pages/man2/seccomp.2.html
>>
>> But isn't that the fallout rather than the cause ? i.e. seccomp
>> is sending a SIGSYS because the process used sigreturn, my question
>> is why did the process call sigreturn in the first place - it must
>> have received a signal to return from?
>=20
> Good question. virtiofsd seems to prepare itself for
>=20
> int fuse_set_signal_handlers(struct fuse_session *se)
> {
>  =C2=A0=C2=A0=C2=A0 /*
>  =C2=A0=C2=A0=C2=A0=C2=A0 * If we used SIG_IGN instead of the do_nothing =
function,
>  =C2=A0=C2=A0=C2=A0=C2=A0 * then we would be unable to tell if we set SIG=
_IGN (and
>  =C2=A0=C2=A0=C2=A0=C2=A0 * thus should reset to SIG_DFL in fuse_remove_s=
ignal_handlers)
>  =C2=A0=C2=A0=C2=A0=C2=A0 * or if it was already set to SIG_IGN (and shou=
ld be left
>  =C2=A0=C2=A0=C2=A0=C2=A0 * untouched.
>  =C2=A0=C2=A0=C2=A0=C2=A0 */
>  =C2=A0=C2=A0=C2=A0 if (set_one_signal_handler(SIGHUP, exit_handler, 0) =
=3D=3D -1 ||
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_one_signal_handler(SIGINT=
, exit_handler, 0) =3D=3D -1 ||
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_one_signal_handler(SIGTER=
M, exit_handler, 0) =3D=3D -1 ||
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_one_signal_handler(SIGPIP=
E, do_nothing, 0) =3D=3D -1) {
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -1;
>  =C2=A0=C2=A0=C2=A0 }
>=20
>=20
>=20
> Given that rt_sigreturn was already on the seccomp list it seems
> to be expected that those handlers are called.

For me, it seems to happen on shutdown:
                 Stack trace of thread 1:
                 #0  0x000003ffc06f348a __kernel_sigreturn (linux-vdso64.so=
.1 + 0x48a)
                 #1  0x000003ffc06f3488 __kernel_sigreturn (linux-vdso64.so=
.1 + 0x488)
                 #2  0x000003ff9af1be96 __GI___futex_abstimed_wait_cancelab=
le64 (libc.so.6 + 0x9be96)
                 #3  0x000003ff9af211b4 __pthread_clockjoin_ex (libc.so.6 +=
 0xa11b4)
                 #4  0x000003ff9af2106e pthread_join@GLIBC_2.2 (libc.so.6 +=
 0xa106e)
                 #5  0x000002aa35d2fe36 fv_queue_cleanup_thread (virtiofsd =
+ 0x2fe36)
                 #6  0x000002aa35d3152c stop_all_queues (virtiofsd + 0x3152=
c)
                 #7  0x000002aa35d2869c main (virtiofsd + 0x2869c)
                 #8  0x000003ff9aeb4872 __libc_start_call_main (libc.so.6 +=
 0x34872)
                 #9  0x000003ff9aeb4950 __libc_start_main@@GLIBC_2.34 (libc=
.so.6 + 0x34950)
                 #10 0x000002aa35d290a0 .annobin_libvhost_user.c_end.startu=
p (virtiofsd + 0x290a0)


