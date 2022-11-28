Return-Path: <mhartmay@linux.ibm.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=frS9Zh18JIFRLV3k0NYVkamO7NVNX+oTphRcy/+WDJc=;
 b=dGTkuRPU6p+Fxav92R6AaBOqNuaF5up9tLJ77JGBIv4lG6Hpvmkf7EP0XvWdl0J84vDR
 +Ihp3Nw6wjWYME4VLi5i9Dk2qmJZFE0WVjVkgrNMP7pJKa0ZLJTYe8OuyvlMOtRS/JA8
 KVM5PEutucHGQE9qPvd3UYcMPA1yeQE+Q9hpX10c9WiLnosZOkEZ2L3Nai2KgC/dLF/y
 H1zzWiDAHtcufC/iNN5KXOMbJsYRCJWBfs+zVfCjsp6zPPc9iYiojZo9WunJTYtM8hZ0
 eKOsenp+jUJyQMcES1TuJG7F5yhcgrg342l72uxhqkOzkNMIMooE41xrudr02+m+pFub GA==
From: Marc Hartmayer <mhartmay@linux.ibm.com>
In-Reply-To: <CAJh=p+7igBB9CMTUi--HCpcuxdHgveqgkw5dY7frE7Wqf==04w@mail.gmail.com>
References: <20221125143946.27717-1-mhartmay@linux.ibm.com>
 <CAJh=p+7igBB9CMTUi--HCpcuxdHgveqgkw5dY7frE7Wqf==04w@mail.gmail.com>
Date: Mon, 28 Nov 2022 10:00:03 +0100
Message-ID: <87lenvjvxo.fsf@linux.ibm.com>
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
To: German Maglione <gmaglione@redhat.com>
Cc: qemu-devel@nongnu.org, Stefan Liebler <stli@linux.ibm.com>, virtio-fs@redhat.com, Christian Borntraeger <borntraeger@de.ibm.com>, qemu-s390x <qemu-s390x@nongnu.org>, Sven Schnelle <svens@linux.ibm.com>, Stefan Hajnoczi <stefanha@redhat.com>

German Maglione <gmaglione@redhat.com> writes:

> On Fri, Nov 25, 2022 at 3:40 PM Marc Hartmayer <mhartmay@linux.ibm.com> w=
rote:
>>
>> The virtiofsd currently crashes on s390x. This is because of a
>> `sigreturn` system call. See audit log below:
>>
>> type=3DSECCOMP msg=3Daudit(1669382477.611:459): auid=3D4294967295 uid=3D=
0 gid=3D0 ses=3D4294967295 subj=3Dsystem_u:system_r:virtd_t:s0-s0:c0.c1023 =
pid=3D6649 comm=3D"virtiofsd" exe=3D"/usr/libexec/virtiofsd" sig=3D31 arch=
=3D80000016 syscall=3D119 compat=3D0 ip=3D0x3fff15f748a code=3D0x80000000AU=
ID=3D"unset" UID=3D"root" GID=3D"root" ARCH=3Ds390x SYSCALL=3Dsigreturn
>>
>> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> ---
>>  tools/virtiofsd/passthrough_seccomp.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/pas=
sthrough_seccomp.c
>> index 888295c073de..0033dab4939e 100644
>> --- a/tools/virtiofsd/passthrough_seccomp.c
>> +++ b/tools/virtiofsd/passthrough_seccomp.c
>> @@ -110,6 +110,7 @@ static const int syscall_allowlist[] =3D {
>>  #endif
>>      SCMP_SYS(set_robust_list),
>>      SCMP_SYS(setxattr),
>> +    SCMP_SYS(sigreturn),
>>      SCMP_SYS(symlinkat),
>>      SCMP_SYS(syncfs),
>>      SCMP_SYS(time), /* Rarely needed, except on static builds */
>> --
>> 2.34.1
>>
>> _______________________________________________
>> Virtio-fs mailing list
>> Virtio-fs@redhat.com
>> https://listman.redhat.com/mailman/listinfo/virtio-fs
>>
>
> Reviewed-by:  German Maglione <gmaglione@redhat.com>

Thanks.

>
> Should we add this also in the rust version?, I see we don't have it
> enabled either.

Yep - thanks.

>
> --=20
> German
>
--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

