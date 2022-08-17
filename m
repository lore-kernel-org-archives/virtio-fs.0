Return-Path: <dehghani.e@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=to:subject:message-id:date:from:mime-version:from:to:cc;
 bh=ZuvL1KW7p/51kTkABBchPgXaPjI92vEHl+aAOKWeaSY=;
 b=j9k83eiof08pqd4AUVKiJvmzbR2b2WvVRSOp6C2HrofwYdMTMt2JSKdrEk4DIoCInH
 5pibXCpdU8PBgnOKQNszeu1e+1umh/buE3rsXCx9lZ6KGn1KCum36O9JPWwBFDXtz5Zg
 BQFLBAMvFokjTXvxN+m83v1r46P8oAsrR9vMq7iwCeSun6KFL4XDJdHrDV9xoYmm2Kqk
 rbsc4FcGh65q3iFMtnPd6cejHyN+SzuEKQ0xrW1Q71bW4WEmuDcum5kLJOPC3HIy/Xok
 GYsHK6GnH/I+jmjr+WK/g3rN6O5ZeW30anQ2Wss1KdgtHxjd6UPxpMOsD45r+7XisF6x
 h/fA==
MIME-Version: 1.0
From: Elaheh Dehghani <dehghani.e@gmail.com>
Date: Wed, 17 Aug 2022 16:16:22 -0700
Message-ID: <CAH7xS_XHPenR9STmr7MNaHoGLr-Ks_FiFUYu482ntd1ftVsPfQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000003b2e4605e6780ebc"
Subject: [Virtio-fs] Map more than one uid/gid when running virtiofsd with
 unprivileged user
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

--0000000000003b2e4605e6780ebc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

We are using an unprivileged user to run virtiofsd in its own user
namespace. We have a guest VM running on top of QEMU with KVM. We are
sharing files from the host to the guest and we need to make sure only
certain users/groups in the guest can read/write those files. Currently
there is only one uid/gid that=E2=80=99s mapped correctly (the virtiofsd us=
er on
the host is mapped to guest) and everything else is mapped to nobody.

It seems the reason is that unprivileged virtiofsd only maps current
uid/gid when it's running inside its own user namespace.

Due to some resource limitations that we have in our system, we can't use a
container-engine such as lxc-usernsexec to map a range of uids/gids. So,
I'm trying to figure out if there is a way to patch the =E2=80=98setup_id_m=
appings=E2=80=99
in virtiofsd code to support our specific scenario.


The additional mapping that we need is for uid/gid=3D1000. What I've done:

-        Defined 1000:100000:65536 in both /etc/subuid and /etc/subgid

-        Changed this line src/sandbox.rs =C2=B7 main =C2=B7 virtio-fs / vi=
rtiofsd =C2=B7
GitLab
<https://gitlab.com/virtio-fs/virtiofsd/-/blob/main/src/sandbox.rs#L289> to
something like:

-         let uid_mapping =3D format!("{} {} 1\n1000 1000 1\n", uid, uid);


After running virtiofsd, I=E2=80=99m getting this error:

Error entering sandbox: WriteUidMap(Os { code: 1, kind: PermissionDenied,
message: =E2=80=9COperation not permitted=E2=80=9D })


What am I missing here?


Thanks,

Ellie

--0000000000003b2e4605e6780ebc
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><p class=3D"MsoNormal"><=
span style=3D"line-height:107%"><font face=3D"arial, sans-serif" style=3D""=
>We are using an unprivileged user to run=C2=A0virtiofsd=C2=A0in its own
user namespace.=C2=A0We have a guest VM running on top of QEMU with KVM.=C2=
=A0We
are sharing files from the host to the guest and we need to make sure only
certain users/groups in the guest can read/write those files.=C2=A0Currentl=
y
there is only one uid/gid that=E2=80=99s mapped correctly=C2=A0(the virtiof=
sd user on
the host is mapped to guest)=C2=A0and everything else is mapped to nobody.<=
/font></span></p>

