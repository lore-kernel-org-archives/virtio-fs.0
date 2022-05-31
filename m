Return-Path: <linux_learner@outlook.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJHT3jRd3z8fNRT2TKVAl4rH1uxtrwmVenArrBEFEHs=;
 b=scsvInu29hZbddofVyHxqqyDnZRUq4bl3KjEq+uPcirpIO0JuW9/aCyQEukil2rhsontfQPxvtiZMw2aEouh2yoiy9SSqML/Dz2idaMsa/+kkObKVKBkbY93KQTS+B1O0iZ8nllERM6tDkdgwczJnwgn3Y7Z41zxxA9X6D6pmNwXSctXV/MB2L7fkyx0ntHHbRXR77cNASFcVzRIhNGxTPMBLqzG0a+gaufNyWVtY0AeiIKBlulnHCWIiB5s9NToObo+aT/yOVPGlkJ9kNE3FzDbc/hSHu5czQxDh7jlZK4j5sz/Hk93QUlvc1n3kLTK9QILZffeVZZa+fPz93J3HA==
From: "Pra.. Dew.." <linux_learner@outlook.com>
Date: Tue, 31 May 2022 18:33:18 +0000
Message-ID: <BY5PR14MB38930133483FCB8F1C2EC3F486DC9@BY5PR14MB3893.namprd14.prod.outlook.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/alternative;
 boundary="_000_BY5PR14MB38930133483FCB8F1C2EC3F486DC9BY5PR14MB3893namp_"
Subject: Re: [Virtio-fs] vhost_set_vring_kick failed
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Sergio Lopez <slp@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "gmaglione@redhat.com" <gmaglione@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

--_000_BY5PR14MB38930133483FCB8F1C2EC3F486DC9BY5PR14MB3893namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Thank you Sergio.  Is there a patch I could use to make it work with an old=
er version?

Thanks
Prashant



________________________________
From: Sergio Lopez
Sent: Tuesday, May 31, 2022 10:50 AM
To: Pra.. Dew..
Cc: Stefan Hajnoczi; virtio-fs@redhat.com; gmaglione@redhat.com; Vivek Goya=
l
Subject: Re: [Virtio-fs] vhost_set_vring_kick failed

On Thu, May 26, 2022 at 04:07:36PM +0000, Pra.. Dew.. wrote:
> Thanks for the response.  The  version of the qemu is 5.1.0 and  here is =
the comandline..
>
>
> [/usr/bin/qemu-system-test-machine test --enable-kvm -display none -mon m=
on-console,mode=3Dreadline -chardev socket,host=3D,port=3D5001,server,nowai=
t,id=3Dmon-console -device virtio-serial-device,max_ports=3D2 -device virtc=
onsole,chardev=3Dconsole,name=3Dconsole -chardev socket,host=3D,port=3D5000=
,server,nowait,id=3Dconsole -netdev tap,id=3Dtap0,ifname=3Dtap0,vhost=3Don,=
script=3Dno,downscript=3Dno -device virtio-net-device,netdev=3Dtap0 -device=
 vhost-vsock-device,guest-cid=3D4 -object rng-random,filename=3D/dev/urando=
m,id=3Drng0 -device virtio-rng-device,rng=3Drng0 -chardev socket,id=3Dchar0=
,path=3D/run/vm001-vhost-fs.sock -device vhost-user-fs-device,queue-size=3D=
2,chardev=3Dchar0,tag=3Dmyfs -object memory-backend-memfd,id=3Dmem,size=3D4=
G,share=3Don -kernel /var/lib/are/images/active/kernel.bin -dtb /var/lib/ar=
e/images/active/device-tree.dtb -device virtio-blk-device,drive=3Dwritable,=
serial=3Dwritable -drive file=3D/var/lib/are/volumes/writable.bin,if=3Dnone=
,id=3Dwritable,format=3Draw -device virtio-blk-device,drive=3Drootfs,serial=
=3Drootfs -drive file=3D/var/lib/are/images/active/rootfs/rootfs.bin,if=3Dn=
one,id=3Drootfs,format=3Draw,readonly]

