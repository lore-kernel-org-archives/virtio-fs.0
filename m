Date: Fri, 19 Jun 2020 10:29:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200619142911.GC3154@redhat.com>
References: <20200416164907.244868-1-stefanha@redhat.com>
	<20200618190816.GD3814@redhat.com>
	<CAJfpegsfqADmK6foDyuQQnvMDh_jE0rNUCBRuxPchSSirrb04Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsfqADmK6foDyuQQnvMDh_jE0rNUCBRuxPchSSirrb04Q@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: drop Linux capabilities(7)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

On Fri, Jun 19, 2020 at 04:16:30PM +0200, Miklos Szeredi wrote:
> On Thu, Jun 18, 2020 at 9:08 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Thu, Apr 16, 2020 at 05:49:05PM +0100, Stefan Hajnoczi wrote:
> > > virtiofsd doesn't need of all Linux capabilities(7) available to root.  Keep a
> > > whitelisted set of capabilities that we require.  This improves security in
> > > case virtiofsd is compromised by making it hard for an attacker to gain further
> > > access to the system.
> >
> > Hi Stefan,
> >
> > I just noticed that this patch set breaks overlayfs on top of virtiofs.
> 
> How so?  Virtiofs isn't mounting overlayfs, is it?  Only the mounter
> requires CAP_SYS_ADMIN, not the accessor.

Are you thinking of virtiofs on top of overlayfs? I was referring to
mounting overlayfs on top of virtiofs inside VM.

Thanks
Vivek

