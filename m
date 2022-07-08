Return-Path: <linux_learner@outlook.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=taYeYQj6zhb5F1uc5knGWA9dyZEM4DQHpAsO2v7W50M=;
 b=O44+N/0KBo6p99Y+8gsemA8dQeE/CasfpLLpTXxn8kvdXWis4kTjPQaRGWxpDPOWL8s6G99SbLrYGMMBJEQWhAhnloVoyDmrSRusKHZ5UcUFXTY6Ka5ViYICKCusFS1roY84K6o13BCZwXjaF1vg00FADzk47SRqddRqwL8tDfrw6fLCG5DAW1ZGrWxhtN4QOu8rM8osxVbgjiBJ5J1AiNRDd7WBUcZd8e80QPK+owZC9Sly9ZYfXzHRNOkS6bIHvepi/SrIGQIf3h0z++pbIaAVDKCvEgDpajjs5utvN/yuGFICCn4/T/IWsnfWs50mKpuX36NVOqBr17n+jCVFZA==
From: "Pra.. Dew.." <linux_learner@outlook.com>
Date: Fri, 8 Jul 2022 20:18:19 +0000
Message-ID: <BY5PR14MB38930999DE81BFE799016C8C86829@BY5PR14MB3893.namprd14.prod.outlook.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/alternative;
 boundary="_000_BY5PR14MB38930999DE81BFE799016C8C86829BY5PR14MB3893namp_"
Subject: [Virtio-fs] Ownership of a file shared between guest and host
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

--_000_BY5PR14MB38930999DE81BFE799016C8C86829BY5PR14MB3893namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

We have been able to setup virtiofs between guest and host (QEMU 6.2/Linux =
5.15). We run virtiofsd as a non-root user in the host. We did not want to =
run it as a root user in order to minimize the attack surface. We run it as=
 a virtiofs user. When we create a file in the shared folder, the permissio=
n of the file is virtiofs user and virtiofs group. When we read that file f=
rom the guest it shows virtiofs user (only the uid) and nobody group. The g=
oal is to restrict the access of the file to a few services in the guest (n=
ot give access to all services). We tried to create a group in the guest an=
d tried to move the file in the new group. However chown gives "bad descrip=
tor." Is there a better way of doing this? Any input is really appreciated.=
 Thank you so much!

--_000_BY5PR14MB38930999DE81BFE799016C8C86829BY5PR14MB3893namp_
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
We have been able to setup virtiofs between guest and host (QEMU 6.2/Linux =
5.15). We run virtiofsd as a non-root user in the host. We did not want to =
run it as a root user in order to minimize the attack surface. We run it as=
 a virtiofs user. When we create
 a file in the shared folder, the permission of the file is virtiofs user a=
nd virtiofs group. When we read that file from the guest it shows virtiofs =
user (only the uid) and nobody group. The goal is to restrict the access of=
 the file to a few services in the
 guest (not give access to all services). We tried to create a group in the=
 guest and tried to move the file in the new group. However chown gives &qu=
ot;bad descriptor.&quot; Is there a better way of doing this? Any input is =
really appreciated. Thank you so much!</div>
<div>
<div class=3D"BodyFragment"></div>
</div>
</body>
</html>

--_000_BY5PR14MB38930999DE81BFE799016C8C86829BY5PR14MB3893namp_--

