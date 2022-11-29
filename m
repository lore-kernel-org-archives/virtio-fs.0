Return-Path: <borntraeger@de.ibm.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=GiHli5LfJ3etfGtAFOqYYnUrQQhwbX27K/T+xjCtMPk=;
 b=RiEmf51cD5TfgOW7BGLRqbfSHOgPLf9ZjB5cBFsnVvwVHBnXeYAr2IO77qnDbjrO1FVz
 OgvRDh7EAMuKL40hhZQ/YQQ8pz2hxmP3Je5ze9DiCfYaW25BZq9OvO4OXmpp256V0umr
 FHM4CcCSvp8mX945Kn4EsnIm7JGua4TYzxpSQ5QvYt4cskLxjOk/Qr8JoNgIXqyU9Az2
 VBhzH3wbsxEwVn7cochtAv4dhn1rqTN8ySndS7dG/nguJOguU7cZwUOGFyWf9sYZ17LT
 hs8aEiRlEH5SPlIVupeyYvXn4Q4zWIjJo88Zug3TnZ3ubbTgado5nCh9Uk79M22Oc1tV Zg==
Message-ID: <1a94f96b-d9b6-44af-cedb-aa17eb1a3a84@de.ibm.com>
Date: Tue, 29 Nov 2022 10:52:46 +0100
References: <20221125143946.27717-1-mhartmay@linux.ibm.com>
 <Y4UCPQ0E2ZY15aEq@work-vm> <87wn7ef6cm.fsf@linux.ibm.com>
 <Y4XT/ZxuyU7F5h1n@work-vm>
From: Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <Y4XT/ZxuyU7F5h1n@work-vm>
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



Am 29.11.22 um 10:42 schrieb Dr. David Alan Gilbert:
> * Marc Hartmayer (mhartmay@linux.ibm.com) wrote:
>> "Dr. David Alan Gilbert" <dgilbert@redhat.com> writes:
>>
>>> * Marc Hartmayer (mhartmay@linux.ibm.com) wrote:
>>>> The virtiofsd currently crashes on s390x. This is because of a
>>>> `sigreturn` system call. See audit log below:
>>>>
>>>> type=3DSECCOMP msg=3Daudit(1669382477.611:459): auid=3D4294967295 uid=
=3D0 gid=3D0 ses=3D4294967295 subj=3Dsystem_u:system_r:virtd_t:s0-s0:c0.c10=
23 pid=3D6649 comm=3D"virtiofsd" exe=3D"/usr/libexec/virtiofsd" sig=3D31 ar=
ch=3D80000016 syscall=3D119 compat=3D0 ip=3D0x3fff15f748a code=3D0x80000000=
AUID=3D"unset" UID=3D"root" GID=3D"root" ARCH=3Ds390x SYSCALL=3Dsigreturn
>>>
>>> I'm curious; doesn't that mean that some signal is being delivered and
>>> you're returning?  Which one?
>>
>> code=3D0x80000000 means that the seccomp action SECCOMP_RET_KILL_PROCESS
>> is taken =3D> process is killed by a SIGSYS signal (31) [1].
>>
>> At least, that=E2=80=99s my understanding of this log message.
>>
>> [1] https://man7.org/linux/man-pages/man2/seccomp.2.html
>=20
> But isn't that the fallout rather than the cause ? i.e. seccomp
> is sending a SIGSYS because the process used sigreturn, my question
> is why did the process call sigreturn in the first place - it must
> have received a signal to return from?

Good question. virtiofsd seems to prepare itself for

int fuse_set_signal_handlers(struct fuse_session *se)
{
     /*
      * If we used SIG_IGN instead of the do_nothing function,
      * then we would be unable to tell if we set SIG_IGN (and
      * thus should reset to SIG_DFL in fuse_remove_signal_handlers)
      * or if it was already set to SIG_IGN (and should be left
      * untouched.
      */
     if (set_one_signal_handler(SIGHUP, exit_handler, 0) =3D=3D -1 ||
         set_one_signal_handler(SIGINT, exit_handler, 0) =3D=3D -1 ||
         set_one_signal_handler(SIGTERM, exit_handler, 0) =3D=3D -1 ||
         set_one_signal_handler(SIGPIPE, do_nothing, 0) =3D=3D -1) {
         return -1;
     }



Given that rt_sigreturn was already on the seccomp list it seems
to be expected that those handlers are called.

