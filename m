Date: Tue, 5 Jan 2021 12:28:06 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20210105122806.GB2945@work-vm>
References: <20210104160013.GG2972@work-vm>
 <87turvsnfm.fsf@vostro.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <87turvsnfm.fsf@vostro.rath.org>
Subject: Re: [Virtio-fs] [fuse-devel] 'FORGET' ordering semantics (vs unlink
	& NFS)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: fuse-devel@lists.sourceforge.net, virtio-fs@redhat.com, mszeredi@redhat.com, vgoyal@redhat.com

* Nikolaus Rath (Nikolaus@rath.org) wrote:
> On Jan 04 2021, "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> > Hi,
> >   On virtio-fs we're hitting a problem with NFS, where
> > unlinking a file in a directory and then rmdir'ing that
> > directory fails complaining about the directory not being empty.
> >
> > The problem here is that if a file has an open fd, NFS doesn't
> > actually delete the file on unlink, it just renames it to
> > a hidden file (e.g. .nfs*******).  That open file is there because
> > the 'FORGET' hasn't completed yet by the time the rmdir is issued.
>=20
>=20
> Are you really talking about FORGET and file descriptors here? I always
> assumed that the kernel will only drop dentries (aka emit FORGET) when
> all fds are closed and never saw otherwise in practice.
>=20
> Do you mean RELEASE rather than FORGET, or dentry rather than file descri=
ptor?

<reads code again> I still think I mean FORGET, and deamons fd.

In the (passthrough_ll) daemon we have two fd's; if I've got this right
then RELEASE closes fi->fh (i.e. a normal fd) where as FORGET
will close inode->fd which is the O_PATH fd.

If the user was to do:

    1 touch a/x
    2 rm a/x
    3 rmdir a/x

They would close(2) the fd at the end of the touch; so I think that
would cause us to see the RELEASE - but we don't see the FORGET yet.
Only after the 'rm' when a/x shouldn't exist any more; then I think we
can get a FORGET and close our inode->fd

Dave

> Best,
> -Nikolaus
>=20
> --=20
> GPG Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F
>=20
>              =BBTime flies like an arrow, fruit flies like a Banana.=AB
>=20
--=20
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

