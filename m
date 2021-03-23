DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=8EvuWMeSvlhuN/NKhL1UEoBjWre8dNBAehaT2Zpce9o=;
	b=NqYiK4FfYS8c9KtJULdhW93z5r
	y99PLzm/cCPl/l9Nj1iquA6FxM++4L2wMCCwRwd1aZ3M5Th9fqTTv72mthY/2LsIuVQaHt/Mvszp+
	v8saY9s12zcMCdxzcoeQtVEkXDZM4/Nm1xd9Vub/ofMi4+vpnEz0h6oQT9jff+0FoArMyIONqW2iK
	I8hTXhCWM+8fB6Sml/BSRtDx95Mz4VbMGMIxU619lt/3bZGEm9RT0bjEn2Pwl+JJqlzPYPsbY5JB9
	KQW0up0aJtM6znG2O2o8aRd3vJR/QDlFGuz+js2icjIhpqNw4qd8T4J68BZX4BiiUe0k9B5FC0DcX
	ujgjn4LQwBd8xpApAthBcDJ3+9gdY7GFRZdqmPHr4HyFuW0gDfABnWmBt/24pIk2hePkFPg3p6klr
	RLVHRoCAqe4CTyuyeKMn8ai9DS+CUAm7BZ7vYoU43o0cuMBkiRTrf9W5h5bLtnTPK5q9eNLjIIx3U
	1G6cD2vkMBEt0qeARHsckBd0YX21qqkei8pJml0/e9bAON8VPOnJfTNz0iftSpeGV4fH4EWSu97sH
	Vp1oskbTLPZILyYdm09deTV4Bi/UFz/EEvb0vN4OWchUXAQX4KjZqLZa49A+AQZv/I5OAigslc7s4
	4zJ/aKiqo3E1e7hmMUrkJ19TjBV9Kfg6EKevMyy6M=
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Tue, 23 Mar 2021 13:54:46 +0100
Message-ID: <2732080.qQGZu95Wvu@silver>
In-Reply-To: <YFh3gIMbEEEYDdS/@stefanha-x1.localdomain>
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
	<1711593.yAA9ihpmTb@silver>
	<YFh3gIMbEEEYDdS/@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [External] Re: [RFC PATCH 0/9] Support for
	Virtio-fs daemon crash reconnection
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "Daniel P. Berrange" <berrange@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, Xie Yongji <xieyongji@bytedance.com>, =?ISO-8859-1?Q?Marc=2DAndr=E9?= Lureau <marcandre.lureau@gmail.com>

On Montag, 22. M=E4rz 2021 11:54:56 CET Stefan Hajnoczi wrote:
> > > Thanks, Christian. I am still trying to figure out the details of the
> > > ROP
> > > attacks.
> > >=20
> > > However, QEMU's vhost-user reconnection is based on chardev socket
> > > reconnection. The socket reconnection can be enabled by the "--chardev
> > > socket,...,reconnect=3DN" in QEMU command options, in which N means Q=
EMU
> > > will
> > > try to connect the disconnected socket every N seconds. We can increa=
se
> > > N
> > > to increase the reconnect delay. If we want to change the reconnect
> > > delay
> > > dynamically, I think we should change the chardev socket reconnection
> > > code.
> > > It is a more generic mechanism than vhost-user-fs and vhost-user
> > > backend.
> > >=20
> > > By the way, I also considered the socket reconnection delay time in t=
he
> > > performance aspect. As the reconnection delay increase, if an
> > > application
> > > in the guest is doing I/Os, it will suffer larger tail latency. And f=
or
> > > now, the smallest delay is 1 second, which is rather large for
> > > high-performance virtual I/O devices today. I think maybe a more
> > > performant
> > > and safer reconnect delay adjustment mechanism should be considered in
> > > the
> > > future. What are your thoughts?
> >=20
> > So with N=3D1 an attacker could e.g. bypass a 16-bit PAC by brute-force=
 in
> > ~18 hours (e.g. on Arm if PAC + MTE was enabled). With 24-bit PAC (no
> > MTE) it would be ~194 days. Independent of what architecture and defend
> > mechanism is used, there is always the possibility though that some kind
> > of side channel attack exists that might require a much lower amount of
> > attempts. So in an untrusted environment I would personally limit the
> > amount of automatic reconnects and rather accept a down time for further
> > investigation if a suspicious high amount of crashes happened.
> >=20
> > And yes, if a dynamic delay scheme was deployed in future then starting
> > with a value smaller than 1 second would make sense.
>=20
> If we're talking about repeatedly crashing the process to find out its
> memory map, shouldn't each process have a different randomized memory
> layout?
>=20
> Stefan

Yes, ASLR is enabled on Linux and other OSes by default for more than 10=20
years. But ASLR does not prevent ROP attacks which are commonly using relat=
ive=20
offsets, tweaking the stack, indirect jumps, as well as heap spraying. Plus=
=20
side channels exist to gain access to direct addresses.

The situation might improve significantly when shadow stacks (e.g. Intel CE=
T)=20
become widely used in future. But in the meantime I would be cautious if=20
something is crashing too often in a certain time frame.

Best regards,
Christian Schoenebeck



