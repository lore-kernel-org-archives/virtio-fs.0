DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=bytedance-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=wwTbuNPne9pTDpqWEBar9ogzQkO9XEiXzRQcmGkEMNw=;
	b=gCKfMWfPRCBcIrEgzD5LWIEdI8O0W7zntE76aG7NhdKUvSoZf1JeDyCbr88wiMGMK/
	J1tzci2SDWrjpQ5vCqon8CEuU+Bxo32PzkaZa8tOSrP43PCCoNOKytVKL8nVrzjZR4Uo
	4gBHZsHRh5ikmxRxUDqbXRhJCRqH7jsO/JoGjvrtT70S9Ioy4v262uLI9tqdPivgSN8x
	sfPmzNwpi8H4xeR2OtyeEmYQOt+FCjKdY7Tdeem5/PQ4QyCF/b0mrGB/xpgwkKbgTTrY
	hf8F8a6tadMu5leSdcbkMgJKBeiiNfOncIjGH0DL0xZO6+vC6CVjAnqXFUg2nwRyIBPS
	W4wQ==
MIME-Version: 1.0
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
	<CAJ+F1CLZ4VtgKp5fEdC70m22PgV2VHvRHunR-nPOWDnJPFvqqg@mail.gmail.com>
	<CAFQAk7hCqSMMfRjUO8vtK-B2cKxJZZTJgSDAbRycd1AOSktM_w@mail.gmail.com>
	<YFHUbEdszo4nursr@stefanha-x1.localdomain>
In-Reply-To: <YFHUbEdszo4nursr@stefanha-x1.localdomain>
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Date: Wed, 17 Mar 2021 20:32:31 +0800
Message-ID: <CAFQAk7ia5HsX0e4WBrhDtytGKnd5LsPrUSz9DJVFoo+ShDRP7Q@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000e66ecd05bdbaadc9"
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, QEMU <qemu-devel@nongnu.org>, virtio-fs@redhat.com, Xie Yongji <xieyongji@bytedance.com>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@gmail.com>

--000000000000e66ecd05bdbaadc9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 17, 2021 at 6:05 PM Stefan Hajnoczi <stefanha@redhat.com> wrote=
:

> On Fri, Dec 18, 2020 at 05:39:34PM +0800, Jiachen Zhang wrote:
> > Thanks for the suggestions. Actually, we choose to save all state
> > information to QEMU because a virtiofsd has the same lifecycle as its
> > QEMU master. However, saving things to a file do avoid communication wi=
th
> > QEMU, and we no longer need to increase the complexity of vhost-user
> > protocol. The suggestion to save fds to the systemd is also very
> reasonable
> > if we don't consider the lifecycle issues, we will try it.
>
> Hi,
> We recently discussed crash recovery in the virtio-fs bi-weekly call and
> I read some of this email thread because it's a topic I'm interested in.
>
> I agree with Marc-Andr=C3=A9 that storing file descriptors does not need =
to
> be in the vhost-user protocol. The lifetime of a vhost-user device
> backend is not controlled by the VMM since the device backend is
> launched separately. Therefore it's reasonable for the component that
> launched the device backend to also have the responsibility of cleaning
> up the vhost-user device backend.
>
> Using the sd_notify(3) interface is a neat idea. It's supported natively
> by systemd but you can also implement a compatible interface in your own
> software. This way the vhost-user device backend can be launched using
> systemd or your own software.
>
> That said, if people find it more convenient to store fds using the
> vhost-user protocol, then I think that is enough justification to add a
> generic message to the vhost-user protocol. The important thing is to
> make the message generic so it solves all crash recovery use cases. The
> inflight fd messages were too specific and now we're having to think
> about adding more messages again.
>
> Stefan
>


Hi, Stefan,

I agreed with you that a virtiofsd must be launched by a software like
systemd. So we are planning to define more generic persist/restore
interfaces (callbacks). Then anyone can implement their own persist/restore
callbacks to store states to proper places.  And I think in the next
version we will implement default callbacks for the interfaces. Instead of
vhost-user messages, systemd's sd_notify(3) will be the default method for
storing fds, and several tmpfs files can be the default place to store the
shm regions.

Jiachen

--000000000000e66ecd05bdbaadc9
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">On Wed, Mar 17, 2021 at 6:05 PM Stefan Ha=
jnoczi &lt;<a href=3D"mailto:stefanha@redhat.com">stefanha@redhat.com</a>&g=
t; wrote:<br></div><div class=3D"gmail_quote"><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,20=
4);padding-left:1ex">On Fri, Dec 18, 2020 at 05:39:34PM +0800, Jiachen Zhan=
g wrote:<br>
&gt; Thanks for the suggestions. Actually, we choose to save all state<br>
&gt; information to QEMU because a virtiofsd has the same lifecycle as its<=
br>
&gt; QEMU master. However, saving things to a file do avoid communication w=
ith<br>
&gt; QEMU, and we no longer need to increase the complexity of vhost-user<b=
r>
&gt; protocol. The suggestion to save fds to the systemd is also very reaso=
nable<br>
&gt; if we don&#39;t consider the lifecycle issues, we will try it.<br>
<br>
Hi,<br>
We recently discussed crash recovery in the virtio-fs bi-weekly call and<br=
>
I read some of this email thread because it&#39;s a topic I&#39;m intereste=
d in.<br>
<br>
I agree with Marc-Andr=C3=A9 that storing file descriptors does not need to=
<br>
be in the vhost-user protocol. The lifetime of a vhost-user device<br>
backend is not controlled by the VMM since the device backend is<br>
launched separately. Therefore it&#39;s reasonable for the component that<b=
r>
launched the device backend to also have the responsibility of cleaning<br>
up the vhost-user device backend.<br>
<br>
Using the sd_notify(3) interface is a neat idea. It&#39;s supported nativel=
y<br>
by systemd but you can also implement a compatible interface in your own<br=
>
software. This way the vhost-user device backend can be launched using<br>
systemd or your own software.<br>
<br>
That said, if people find it more convenient to store fds using the<br>
vhost-user protocol, then I think that is enough justification to add a<br>
generic message to the vhost-user protocol. The important thing is to<br>
make the message generic so it solves all crash recovery use cases. The<br>
inflight fd messages were too specific and now we&#39;re having to think<br=
>
about adding more messages again.<br>
<br>
Stefan<br></blockquote><div><br></div><div><br></div><div>Hi, Stefan,</div>=
<div><br></div><div>I agreed with you that a virtiofsd must be launched by =
a software like systemd. So we are planning to define more generic persist/=
restore interfaces (callbacks). Then anyone can implement their own persist=
/restore callbacks to store states to proper places.=C2=A0 And I think in t=
he next version we will implement default callbacks for the interfaces. Ins=
tead of vhost-user messages, systemd&#39;s sd_notify(3) will be the default=
 method for storing fds, and several tmpfs files can be the default place t=
o store the shm regions.</div><div><br></div><div>Jiachen</div><div><br></d=
iv><div><br></div></div></div>

--000000000000e66ecd05bdbaadc9--

