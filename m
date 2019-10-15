DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=W4jwGw9tpK2Ep0Rp6kHsYedYG4/2oTitydgwNGsuUZE=;
	b=U/xvL0IVUFdItLvpZ5Qj9Z3Qr3x+OqjmQpYcv0sc/c6QpKSca8tosv9XV2Adjjme8h
	+5Iz2l52dfviwtJ6Rb8b70vJKzBLI2KK9z7inR2COjkLNg7cAgknGbj6QTnJ3FYChJpa
	c6DG4BOAAlcNnSvHiO15M3cM39YlZdPKkce6U=
MIME-Version: 1.0
References: <7331fd60-10c6-6076-4cf5-f5cce7bc6ef1@jp.fujitsu.com>
	<20191007143444.GA174343@work-vm> <20191009165116.GJ2893@work-vm>
	<27035e4a-bd12-e5d8-30d0-0df45e75457c@jp.fujitsu.com>
	<CAJFHJrr5Esq=cjZNW4qZRABtCCh_vpkFJEQO9kYb=Pg62O+weQ@mail.gmail.com>
	<20191011195935.GB13861@redhat.com>
	<CAJFHJrq6bQo=yvO0tAxH7RWg=U=ftpsePs3c7y-AcE90Wh4afg@mail.gmail.com>
	<20191011203647.GC13861@redhat.com>
	<20191014091108.GH22963@stefanha-x1.localdomain>
	<CAJFHJrrqfjQqMu-K99DiBYNmD1=hB710wRZ88w--SQ0GxQv9Tw@mail.gmail.com>
	<20191015155749.GH3073@work-vm>
In-Reply-To: <20191015155749.GH3073@work-vm>
From: Chirantan Ekbote <chirantan@chromium.org>
Date: Wed, 16 Oct 2019 01:11:03 +0900
Message-ID: <CAJFHJroxYvu_cfwCCxdWV_mN-0pxZ4qBbXdjiJEzPECui-ygrA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] xfstest results for virtio-fs on aarch64
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "masayoshi.mizuma@fujitsu.com" <masayoshi.mizuma@fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>

On Wed, Oct 16, 2019 at 12:58 AM Dr. David Alan Gilbert
<dgilbert@redhat.com> wrote:
>
> * Chirantan Ekbote (chirantan@chromium.org) wrote:
> >
> > I'm not using virtiofsd.  We have our own server for crosvm, which
> > supports multiple queues.
>
> Ah excellent; is that public anywhere?
>

It's currently under review here:
https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/1758103

I expect to have it merged sometime this week.

