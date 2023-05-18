Return-Path: <vgoyal@redhat.com>
Date: Thu, 18 May 2023 15:45:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <ZGaAalXSMhPb3eqe@redhat.com>
References: <87v8grlzu9.fsf@linaro.org>
 <CAJSP0QX+NeJ8Z5d+2ocUUVj4EGopxKT+trmEfacgvhE7TqCokQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJSP0QX+NeJ8Z5d+2ocUUVj4EGopxKT+trmEfacgvhE7TqCokQ@mail.gmail.com>
Subject: Re: [Virtio-fs] Status of DAX for virtio-fs/virtiofsd?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, QEMU Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs@redhat.com, Erik Schilling <erik.schilling@linaro.org>

On Wed, May 17, 2023 at 12:26:18PM -0400, Stefan Hajnoczi wrote:
> On Wed, 17 May 2023 at 11:54, Alex Benn=E9e <alex.bennee@linaro.org> wrot=
e:
> Hi Alex,
> There were two unresolved issues:
>=20
> 1. How to inject SIGBUS when the guest accesses a page that's beyond
> the end-of-file.
> 2. Implementing the vhost-user messages for mapping ranges of files to
> the vhost-user frontend.
>=20
> The harder problem is SIGBUS. An mmap area may be larger than the
> length of the file. Or another process could truncate the file while
> it's mmapped, causing a previously correctly sized mmap to become
> longer than the actual file. When a page beyond the end of file is
> accessed, the kernel raises SIGBUS.
>=20
> When this scenario occurs in the DAX Window, kvm.ko gets some type of
> vmexit (fault) and the code currently enters an infinite loop because
> it expects KVM memory regions to resolve faults. Since there is no
> page backing that part of the vma, the fault handling fails and the
> code loops trying to do this forever.
>=20
> There needs to be a way to inject this fault back into the guest.
> However, we did not found a way to do that. We considered Machine
> Check Exceptions (MCEs), x86 interrupts, and paravirtualized
> approaches. None of them looked like a clean and sane way to do this.
> The Linux maintainers for MCEs and kvm.ko were not excited about
> supporting this.
>=20
> So in the end, SIGBUS was never solved. It leads to a DoS because the
> host kernel will enter an infinite loop. We decided that until there
> is progress on SIGBUS, we can't go ahead with DAX Windows in
> production.
>=20
> The easier problem is adding new vhost-user messages. It does lead to
> a fundamental change in the vhost-user protocol: the presence of the
> DAX Window means there are memory ranges that cannot be accessed via
> shared memory. Imagine Device A has a DAX Window and Device B needs to
> DMA to/from it. That doesn't work because the mmaps happen inside the
> frontend (QEMU), so Device B doesn't have access to the current
> mappings. The fundamental change to vhost-user is that virtqueue
> descriptor mapping code must now deal with the situation where guest
> addresses are absent from the shared memory regions and instead send
> vhost-user protocol messages to read/write to/from bounce buffers
> instead. The rest of the device backend does not require modification.
> This is a slow path, but at least it works whereas currently the I/O
> would fail because the memory is absent. Other solutions to the
> vhost-user DMA problem exist, but this is the one that Dave and I last
> discussed.
>=20
> In the end, there is still work to do to make the DAX Window
> supportable. There is experimental code out there that kind of works,
> but we felt it was incomplete.

I feel that it will be good if someone can solve the vhost-user problem
first and get patches upstream. Now virtiofsd support from qemu has
been removed, so someone will have to add DAX support to rust virtiofsd.
(And make correspoding vhost-user changes in qemu).

Once that is done, someone can look into MCE issue.

With vhost-user problem solved, DAX will be usable in non-shared mode.
That is just pass through host filesystem into the guest and even host
can't make modifications. And that should steer clear us of the truncation
issue.

virtiofs DAX is a good piece of technology and provides speed up in many
cases. Will be sad to see the patches lost.

Now people are posting fixes to kernel side of DAX and there is no good
way to test these. I will try to make it work with old DAX branch david
had to test kernel changes but I am sure at some point of time it will
stop working and I don't want virtiofs kernel DAX code to become unstable.

Will be good if somebody takes up this project and makes it happen.

Thanks
Vivek

>=20
> To your specific questions:
>=20
> >  * What VMM/daemon combinations has DAX been tested on?
>=20
> Only the experimental virtio-fs Kata Containers kernels and QEMU
> builds that were available a few years ago. I don't think the code has
> been rebased.
>=20
> >  * Isn't it time the vhost-user spec is updated?
>=20
> I don't know if Dave ever wrote the spec for or implemented the final
> version of the vhost-user protocol messages we discussed.
>=20
> >  * Is anyone picking up Dave's patches for the QEMU side of support?
>=20
> Not at the moment. It would be nice to support, but someone needs the
> energy/time/focus to deal with the outstanding issues I mentioned.
>=20
> If you want to work on it, feel free to include me. I can help dig up
> old discussions and give input.
>=20
> Stefan
>=20
