DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=intel-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=dPd0oj72IQTr7Ho1Km4ZWXqORK+AR/nQgrcplLwpJyE=;
	b=fpojuKnu+Wi5p9+eOGcUnK1tXz/ym+tDyQJR7fiN07JPdlNydPbQ1RuKfL9nYOO/vp
	ktdoj1LGNeeH0tLetzt6le5Wb0WjNM3TI4p2CjOGGX+EuSOWw0DzUACfhhv8vVjFUZDe
	W6M8jugyiYMYQ6KmvTTdLB9sA/e2SPnlatCfzz0H0tbTOuYqDFrMchmtCY6PyFUez9hR
	OJoFqGd7eJNY1E5+nY46wPN/+WfX65rZrOFaITHNzfaWg74cclGgIH9l50y+jzJWSEL7
	OLoPXxM4Hj1zKIsYyFEQOBs4ip5mmicI0GLmGXVjvoFJoRTGMOaPmOsh7mhiRTDNLsCU
	UcPg==
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
In-Reply-To: <20200115195617.GA4133@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 15 Jan 2020 12:17:40 -0800
Message-ID: <CAPcyv4iEoN9SnBveG7-Mhvd+wQApi1XKVnuYpyYxDybrFv_YYw@mail.gmail.com>
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed, Jan 15, 2020 at 11:56 AM Vivek Goyal <vgoyal@redhat.com> wrote:
[..]
> > Even the Red Hat
> > installation guide example shows mounting on pmem0 directly. [1]
>
> Below that example it also says.
>
> "When creating partitions on a pmem device to be used for direct access,
> partitions must be aligned on page boundaries. On the Intel 64 and AMD64
> architecture, at least 4KiB alignment for the start and end of the
> partition, but 2MiB is the preferred alignment. By default, the parted
> tool aligns partitions on 1MiB boundaries. For the first partition,
> specify 2MiB as the start of the partition. If the size of the partition
> is a multiple of 2MiB, all other partitions are also aligned."
>
> So documentation is clearly saying dax will work with partitions as well.
> And some user might decide to just do that.

Yes, of course but my point is that it was ambiguous.

I'm going to take a look at how hard it would be to develop a kpartx
fallback in udev. If that can live across the driver transition then
maybe this can be a non-event for end users that already have that
udev update deployed.


