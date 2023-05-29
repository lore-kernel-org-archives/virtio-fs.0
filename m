Return-Path: <gmaglion@redhat.com>
MIME-Version: 1.0
References: <SA1P221MB1018666909025F9520B3A960B57B9@SA1P221MB1018.NAMP221.PROD.OUTLOOK.COM>
 <CAJh=p+7EnxbniPKyQX26waewoAv3jH_v1=3cGvp9b3Jpx9x=fw@mail.gmail.com>
 <SA1P221MB1018D1F87D19E4F29CC7AD98B5459@SA1P221MB1018.NAMP221.PROD.OUTLOOK.COM>
In-Reply-To: <SA1P221MB1018D1F87D19E4F29CC7AD98B5459@SA1P221MB1018.NAMP221.PROD.OUTLOOK.COM>
From: German Maglione <gmaglione@redhat.com>
Date: Mon, 29 May 2023 12:08:08 +0200
Message-ID: <CAJh=p+5bVCrxKcGWACpbYHyKohWe5o4CM8Cs0VAXYGd+UmF7tA@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000009ecc8f05fcd24566"
Subject: Re: [Virtio-fs] Is there a way to get NFS and/or NFSoRDMA to play
 nice with Virtio-FS?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Ewen Chan <alpha754293@hotmail.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

--0000000000009ecc8f05fcd24566
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 28, 2023 at 3:27=E2=80=AFPM Ewen Chan <alpha754293@hotmail.com>=
 wrote:

> German:
>
> I finally got around to testing this and unfortunately, I am still gettin=
g
> the stale file handle error.
>
> Here is the command that I used for virtiofsd (which is embedded inside a
> startup script file in Proxmox).
>
> nohup /usr/lib/kvm/virtiofsd --syslog --daemonize
> --socket-path=3D/var/run/shared-fs.sock -o source=3D/export/myfs/ -o cach=
e=3Dnone
> &> /dev/null  &
>
> If you have any other suggestions, that would be greatly appreciated.
>
>
Sadly no, since FUSE does not support persistent file handles, I don't
think it would work
(I know the NFsv4 protocol defines volatile file handles, but idk if that
is currently implemented or even if it would solve the problem)

Maybe you could try with a nfs proxy



> Thank you.
>
> Sincerely,
> Ewen
> ------------------------------
> *From:* German Maglione <gmaglione@redhat.com>
> *Sent:* May 14, 2023 1:06 PM
> *To:* Ewen Chan <alpha754293@hotmail.com>
> *Cc:* virtio-fs@redhat.com <virtio-fs@redhat.com>
> *Subject:* Re: [Virtio-fs] Is there a way to get NFS and/or NFSoRDMA to
> play nice with Virtio-FS?
>
> Hi Ewen,
>
> On Sun, May 14, 2023 at 9:49=E2=80=AFAM Ewen Chan <alpha754293@hotmail.co=
m> wrote:
>
> To Whom It May Concern:
>
> I'm using Proxmox 7.3-4 and I have a CentOS 7.7.1908 VM that's able to
> share data/files via Virtio-FS. That part is working fine.
>
> However, if I try to export that VirtIO-FS "target" as a NFS export,
> whenever my other computers connect to that NFS share, it will say that t=
he
> folders have stale NFS handles.
>
> Is there a way to fix/resolve this?
>
> Here is the output for /etc/exports:
>
> /export *(rw,async,no_root_squash,no_all_squash,no_subtree_check,fsid=3D4=
)
>
> I have tried rebooting the clients multiple times, along with
> mounting/unmounting said NFS share and it doesn't appear to make any
> difference.
>
>
> Just to confirm, you want to share a folder using virtiofs with a VM, and
> then that VM running as an NFS server sharing that same folder over nfs, =
am
> I right?
>
> If that is the case, it's not possible (*) the NFS server requires
> persistent file handles that FUSE does not support.
>
> (*) I'm not sure, but IIRC Miklos said it could work if you disable the
> cache, so you can try running virtiofsd with `--cache=3Dnone` (let me kno=
w if
> that work).
>
>
>
>
> Your help is greatly appreciated.
>
> Thank you.
>
> Sincerely,
> Ewen
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
>
>
>
> --
> German
>


--=20
German

--0000000000009ecc8f05fcd24566
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Sun, May 28, 2023 at 3:27=E2=80=AF=
PM Ewen Chan &lt;<a href=3D"mailto:alpha754293@hotmail.com">alpha754293@hot=
mail.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D=
"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-le=
ft:1ex"><div class=3D"msg-2999798650551694767">




<div dir=3D"ltr">
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
German:</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
I finally got around to testing this and unfortunately, I am still getting =
the stale file handle error.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
Here is the command that I used for virtiofsd (which is embedded inside a s=
tartup script file in Proxmox).</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
nohup /usr/lib/kvm/virtiofsd --syslog --daemonize --socket-path=3D/var/run/=
shared-fs.sock -o source=3D/export/myfs/ -o cache=3Dnone &amp;&gt; /dev/nul=
l =C2=A0&amp;</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
If you have any other suggestions, that would be greatly appreciated.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
<br></div></div></div></blockquote><div><br></div><div>Sadly no, since FUSE=
 does not support persistent file handles, I don&#39;t think it would work<=
