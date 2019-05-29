DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=hyper-sh.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=VcswAPoCaYw0Mll/satJL70QxalRFsdLAfeg5cJe8as=;
	b=1kOt75vipQ7KlYIYN7rxqc/sU1eWsfIUsWsZiufSI6Ey7+IcaQ2yyLn5wsuponDFkd
	zmIjYk2JXP+qt+hNODcSv3uarrngRoxy1rWKDljERIUNJ2lsv1XQariaZ9wvpTCFdoTf
	79klQD6C6VJj3h/h4oGm/yQ+Jj974Q+PqXsZ6aYw8VFpojwJmqwxU/pmlaYj/TPqRh9Q
	7kAowNaM8jaCceOdr2LCqw53k69yz0OTkfiOn351Bmt3Z3z2Rv5uryYkMCf+oh9ohScg
	vrUDa1XuVn6PYSIG0HxaQSJ9E2wYvnhcDkCpX7Z+29SK/7brEsnSc2x+h79LbuRbqBtd
	/obw==
MIME-Version: 1.0
References: <20190522162623.GH2666@work-vm>
	<CACGKRzXxcwRZ+fmiDu7gL16cRf=vT3X-o=w3yYeOCZxZoBXpmg@mail.gmail.com>
	<20190528213555.GC6446@redhat.com>
In-Reply-To: <20190528213555.GC6446@redhat.com>
From: Tao Peng <bergwolf@hyper.sh>
Date: Wed, 29 May 2019 10:17:57 +0800
Message-ID: <CACGKRzWW3TNHAhX_zOyc2uaZzM8AWYx74UUq9FMCvMwE2LOSnQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] qemu/virtiofsd dev tree
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com

On Wed, May 29, 2019 at 5:35 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Fri, May 24, 2019 at 03:39:41PM +0800, Tao Peng wrote:
> > On Thu, May 23, 2019 at 12:26 AM Dr. David Alan Gilbert
> > <dgilbert@redhat.com> wrote:
> > >
> > > Hi,
> > >   I uploaded: https://gitlab.com/virtio-fs/qemu/commits/virtio-fs-dev
> > > which has:
> > >
> > >    * Fixes from Alibaba, Intel, Red Hat
> > >    * Stefan's security doc
> > >    * support for direct-io from virtiofs to virtiofs (e.g.
> > >      reading a virtiofs file into an mmap'd viritofs dax file)
> > >      - I've just finished this and it's lightly tested, so feedback
> > >      welcome
> > >    * Rebase on bleeding edge qemu.
> > >
> > > Let me know how it goes.
> > Thanks Dave! Is there a dev branch for the kernel part that we can
> > collaborate on?
>
> Hi Tao,
>
> For now use this one.
>
> https://github.com/rhvgoyal/linux/tree/virtio-fs-dev-5.1
>
Cool, thanks!

Cheers,
Tao
-- 
Into something rich and strange.

