DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=intel-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=FzuZRenN/3UczXLj3+thO7tKTqsTx9weWp2ttaG3+Ko=;
	b=zawuOQt5P47InN/xf28+hOOPRs0JqfEPg7d21bnyv89wscVYKmezFAfp43eeV4aj1z
	amFHw66rURc66/hjqx+kl6xxu+bxKSxkeEHWHRlL7UAodZS4USBNj/I1Y1mC8w76qAPe
	oJPFMagtBnvN/9TXG8ZOcyPhNz9NfaMSlmontOpFUyjwa9D5ipU4d2BAQTFZtbYH0LO8
	AsAKOyhzVopHd0EMrUJCO/LYIHUuDEZldvlymyKTVB297Erz7EZ9RyUbVBQeAe7/Ja4V
	HC9yWT8qYYbgQJarOSQ/z9QpA6XabIQSANO7+YXGXik4Wuxi4b0InRmGg+tFAxyTAk/5
	dK7g==
MIME-Version: 1.0
References: <20200107180101.GC15920@redhat.com>
	<CAPcyv4gmdoqpwwwy4dS3D2eZFjmJ_Zi39k=1a4wn-_ksm-UV4A@mail.gmail.com>
	<20200107183307.GD15920@redhat.com>
	<CAPcyv4ggoS4dWjq-1KbcuaDtroHKEi5Vu19ggJ-qgycs6w1eCA@mail.gmail.com>
	<20200109112447.GG27035@quack2.suse.cz>
	<CAPcyv4j5Mra8qeLO3=+BYZMeXNAxFXv7Ex7tL9gra1TbhOgiqg@mail.gmail.com>
	<20200114203138.GA3145@redhat.com>
	<CAPcyv4iXKFt207Pen+E1CnqCFtC1G85fxw5EXFVx+jtykGWMXA@mail.gmail.com>
	<20200114212805.GB3145@redhat.com>
	<CAPcyv4igrs40uWuCB163PPBLqyGVaVbaNfE=kCfHRPRuvZdxQA@mail.gmail.com>
	<20200115195617.GA4133@redhat.com>
	<CAPcyv4iEoN9SnBveG7-Mhvd+wQApi1XKVnuYpyYxDybrFv_YYw@mail.gmail.com>
	<x49wo9smnqc.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49wo9smnqc.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 Jan 2020 10:09:46 -0800
Message-ID: <CAPcyv4hCR9NV+2MF0iAJ5rHS2uiOgTnu=+yQRfpieDJQpQz22w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 01/19] dax: remove block device dependencies
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: virtio-fs@redhat.com, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Wed, Jan 15, 2020 at 1:08 PM Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Hi, Dan,
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > I'm going to take a look at how hard it would be to develop a kpartx
> > fallback in udev. If that can live across the driver transition then
> > maybe this can be a non-event for end users that already have that
> > udev update deployed.
>
> I just wanted to remind you that label-less dimms still exist, and are
> still being shipped.  For those devices, the only way to subdivide the
> storage is via partitioning.

True, but if kpartx + udev can make this transparent then I don't
think users lose any functionality. They just gain a device-mapper
dependency.


