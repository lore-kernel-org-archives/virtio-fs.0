Return-Path: <linux_learner@outlook.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DClJNJjM0VvuE109xlTu0Nz7firXTPJlP/7lDPOiIKU=;
 b=uMapYbebVOGZBcLktSNj6hwr0HtZJ5kllDuBxQHR+JmrLLNv4/dhYib0zLXAjceG6TMlwhGPifH8SjzT22KA8ckY0be6/IO0j0GVe0HjrBjE3b2c0QXl8B7KCoAUQGb/FXbcsISUKIBN+0yvY9oAPBw3G9udFoJOGNJDbzCFV6u8+nDog0lKWjBBtmkmf+ouJn0u6Zsbs4o+G8u42PnHDDmqsh44g/BKgDFZCKFRGkCffx5DY21sJ9oVoxYkYLZYLQ5E2SIdJ78lttiqPcc/wlUDp58C3urPe7uT0+eQn0qhbazGOvH3qco9VTLWsCEaqQ3SssSF3YPMzPCGT9s0Vg==
From: "Pra.. Dew.." <linux_learner@outlook.com>
Date: Thu, 26 May 2022 16:07:36 +0000
Message-ID: <BY5PR14MB3893C17AAED9ECD7280AE7FD86D99@BY5PR14MB3893.namprd14.prod.outlook.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/alternative;
 boundary="_000_BY5PR14MB3893C17AAED9ECD7280AE7FD86D99BY5PR14MB3893namp_"
Subject: Re: [Virtio-fs] vhost_set_vring_kick failed
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Sergio Lopez <slp@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "gmaglione@redhat.com" <gmaglione@redhat.com>

--_000_BY5PR14MB3893C17AAED9ECD7280AE7FD86D99BY5PR14MB3893namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Thanks for the response.  The  version of the qemu is 5.1.0 and  here is th=
e comandline..


[/usr/bin/qemu-system-test-machine test --enable-kvm -display none -mon mon=
-console,mode=3Dreadline -chardev socket,host=3D,port=3D5001,server,nowait,=
id=3Dmon-console -device virtio-serial-device,max_ports=3D2 -device virtcon=
sole,chardev=3Dconsole,name=3Dconsole -chardev socket,host=3D,port=3D5000,s=
erver,nowait,id=3Dconsole -netdev tap,id=3Dtap0,ifname=3Dtap0,vhost=3Don,sc=
ript=3Dno,downscript=3Dno -device virtio-net-device,netdev=3Dtap0 -device v=
host-vsock-device,guest-cid=3D4 -object rng-random,filename=3D/dev/urandom,=
id=3Drng0 -device virtio-rng-device,rng=3Drng0 -chardev socket,id=3Dchar0,p=
ath=3D/run/vm001-vhost-fs.sock -device vhost-user-fs-device,queue-size=3D2,=
chardev=3Dchar0,tag=3Dmyfs -object memory-backend-memfd,id=3Dmem,size=3D4G,=
share=3Don -kernel /var/lib/are/images/active/kernel.bin -dtb /var/lib/are/=
images/active/device-tree.dtb -device virtio-blk-device,drive=3Dwritable,se=
rial=3Dwritable -drive file=3D/var/lib/are/volumes/writable.bin,if=3Dnone,i=
d=3Dwritable,format=3Draw -device virtio-blk-device,drive=3Drootfs,serial=
=3Drootfs -drive file=3D/var/lib/are/images/active/rootfs/rootfs.bin,if=3Dn=
one,id=3Drootfs,format=3Draw,readonly]


________________________________
From: Sergio Lopez
Sent: Thursday, May 26, 2022 8:06 AM
To: Stefan Hajnoczi
Cc: Prashant Dewan; virtio-fs@redhat.com; gmaglione@redhat.com
Subject: Re: [Virtio-fs] vhost_set_vring_kick failed

On Thu, May 26, 2022 at 08:49:34AM +0100, Stefan Hajnoczi wrote:
> On Thu, May 26, 2022 at 05:34:42AM +0000, Prashant Dewan wrote:
> > Hello Stefan,
> >
> > Here is the output from virtofsd..
> >
> > ------------------------------------
> > - Journal begins at Thu 2022-05-26 04:23:42 UTC, ends at Thu 2022-05-26=
 04:41:57 UTC. --
> > May 26 04:24:13 localhost systemd[1]: Started virtio-fs vhost-user devi=
ce daemon.<<Placeholder: run this daemon as non-privileged user>>.
> > May 26 04:24:13 localhost virtiofsd[505]: [2022-05-26T04:24:13Z INFO  v=
irtiofsd] Waiting for vhost-user socket connection...
> > May 26 04:27:11 device-3e4b479e2ee9c647 virtiofsd[505]: [2022-05-26T04:=
27:11Z INFO  virtiofsd] Client connected, servicing requests
> > May 26 04:27:33 device-3e4b479e2ee9c647 virtiofsd[505]: [2022-05-26T04:=
27:33Z ERROR virtiofsd] Waiting for daemon failed: HandleRequest(InvalidPar=
am)
>
> virtiofsd terminated. I have CCed Sergio and German, who may have
> suggestions about what to check next.

