DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=0+ML9D8t0qHLLc0IkFSgl4VquOhXBGW3wDjpNV1Dr4Y=;
	b=GzOoXN6R0YwtVm9WdlSPJSM79+9WNpzWlc67UUXi1x5ICXqL5P8zbyYvxOUWNrR3mS
	Y09eTbzgjxUe62qDkZeRSOe5PVpcNs2Ep67LSc+NWFFRm9NOq+3gytkRw3odi8Rdnwbb
	eoMKKx/J/LN5PUy0AN+ppxn4boRqV7zZB7rsSviODQ0IILPUmb/KtqGN8Q976XfTuA8X
	bpukzVrFMjgDQNkjp45VoE0UkGa3JhidUSyp5RXJtLMf4S0U+bY5TtnUW440sNaUD5DH
	wr1++BD1e5cF3k2dNUFrzNgtpEhAiufcK4LIGX78nUfBHb0B14uLdZ9JTJCet78R6Tzn
	MG6g==
MIME-Version: 1.0
References: <20200807195526.426056-1-vgoyal@redhat.com>
	<20200807195526.426056-5-vgoyal@redhat.com>
	<20200810100327-mutt-send-email-mst@kernel.org>
	<20200810145019.GB455528@redhat.com>
In-Reply-To: <20200810145019.GB455528@redhat.com>
From: Gurchetan Singh <gurchetansingh@google.com>
Date: Thu, 13 Aug 2020 19:51:56 -0700
Message-ID: <CAAfnVBk+Hmcm2ftd3wOK-P2NyYQ7z4Wrf1JKhLJaNkCZBLoo6g@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000bd1d2c05accd8162"
Subject: Re: [Virtio-fs] [PATCH v2 04/20] virtio: Implement get_shm_region
	for PCI transport
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: kbuild test robot <lkp@intel.com>, kvm@vger.kernel.org, miklos@szeredi.hu, "Michael S. Tsirkin" <mst@redhat.com>, open list <linux-kernel@vger.kernel.org>, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org

--000000000000bd1d2c05accd8162
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 10, 2020 at 7:50 AM Vivek Goyal <vgoyal@redhat.com> wrote:

