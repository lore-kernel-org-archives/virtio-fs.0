DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=yrw24KSUKB5un7ypzoyzMi3gtuBjd4drCZP05BGVyRE=;
	b=mLGbdNuQuUo9/i9Io2a5XDaSipZG1M5EjNQ3i3ZQihTvTEcDGTI4dunkRY2zas7b1n
	3mN1GwTwS6MONmC9hjS1wol02Zy7s4WPqCaBkXh70pVBBy1Et/sZ+tdYCoiARYdrkogK
	cXfnGucEeAPmI8BehP2PDLQS8Qp4jTEcQXH3c=
MIME-Version: 1.0
References: <20200918213436.GA3520@redhat.com>
In-Reply-To: <20200918213436.GA3520@redhat.com>
From: Chirantan Ekbote <chirantan@chromium.org>
Date: Wed, 23 Sep 2020 21:50:59 +0900
Message-ID: <CAJFHJroSeg=Zk1VaHBzwurNTkziFzupiiVf_Y-2TDQ7nmdAERg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] tools/virtiofs: Multi threading seems to hurt
	performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

On Sat, Sep 19, 2020 at 6:36 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Hi All,
>
> virtiofsd default thread pool size is 64. To me it feels that in most of
> the cases thread pool size 1 performs better than thread pool size 64.
>
> I ran virtiofs-tests.
>
> https://github.com/rhvgoyal/virtiofs-tests
>
> And here are the comparision results. To me it seems that by default
> we should switch to 1 thread (Till we can figure out how to make
> multi thread performance better even when single process is doing
> I/O in client).
>

FWIW, we've observed the same behavior in crosvm. Using a thread pool
for the virtiofs server consistently gave us worse performance than
using a single thread.

Chirantan

