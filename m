DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=9gMPmMtjRZPxIw/k279+mMi8Jf2DvDPBfQpmjNzYywc=;
	b=PB4L/yK8ulPV/nukp8omko4ITQzK80cpdJv6/4eo7jZoMK0K9TF024+t3Lr7ueJhXg
	lXk62P2B+U5xWo+pk7W39Cr1yFn/UIOFtY+s/IPA3xLBCg7+6vGnDf+ay2K12mXoxY24
	AIjbKhOEIz5cadqECbfC5bZTNlK9DyqO289AxHhOH/tCS6yh0AXYH+fcqGKIY4VmWWfy
	hN382HenaOcBQG88l0Pd927QjeFeCCkXtwrbbvmq/W1crlpdMJqxUcTF4Q5cV/dPQtJu
	euUTyUxQAha+QzWYXf3apcBksPzXwn1yN1BxgTXAjS2hsZidgenJ5soQNTsIkQbuEqaP
	ltBg==
MIME-Version: 1.0
References: <20190906100324.8492-1-stefanha@redhat.com>
	<CAFLxGvw-n2VYcYR9kei7Hu2RBhCG9PeWuW7Z+SaiyDQVBRiugw@mail.gmail.com>
	<20190909070039.GB13708@stefanha-x1.localdomain>
In-Reply-To: <20190909070039.GB13708@stefanha-x1.localdomain>
From: Richard Weinberger <richard.weinberger@gmail.com>
Date: Tue, 17 Sep 2019 20:19:55 +0200
Message-ID: <CAFLxGvw51qeifCLwhV-8DKXNwC9=_5hFf==e7h4YCvFE5_Wz0A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] init/do_mounts.c: add virtiofs root fs
	support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, David Howells <dhowells@redhat.com>, virtio-fs@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Mon, Sep 9, 2019 at 9:00 AM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> On Fri, Sep 06, 2019 at 09:16:04PM +0200, Richard Weinberger wrote:
> > On Fri, Sep 6, 2019 at 1:15 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> > I think you don't need this, you can abuse a hack for mtd/ubi in
> > prepare_namespace().
> > At least for 9p it works well:
> > qemu-system-x86_64 -m 4G -M pc,accel=kvm -nographic -kernel
> > arch/x86/boot/bzImage -append "rootfstype=9p
> > rootflags=trans=virtio,version=9p2000.L root=mtdfake console=ttyS0 ro
> > init=/bin/sh" -virtfs
> > local,id=rootfs,path=/,security_model=passthrough,mount_tag=mtdfake
>
> That is worse because:
> 1. The file system must be named "mtd*" or "ubi*".
> 2. When mounting fails you get confusing error messages about block
>    devices and partitions.  These do not apply to virtio-fs or
>    virtio-9p.

This is the current situation, I'm not saying it is perfect. But
before we add another
special case for a filesystem we should at least try to consolidate this stuff.

> > If this works too for virtiofs I suggest to cleanup the hack and
> > generalize it. B-)
>
> Why mtd and ubi block devices even have a special case?  Maybe this code
> was added because ROOT_DEV = name_to_dev_t(root_device_name) doesn't
> work for "mtd:partition" device names so the regular CONFIG_BLOCK code
> path doesn't work for these devices.

ubi and mtd are not block devices, they are character devices.
That's why the hack with name matching was added a long time ago.

> Given the ordering/fallback logic in prepare_namespace()/mount_root() I
> don't feel comfortable changing other code paths.  It's likely to break
> something.
>
> If you or others have a concrete suggestion for how to generalize this
> I'm happy to try implementing it.

mtd, ubi, virtiofs and 9p have one thing in common, they are not block devices.
What about a new miscroot= kernel parameter?

-- 
Thanks,
//richard