> On Mon, Aug 10, 2020 at 10:05:17AM -0400, Michael S. Tsirkin wrote:
> > On Fri, Aug 07, 2020 at 03:55:10PM -0400, Vivek Goyal wrote:
> > > From: Sebastien Boeuf <sebastien.boeuf@intel.com>
> > >
> > > On PCI the shm regions are found using capability entries;
> > > find a region by searching for the capability.
> > >
> > > Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
> > > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > > Signed-off-by: kbuild test robot <lkp@intel.com>
> > > Cc: kvm@vger.kernel.org
> > > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> >
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> >
>
> [..]
> > > +static bool vp_get_shm_region(struct virtio_device *vdev,
> > > +                         struct virtio_shm_region *region, u8 id)
> > > +{
> > > +   struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> > > +   struct pci_dev *pci_dev = vp_dev->pci_dev;
> > > +   u8 bar;
> > > +   u64 offset, len;
> > > +   phys_addr_t phys_addr;
> > > +   size_t bar_len;
> > > +
> > > +   if (!virtio_pci_find_shm_cap(pci_dev, id, &bar, &offset, &len)) {
> > > +           return false;
> > > +   }
> > > +
> > > +   phys_addr = pci_resource_start(pci_dev, bar);
> > > +   bar_len = pci_resource_len(pci_dev, bar);
> > > +
> > > +   if ((offset + len) < offset) {
> > > +           dev_err(&pci_dev->dev, "%s: cap offset+len overflow
> detected\n",
> > > +                   __func__);
> > > +           return false;
> > > +   }
> > > +
> > > +   if (offset + len > bar_len) {
> > > +           dev_err(&pci_dev->dev, "%s: bar shorter than cap
> offset+len\n",
> > > +                   __func__);
> > > +           return false;
> > > +   }
> >
> > Maybe move this to a common header so the checks can be reused by
> > other transports? Can be a patch on top.
>
> Will do as patch on top once these patches get merged.
>

There's also some minor checkpatch complaints.  I fixed them with the
series I sent out with virtio-gpu.


>
> Thanks
> Vivek
>
>

--000000000000bd1d2c05accd8162
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Mon, Aug 10, 2020 at 7:50 AM Vivek=
 Goyal &lt;<a href=3D"mailto:vgoyal@redhat.com">vgoyal@redhat.com</a>&gt; w=
rote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0p=
x 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">On Mon, Au=
g 10, 2020 at 10:05:17AM -0400, Michael S. Tsirkin wrote:<br>
&gt; On Fri, Aug 07, 2020 at 03:55:10PM -0400, Vivek Goyal wrote:<br>
&gt; &gt; From: Sebastien Boeuf &lt;<a href=3D"mailto:sebastien.boeuf@intel=
.com" target=3D"_blank">sebastien.boeuf@intel.com</a>&gt;<br>
&gt; &gt; <br>
&gt; &gt; On PCI the shm regions are found using capability entries;<br>
&gt; &gt; find a region by searching for the capability.<br>
&gt; &gt; <br>
&gt; &gt; Signed-off-by: Sebastien Boeuf &lt;<a href=3D"mailto:sebastien.bo=
euf@intel.com" target=3D"_blank">sebastien.boeuf@intel.com</a>&gt;<br>
&gt; &gt; Signed-off-by: Dr. David Alan Gilbert &lt;<a href=3D"mailto:dgilb=
ert@redhat.com" target=3D"_blank">dgilbert@redhat.com</a>&gt;<br>
&gt; &gt; Signed-off-by: kbuild test robot &lt;<a href=3D"mailto:lkp@intel.=
com" target=3D"_blank">lkp@intel.com</a>&gt;<br>
&gt; &gt; Cc: <a href=3D"mailto:kvm@vger.kernel.org" target=3D"_blank">kvm@=
vger.kernel.org</a><br>
&gt; &gt; Cc: &quot;Michael S. Tsirkin&quot; &lt;<a href=3D"mailto:mst@redh=
at.com" target=3D"_blank">mst@redhat.com</a>&gt;<br>
&gt; <br>
&gt; Acked-by: Michael S. Tsirkin &lt;<a href=3D"mailto:mst@redhat.com" tar=
get=3D"_blank">mst@redhat.com</a>&gt;<br>
&gt; <br>
<br>
[..]<br>
&gt; &gt; +static bool vp_get_shm_region(struct virtio_device *vdev,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0struct virtio_shm_region *region, u8 id)<br>
&gt; &gt; +{<br>
&gt; &gt; +=C2=A0 =C2=A0struct virtio_pci_device *vp_dev =3D to_vp_device(v=
dev);<br>
&gt; &gt; +=C2=A0 =C2=A0struct pci_dev *pci_dev =3D vp_dev-&gt;pci_dev;<br>
&gt; &gt; +=C2=A0 =C2=A0u8 bar;<br>
&gt; &gt; +=C2=A0 =C2=A0u64 offset, len;<br>
&gt; &gt; +=C2=A0 =C2=A0phys_addr_t phys_addr;<br>
&gt; &gt; +=C2=A0 =C2=A0size_t bar_len;<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0if (!virtio_pci_find_shm_cap(pci_dev, id, &amp;bar,=
 &amp;offset, &amp;len)) {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
&gt; &gt; +=C2=A0 =C2=A0}<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0phys_addr =3D pci_resource_start(pci_dev, bar);<br>
&gt; &gt; +=C2=A0 =C2=A0bar_len =3D pci_resource_len(pci_dev, bar);<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0if ((offset + len) &lt; offset) {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;pci_dev-&g=
t;dev, &quot;%s: cap offset+len overflow detected\n&quot;,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0__func__);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
&gt; &gt; +=C2=A0 =C2=A0}<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0if (offset + len &gt; bar_len) {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;pci_dev-&g=
t;dev, &quot;%s: bar shorter than cap offset+len\n&quot;,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0__func__);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
&gt; &gt; +=C2=A0 =C2=A0}<br>
&gt; <br>
&gt; Maybe move this to a common header so the checks can be reused by<br>
&gt; other transports? Can be a patch on top.<br>
<br>
Will do as patch on top once these patches get merged. <br></blockquote><di=
v><br></div><div>There&#39;s also some minor checkpatch complaints.=C2=A0 I=
 fixed them with the series I sent out with virtio-gpu.</div><div>=C2=A0</d=
iv><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bord=
er-left:1px solid rgb(204,204,204);padding-left:1ex">
<br>
Thanks<br>
Vivek<br>
<br>
</blockquote></div></div>

--000000000000bd1d2c05accd8162--

