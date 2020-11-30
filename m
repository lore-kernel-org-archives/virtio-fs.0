Date: Mon, 30 Nov 2020 09:49:55 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201130144955.GA14328@redhat.com>
References: <0503b244-b426-0779-7b9e-ff63dfa1165c@gmail.com>
	<20201119181635.GA3300@redhat.com>
	<04959049-62bf-c7dc-70b5-aacbc649c474@gmail.com>
	<20201119183841.GB3300@redhat.com>
	<20201119184436.GC3300@redhat.com>
	<20201119194424.GD3300@redhat.com>
	<d6a20a5e-3da3-b73b-03b6-24eb044c05a6@redhat.com>
	<eecb8c4e-9fd9-39ba-024b-c35953e769ef@gmail.com>
	<20201120185557.GC3105@redhat.com>
	<34ee3c42-8948-13a7-9c3f-8417bb4e948e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <34ee3c42-8948-13a7-9c3f-8417bb4e948e@gmail.com>
Subject: Re: [Virtio-fs] restorcon/SELinux virtiofs question
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Harry G. Coin" <hgcoin@gmail.com>
Cc: virtio-fs@redhat.com

On Sun, Nov 29, 2020 at 03:41:00PM -0600, Harry G. Coin wrote:

[..]
> Testing results follow.=A0 Short version:=A0 Commands above applied witho=
ut
> error,=A0 failure remains until vm is rebooted, then success.=A0 Good eno=
ugh
> for today!

During my testing, I too noticed that I had to unmount virtiofs and mount
again and then it worked. So not sure why this SELinux policy change does
not work for a already mounted filesystem. May be some caching happens
somewhere.

Thanks
Vivek