<p class=3D"MsoNormal"><span style=3D"line-height:107%"><font face=3D"arial=
, sans-serif">It seems the reason is that unprivileged=C2=A0virtiofsd=C2=A0=
only maps
current uid/gid when it&#39;s running inside its own user namespace.=C2=A0<=
/font></span></p><p class=3D"MsoNormal"><span style=3D"line-height:107%"><f=
ont face=3D"arial, sans-serif">Due to some resource limitations that we hav=
e in our system, we can&#39;t use a
container-engine such as lxc-usernsexec to=C2=A0map a range of uids/gids. S=
o,
I&#39;m trying to figure out if there=C2=A0is a way to patch the
=E2=80=98setup_id_mappings=E2=80=99 in virtiofsd code to support our specif=
ic scenario.<span></span></font></span></p><p class=3D"MsoNormal"><span sty=
le=3D"line-height:107%"><font face=3D"arial, sans-serif"><br></font></span>=
</p>

<p class=3D"MsoNormal"><span style=3D"line-height:107%"><font face=3D"arial=
, sans-serif">The additional mapping that we need is for uid/gid=3D1000. Wh=
at I&#39;ve done:<span></span></font></span></p>

<p class=3D"gmail-MsoListParagraphCxSpFirst"><font face=3D"arial, sans-seri=
f"><span style=3D"line-height:107%">-<span style=3D"font-variant-numeric:no=
rmal;font-variant-east-asian:normal;font-stretch:normal;line-height:normal"=
>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
</span></span><span style=3D"line-height:107%">Defined 1000:100000:65536 in=
 both /etc/subuid and
/etc/subgid</span></font></p>

<p class=3D"gmail-MsoListParagraphCxSpMiddle"><font face=3D"arial, sans-ser=
if"><span style=3D"line-height:107%">-<span style=3D"font-variant-numeric:n=
ormal;font-variant-east-asian:normal;font-stretch:normal;line-height:normal=
">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
</span></span><span style=3D"line-height:107%">Changed this line </span><a =
href=3D"https://gitlab.com/virtio-fs/virtiofsd/-/blob/main/src/sandbox.rs#L=
289">src/sandbox.rs
=C2=B7 main =C2=B7 virtio-fs / virtiofsd =C2=B7 GitLab</a><span style=3D"li=
ne-height:107%"> to something like:<span></span></span></font></p>

<p class=3D"gmail-MsoListParagraphCxSpLast" style=3D"margin-bottom:0cm;line=
-height:14.25pt;background:rgb(30,30,30)"><font face=3D"arial, sans-serif">=
<span style=3D"color:rgb(212,212,212)">-<span style=3D"font-variant-numeric=
:normal;font-variant-east-asian:normal;font-stretch:normal;line-height:norm=
al">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
</span></span><span style=3D"color:rgb(86,156,214)">let</span><span style=
=3D"color:rgb(212,212,212)">
uid_mapping =3D </span><span style=3D"color:rgb(86,156,214)">format</span><=
span style=3D"color:rgb(212,212,212)">!(</span><span style=3D"color:rgb(206=
,145,120)">&quot;</span><span style=3D"color:rgb(86,156,214)">{}</span><spa=
n style=3D"color:rgb(206,145,120)">
</span><span style=3D"color:rgb(86,156,214)">{}</span><span style=3D"color:=
rgb(206,145,120)"> 1\n1000 1000 1\n&quot;</span><span style=3D"color:rgb(21=
2,212,212)">,
uid, uid);<span></span></span></font></p>

<p class=3D"MsoNormal"><font face=3D"arial, sans-serif"><br></font></p>

<p class=3D"MsoNormal"><span style=3D"line-height:107%"><font face=3D"arial=
, sans-serif">After running virtiofsd, I=E2=80=99m getting this error:<span=
></span></font></span></p>

<p class=3D"MsoNormal"><span style=3D"line-height:107%"><font face=3D"arial=
, sans-serif" style=3D"">Error entering sandbox: WriteUidMap(Os { code: 1,
kind: PermissionDenied, message: =E2=80=9COperation not permitted=E2=80=9D =
})<b style=3D"font-size:12pt"><span></span></b></font></span></p><p class=
=3D"MsoNormal"><b><span style=3D"font-size:12pt;line-height:107%;font-famil=
y:&quot;Times New Roman&quot;,serif"><br></span></b></p><p class=3D"MsoNorm=
al">What am I missing here?=C2=A0</p><p class=3D"MsoNormal"><br></p><p clas=
s=3D"MsoNormal">Thanks,</p><p class=3D"MsoNormal">Ellie</p></div></div></di=
v>

--0000000000003b2e4605e6780ebc--

