Return-Path: <xiagao@redhat.com>
MIME-Version: 1.0
References: <SA1P221MB1018AA58757048B93CFB3437B5AD9@SA1P221MB1018.NAMP221.PROD.OUTLOOK.COM>
 <CADVA6RSDvd1PiqMuRS2EK=qcM-u9-8GkTN1R3PMfiyQF6_3FfQ@mail.gmail.com>
 <SA1P221MB101899A720637370A7C33E64B5B39@SA1P221MB1018.NAMP221.PROD.OUTLOOK.COM>
In-Reply-To: <SA1P221MB101899A720637370A7C33E64B5B39@SA1P221MB1018.NAMP221.PROD.OUTLOOK.COM>
From: Xiaoling Gao <xiagao@redhat.com>
Date: Fri, 3 Mar 2023 15:24:54 +0800
Message-ID: <CADVA6RRx4vNp4SB98TzJRnrmFo+L1gz508r5YwY8_PpRp+c3cg@mail.gmail.com>
Content-Type: multipart/related; boundary="0000000000002a8b3d05f5f9d8ac"
Subject: Re: [Virtio-fs] [virtio-fs] Windows 10 VirtioFS Service error - The
 service did not respond to the start or control request in a timely fashion
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

--0000000000002a8b3d05f5f9d8ac
Content-Type: multipart/alternative; boundary="0000000000002a8b3b05f5f9d8ab"

--0000000000002a8b3b05f5f9d8ab
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ewen Chan <alpha754293@hotmail.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=883=E6=97=
=A5=E5=91=A8=E4=BA=94 12:09=E5=86=99=E9=81=93=EF=BC=9A

> Xiaoling:
>
> The only thing that I did was I had to pull all of the drives out from th=
e
> system because I needed to move the system from one area in the basement =
of
> my home for my homelab into my rack, and then put all the drives back.
>
> No other updates, either to Proxmox, nor the system, was performed.
>
> When I type:
> # ps aux | grep virtiofs
> it shows that the processes are running.
>
> I am not really sure how else I can check the status of the virtiofsd
> daemon.
>
>
>
> Seems like the daemon is running well, then could you pls check if the
winfsp software is installed or not? Virtiofs service depends on it.
Besides that, this issue seems to windows related, you can submit issue in
https://github.com/virtio-win/kvm-guest-drivers-windows/issues

Regards,
Xiaoling


