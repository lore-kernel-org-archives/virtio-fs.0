Date: Fri, 9 Apr 2021 09:41:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210409134158.GD1111800@redhat.com>
References: <CABpfLih7gTh8a=SYtFT4hGo03K3cnCmAK-+FUXC8X9MhLBwfzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABpfLih7gTh8a=SYtFT4hGo03K3cnCmAK-+FUXC8X9MhLBwfzg@mail.gmail.com>
Subject: Re: [Virtio-fs] Compiling virtio-fs/qemu on Mac
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Anthony J Rabbito <hello@anthonyrabbito.com>
Cc: virtio-fs@redhat.com

On Thu, Apr 08, 2021 at 08:36:37PM -0400, Anthony J Rabbito wrote:
> Hi All,
> I'm having some trouble getting virt9p built with Qemu on Darwin. Given
> that virtio-fs is progressing nicely i'm wondering if anyone has had any
> success building for Darwin?
> Looking to build a podman machine with shared directories.
> Thanks,

Hi Anthony, 

I have never tried building qemu/virtiofsd for Darwin.

My understanding is that virtiofsd is supposed to be running on Linux.
It has code which makes assumption about linux specific behavior. So
I doubt it will work correctly on Darwin even if you managed to
compile it.

Vivek

> Anthony Rabbito

> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs

