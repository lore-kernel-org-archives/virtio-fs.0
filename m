Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1694008665; x=1694613465; darn=redhat.com;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to;
 bh=S2Smp2aBwuIRNZtLWcjlS8jG1YQykyl/Y7n9k5HqWmI=;
 b=qPtiUi+AN7TrBokScCP5lTXP6CVtFRDr1nqV2ejuwmsB1SPSeFuLtN4tw0zMtkxLld
 L8/9FQJ8Mra2bHBN4jHmlf8lh2+BLmeeeh73Z5nGsBFdemcGdaJC/VRrHW+0smrwLMeo
 wkcKscSIrj+I9RsGdKYR5EzEL8lYqQ6oIfNAXP19W2VDcTuAxr2UO9BbYzw0t1huEcRk
 94XdHkIl8zOU3uiASVFtbp9awbRe+bpJA/tnIQUPqvwCJXwODgslJcmMi3Z0o0HtWO+j
 nNkQh7k7YDZ2blXlYUbh/aMlM5kp4GwIDKIhYIfLPswzSCrRSKj5a0qFxDS4+hsKcVtB
 +rVQ==
MIME-Version: 1.0
References: <87v8grlzu9.fsf@linaro.org>
 <CAJSP0QX+NeJ8Z5d+2ocUUVj4EGopxKT+trmEfacgvhE7TqCokQ@mail.gmail.com>
 <5e6b1bbd-bc0a-cff5-119c-639a9d15e72a@linux.dev>
In-Reply-To: <5e6b1bbd-bc0a-cff5-119c-639a9d15e72a@linux.dev>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Wed, 6 Sep 2023 09:57:33 -0400
Message-ID: <CAJSP0QUZ51y4bBTRgp_g6AO_6iEFamhOqMbcfFi5UiWBCkJQJQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] Status of DAX for virtio-fs/virtiofsd?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hao Xu <hao.xu@linux.dev>
Cc: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, virtio-fs@redhat.com, Erik Schilling <erik.schilling@linaro.org>, QEMU Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Wed, 6 Sept 2023 at 09:07, Hao Xu <hao.xu@linux.dev> wrote:
> On 5/18/23 00:26, Stefan Hajnoczi wrote:
> > On Wed, 17 May 2023 at 11:54, Alex Benn=C3=A9e <alex.bennee@linaro.org>=
 wrote:
> > Hi Alex,
> > There were two unresolved issues:
> >
> > 1. How to inject SIGBUS when the guest accesses a page that's beyond
> > the end-of-file.
>
> Hi Stefan,
> Does this SIGBUS issue exist if the guest kernel can be trusted? Since in
>
> that case, we can check the offset value in guest kernel.

The scenario is:
1. A guest userspace process has a DAX file mmapped.
2. The host or another guest that is also sharing the directory
truncates the file. The pages mmapped by our guest are no longer
valid.
3. The guest loads from an mmapped page and a vmexit occurs.
4. Now the host must inject a SIGBUS into the guest. There is
currently no way to do this.

I believe this scenario doesn't happen within a single guest, because
the guest kernel will raise SIGBUS itself without a vmexit if another
process inside that same guest truncates the file.

Another scenario is when the guest kernel access the DAX pages. A
vmexit can occur here too.

If you trust the host and all guests sharing the directory not to
truncate files that are mmapped, then this issue will not occur.

Stefan

