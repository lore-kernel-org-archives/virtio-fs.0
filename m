Date: Thu, 11 Jun 2020 20:11:54 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200611191154.GI2968@work-vm>
References: <CALjEBWTnYLtVfJV_KnEv6oqdcWhU-dzoR_pB+C84u798oAw1Vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALjEBWTnYLtVfJV_KnEv6oqdcWhU-dzoR_pB+C84u798oAw1Vw@mail.gmail.com>
Subject: Re: [Virtio-fs] Getting help setting up virtiofs guest
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: David Lomas <dl3@pale-eds.co.uk>
Cc: virtio-fs@redhat.com

* David Lomas (dl3@pale-eds.co.uk) wrote:
> Apologies if this isn't the correct place for this kind or request.

It's the right place to ask.

> I've been following these instructions to set up host and guest:
> https://virtio-fs.gitlab.io/howto-qemu.html and
> https://libvirt.org/kbase/virtiofs.html
> 
> On the host, I've built the latest version of libvirt (6.4.0) and qemu
> (5.0.0), and added sections to the domain definition. All appears well (no
> errors at least). This is the relevant section:
> 
>     <filesystem type='mount' accessmode='passthrough'>
>       <driver type='virtiofs'/>
>       <binary path='/usr/libexec/virtiofsd'/>
>       <source dir='/fast_data/test'/>
>       <target dir='test'/>
>       <address type='pci' domain='0x0000' bus='0x00' slot='0x06'
> function='0x0'/>
>     </filesystem>

I think that's OK.

> On the guest, I've build the kernel (4.19.28), booted it, and confirmed
> virtio_fs.ko is a built-in module.

Where did you get that kernel?  It sounds rather old;  the main part of
virtiofs is now in the upstream kernel; so if your distro has a recent
5.x kernel, you can just use it.

> But on running mount -t virtio_fs test /mnt/test/ I get the following error:
> 
> mount: /mnt/test: wrong fs type, bad option, bad superblock on qube-server,
> missing codepage or helper program, or other error.
> 
> Note both those web pages above suggest using mount -t virtiofs, but that
> gives unknown filesystem type 'virtiofs'

It changed in the newer kernels to the 'virtiofs'.

> I'm at a loss to find more detailed information on how to configure
> this—are there other resources online, or can anyone suggest what to try
> next?

I suspect you're suffering from the older kernel here.  Try a nice
shiny new one.

Dave

> Thanks!

> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

