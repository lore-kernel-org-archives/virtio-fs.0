Return-Path: <borntraeger@de.ibm.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=+wsnw95yRx++5NeHSfOM34OuFvLKXXPbvSmx2MFcj8o=;
 b=jBxU5AKZxNWnQF2KeQBcPHNp3XAPDRmZGJiDMkCv0ZN9Eo0ssx+p6C38nJ107pTNTAd1
 nfPuh5wGZr6XBl/t0Yj77lxfgQ3OyalcuYzGR/oAd8Fz9k7xEwfyB+GSpXmc4eQWiTrk
 cCDrIxEyymfELMTf0sufuHElzLUe5oAjUWN78Dmoak1o3cBTe86eeA60BrVk//NPNzfR
 y4o3MT11WLAgTa7TCxXjGPVHlKuirl3PVd4MFcFoT1Say4YzuEuiLNqk8aAGgbig/qxY
 zrZfzUU8Atrih1tLgnMePvlQKcYDwt7zhlKMiSXKbtSX5Hq4YFoq+z9EsrnZEt7092Sn Ww==
Message-ID: <f761e76b-ab11-a1d2-956e-c38167e3bbc2@de.ibm.com>
Date: Mon, 28 Nov 2022 07:18:59 +0100
References: <20221125143946.27717-1-mhartmay@linux.ibm.com>
 <CAJh=p+7igBB9CMTUi--HCpcuxdHgveqgkw5dY7frE7Wqf==04w@mail.gmail.com>
From: Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <CAJh=p+7igBB9CMTUi--HCpcuxdHgveqgkw5dY7frE7Wqf==04w@mail.gmail.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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
To: German Maglione <gmaglione@redhat.com>, Marc Hartmayer <mhartmay@linux.ibm.com>
Cc: qemu-devel@nongnu.org, Stefan Liebler <stli@linux.ibm.com>, virtio-fs@redhat.com, qemu-s390x <qemu-s390x@nongnu.org>, Sven Schnelle <svens@linux.ibm.com>, Stefan Hajnoczi <stefanha@redhat.com>


Am 25.11.22 um 17:32 schrieb German Maglione:
> On Fri, Nov 25, 2022 at 3:40 PM Marc Hartmayer <mhartmay@linux.ibm.com> wrote:
>>
>> The virtiofsd currently crashes on s390x. This is because of a
>> `sigreturn` system call. See audit log below:
>>
>> type=SECCOMP msg=audit(1669382477.611:459): auid=4294967295 uid=0 gid=0 ses=4294967295 subj=system_u:system_r:virtd_t:s0-s0:c0.c1023 pid=6649 comm="virtiofsd" exe="/usr/libexec/virtiofsd" sig=31 arch=80000016 syscall=119 compat=0 ip=0x3fff15f748a code=0x80000000AUID="unset" UID="root" GID="root" ARCH=s390x SYSCALL=sigreturn
>>
>> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> ---
>>   tools/virtiofsd/passthrough_seccomp.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
>> index 888295c073de..0033dab4939e 100644
>> --- a/tools/virtiofsd/passthrough_seccomp.c
>> +++ b/tools/virtiofsd/passthrough_seccomp.c
>> @@ -110,6 +110,7 @@ static const int syscall_allowlist[] = {
>>   #endif
>>       SCMP_SYS(set_robust_list),
>>       SCMP_SYS(setxattr),
>> +    SCMP_SYS(sigreturn),
>>       SCMP_SYS(symlinkat),
>>       SCMP_SYS(syncfs),
>>       SCMP_SYS(time), /* Rarely needed, except on static builds */
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
> 
> Should we add this also in the rust version?, I see we don't have it
> enabled either.

this is probably a good idea.