Hi,

Could you please tell us which QEMU version are you running, and paste
here the its command line?

Thanks,
Sergio.

--_000_BY5PR14MB3893C17AAED9ECD7280AE7FD86D99BY5PR14MB3893namp_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
Thanks&nbsp;for the response.&nbsp; The&nbsp; version of the qemu is 5.1.0 =
and&nbsp; here is the comandline..</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
[/usr/bin/qemu-system-test-machine test --enable-kvm -display none -mon mon=
-console,mode=3Dreadline -chardev socket,host=3D,port=3D5001,server,nowait,=
id=3Dmon-console -device virtio-serial-device,max_ports=3D2 -device virtcon=
sole,chardev=3Dconsole,name=3Dconsole -chardev
 socket,host=3D,port=3D5000,server,nowait,id=3Dconsole -netdev tap,id=3Dtap=
0,ifname=3Dtap0,vhost=3Don,script=3Dno,downscript=3Dno -device virtio-net-d=
evice,netdev=3Dtap0 -device vhost-vsock-device,guest-cid=3D4 -object rng-ra=
ndom,filename=3D/dev/urandom,id=3Drng0 -device virtio-rng-device,rng=3Drng0
 -chardev socket,id=3Dchar0,path=3D/run/vm001-vhost-fs.sock -device vhost-u=
ser-fs-device,queue-size=3D2,chardev=3Dchar0,tag=3Dmyfs -object memory-back=
end-memfd,id=3Dmem,size=3D4G,share=3Don -kernel /var/lib/are/images/active/=
kernel.bin -dtb /var/lib/are/images/active/device-tree.dtb
 -device virtio-blk-device,drive=3Dwritable,serial=3Dwritable -drive file=
=3D/var/lib/are/volumes/writable.bin,if=3Dnone,id=3Dwritable,format=3Draw -=
device virtio-blk-device,drive=3Drootfs,serial=3Drootfs -drive file=3D/var/=
lib/are/images/active/rootfs/rootfs.bin,if=3Dnone,id=3Drootfs,format=3Draw,=
readonly]<br>
</div>
<div>
<div><br>
</div>
<div style=3D"font-family:Calibri,Arial,Helvetica,sans-serif; font-size:12p=
t; color:rgb(0,0,0);">
<br>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%;">
<b>From:</b> Sergio Lopez<br>
<b>Sent:</b> Thursday, May 26, 2022 8:06 AM<br>
<b>To:</b> Stefan Hajnoczi<br>
<b>Cc:</b> Prashant Dewan; virtio-fs@redhat.com; gmaglione@redhat.com<br>
<b>Subject:</b> Re: [Virtio-fs] vhost_set_vring_kick failed
<div><br>
</div>
</div>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt;=
">
<div class=3D"PlainText">On Thu, May 26, 2022 at 08:49:34AM +0100, Stefan H=
ajnoczi wrote:<br>
&gt; On Thu, May 26, 2022 at 05:34:42AM +0000, Prashant Dewan wrote:<br>
&gt; &gt; Hello Stefan,<br>
&gt; &gt; <br>
&gt; &gt; Here is the output from virtofsd..<br>
&gt; &gt; <br>
&gt; &gt; ------------------------------------<br>
&gt; &gt; - Journal begins at Thu 2022-05-26 04:23:42 UTC, ends at Thu 2022=
-05-26 04:41:57 UTC. --<br>
&gt; &gt; May 26 04:24:13 localhost systemd[1]: Started virtio-fs vhost-use=
r device daemon.&lt;&lt;Placeholder: run this daemon as non-privileged user=
&gt;&gt;.<br>
&gt; &gt; May 26 04:24:13 localhost virtiofsd[505]: [2022-05-26T04:24:13Z I=
NFO&nbsp; virtiofsd] Waiting for vhost-user socket connection...<br>
&gt; &gt; May 26 04:27:11 device-3e4b479e2ee9c647 virtiofsd[505]: [2022-05-=
26T04:27:11Z INFO&nbsp; virtiofsd] Client connected, servicing requests<br>
&gt; &gt; May 26 04:27:33 device-3e4b479e2ee9c647 virtiofsd[505]: [2022-05-=
26T04:27:33Z ERROR virtiofsd] Waiting for daemon failed: HandleRequest(Inva=
lidParam)<br>
&gt; <br>
&gt; virtiofsd terminated. I have CCed Sergio and German, who may have<br>
&gt; suggestions about what to check next.<br>
<br>
Hi,<br>
<br>
Could you please tell us which QEMU version are you running, and paste<br>
here the its command line?<br>
<br>
Thanks,<br>
Sergio.<br>
</div>
</span></font></div>
</div>
</body>
</html>

--_000_BY5PR14MB3893C17AAED9ECD7280AE7FD86D99BY5PR14MB3893namp_--