br></div><div>(I know the NFsv4 protocol defines volatile file handles, but=
 idk if that is currently implemented or even if it would solve the problem=
)</div><div><br></div><div>Maybe you could try with a nfs proxy</div><div><=
br></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin=
:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"=
><div class=3D"msg-2999798650551694767"><div dir=3D"ltr"><div style=3D"font=
-family:Calibri,Helvetica,sans-serif;font-size:12pt;color:rgb(0,0,0)">
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
Thank you.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
Sincerely,</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
Ewen<br>
</div>
<div id=3D"m_-2999798650551694767appendonsend"></div>
<hr style=3D"display:inline-block;width:98%">
<div id=3D"m_-2999798650551694767divRplyFwdMsg" dir=3D"ltr"><font style=3D"=
font-size:11pt" face=3D"Calibri, sans-serif" color=3D"#000000"><b>From:</b>=
 German Maglione &lt;<a href=3D"mailto:gmaglione@redhat.com" target=3D"_bla=
nk">gmaglione@redhat.com</a>&gt;<br>
<b>Sent:</b> May 14, 2023 1:06 PM<br>
<b>To:</b> Ewen Chan &lt;<a href=3D"mailto:alpha754293@hotmail.com" target=
=3D"_blank">alpha754293@hotmail.com</a>&gt;<br>
<b>Cc:</b> <a href=3D"mailto:virtio-fs@redhat.com" target=3D"_blank">virtio=
-fs@redhat.com</a> &lt;<a href=3D"mailto:virtio-fs@redhat.com" target=3D"_b=
lank">virtio-fs@redhat.com</a>&gt;<br>
<b>Subject:</b> Re: [Virtio-fs] Is there a way to get NFS and/or NFSoRDMA t=
o play nice with Virtio-FS?</font>
<div>=C2=A0</div>
</div>
<div>
<div dir=3D"ltr">
<div dir=3D"ltr">Hi Ewen,<br>
</div>
<br>
<div>
<div dir=3D"ltr">On Sun, May 14, 2023 at 9:49=E2=80=AFAM Ewen Chan &lt;<a h=
ref=3D"mailto:alpha754293@hotmail.com" target=3D"_blank">alpha754293@hotmai=
l.com</a>&gt; wrote:<br>
</div>
<blockquote style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204=
,204,204);padding-left:1ex">
<div>
<div dir=3D"ltr">
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
To Whom It May Concern:<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
<br>
I&#39;m using Proxmox 7.3-4 and I have a CentOS 7.7.1908 VM that&#39;s able=
 to share data/files via Virtio-FS. That part is working fine.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
However, if I try to export that VirtIO-FS &quot;target&quot; as a NFS expo=
rt, whenever my other computers connect to that NFS share, it will say that=
 the folders have stale NFS handles.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
Is there a way to fix/resolve this?</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
Here is the output for /etc/exports:</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
/export *(rw,async,no_root_squash,no_all_squash,no_subtree_check,fsid=3D4)<=
/div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
I have tried rebooting the clients multiple times, along with mounting/unmo=
unting said NFS share and it doesn&#39;t appear to make any difference.</di=
v>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
<br>
</div>
</div>
</div>
</blockquote>
<div><br>
</div>
<div>Just to confirm, you want to share a folder using virtiofs with a VM, =
and then that VM running as an NFS server sharing that same folder over nfs=
, am I right?</div>
<div><br>
</div>
<div>If that is the case, it&#39;s not possible (*) the NFS server requires=
 persistent file handles that FUSE does not support.</div>
<div><br>
</div>
<div>(*) I&#39;m not sure, but IIRC Miklos said it could work if you disabl=
e the cache, so you can try running virtiofsd with `--cache=3Dnone` (let me=
 know if that work).</div>
<div><br>
</div>
<div><br>
</div>
<div>=C2=A0</div>
<blockquote style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204=
,204,204);padding-left:1ex">
<div>
<div dir=3D"ltr">
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0)">
Your help is greatly appreciated.<br>
<br>
Thank you.<br>
<br>
Sincerely,<br>
Ewen<br>
</div>
</div>
_______________________________________________<br>
Virtio-fs mailing list<br>
<a href=3D"mailto:Virtio-fs@redhat.com" target=3D"_blank">Virtio-fs@redhat.=
com</a><br>
<a href=3D"https://listman.redhat.com/mailman/listinfo/virtio-fs" rel=3D"no=
referrer" target=3D"_blank">https://listman.redhat.com/mailman/listinfo/vir=
tio-fs</a><br>
</div>
</blockquote>
</div>
<br clear=3D"all">
<br>
<span>-- </span><br>
<div dir=3D"ltr">
<div dir=3D"ltr">German<br>
</div>
</div>
</div>
</div>
</div>

</div></blockquote></div><br clear=3D"all"><br><span class=3D"gmail_signatu=
re_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail_signature"><div di=
r=3D"ltr">German<br></div></div></div>

--0000000000009ecc8f05fcd24566--