> Thank you.
>
> Sincerely,
> Ewen
> ------------------------------
> *From:* Xiaoling Gao <xiagao@redhat.com>
> *Sent:* March 2, 2023 9:08 PM
> *To:* Ewen Chan <alpha754293@hotmail.com>
> *Cc:* virtio-fs@redhat.com <virtio-fs@redhat.com>
> *Subject:* Re: [Virtio-fs] [virtio-fs] Windows 10 VirtioFS Service error
> - The service did not respond to the start or control request in a timely
> fashion
>
>
>
> Ewen Chan <alpha754293@hotmail.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=881=E6=
=97=A5=E5=91=A8=E4=B8=89 20:05=E5=86=99=E9=81=93=EF=BC=9A
>
> To Whom It May Concern:
>
> I am trying to use Virtiofs inside a Windows 10 VM under Proxmox 7.3-3.
>
> Previously, I was able to do it, but now, for some reason, whenever I try
> to start the service, this is the error message that I get:
>
>
> I tried a fresh install of Windows 10 Pro x64 and then installed the
> virtio Windows drivers (virtio-win-0.1.229.iso) this error is still poppi=
ng
> up.
>
> I have a script which daemonizes the virtiofsd daemon:
>
>   # cat launch-virtio-daemon.sh
>
> #!/usr/bin/bash
>
>
>
> function launch() {
>
>     nohup /usr/lib/kvm/virtiofsd --syslog --daemonize
> --socket-path=3D/var/run/shared-fs.sock -o source=3D/export/myfs/ -o
> cache=3Dalways &> /dev/null  &
>     return 0
> }
>
> launch
>
>
> And in my Proxmox VM, I have called the launch-virtio-daemon.sh via a
> Proxmox hookscript:
>
> qm set 101 --hookscript local:snippets/virtiofs.pl
>
> and this is what's in the virtiofs.pl file:
>
> # cat /var/lib/vz/snippets/virtiofs.pl
>
> #!/usr/bin/perl
>
> # Exmple hook script for PVE guests (hookscript config option)
> # You can set this via pct/qm with
> # pct set <vmid> -hookscript <volume-id>
> # qm set <vmid> -hookscript <volume-id>
> # where <volume-id> has to be an executable file in the snippets folder
> # of any storage with directories e.g.:
> # qm set 100 -hookscript local:snippets/hookscript.pl
>
> use strict;
> use warnings;
>
> print "GUEST HOOK: " . join(' ', @ARGV). "\n";
>
> # First argument is the vmid
>
> my $vmid =3D shift;
>
> # Second argument is the phase
>
> my $phase =3D shift;
>
> if ($phase eq 'pre-start') {
>
>     # First phase 'pre-start' will be executed before the guest
>     # ist started. Exiting with a code !=3D 0 will abort the start
>
>     print "$vmid is starting, doing preparations.\n";
>
>     system('/var/lib/vz/snippets/launch-virtio-daemon.sh');
>
>     # print "preparations failed, aborting."
>     # exit(1);
>
> } elsif ($phase eq 'post-start') {
>
>     # Second phase 'post-start' will be executed after the guest
>     # successfully started.
>
>     print "$vmid started successfully.\n";
>
> } elsif ($phase eq 'pre-stop') {
>
>     # Third phase 'pre-stop' will be executed before stopping the guest
>     # via the API. Will not be executed if the guest is stopped from
>     # within e.g., with a 'poweroff'
>
>     print "$vmid will be stopped.\n";
>
> } elsif ($phase eq 'post-stop') {
>
>     # Last phase 'post-stop' will be executed after the guest stopped.
>     # This should even be executed in case the guest crashes or stopped
>     # unexpectedly.
>
>     print "$vmid stopped. Doing cleanup.\n";
>
> } else {
>     die "got unknown phase '$phase'\n";
> }
>
> exit(0);
>
>
>
> This was working before and now I don't really know nor understand why it
> isn't working anymore.
>
>
> Hi, you said it was working before, did you do some updates that lead to
> the failure?
> And could you check the virtiofsd daemon process status?
>
> Best,
> Xiaoling
>
>
>
> Your help would be greatly appreciated.
>
> Thank you.
>
> Sincerely,
> Ewen Chan
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
>
>
>
> --
> BR,
> Xiaoling
>


--=20
BR,
Xiaoling

--0000000000002a8b3b05f5f9d8ab
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">Ewen Chan &lt;<a href=3D"mailto:alpha=
754293@hotmail.com">alpha754293@hotmail.com</a>&gt; =E4=BA=8E2023=E5=B9=B43=
=E6=9C=883=E6=97=A5=E5=91=A8=E4=BA=94 12:09=E5=86=99=E9=81=93=EF=BC=9A<br><=
/div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bo=
rder-left:1px solid rgb(204,204,204);padding-left:1ex"><div class=3D"msg-32=
9195899546246133">




<div dir=3D"ltr">
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
Xiaoling:<br>
<br>
The only thing that I did was I had to pull all of the drives out from the =
system because I needed to move the system from one area in the basement of=
 my home for my homelab into my rack, and then put all the drives back.</di=
