Return-Path: <fejes@inf.elte.hu>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ikelte.onmicrosoft.com; s=selector2-ikelte-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9IPU4D47ZfRXPjkxjtCMVrkotKUKUOcRMjV5B1Ng500=;
 b=lGf1wtI8ze6VHycSI7NCLLFsZLuSXfdxy9u06/nAnsU4TcP1w1l6wrmaE0gY5Ft02s7ZnEKyZ28oe2zWQiIyrcjKPPktQydWsYmQZ4Pge1WDqjpoHGst1LsXdwDEnMNWJDEOnb7XbI1cvi1QLb9uD3vM9/pWzceaWhQ6CbC25kA=
References: <b155ad6fe6bb026377a8f75882e26078da10ab70.camel@inf.elte.hu>
 <CAJSP0QX3VTU+_wngw+8jHttKykJ-WzMgns+PASDaD91or+zp5A@mail.gmail.com>
In-Reply-To: <CAJSP0QX3VTU+_wngw+8jHttKykJ-WzMgns+PASDaD91or+zp5A@mail.gmail.com>
From: Ferenc Fejes <fejes@inf.elte.hu>
Date: Fri, 24 Feb 2023 20:04:21 +0100
Message-ID: <CAAej5NZBzbx6paJRH-UDxreiFCMdX60RohHb1VU6mcsnWbyJJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] question: QEMU guest with Virtiofs but without
 virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org, stefanha@redhat.com, =?UTF-8?B?UMOpdGVyIEFudGFs?= <peti.antal99@gmail.com>, Christian Schoenebeck <qemu_oss@crudebyte.com>

Hi Stefan!

On Fri, Feb 24, 2023 at 6:23 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>
> On Fri, 24 Feb 2023 at 11:47, Ferenc Fejes <fejes@inf.elte.hu> wrote:
> > I'm using a QEMU VM with a debootstrap rootfs, shared over virtiofs for
> > the guest. My best understanding is that virtiofsd must required even
> > if just using one guest.
>
> Yes, virtiofsd is required even if just one guest is accessing a
> shared directory using a virtiofs device. The virtiofsd daemon is
> responsible for emulating the virtiofs device (QEMU does not do the
> emulation), so that's why it's essential even with just a single
> guest.
>
> > Looking around in the QEMU manpages I got a little bit confused by
> > virtfs parameter. Is it something entirely connected with 9P or it is
> > possible to pass folders to the guest through virtiofs without
> > virtiofsd? Unfortunately none of my trial with the parameters
> > succeeded.
>
> There are two separate VIRTIO devices for sharing files/directories:
> virtiofs and virtio-9p (sometimes called virtfs). It's easy to confuse
> them because "virtiofs" and "virtfs" look similar. They have different
> features and are completely independent of each other. In terms of the
> file system protocol, virtiofs is based on Linux FUSE while virtio-9p
> is based on the 9P protocol.

Thank you for the clarification! No wonder that my commands failed to work.
As a very occasional user of QEMU I those two (and their parameters)
looked very similar to me.

>
> virtiofs uses the --device vhost-user-fs-pci syntax together with a
> virtiofsd process.
>
> virtio-9p uses either the full --device virtio-9p-pci and --fsdev
> syntax or the shortcut --virtfs syntax that combines both these
> options.
>
> > Could someone can give me a confirmation if virtiofsd is must or its
> > optional. Thanks in advance!
>
> If you want to use virtiofs then virtiofsd is required.
>
> If you use virtio-9p then virtiofsd is not needed.
>
> In terms of which one you should use, both are widely used today.
> Unless you have specific requirements, I think you can choose
> whichever one seems most convenient to you.

I think I stick with the virtiofs+virtiofsd. Most QEMU features I need
shipped with 1-2 years old distros and can be installed from repos, so
I dont need to bother with building it.

Thanks again for the detailed explanation!

>
> Stefan

Best,
Ferenc

