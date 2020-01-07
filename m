DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=intel-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=xMZkcHtFGlxtWMU0/yJi4CuOWPo2x4C+GD+Xd4ftxtY=;
	b=fGlV4Pr2MgSNzKMiDvbbOE+RWBOvNONUJBDPutDXvnKV0UHzXrxqy41oXKo6WrCibz
	nIRkrfWVWS/3omjTf2Szli0DI/W6lLwbaiIUY2Th1bSJbzbi5GX640rH874VzisnSJBN
	s3Goe8kx/MBl1KrfR/Q6Q38YPMR41UmkrW1Gd+X9IIEIxtYmHbhTJRqiFPcX8Z4JUIxo
	AbpigFkKiQOO5NhcIFROnexkKOwsN9Kh7HoEvk2zwnpTt8e9OmkfedzdRR1luOdVBsXq
	wj40LOEnqORt9GMjzv6fUO3xLP+gEY5sn5TmCNDBD42EaYbFnVTfd41qJspyjppYb7f8
	ISzg==
MIME-Version: 1.0
References: <CAPcyv4jGEAbYSJef2zLzgg6Arozsuz7eN_vZL1iTcd1XQuNT4Q@mail.gmail.com>
	<20191216181014.GA30106@redhat.com>
	<20200107125159.GA15745@infradead.org>
	<CAPcyv4jZE35sbDo6J4ihioEUFTuekJ3_h0=2Ra4PY+xn2xn1cQ@mail.gmail.com>
	<20200107170731.GA472641@magnolia>
	<CAPcyv4ggH7-QhYg+YOOWn_m25uds+-0L46=N09ap-LALeGuU_A@mail.gmail.com>
	<20200107180101.GC15920@redhat.com>
	<CAPcyv4gmdoqpwwwy4dS3D2eZFjmJ_Zi39k=1a4wn-_ksm-UV4A@mail.gmail.com>
	<20200107183307.GD15920@redhat.com>
	<CAPcyv4ggoS4dWjq-1KbcuaDtroHKEi5Vu19ggJ-qgycs6w1eCA@mail.gmail.com>
	<20200107190258.GB472665@magnolia>
	<CAPcyv4ia9r0rdbb7t0JvEnGW6nnHdAWUHbaMrY5FKBY+4Fum6Q@mail.gmail.com>
In-Reply-To: <CAPcyv4ia9r0rdbb7t0JvEnGW6nnHdAWUHbaMrY5FKBY+4Fum6Q@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 7 Jan 2020 15:38:54 -0800
Message-ID: <CAPcyv4jDYUPp=aqH1VTfxFAXiMa0Uqn+ykptfu_yNDOjR7Akfg@mail.gmail.com>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: virtio-fs@redhat.com, linux-nvdimm <linux-nvdimm@lists.01.org>, Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Tue, Jan 7, 2020 at 11:46 AM Dan Williams <dan.j.williams@intel.com> wrote:
[..]
> > I'd say deprecate the
> > kernel automounting partitions, but I guess it already does that, and
>
> Ok, now I don't know why automounting is leaking into this discussion?
>
> > removing it would break /something/.
>
> Yes, the breakage risk is anyone that was using ext4 mount failure as
> a dax capability detector.
>
> > I guess you could put
> > "/dev/pmemXpY" on the deprecation schedule.
>
> ...but why deprecate /dev/pmemXpY partitions altogether? If someone
> doesn't care about dax then they can do all the legacy block things.
> If they do care about dax then work with whole device namespaces.

Circling back on this point now that I understand what you meant by
automount. It would need to be a full deprecation of /dev/pmemXpY
devices if kpartx dax support is going to fully take over for people
that want to use disk partition tables instead of EFI Namespace Labels
to carve up pmem.