v>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
No other updates, either to Proxmox, nor the system, was performed.<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
When I type:</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
# ps aux | grep virtiofs</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
it shows that the processes are running.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
I am not really sure how else I can check the status of the virtiofsd daemo=
n.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<img style=3D"max-width: 100%;" size=3D"6764" src=3D"cid:186a5fdff316d0e7b4=
12"><br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br></div></div></div></blockquote><div>Seems like the daemon is running we=
ll, then could you pls check if the winfsp software is installed or not? Vi=
rtiofs service depends on it.</div><div>Besides that, this issue seems to w=
indows related, you can submit issue in=C2=A0<a href=3D"https://github.com/=
virtio-win/kvm-guest-drivers-windows/issues">https://github.com/virtio-win/=
kvm-guest-drivers-windows/issues</a>=C2=A0</div><div><br></div><div>Regards=
,</div><div>Xiaoling</div><div>=C2=A0</div><blockquote class=3D"gmail_quote=
" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);=
padding-left:1ex"><div class=3D"msg-329195899546246133"><div dir=3D"ltr"><d=
iv style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color:r=
gb(0,0,0);background-color:rgb(255,255,255)">
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
Thank you.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
Sincerely,</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
Ewen<br>
</div>
<div id=3D"m_-329195899546246133appendonsend"></div>
<hr style=3D"display:inline-block;width:98%">
<div id=3D"m_-329195899546246133divRplyFwdMsg" dir=3D"ltr"><font face=3D"Ca=
libri, sans-serif" style=3D"font-size:11pt" color=3D"#000000"><b>From:</b> =
Xiaoling Gao &lt;<a href=3D"mailto:xiagao@redhat.com" target=3D"_blank">xia=
gao@redhat.com</a>&gt;<br>
<b>Sent:</b> March 2, 2023 9:08 PM<br>
<b>To:</b> Ewen Chan &lt;<a href=3D"mailto:alpha754293@hotmail.com" target=
=3D"_blank">alpha754293@hotmail.com</a>&gt;<br>
<b>Cc:</b> <a href=3D"mailto:virtio-fs@redhat.com" target=3D"_blank">virtio=
-fs@redhat.com</a> &lt;<a href=3D"mailto:virtio-fs@redhat.com" target=3D"_b=
lank">virtio-fs@redhat.com</a>&gt;<br>
<b>Subject:</b> Re: [Virtio-fs] [virtio-fs] Windows 10 VirtioFS Service err=
or - The service did not respond to the start or control request in a timel=
y fashion</font>
<div>=C2=A0</div>
</div>
<div>
<div dir=3D"ltr">
<div dir=3D"ltr"><br>
</div>
<br>
<div>
<div dir=3D"ltr">Ewen Chan &lt;<a href=3D"mailto:alpha754293@hotmail.com" t=
arget=3D"_blank">alpha754293@hotmail.com</a>&gt; =E4=BA=8E2023=E5=B9=B43=E6=
=9C=881=E6=97=A5=E5=91=A8=E4=B8=89 20:05=E5=86=99=E9=81=93=EF=BC=9A<br>
</div>
<blockquote style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204=
,204,204);padding-left:1ex">
<div>
<div dir=3D"ltr">
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
To Whom It May Concern:</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
I am trying to use Virtiofs inside a Windows 10 VM under Proxmox 7.3-3.</di=
v>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
Previously, I was able to do it, but now, for some reason, whenever I try t=
o start the service, this is the error message that I get:</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<img size=3D"6810" style=3D"max-width: 100%;" src=3D"cid:186a5fdff316d0e7b4=
11"></div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
I tried a fresh install of Windows 10 Pro x64 and then installed the virtio=
 Windows drivers (virtio-win-0.1.229.iso) this error is still popping up.</=
