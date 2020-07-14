Date: Tue, 14 Jul 2020 08:33:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200714123307.GA324688@redhat.com>
References: <20200416164907.244868-1-stefanha@redhat.com>
	<20200618190816.GD3814@redhat.com> <20200618191655.GI2769@work-vm>
	<20200618192717.GE3814@redhat.com>
	<CAJFHJrrJzPLatNvw2xC3WYLbzCW0+DB+4UczQHGPBF9p+WGYQA@mail.gmail.com>
	<20200619191540.GI3154@redhat.com>
	<CAJFHJroGNbfO-tXqrod_snCHcnN4NKjX8t9LTeroyiNEwjtVcQ@mail.gmail.com>
	<20200625125508.GB149340@redhat.com>
	<CAJFHJrpwvEMa_OkxRg3XHXp+=Wuzwwc8shhCZd3xDsmVVJG7aw@mail.gmail.com>
	<fa2f133f-ac79-7205-ad86-facf4f979e56@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <fa2f133f-ac79-7205-ad86-facf4f979e56@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: drop Linux capabilities(7)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Daniel Walsh <dwalsh@redhat.com>
Cc: virtio-fs@redhat.com

On Mon, Jul 13, 2020 at 05:39:05PM -0400, Daniel Walsh wrote:

[..]
> >> Otherwise we either have to disable selinux on host (if we want to
> >> support it in guest) or somehow guest and how policies will have
> >> to know about each other and be able to work together (which will
> >> be hard for a generic use case).
> > Yes, I agree this is hard to do for a generic case but unfortunately
> > the more I understand how selinux works the less I feel that it works
> > well with a passthrough style file system.  As you said it either
> > needs to be turned off on the host or the host and guest need to work
> > together.
>=20
> Correct both kernels need to understand the labels, or one of the
> kernels has to have SELinux disabled.
>=20
> That is the bottom line.=A0 Same issue exists for labeled NFS so I don't
> see this as a problem.

Dan,

So what does labeled NFS do. Server disables SELinux so that it can
be enabled on client?

Thanks
Vivek

