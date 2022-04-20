Return-Path: <gmaglion@redhat.com>
MIME-Version: 1.0
From: German Maglione <gmaglione@redhat.com>
Date: Wed, 20 Apr 2022 18:50:42 +0200
Message-ID: <CAJh=p+5O_65WqUZY6tgzN-xFHnevvrJu=Tp8bah1_6ivYPBF_g@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000005c6ae705dd18cd26"
Subject: [Virtio-fs] [RFC] [dracut] virtiofs root filesystem support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>

--0000000000005c6ae705dd18cd26
Content-Type: text/plain; charset="UTF-8"

Hi,

I have just sent a PR [0] to add virtiofs as a dracut module,
to allow booting VMs off virtiofs.
The module accepts both formats as kernel cmdline:
                 root=virtiofs:<mount-tag>
                 rootfstype=virtiofs root=<mount-tag>

[0] https://github.com/dracutdevs/dracut/pull/1784

Thanks,
-- 
German

--0000000000005c6ae705dd18cd26
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi,</div><div><br></div><div>I have just sent a PR [0=
] to add virtiofs as a dracut module,</div><div>to allow booting VMs off vi=
rtiofs.</div><div>The module accepts both formats as kernel cmdline:<br>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0root=3Dvirtiofs:=
&lt;mount-tag&gt;<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0rootfstype=3Dvirtiofs root=3D&lt;mount-tag&gt; =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 <br></div><div><br></div><div>[0] <a href=3D"https=
://github.com/dracutdevs/dracut/pull/1784">https://github.com/dracutdevs/dr=
acut/pull/1784</a><br></div><div><br></div>Thanks,<br><div>-- <br><div dir=
=3D"ltr" class=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div =
dir=3D"ltr">German<br></div></div></div></div>

--0000000000005c6ae705dd18cd26--

