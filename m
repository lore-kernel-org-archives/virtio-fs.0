Return-Path: <mhartmay@linux.ibm.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=KPiXkMI5rsvRFtZnAKXBVhAtBy9zMoxjWGveXJYbvgs=;
 b=omMxmJHs2Hnj3/aep/LRTHHfdwTHETU1Y6PEeLHsU9BH8xwXSrMK1GlB0G8PX3/yPa74
 X5CRjuQbK71j2JDraW66blOoybTfcPU1NMDKk493HYwTLM4xHImDW++5uL3YzU0AgXfN
 XLwawDdJ90FiKU5ETmC2aAVE7Xp1ptx4GGbGU27hAH51P89ebikzFl1vRlCd/t1ChNOm
 urXbDNhOVXsnDnk842FxfKhlTM8NpMhoLp8KvH9nIDTzR5bbcM6bTftRKSI6YYh628j4
 hFxI+RBHzzZO1Y5WtC/ZuhR2RJiOqHAdjKUhi/eLWGFgcn+xLN9M4QDQwx+qS8YWKEoG Ww==
From: Marc Hartmayer <mhartmay@linux.ibm.com>
In-Reply-To: <Y4UCPQ0E2ZY15aEq@work-vm>
References: <20221125143946.27717-1-mhartmay@linux.ibm.com>
 <Y4UCPQ0E2ZY15aEq@work-vm>
Date: Tue, 29 Nov 2022 10:38:33 +0100
Message-ID: <87wn7ef6cm.fsf@linux.ibm.com>
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
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: qemu-devel@nongnu.org, qemu-s390x <qemu-s390x@nongnu.org>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Stefan Liebler <stli@linux.ibm.com>

"Dr. David Alan Gilbert" <dgilbert@redhat.com> writes:

> * Marc Hartmayer (mhartmay@linux.ibm.com) wrote:
>> The virtiofsd currently crashes on s390x. This is because of a
>> `sigreturn` system call. See audit log below:
>>=20
>> type=3DSECCOMP msg=3Daudit(1669382477.611:459): auid=3D4294967295 uid=3D=
0 gid=3D0 ses=3D4294967295 subj=3Dsystem_u:system_r:virtd_t:s0-s0:c0.c1023 =
pid=3D6649 comm=3D"virtiofsd" exe=3D"/usr/libexec/virtiofsd" sig=3D31 arch=
=3D80000016 syscall=3D119 compat=3D0 ip=3D0x3fff15f748a code=3D0x80000000AU=
ID=3D"unset" UID=3D"root" GID=3D"root" ARCH=3Ds390x SYSCALL=3Dsigreturn
>
> I'm curious; doesn't that mean that some signal is being delivered and
> you're returning?  Which one?

code=3D0x80000000 means that the seccomp action SECCOMP_RET_KILL_PROCESS
is taken =3D> process is killed by a SIGSYS signal (31) [1].

At least, that=E2=80=99s my understanding of this log message.

[1] https://man7.org/linux/man-pages/man2/seccomp.2.html

[=E2=80=A6snip=E2=80=A6]

> --=20
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>
--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

