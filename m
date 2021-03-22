DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:from:date:message-id:subject:to;
	bh=fBYDkaWXcVkKctIQSdIY46Eh4MER691ULL/hAhN8dcM=;
	b=R7MAhbAlyui+MLf0fdRfgptxC48nxHEcoL8gSPygQO/IsVqYLxUaUnO3rSyrm3JJuT
	/3SBwsza0ZzCmFOo35ZhcVBEHVNByDUQ0lRPE+VspD+/+TJTQ9UuJ5FD1pr6BjdNRVr/
	PDFqhLNPO/SMtxbMe8mkFQcmyCik6KT7G5IZizHUz9UK0QY8XPlvkKFKWTxPBKD02Q4j
	kgcLh9vC9fmfgIZUeV2kUWgkX/uOQECXFBK16o0a1GYNLM7LTBn67bvvEdWxRkSg4ZRx
	NRDg0EoywBqC1wl9SqJ/uqrgr2RQNv+r9vzcRILNWDTzZS9i9d5Czdyxm7U3EM7RgArH
	nrEQ==
MIME-Version: 1.0
From: Eric Ernst <eric.g.ernst@gmail.com>
Date: Sun, 21 Mar 2021 21:14:37 -0700
Message-ID: <CAAQbG+XwZdcyEopmBV9J=Y8m++QCV8BOKAnPWTrsnwk4sesG1Q@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000006e481605be184e34"
Subject: [Virtio-fs] Large memory consumption by virtiofsd,
	suspecting fd's aren't being closed?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

--0000000000006e481605be184e34
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey ya=E2=80=99ll,

One challenge I=E2=80=99ve been looking at is how to setup an appropriate m=
emory
cgroup limit for workloads that are leveraging virtiofs (ie, running pods
with Kata Containers that leverage virtiofs). I noticed that memory usage
of the daemon itself can grow considerably depending on the workload;
though much more than I=E2=80=99d expect.

I=E2=80=99m running workload that simply runs a build on kernel sources wit=
h -j3.
In doing this, the source of the linux kernel are shared via virtiofs (no
DAX), so as the build goes on, there are a lot of files opened, closed, as
well as created. The rss memory of virtiofsd grows into several hundreds of
MBs.

When taking a look, I=E2=80=99m suspecting that virtiofsd is carrying out t=
he
opens, but never actually closing fds. In the guest, I=E2=80=99m seeing fd=
=E2=80=99s on the
order of 10-40 for all the container processes as it runs, whereas I see
the number of fds for virtiofsd continually increasing, reaching over
80,000 fds. I=E2=80=99m guessing this isn=E2=80=99t expected?

Can any ya=E2=80=99ll help shed some light, or where I can look?

Thanks,
Eric

--0000000000006e481605be184e34
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><font color=3D"#000000"><span style=3D"fo=
nt-family:Helvetica;font-size:12px">Hey ya=E2=80=99ll,</span><br style=3D"f=
ont-family:Helvetica;font-size:12px"><br style=3D"font-family:Helvetica;fon=
t-size:12px"><span style=3D"font-family:Helvetica;font-size:12px">One chall=
enge I=E2=80=99ve been looking at is how to setup an appropriate memory cgr=
oup limit for workloads that are leveraging virtiofs (ie, running pods with=
 Kata Containers that leverage virtiofs). I noticed that memory usage of th=
e daemon itself can grow considerably depending on the workload; though muc=
h more than I=E2=80=99d expect.</span><br style=3D"font-family:Helvetica;fo=
nt-size:12px"><br style=3D"font-family:Helvetica;font-size:12px"><span styl=
e=3D"font-family:Helvetica;font-size:12px">I=E2=80=99m running workload tha=
t simply runs a build on kernel sources with -j3. In doing this, the source=
 of the linux kernel are shared via virtiofs (no DAX), so as the build goes=
 on, there are a lot of files opened, closed, as well as created. The rss m=
emory of virtiofsd grows into several hundreds of MBs.</span><br style=3D"f=
ont-family:Helvetica;font-size:12px"><br style=3D"font-family:Helvetica;fon=
t-size:12px"><span style=3D"font-family:Helvetica;font-size:12px">When taki=
ng a look, I=E2=80=99m suspecting that virtiofsd is carrying out the opens,=
 but never actually closing fds. In the guest, I=E2=80=99m seeing fd=E2=80=
=99s on the order of 10-40 for all the container processes as it runs, wher=
eas I see the number of fds for virtiofsd continually increasing, reaching =
over 80,000 fds. I=E2=80=99m guessing this isn=E2=80=99t expected?</span><b=
r style=3D"font-family:Helvetica;font-size:12px"><br style=3D"font-family:H=
elvetica;font-size:12px"><span style=3D"font-family:Helvetica;font-size:12p=
x">Can any ya=E2=80=99ll help shed some light, or where I can look?</span><=
br style=3D"font-family:Helvetica;font-size:12px"><br style=3D"font-family:=
Helvetica;font-size:12px"><span style=3D"font-family:Helvetica;font-size:12=
px">Thanks,</span><br style=3D"font-family:Helvetica;font-size:12px"><span =
style=3D"font-family:Helvetica;font-size:12px">Eric</span></font><br></div>=
</div>

--0000000000006e481605be184e34--

