Return-Path: <gmaglion@redhat.com>
MIME-Version: 1.0
References: <20221125143946.27717-1-mhartmay@linux.ibm.com>
 <CAJh=p+7igBB9CMTUi--HCpcuxdHgveqgkw5dY7frE7Wqf==04w@mail.gmail.com>
 <87lenvjvxo.fsf@linux.ibm.com>
In-Reply-To: <87lenvjvxo.fsf@linux.ibm.com>
From: German Maglione <gmaglione@redhat.com>
Date: Mon, 28 Nov 2022 11:17:11 +0100
Message-ID: <CAJh=p+6ZoUD7788GewpvAPq2mc=QDEA89B3QMMcAynTqs9szxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
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
To: Marc Hartmayer <mhartmay@linux.ibm.com>
Cc: qemu-devel@nongnu.org, Stefan Liebler <stli@linux.ibm.com>, virtio-fs@redhat.com, Christian Borntraeger <borntraeger@de.ibm.com>, qemu-s390x <qemu-s390x@nongnu.org>, Sven Schnelle <svens@linux.ibm.com>, Stefan Hajnoczi <stefanha@redhat.com>

On Mon, Nov 28, 2022 at 10:00 AM Marc Hartmayer <mhartmay@linux.ibm.com> wr=
ote:
>
> German Maglione <gmaglione@redhat.com> writes:
>
> > On Fri, Nov 25, 2022 at 3:40 PM Marc Hartmayer <mhartmay@linux.ibm.com>=
 wrote:
> >>
> >> The virtiofsd currently crashes on s390x. This is because of a
> >> `sigreturn` system call. See audit log below:
> >>
> >> type=3DSECCOMP msg=3Daudit(1669382477.611:459): auid=3D4294967295 uid=
=3D0 gid=3D0 ses=3D4294967295 subj=3Dsystem_u:system_r:virtd_t:s0-s0:c0.c10=
23 pid=3D6649 comm=3D"virtiofsd" exe=3D"/usr/libexec/virtiofsd" sig=3D31 ar=
ch=3D80000016 syscall=3D119 compat=3D0 ip=3D0x3fff15f748a code=3D0x80000000=
AUID=3D"unset" UID=3D"root" GID=3D"root" ARCH=3Ds390x SYSCALL=3Dsigreturn
> >>
> >> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> >> ---
> >>  tools/virtiofsd/passthrough_seccomp.c | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/p=
assthrough_seccomp.c
> >> index 888295c073de..0033dab4939e 100644
> >> --- a/tools/virtiofsd/passthrough_seccomp.c
> >> +++ b/tools/virtiofsd/passthrough_seccomp.c
> >> @@ -110,6 +110,7 @@ static const int syscall_allowlist[] =3D {
> >>  #endif
> >>      SCMP_SYS(set_robust_list),
> >>      SCMP_SYS(setxattr),
> >> +    SCMP_SYS(sigreturn),
> >>      SCMP_SYS(symlinkat),
> >>      SCMP_SYS(syncfs),
> >>      SCMP_SYS(time), /* Rarely needed, except on static builds */
> >> --
> >> 2.34.1
> >>
> >> _______________________________________________
> >> Virtio-fs mailing list
> >> Virtio-fs@redhat.com
> >> https://listman.redhat.com/mailman/listinfo/virtio-fs
> >>
> >
> > Reviewed-by:  German Maglione <gmaglione@redhat.com>
>
> Thanks.
>
> >
> > Should we add this also in the rust version?, I see we don't have it
> > enabled either.
>
> Yep - thanks.

Could you test this MR to see if it is ok?
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/144

Thanks,

--=20
German

