Date: Fri, 14 Feb 2020 20:31:56 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200214203156.GR3283@work-vm>
References: <20200214191753.GC18654@redhat.com> <20200214194437.GQ3283@work-vm>
	<b703d3ec-b48a-776a-a525-4acb16a27ac4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <b703d3ec-b48a-776a-a525-4acb16a27ac4@redhat.com>
Subject: Re: [Virtio-fs] fedora packages for virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Daniel Walsh <dwalsh@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Mrunal Patel <mpatel@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, crobinso@redhat.com

* Daniel Walsh (dwalsh@redhat.com) wrote:
> On 2/14/20 2:44 PM, Dr. David Alan Gilbert wrote:
> > * Vivek Goyal (vgoyal@redhat.com) wrote:
> >> Hi David,
> >>
> >> Are fedora packages for latest qemu with virtiofsd now available. Can =
one
> >> try it?
> >>
> >> Dan Walsh and Mrunal are looking for it (CCed in email).
> >>
> >> Keeping this thread on virtio-fs list as others might be interested as
> >> well.
> > Cole has got it into the virt-preview copr:
> >
> >  https://copr.fedorainfracloud.org/coprs/g/virtmaint-sig/virt-preview
> >
> > Dave
> >
> >> Thanks
> >> Vivek
> > --
> > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>=20
> How soon can we get this into Fedora.=A0 I really do not want to have to
> deal with special packages, that users can not easily get a hold of.=A0 I
> am real apprehensive on giving the go-ahead on a project as being
> Enterprise ready until it gets some soak time in Fedora.=A0 I would love
> to see this available in Fedora 32, so people can start experimenting
> with it.

Understood.
It's upstream in the current QEMU tree, but it's due for release end of
April which is I assume too late for F32.
 (libvirt is still a work in progress).

I'll leave Cole to comment on Fedora backporting.

Dave

--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

