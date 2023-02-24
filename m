Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=OIUR3OX7z+9tiRTsWrOB/wXMms+PHWE9MXL4csGiWcw=;
 b=aTuMijKjb6oPHV71kwddZHL1nl35v1PE3BRKJQxWmL1FNBv++fl/FjghF4r9d8KBKk
 O2TJELxALvWswG9qReZpvUkVxGNCKif/ZdrPiJuEV9ZaeKM8t9mwn6tKdHzFSo+GW2f3
 B2/aIprV38Clvsg5L6SEmNlbCAUsJLxV1MHvpEo9NdfLZxSibTj8ltVAI0ahj1s4TgtB
 hX1nJlvD7iRp1iyGjIt1YsOv08wYmTzBqF2bvZxixyGmbOxi3PLzUWJQZwEdXSXsKB/x
 251i2SUGBKWcOjLCKz+1/qZXYx313aXUqWg5jwr7KdQA236IrOzpNebKUP1uDhGHqFx8
 6sew==
MIME-Version: 1.0
References: <b155ad6fe6bb026377a8f75882e26078da10ab70.camel@inf.elte.hu>
In-Reply-To: <b155ad6fe6bb026377a8f75882e26078da10ab70.camel@inf.elte.hu>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Fri, 24 Feb 2023 12:23:43 -0500
Message-ID: <CAJSP0QX3VTU+_wngw+8jHttKykJ-WzMgns+PASDaD91or+zp5A@mail.gmail.com>
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
To: Ferenc Fejes <fejes@inf.elte.hu>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org, stefanha@redhat.com, =?UTF-8?B?UMOpdGVyIEFudGFs?= <peti.antal99@gmail.com>, Christian Schoenebeck <qemu_oss@crudebyte.com>

On Fri, 24 Feb 2023 at 11:47, Ferenc Fejes <fejes@inf.elte.hu> wrote:
> I'm using a QEMU VM with a debootstrap rootfs, shared over virtiofs for
> the guest. My best understanding is that virtiofsd must required even
> if just using one guest.

Yes, virtiofsd is required even if just one guest is accessing a
shared directory using a virtiofs device. The virtiofsd daemon is
responsible for emulating the virtiofs device (QEMU does not do the
emulation), so that's why it's essential even with just a single
guest.

> Looking around in the QEMU manpages I got a little bit confused by
> virtfs parameter. Is it something entirely connected with 9P or it is
> possible to pass folders to the guest through virtiofs without
> virtiofsd? Unfortunately none of my trial with the parameters
> succeeded.

There are two separate VIRTIO devices for sharing files/directories:
virtiofs and virtio-9p (sometimes called virtfs). It's easy to confuse
them because "virtiofs" and "virtfs" look similar. They have different
features and are completely independent of each other. In terms of the
file system protocol, virtiofs is based on Linux FUSE while virtio-9p
is based on the 9P protocol.

virtiofs uses the --device vhost-user-fs-pci syntax together with a
virtiofsd process.

virtio-9p uses either the full --device virtio-9p-pci and --fsdev
syntax or the shortcut --virtfs syntax that combines both these
options.

> Could someone can give me a confirmation if virtiofsd is must or its
> optional. Thanks in advance!

If you want to use virtiofs then virtiofsd is required.

If you use virtio-9p then virtiofsd is not needed.

In terms of which one you should use, both are widely used today.
Unless you have specific requirements, I think you can choose
whichever one seems most convenient to you.

Stefan

