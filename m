DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=date:from:to:cc:subject:message-id:references:mime-version
	:content-disposition:in-reply-to;
	bh=pu8Eznl5GQtTXPjOvQ9qkpsA+I6ie4l2E52E9iodSKg=;
	b=kI85VaEUlSWtCUuPFkbQTFWUQOHiHVp00qvsZKCR40vRjJ7HbRRfRKHmOgeCtFNOHJ
	8DDCLa00uLyj2I6rTtVEjA5+HEtebq+ScYFeXJDfb7hrGvscihd69ZlCg+c7VwuO5NmN
	9Dxl1DLsqBsV65H4fZN2pnbtO82hguY2+I9Ul5SewP0/adDMhSznjp9DMfMRq5H/ZjIx
	r8KIf9ouPRbpWKLAKO51I/K7Ra33s3Xh6+BOuzKvB2smCVeO0KFgLMOXxvPplgi0XNxc
	6JnexIvZikj6CcF1I2baJ2wW9XWWPgDlKdc+QuVoGyhDPclWK9Nbi535sUKs0RXxK9HW
	HxXA==
Date: Mon, 25 Nov 2019 11:58:19 -0500
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <20191125165819.k2ghv7h4tzyvyr6e@gabell>
References: <20191118022410.21023-1-msys.mizuma@gmail.com>
	<CAJfpegveuh3b0GMOmC3SuMOq=yi9sgBeOS2LGEetbfKqyS1xtQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJfpegveuh3b0GMOmC3SuMOq=yi9sgBeOS2LGEetbfKqyS1xtQ@mail.gmail.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] fuse: Fix the return code of
 fuse_direct_IO() to deal with the error for aio
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>, virtio-fs@redhat.com, linux-kernel@vger.kernel.org

On Mon, Nov 25, 2019 at 01:38:38PM +0100, Miklos Szeredi wrote:
> On Mon, Nov 18, 2019 at 3:24 AM Masayoshi Mizuma <msys.mizuma@gmail.com> wrote:
> >
> > From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> >
> > exit_aio() is sometimes stuck in wait_for_completion() after aio is issued
> > with direct IO and the task receives a signal.
> >
> > That is because kioctx in mm->ioctx_table is in use by aio_kiocb.
> > aio_kiocb->ki_refcnt is 1 at that time. That means iocb_put() isn't
> > called correctly.
> >
> > fuse_get_req() returns as -EINTR when it's blocked and receives a signal.
> > fuse_direct_IO() deals with the -EINTER as -EIOCBQUEUED and returns as
> > -EIOCBQUEUED even though the aio isn't queued.
> > As the result, aio_rw_done() doesn't handle the error, so iocb_put() isn't
> > called via aio_complete_rw(), which is the callback.
> 
> Hi,
> 
> Thanks for the report.
> 
> Can you please test the attached patch (without your patch)?

The patch you attached works well, thanks! I tested it with virtiofs.

Should I post the patch? Or could you take care of it? Let me know.

Thanks!
Masa