Thanks for the details. I knew that we didn't support older versions,
but didn't want to reply that without explaining why.

I've just took a look, and the origin of this incompatibility is this
change in "hw/virtio/vhost-user.c":

qemu-5.1.0:

typedef struct VhostUserMemRegMsg {
    uint32_t padding;
    VhostUserMemoryRegion region;
} VhostUserMemRegMsg;

qemu-upstream (since 3009edff8192991293fe9e2b50b0d90db83c4a89):

typedef struct VhostUserMemRegMsg {
    uint64_t padding;
    VhostUserMemoryRegion region;
} VhostUserMemRegMsg;

Note how "padding" has changed from uint32_t to uint64_t.

This means we only support QEMU versions starting 5.2.0.

Regards,
Sergio.

--_000_BY5PR14MB38930133483FCB8F1C2EC3F486DC9BY5PR14MB3893namp_
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
Thank you&nbsp;Sergio.&nbsp; Is there a patch I could use to make it work w=
ith an older version?</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
Thanks</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
Prashant</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div>
<div><br>
</div>
<div style=3D"font-family:Calibri,Arial,Helvetica,sans-serif; font-size:12p=
t; color:rgb(0,0,0);">
<br>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%;">
<b>From:</b> Sergio Lopez<br>
<b>Sent:</b> Tuesday, May 31, 2022 10:50 AM<br>
<b>To:</b> Pra.. Dew..<br>
<b>Cc:</b> Stefan Hajnoczi; virtio-fs@redhat.com; gmaglione@redhat.com; Viv=
ek Goyal<br>
<b>Subject:</b> Re: [Virtio-fs] vhost_set_vring_kick failed
<div><br>
</div>
</div>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt;=
">
<div class=3D"PlainText">On Thu, May 26, 2022 at 04:07:36PM +0000, Pra.. De=
w.. wrote:<br>
&gt; Thanks for the response.&nbsp; The&nbsp; version of the qemu is 5.1.0 =
and&nbsp; here is the comandline..<br>
&gt; <br>
&gt; <br>
&gt; [/usr/bin/qemu-system-test-machine test --enable-kvm -display none -mo=
n mon-console,mode=3Dreadline -chardev socket,host=3D,port=3D5001,server,no=
wait,id=3Dmon-console -device virtio-serial-device,max_ports=3D2 -device vi=
rtconsole,chardev=3Dconsole,name=3Dconsole -chardev
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
<br>
Thanks for the details. I knew that we didn't support older versions,<br>
but didn't want to reply that without explaining why.<br>
<br>
I've just took a look, and the origin of this incompatibility is this<br>
change in &quot;hw/virtio/vhost-user.c&quot;:<br>
<br>
qemu-5.1.0:<br>
<br>
typedef struct VhostUserMemRegMsg {<br>
&nbsp;&nbsp;&nbsp; uint32_t padding;<br>
&nbsp;&nbsp;&nbsp; VhostUserMemoryRegion region;<br>
} VhostUserMemRegMsg;<br>
<br>
qemu-upstream (since 3009edff8192991293fe9e2b50b0d90db83c4a89):<br>
<br>
typedef struct VhostUserMemRegMsg {<br>
&nbsp;&nbsp;&nbsp; uint64_t padding;<br>
&nbsp;&nbsp;&nbsp; VhostUserMemoryRegion region;<br>
} VhostUserMemRegMsg;<br>
<br>
Note how &quot;padding&quot; has changed from uint32_t to uint64_t.<br>
<br>
This means we only support QEMU versions starting 5.2.0.<br>
<br>
Regards,<br>
Sergio.<br>
</div>
</span></font></div>
</div>
</body>
</html>

--_000_BY5PR14MB38930133483FCB8F1C2EC3F486DC9BY5PR14MB3893namp_--

