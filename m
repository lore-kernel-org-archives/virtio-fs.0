DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=FVNGMxw1Tu/ULPujLuXi4JIfnYLOLclI5Uy/fyQzbQo=;
	b=P1N1JMy4JcgwxiBIzw2XDOV80y
	A9esKRmwwbaLQdFVNiBefUYR6kNiwask4eGVHk9U/E9UwVLjyX9IwOdPTVSwZoO11NuC4GftfGMf4
	+LmVKMGMOKGHLts4awWHocsalKgD+bZ6tNJHz96fIUNmYLqXWdSws3GTNXCUxEFL1PbhrocNtWkmj
	udXL2WuENOAqgYjU9+1/tPBOfACYVXAtDvxZTqm5X85pGGD+nh/ljBUvrajppS6TxeC2j7lwWPbkX
	a8iJ/d2JdRw+P0ZhX5FRDY7LRrXoQsQEfZSSxEiqyY55x4cloGL72T25RXgQZsmtr4rq4zzuk9CBZ
	mVibXmekJS5jzV3lOVxUdeKtoq/tL3m5n5rXBIwzrRN2kX3UVpk73CvzEeqwOXCTW6Q56u8sbcVX0
	yVoSwWoGMdIKDhRaPZsJRdYrKWnbVuAQrK4zKw+VVOJNQxhksPgxsTBiGE47cxhA51ARXyKD1cBZo
	78JrS1Z2/WvjH21/IZa0AKVnrATuoLU9KvjtclPSsxgfAajvwYIhMVBCFREofH1wkR40jb3a8o4he
	hU/CHaI1ErtHqo2d28bX32fynavSR8qtGF3drQOaUX/IbywdnhoClCyotH5cModT2GUF+sefBJQ7e
	GdGdBsRhbsG+DRt47R5AieJjZZDLoJ+f4Rt0hYgk0=
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Thu, 18 Mar 2021 12:58:46 +0100
Message-ID: <1711593.yAA9ihpmTb@silver>
In-Reply-To: <CAFQAk7jmvzL3tT=7ExcUKyo9SKNdhT29F5y3f4K8YigA08=BWQ@mail.gmail.com>
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
	<1709993.NBFj2RoZ23@silver>
	<CAFQAk7jmvzL3tT=7ExcUKyo9SKNdhT29F5y3f4K8YigA08=BWQ@mail.gmail.com>
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

On Mittwoch, 17. M=E4rz 2021 13:57:47 CET Jiachen Zhang wrote:
> On Wed, Mar 17, 2021 at 7:50 PM Christian Schoenebeck <
>=20
> qemu_oss@crudebyte.com> wrote:
> > On Mittwoch, 17. M=E4rz 2021 11:05:32 CET Stefan Hajnoczi wrote:
> > > On Fri, Dec 18, 2020 at 05:39:34PM +0800, Jiachen Zhang wrote:
> > > > Thanks for the suggestions. Actually, we choose to save all state
> > > > information to QEMU because a virtiofsd has the same lifecycle as i=
ts
> > > > QEMU master. However, saving things to a file do avoid communication
> >=20
> > with
> >=20
> > > > QEMU, and we no longer need to increase the complexity of vhost-user
> > > > protocol. The suggestion to save fds to the systemd is also very
> > > > reasonable
> > > > if we don't consider the lifecycle issues, we will try it.
> > >=20
> > > Hi,
> > > We recently discussed crash recovery in the virtio-fs bi-weekly call =
and
> > > I read some of this email thread because it's a topic I'm interested =
in.
> >=20
> > I just had a quick fly over the patches so far. Shouldn't there be some
> > kind
> > of constraint for an automatic reconnection feature after a crash to
> > prevent
> > this being exploited by ROP brute force attacks?
> >=20
> > E.g. adding some (maybe continuously increasing) delay and/or limiting =
the
> > amount of reconnects within a certain time frame would come to my mind.
> >=20
> > Best regards,
> > Christian Schoenebeck
>=20
> Thanks, Christian. I am still trying to figure out the details of the ROP
> attacks.
>=20
> However, QEMU's vhost-user reconnection is based on chardev socket
> reconnection. The socket reconnection can be enabled by the "--chardev
> socket,...,reconnect=3DN" in QEMU command options, in which N means QEMU =
will
> try to connect the disconnected socket every N seconds. We can increase N
> to increase the reconnect delay. If we want to change the reconnect delay
> dynamically, I think we should change the chardev socket reconnection cod=
e.
> It is a more generic mechanism than vhost-user-fs and vhost-user backend.
>=20
> By the way, I also considered the socket reconnection delay time in the
> performance aspect. As the reconnection delay increase, if an application
> in the guest is doing I/Os, it will suffer larger tail latency. And for
> now, the smallest delay is 1 second, which is rather large for
> high-performance virtual I/O devices today. I think maybe a more performa=
nt
> and safer reconnect delay adjustment mechanism should be considered in the
> future. What are your thoughts?

So with N=3D1 an attacker could e.g. bypass a 16-bit PAC by brute-force in =
~18=20
hours (e.g. on Arm if PAC + MTE was enabled). With 24-bit PAC (no MTE) it=20
would be ~194 days. Independent of what architecture and defend mechanism i=
s=20
used, there is always the possibility though that some kind of side channel=
=20
attack exists that might require a much lower amount of attempts. So in an =

untrusted environment I would personally limit the amount of automatic=20
reconnects and rather accept a down time for further investigation if a=20
suspicious high amount of crashes happened.

And yes, if a dynamic delay scheme was deployed in future then starting wit=
h a=20
value smaller than 1 second would make sense.

Best regards,
Christian Schoenebeck



