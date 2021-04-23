DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=intel-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=dfQYJoLyB6h5ZbM4eg6Kr44fOO/ylFVrCnfKWSRlupI=;
	b=XIrgS7eZvzhqFQGzaCw99zsTJou6Zmn6+qlQS+jLXwjE4/FMmqnjZuwoAcS2cOq9MJ
	YwLvedQjp6Xc7eib13/t2RHH1CRhgf4pLfr2ZnEmQ2s94gOCMX2a7ccCO4BrwX8ELRNz
	pratDifm/U3Qz0LPqF5zfi5UiRmLchv91hKIKYZ7Tcw1b1ngICuDWkuFMKnVbs+PI+lF
	Qx6B6YkP9fV1dUeP+TLUmymxhUAQdBr8fal4P+zCvMljDKJ2AR6ye99CxLvf1/n4xrTq
	ImhgPSL3EFPtqiQITgBoMcFVvYbf3yVITE8jWKMGK2GZw/bT+aB9l6F5n9ZAlNFWYzuE
	W3Eg==
MIME-Version: 1.0
References: <20210423130723.1673919-1-vgoyal@redhat.com>
In-Reply-To: <20210423130723.1673919-1-vgoyal@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 23 Apr 2021 13:38:51 -0700
Message-ID: <CAPcyv4hz=nHYQ89-m-7yVJWpEP4gZBYTY6E4POAms9mYDb_N+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v4 0/3] dax: Fix missed wakeup in
	put_unlocked_entry()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, virtio-fs-list <virtio-fs@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Apr 23, 2021 at 6:07 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Hi,
>
> This is V4 of the patches. Posted V3 here.
>
> https://lore.kernel.org/linux-fsdevel/20210419213636.1514816-1-vgoyal@redhat.com/
>
> Changes since V3 are.
>
> - Renamed "enum dax_entry_wake_mode" to "enum dax_wake_mode" (Matthew Wilcox)
> - Changed description of WAKE_NEXT and WAKE_ALL (Jan Kara)
> - Got rid of a comment (Greg Kurz)

Looks good Vivek, thanks for the resend.