div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
I have a script which daemonizes the virtiofsd daemon:</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<span>=E2=80=82=E2=80=82=E2=80=82=E2=80=82=C2=A0 # cat launch-virtio-daemon=
.sh</span><br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<blockquote style=3D"margin-top:0px;margin-bottom:0px">
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">#!/usr/b=
in/bash</span></div>
</blockquote>
<div><br>
</div>
<blockquote style=3D"margin-top:0px;margin-bottom:0px">
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">function=
 launch() {</span></div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">=C2=A0 =
=C2=A0 nohup /usr/lib/kvm/virtiofsd --syslog --daemonize --socket-path=3D/v=
ar/run/shared-fs.sock -o source=3D/export/myfs/ -o cache=3Dalways &amp;&gt;=
 /dev/null =C2=A0&amp;</span></div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">=C2=A0 =
=C2=A0 return 0</span></div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">}</span>=
</div>
<div><br>
</div>
<span style=3D"font-family:&quot;Courier New&quot;,monospace">launch</span>=
<br>
</blockquote>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
And in my Proxmox VM, I have called the launch-virtio-daemon.sh via a Proxm=
ox hookscript:</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
qm set 101 --hookscript local:snippets/<a href=3D"http://virtiofs.pl" targe=
t=3D"_blank">virtiofs.pl</a></div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
and this is what&#39;s in the <a href=3D"http://virtiofs.pl" target=3D"_bla=
nk">virtiofs.pl</a> file:</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
# cat /var/lib/vz/snippets/<a href=3D"http://virtiofs.pl" target=3D"_blank"=
>virtiofs.pl</a></div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<blockquote style=3D"margin-top:0px;margin-bottom:0px"><span style=3D"font-=
family:&quot;Courier New&quot;,monospace">#!/usr/bin/perl</span>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace"># Exmple=
 hook script for PVE guests (hookscript config option)</span></div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace"># You ca=
n set this via pct/qm with</span></div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace"># pct se=
t &lt;vmid&gt; -hookscript &lt;volume-id&gt;</span></div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace"># qm set=
 &lt;vmid&gt; -hookscript &lt;volume-id&gt;</span></div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace"># where =
&lt;volume-id&gt; has to be an executable file in the snippets folder</span=
></div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace"># of any=
 storage with directories e.g.:</span></div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace"># qm set=
 100 -hookscript local:snippets/<a href=3D"http://hookscript.pl" target=3D"=
_blank">hookscript.pl</a></span></div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">use stri=
ct;</span></div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">use warn=
ings;</span></div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">print &q=
uot;GUEST HOOK: &quot; . join(&#39; &#39;, @ARGV). &quot;\n&quot;;</span></=
div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace"># First =
argument is the vmid</span></div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">my $vmid=
 =3D shift;</span></div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace"># Second=
 argument is the phase</span></div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">my $phas=
e =3D shift;</span></div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">if ($pha=
se eq &#39;pre-start&#39;) {</span></div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">=C2=A0 =
=C2=A0 # First phase &#39;pre-start&#39; will be executed before the guest<=
/span></div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">=C2=A0 =
=C2=A0 # ist started. Exiting with a code !=3D 0 will abort the start</span=
></div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">=C2=A0 =
=C2=A0 print &quot;$vmid is starting, doing preparations.\n&quot;;</span></=
div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">=C2=A0 =
=C2=A0 system(&#39;/var/lib/vz/snippets/launch-virtio-daemon.sh&#39;);</spa=
n></div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">=C2=A0 =
=C2=A0 # print &quot;preparations failed, aborting.&quot;</span></div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">=C2=A0 =
=C2=A0 # exit(1);</span></div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">} elsif =
($phase eq &#39;post-start&#39;) {</span></div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">=C2=A0 =
=C2=A0 # Second phase &#39;post-start&#39; will be executed after the guest=
</span></div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">=C2=A0 =
=C2=A0 # successfully started.</span></div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">=C2=A0 =
=C2=A0 print &quot;$vmid started successfully.\n&quot;;</span></div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">} elsif =
($phase eq &#39;pre-stop&#39;) {</span></div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">=C2=A0 =
=C2=A0 # Third phase &#39;pre-stop&#39; will be executed before stopping th=
e guest</span></div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">=C2=A0 =
=C2=A0 # via the API. Will not be executed if the guest is stopped from</sp=
an></div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">=C2=A0 =
=C2=A0 # within e.g., with a &#39;poweroff&#39;</span></div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">=C2=A0 =
=C2=A0 print &quot;$vmid will be stopped.\n&quot;;</span></div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">} elsif =
($phase eq &#39;post-stop&#39;) {</span></div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">=C2=A0 =
=C2=A0 # Last phase &#39;post-stop&#39; will be executed after the guest st=
opped.</span></div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">=C2=A0 =
=C2=A0 # This should even be executed in case the guest crashes or stopped<=
/span></div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">=C2=A0 =
=C2=A0 # unexpectedly.</span></div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">=C2=A0 =
=C2=A0 print &quot;$vmid stopped. Doing cleanup.\n&quot;;</span></div>
<div><br>
</div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">} else {=
</span></div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">=C2=A0 =
=C2=A0 die &quot;got unknown phase &#39;$phase&#39;\n&quot;;</span></div>
<div><span style=3D"font-family:&quot;Courier New&quot;,monospace">}</span>=
</div>
<div><br>
</div>
<span style=3D"font-family:&quot;Courier New&quot;,monospace">exit(0);</spa=
n><br>
</blockquote>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
This was working before and now I don&#39;t really know nor understand why =
it isn&#39;t working anymore.</div>
</div>
</div>
</blockquote>
<div>=C2=A0</div>
<div>Hi, you said it was working before, did you do some updates that lead =
to the failure?</div>
<div>And could you check the virtiofsd daemon process status?</div>
<div><br>
</div>
<div>Best,</div>
<div>Xiaoling</div>
<div>=C2=A0</div>
<blockquote style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204=
,204,204);padding-left:1ex">
<div>
<div dir=3D"ltr">
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
Your help would be greatly appreciated.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
Thank you.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
Sincerely,</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
Ewen Chan<br>
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
<div><br>
</div>
-- <br>
<div dir=3D"ltr">
<div dir=3D"ltr">BR,
<div>Xiaoling</div>
</div>
</div>
</div>
</div>
</div>

</div></blockquote></div><br clear=3D"all"><div><br></div>-- <br><div dir=
=3D"ltr" class=3D"gmail_signature"><div dir=3D"ltr">BR,<div>Xiaoling</div><=
/div></div></div>

--0000000000002a8b3b05f5f9d8ab--

--0000000000002a8b3d05f5f9d8ac
Content-Type: image/png; name="Capture.PNG"
Content-Disposition: inline; filename="Capture.PNG"
Content-Transfer-Encoding: base64
Content-ID: <186a5fdff316d0e7b411>
X-Attachment-Id: 186a5fdff316d0e7b411

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
3r7Stqka7OwIAAAE1Yw6DTu+wKxobjPKNMzZEQAACKoZdRZ2vM3fikIxOwIAGCyqGXUWdrzl34pC
MTsCABgmqhl1EnZcZiiPjsz/Hsp0pCNldUmdzI4AAIaFakadhB2XGYoYQx9idgQAMChUMxpM2HEA
ANgQ1M1oNJCw4wAAsGHwzSh4a3dnf/QKAAAbGswIAAB6BzMCAIDewYwAAKB3MCMAAOidpBl1HnYc
AAA2JKoZ9RZ2HAAANiSqGfUSdhwAADYsqhn1EnZ8kEgAvCpkhWjSRdxuG0Y8CBHuhSF3Ap8XIchz
uSHHq/XT8OQq9T5WIdCHFgBQ2rPs0OluH1PlL3tfDG3fzkOs7Yv2KczXxr5ZVtuGxnraN6y+qWbU
edjxwdL1wVozK+PMDMbjwIzcduRpcj+SzzPapxmbitbXYZ2s7dC0j8veFxfzvo21fdE+hfna2DfL
atvQWE/7htU334yKd9N1HnZ8sMQOVr5+MhlnxrGSWUK4XKYJZxqCljZE0jgGIrMiZza0tpKZlS2w
oRmV9QTl+OTt8ssq1q1UszJ/luX0MVKutDXPG5prmC+vK98vEzOZGq5syup39rO/L7VywnUhbpqs
rmmZqfLddC5Fnib7yKunXKfNXPMyo+eT06/6/q23x98NWnuEer74sdb2hVuumzdWX4mWb5626MfY
3y9aHcUXP2+dkNed73v5UqilcXHLru/P+HWu9SFdVn1/uOnddYlzRyt3utwvqhl1GnZ80PgHO7wN
5p/A/skqt8+my9PB1C7U0taRNNXgXZlPwdRUYheUczG6F8JCZpSVUeaR/E67pI/5ppgp+v0o0fP5
+8W2v6i32pd+G+0tyqA/s9vklmcXsj65bfDL19O5zN5HXhneeaC3ryxzmi9D75ekC/fvetozR77o
vvDXx+tzCfPNbkt9X7hIfm2/aGkFN31ed7XvU/myrTP2Z1WOj+TTzt1UWfr+CNtXrzddbrxvXaOa
UadhxwdN7GBpJ0DT5ViZLpKmupjiZuQSKXept+ncZfmcXSCOak2yg0V40cXyBXVNZ3Th4Kt9LmnS
pjBfrMxUOpem5QmpbS5aPq1fsf3btM5lbHOZlW4Z+eSzti9cmuyXDDuol+W45afa4pJKO08+YZ6y
mm4T5snbL6oZdRZ2fPDEDtY8B1xwl2Nlukgax0AC86mZU0H1jdEntt5Ha9d6+5GTz9Ji3+RKwvWF
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
0Ysvvmj+HxiDD28RZtnwAAAAAElFTkSuQmCC
--0000000000002a8b3d05f5f9d8ac
Content-Type: image/png; name="Capture.PNG"
Content-Disposition: inline; filename="Capture.PNG"
Content-Transfer-Encoding: base64
Content-ID: <186a5fdff316d0e7b412>
X-Attachment-Id: 186a5fdff316d0e7b412

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
V5k76c5mPZtZZzIfu52PM+fuAs9XZ1de57MXVJnKY19lKi+oMuj9Cbrzr/K7mXXlBZipwHzWR73z
ApXhNfsMZjg7nVHrPJwxg7C/9BcNWI41z7Hx6pxp3wLfW3evu37oWffU3wX3xNfpOaf9jtP9T/sT
Yj+1L2r4mq0zH3npis4/Zed81PA1W7M2ZafzK8SzUc+H9SzXeVfQ7X9yfnS7/skZO+B5+Dq9hq7f
+SuoHmurM2ux5gznFLs+69Oc0jmzMuMrZgKls6YynYd6rDHHc4bKsZbNSHhVfjp3RF6x4vN+MXeZ
ymOUx9rq3BF5xYrP+8XMdPlqxle13pkR5akZtW7uiLxixef9rppZY7+bM409BWeyGVFelX8RfmS6
fIbqsaYyiPJRizVnOBdsfdEQm2TrnTnTvoW4N0WWZT3o/Bene3T+KrEf7ovrDuxGB9en4N6xJ647
sBsdXJ+i9sW9UQtdrZUWeyCZV3WuoNs/80NHX62VFntM2On8Gtkzmj67aW6Hbu+rzq72ueqMFeJM
PBvXHdiNjlorLfaYkHVYVzmlIeFHRuWVxnSZzGdd5ZTGnsqwVs34iplMU3qWq7zQw+Mczxkqx9ok
w1Q+e1X2Lroz2e/mDJVjbXW+m8n5oSGV94L9WCst1jszUnkvlB8ag5m7qc5kr5sVkVFZ9gKVQW0F
7mczEp7KM+xnMxO+6mS6yoWGZD7OKoPai+2/aGDYW50z7VvJ7rV7Bp0fnO7T+avEfrjnyhmn/Y7T
/U/7Hd3eMWeZzmeUV+WvoNu/8sNDH+fON2esPNvKe9H5u1xxbmSmual+N3Eunq2uReUyHefOn1Dl
2VvJdnrQ+cHuPqx3M4M+Z1dmfM0yzEm204POD1SOtUkmY9JVmT9Fdjbr0xyjfNZW57vpzl+dGfTx
Va13ZiTzdjrvQF0La92swAzneVZMMhXcx7nyKg1hv8szVZ691TnTkMp/7BcNyv8msvvr7nvau3o+
Re1XaStZ1HaZ7h/aSha1XXivbmZt1V+dT+n2X51Z6/wpO51fgJ/L6oxU3i685+rMOnusqUyl3406
t9JWshO/o8uyvzpn2sRjumzms44zewrOZDPrnMVXtc6ITJfN/JVelVUea5NM5a3OdzM9P3T2uxlR
HmtVBkH/Tvi8O2d8VeudGVFepmW+yt9Jd/7p3GUqT2nK7+AOzpWntM7PMhmTbGRUlrVJZuq92Pqf
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
tc7DGTMI+0t/0YDlWPMcG6/OmfYt8L1197rrh551Kx895Z+Ae+Lr9JzTfsfp/qd9pOqFV+2rfOwp
X+WUHmvWcGZ9FdXHfSt/d56y2/sF4tl0z+fdz7A7/+T6otv1T87YAc/D1+k1dP3OX0H1WFudWYs1
Zzin2PVZn+aUzpmVGV8xEyidNZXpPNRjjTmeM1SOtWxGwqvy07kj8ooVn/eLuctUHqM81lbnjsgr
VnzeL2amy1czvqr1zowoT82odXNH5BUrPu931cwa+92caewpOJPNiPKq/IvwI9PlM1SPNZVBlI9a
rDnDuWDri4bYJFvvzJn2LcS9KbIs60Hnv1jdA+dYo38K7hn74roDu9HB9Sm4d+yJ6w7sRgfXU6ad
LHfaD9iPGfVuHfMKWY/1bFZM/Ck7nV+je0bvfIZ/6tqqfa46Y4U4E8/GdQd2o6PWSos9JmQd1lVO
aUj4kVF5pTFdJvNZVzmlsacyrFUzvmIm05Se5Sov9PA4x3OGyrE2yTCVz16VvYvuTPa7OUPlWFud
72ZyfmhI5b1gP9ZKi/XOjFTeC+WHxmDmbqoz2etmRWRUlr1AZVBbgfvZjISn8gz72cyErzqZrnKh
IZmPs8qg9mL7LxoY9lbnTPtWsnvtnkHnB6v7dPMpsd/uGaf9jtP9T/svVvIqe9pH2I9ZaVU+5glV
h70q++LUN2vw86yeb+XdSXfu5LoiM81N9buJc/FsdS0ql+k4d/6EKs/eSrbTg84PdvdhvZsZ9Dm7
MuNrlmFOsp0edH6gcqxNMhmTrsr8KbKzWZ/mGOWztjrfTXf+6sygj69qvTMjmbfTeQfqWljrZgVm
OM+zYpKp4D7OlVdpCPtdnqny7K3OmYZU/mO/aFD+N5HdX3ff097V8ylqv0pbyaK2y3T/0FayqGVw
9ukza+zz3NH1u5k59TN2e98OP5fqOVXeXfCZqzPr7LGmMpV+N+rcSlvJTvyOLsv+6pxpE4/pspnP
Os7sKTiTzaxzFl/VOiMyXTbzV3pVVnmsTTKVtzrfzfT80NnvZkR5rFUZBP074fPunPFVrXdmRHmZ
lvkqfyfd+adzl6k8pSm/gzs4V57SOj/LZEyykVFZ1iaZqfdi638GmW3YZTqfM8r/BvAe+T6VhlR+
eFnm1D+F91dnTL0sc8Jk/6mXZTJU90WVqbygyqC343Om8jq4G1QZ9JAu1/kVO51fAZ+pekbsB5y7
A3Xui6k/YdKtvLvBa9u5jq7f+RWTLO+La/ZR77zwWWN4j2Diq3XMocVakXW4p7RMR011FGof9hjl
cTeoMughmV910Ztm2Mtyd4Hnd+eqDHbZU36Q+dhlJpmr4Wvja1jxUVdZpcXMepVVGabzsj56f4Lu
/BNf6dnMOtL5FdhVe7A+yVS6ymWs5LJseOGrNWqI0pClv2gwxhhjjDHGPI/sl4E74TPfcQ3G3Inf
0/v4iwZjjDHGGGM+kPgl6J2/DD3hGoy5A7+3z/AXDcYYY4wxxhhjjLmMr/mi4UnfNp1cy0n3nXzq
dRuD+H28xxOeG17DO6/DGGOMMcZ8wBcNKx8Yn/QBc+dasLPTfzefeM3fzie+h5SeceX94fsX1ydc
eX1P56pndspTrsMYY4wx5pd59BcNqx8Yn/QBc+dannT9O3z69X8bn/bzWL3eq+/v6fs9nafc7689
d2OMMcaYJzL+oiE+vMUHOP4wN52R8BQqg1320Oc1+52Hc5ZhT/kqU9F1cN8ql9H1r/Kz+ZTYb3ff
rl/5rGVzaOxzhr0dP+AcZpVWeZmm1jFzvvNwVj4SPsM+dpBJJ5uZ8Lvci0lmFTx7Z++uf5XPa/aV
p/wg87GLKH+ixcw6+93MujHGGGPML7L0Fw34AYo/UOF6Z0aUx1qVCV1lAuWhFmueVXZlVmR+dNHP
5o6ufzqzpvyKyCvQ53zMHV3/dGYt1jyr7GReQXVZ6zKdz3PlKS3WmOE5Q+VQw1fMVXOskchxVs1I
5WVER4E+52PuWO13eZ5RCz1bq3mVqq+8qVZ5rOFcecYYY4wxv8jWFw3xASpb78yd3nkv2M9mJDz2
cc66L7ibzRO6zs6eSNVnr5sVkZlkV+E9d86oOuytzqiFnq0V4TO7GdRQZ6pc5qm58lgLnTM8K7IM
6viK2dWZ6fwXk8wOvO/qOZN8ZBD2MM9UnVgzkZ1kKg9RHmr4irmYkfCqfDYbY4wxxvwy23/RwLC3
OmeaIsuxjnPlVdrEe8F+l1dMOzt7I6rPWjcrMDPJr8D7neyvuqytzpk28V50/oRqj+n+kVNZ1nGu
vEpDTnz08BXzq3NGlpv2d+C9V8/q8ux3s6LqsLcK96v9lIcavqq1mqeZSjfGGGOM+SUe80UDz8wk
X2Uqr9Iyb3WeUHXYy7Khs8fa1fM0s8vp3l3/dM60zFudO7o8+yqPWufzXHmVhqDPWZ4Z9PGVO6FV
HmqZ181Xc3pe1z+du0zlTVjpZx7qnOlm1tnvZmOMMcaYX2PrfwaZfYBiP1tnc6wzosNd9ljLMmqN
GtNl2MtyCuxmndVM5V3tK13lTsAzdvbt+is+zuyFxnSZzq+Y5Kv9J1rMiMqvekiWqTovsk7WYy9m
1pEqk3WupDp/Qtdnj3Poo84eayqD+hTu8j7oI+yrLmpVJlBeaMozxhhjjPk1lv6iwRjzu3zLL1D+
RdCc4PePMcYYY0yPv2gwxrTEL1ef+kvWp1+/eS9+/xhjjDHGrOEvGowxxhhjjDHGGHMZ/qLhTah/
GcN/MWNP+SoTuUzPuuwhmDvhdO/Tfsfp/qf9jm5v9jlT+cp7UfXRu4Lp/pnH/Sz3ovMVuO9q9xc4
fT6n/Y5u/87vqPrsIZi7k9Ozu37nfzrTe1P+pFdx2v+T3H2dJ/tH9+T6rtjjieB9ffK9ffo9fPrz
v4NP/5l2fPv9/c8XDf/6678BPTCaRRG6XGIAAAAASUVORK5CYII=
--0000000000002a8b3d05f5f9d8ac--

