Return-Path: <viresh.kumar@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1697528989; x=1698133789; darn=redhat.com;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date:from:to
 :cc:subject:date:message-id:reply-to;
 bh=/ilIXEltbFSCy9BUT4uFYAZHM04KSQPl+dPNSxDO2Ls=;
 b=PntQnZTcfTnviIVwIBVETHNO3DcHmiI8cPWa/mzZ7GDH5WQZ5EqiC4hok4u9Iw1YPU
 7upH7ynYqGnZXQiBJ0q/lXAKydOlxMXjO2NzS1AGTSvD35nBAtRGlHz49CWo6HmEbevn
 l/bUfl0h1GoToDr1zZx+mDQR1k9nWCib5mDsMKYloXCFJCkO9SC5rwuBanZq18DfLEuH
 SN8XVi9xdHLfX/3/kTxeA2+QY9HV/JQa9ejN0CsWqiag5aDXWg5H3aa8+yKqcNDJu6Re
 UAjiANguKEMvI04xx/0vYJWF9vpBZql4LrshC81SpCF3HUZV1HWkq5M3iB0LCq939COX
 iZcQ==
Date: Tue, 17 Oct 2023 13:19:43 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
Message-ID: <20231017074943.gft6f672o6xzeepa@vireshk-i7>
References: <e35f9f71-8d9d-6250-cbaa-70412b5a1149@nvidia.com>
 <3f28b1a4-d618-39df-57e6-6152f61cac6e@redhat.com>
 <8f3694c1-48d4-f34b-8f91-3bc217182ffa@redhat.com>
 <e19eb113-89b1-92ed-3375-8bc93c1ff39c@redhat.com>
 <8f51f02b-4676-c566-7304-f63e76df74ba@nvidia.com>
 <9a36a319-4567-f297-f14a-2025792ae93f@redhat.com>
 <87lecapxi4.fsf@linaro.org>
 <fbe05651-a65a-23d0-52be-2d611cc5740d@redhat.com>
 <87lec6mt03.fsf@linaro.org>
 <a7c01dd0-2b41-e294-f20c-a1edf6562a78@redhat.com>
MIME-Version: 1.0
In-Reply-To: <a7c01dd0-2b41-e294-f20c-a1edf6562a78@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] (no subject)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, "Michael S. Tsirkin" <mst@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>, Parav Pandit <parav@nvidia.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Yajun Wu <yajunw@nvidia.com>

On 13-10-23, 20:02, Hanna Czenczek wrote:
> On 10.10.23 16:35, Alex Bennée wrote:
> > I was going to say there is also the rust-vmm vhost-user-master crates
> > which we've imported:
> > 
> >    https://github.com/vireshk/vhost
> > 
> > for the Xen Vhost Frontend:
> > 
> >    https://github.com/vireshk/xen-vhost-frontend
> > 
> > but I can't actually see any handling for GET/SET_STATUS at all which
> > makes me wonder how we actually work. Viresh?
> 
> As far as I know the only back-end implementation of F_STATUS is in DPDK. 
> As I said, if anyone else implemented it right now, that would be dangerous,
> because qemu doesn’t adhere to the virtio protocol when it comes to the
> status byte.

Yeah, none of the Rust based Virtio backends enable `STATUS` in
`VhostUserProtocolFeatures` and so these messages are never exchanged.

The generic Rust code for the backends, doesn't even implement them.
Not sure if they should or not.

-- 
viresh

