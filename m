Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1684340790; x=1686932790;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to;
 bh=UX4HKKHpNiRzFE0v0DdgFekowRAr8FyedNbPUk28AJM=;
 b=YVzI/wgRtBQx4tu240Krf5VZArDABoV5F8dslpeWUZLLyIWuHaFvqyraaIVlWNv44c
 aQck01zzosFejAn+yYYD9ClrPLpJ1GJDgZ9sKL9vFYW0uZJT0f3D8yD5ft/Lib+HUSfq
 wRSd0AZTPJ2VYnhnNRZmNSkD6+oGMRPSI3/h/f5UOF/Zvc9j4JOKCbTLgHEh1rpNmjOc
 euOJ4E/mSS4xGQb0A7dexFuL/jsZ68wzOcRZoVR3aYgASAt1jd/X2FvfkWO49zlFlTeE
 Zy8W7Cums0LOzHTB0KrGKHP2jsRY36fD+Zj+gocBrLXwGPlD2myiTlVkI6pLAQCo230J
 pE3w==
MIME-Version: 1.0
References: <87v8grlzu9.fsf@linaro.org>
In-Reply-To: <87v8grlzu9.fsf@linaro.org>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Wed, 17 May 2023 12:26:18 -0400
Message-ID: <CAJSP0QX+NeJ8Z5d+2ocUUVj4EGopxKT+trmEfacgvhE7TqCokQ@mail.gmail.com>
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
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs@redhat.com, Erik Schilling <erik.schilling@linaro.org>, Vivek Goyal <vgoyal@redhat.com>

On Wed, 17 May 2023 at 11:54, Alex Benn=C3=A9e <alex.bennee@linaro.org> wro=
te:
Hi Alex,
There were two unresolved issues:

1. How to inject SIGBUS when the guest accesses a page that's beyond
the end-of-file.
2. Implementing the vhost-user messages for mapping ranges of files to
the vhost-user frontend.

The harder problem is SIGBUS. An mmap area may be larger than the
length of the file. Or another process could truncate the file while
it's mmapped, causing a previously correctly sized mmap to become
longer than the actual file. When a page beyond the end of file is
accessed, the kernel raises SIGBUS.

When this scenario occurs in the DAX Window, kvm.ko gets some type of
vmexit (fault) and the code currently enters an infinite loop because
it expects KVM memory regions to resolve faults. Since there is no
page backing that part of the vma, the fault handling fails and the
code loops trying to do this forever.

There needs to be a way to inject this fault back into the guest.
However, we did not found a way to do that. We considered Machine
Check Exceptions (MCEs), x86 interrupts, and paravirtualized
approaches. None of them looked like a clean and sane way to do this.
The Linux maintainers for MCEs and kvm.ko were not excited about
supporting this.

So in the end, SIGBUS was never solved. It leads to a DoS because the
host kernel will enter an infinite loop. We decided that until there
is progress on SIGBUS, we can't go ahead with DAX Windows in
production.

The easier problem is adding new vhost-user messages. It does lead to
a fundamental change in the vhost-user protocol: the presence of the
DAX Window means there are memory ranges that cannot be accessed via
shared memory. Imagine Device A has a DAX Window and Device B needs to
DMA to/from it. That doesn't work because the mmaps happen inside the
frontend (QEMU), so Device B doesn't have access to the current
mappings. The fundamental change to vhost-user is that virtqueue
descriptor mapping code must now deal with the situation where guest
addresses are absent from the shared memory regions and instead send
vhost-user protocol messages to read/write to/from bounce buffers
instead. The rest of the device backend does not require modification.
This is a slow path, but at least it works whereas currently the I/O
would fail because the memory is absent. Other solutions to the
vhost-user DMA problem exist, but this is the one that Dave and I last
discussed.

In the end, there is still work to do to make the DAX Window
supportable. There is experimental code out there that kind of works,
but we felt it was incomplete.

To your specific questions:

>  * What VMM/daemon combinations has DAX been tested on?

Only the experimental virtio-fs Kata Containers kernels and QEMU
builds that were available a few years ago. I don't think the code has
been rebased.

>  * Isn't it time the vhost-user spec is updated?

I don't know if Dave ever wrote the spec for or implemented the final
version of the vhost-user protocol messages we discussed.

>  * Is anyone picking up Dave's patches for the QEMU side of support?

Not at the moment. It would be nice to support, but someone needs the
energy/time/focus to deal with the outstanding issues I mentioned.

If you want to work on it, feel free to include me. I can help dig up
old discussions and give input.

Stefan

