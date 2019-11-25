DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=C5f4xUL+V2+8/nQMkQs1b9op2wEG2TkCTmUU2i8ZzYk=;
	b=AHgt+QfsItPF5DapufRvH6vvDvsst4aKQbSqxqP24tQdnEHkKoAlzB0ygK8TNXfyVh
	F+OVMDWjsnnNL/xUWvoZxYFLiUvdXPp3iz7blyK5pxMDVb6xcnh6GGRAGHeuUSfpzoUH
	BxGBA2oucqlYT6DqajybB3niI5Js8/u5FBjR8=
MIME-Version: 1.0
References: <20191118022410.21023-1-msys.mizuma@gmail.com>
In-Reply-To: <20191118022410.21023-1-msys.mizuma@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 25 Nov 2019 13:38:38 +0100
Message-ID: <CAJfpegveuh3b0GMOmC3SuMOq=yi9sgBeOS2LGEetbfKqyS1xtQ@mail.gmail.com>
Content-Type: multipart/mixed; boundary="000000000000a58caf05982b0b24"
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
To: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>, virtio-fs@redhat.com, linux-kernel@vger.kernel.org

--000000000000a58caf05982b0b24
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 18, 2019 at 3:24 AM Masayoshi Mizuma <msys.mizuma@gmail.com> wr=
ote:
>
> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
>
> exit_aio() is sometimes stuck in wait_for_completion() after aio is issue=
d
> with direct IO and the task receives a signal.
>
> That is because kioctx in mm->ioctx_table is in use by aio_kiocb.
> aio_kiocb->ki_refcnt is 1 at that time. That means iocb_put() isn't
> called correctly.
>
> fuse_get_req() returns as -EINTR when it's blocked and receives a signal.
> fuse_direct_IO() deals with the -EINTER as -EIOCBQUEUED and returns as
> -EIOCBQUEUED even though the aio isn't queued.
> As the result, aio_rw_done() doesn't handle the error, so iocb_put() isn'=
t
> called via aio_complete_rw(), which is the callback.

Hi,

Thanks for the report.

Can you please test the attached patch (without your patch)?

Thanks,
Miklos

--000000000000a58caf05982b0b24
Content-Type: text/x-patch; charset=WINDOWS-1252; 
	name=fuse-fix-leak-of-fuse_io_priv.patch
Content-Disposition: attachment; 
	filename="fuse-fix-leak-of-fuse_io_priv.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k3eesp440>
X-Attachment-Id: f_k3eesp440

LS0tCiBmcy9mdXNlL2ZpbGUuYyB8ICAgIDQgKysrLQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0
aW9ucygrKSwgMSBkZWxldGlvbigtKQoKLS0tIGEvZnMvZnVzZS9maWxlLmMKKysrIGIvZnMvZnVz
ZS9maWxlLmMKQEAgLTcxMyw4ICs3MTMsMTAgQEAgc3RhdGljIHNzaXplX3QgZnVzZV9hc3luY19y
ZXFfc2VuZChzdHJ1YwogCiAJaWEtPmFwLmFyZ3MuZW5kID0gZnVzZV9haW9fY29tcGxldGVfcmVx
OwogCWVyciA9IGZ1c2Vfc2ltcGxlX2JhY2tncm91bmQoZmMsICZpYS0+YXAuYXJncywgR0ZQX0tF
Uk5FTCk7CisJaWYgKGVycikKKwkJZnVzZV9haW9fY29tcGxldGVfcmVxKGZjLCAmaWEtPmFwLmFy
Z3MsIGVycik7CiAKLQlyZXR1cm4gZXJyID86IG51bV9ieXRlczsKKwlyZXR1cm4gbnVtX2J5dGVz
OwogfQogCiBzdGF0aWMgc3NpemVfdCBmdXNlX3NlbmRfcmVhZChzdHJ1Y3QgZnVzZV9pb19hcmdz
ICppYSwgbG9mZl90IHBvcywgc2l6ZV90IGNvdW50LAo=
--000000000000a58caf05982b0b24--

