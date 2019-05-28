Date: Tue, 28 May 2019 17:35:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190528213555.GC6446@redhat.com>
References: <20190522162623.GH2666@work-vm>
	<CACGKRzXxcwRZ+fmiDu7gL16cRf=vT3X-o=w3yYeOCZxZoBXpmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGKRzXxcwRZ+fmiDu7gL16cRf=vT3X-o=w3yYeOCZxZoBXpmg@mail.gmail.com>
Subject: Re: [Virtio-fs] qemu/virtiofsd dev tree
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Tao Peng <bergwolf@hyper.sh>
Cc: virtio-fs@redhat.com

On Fri, May 24, 2019 at 03:39:41PM +0800, Tao Peng wrote:
> On Thu, May 23, 2019 at 12:26 AM Dr. David Alan Gilbert
> <dgilbert@redhat.com> wrote:
> >
> > Hi,
> >   I uploaded: https://gitlab.com/virtio-fs/qemu/commits/virtio-fs-dev
> > which has:
> >
> >    * Fixes from Alibaba, Intel, Red Hat
> >    * Stefan's security doc
> >    * support for direct-io from virtiofs to virtiofs (e.g.
> >      reading a virtiofs file into an mmap'd viritofs dax file)
> >      - I've just finished this and it's lightly tested, so feedback
> >      welcome
> >    * Rebase on bleeding edge qemu.
> >
> > Let me know how it goes.
> Thanks Dave! Is there a dev branch for the kernel part that we can
> collaborate on?

Hi Tao,

For now use this one.

https://github.com/rhvgoyal/linux/tree/virtio-fs-dev-5.1

Thanks
Vivek

