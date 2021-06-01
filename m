MIME-Version: 1.0
References: <e1437314-4870-a3a3-e866-8be50282ce3c@gmail.com>
	<20210601130245.GA24846@redhat.com>
In-Reply-To: <20210601130245.GA24846@redhat.com>
From: Ondrej Mosnacek <omosnace@redhat.com>
Date: Tue, 1 Jun 2021 19:33:54 +0200
Message-ID: <CAFqZXNvPuPMccchKkdgh1VWOem8+mN_WAG9hyKZk5YqdhEeSAA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] regression: lsetfilecon fails, breaks rpm, dpkg,
 dnf in virtiofs guests.
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Tue, Jun 1, 2021 at 3:02 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sat, May 29, 2021 at 01:42:50PM -0500, Harry G. Coin wrote:
> > Some regression in virtio-fs has led to rpm/dnf/yum failing  in the same
> > guest it previously worked.
> >
> > linux 5.11.19-300.fc34.x86_64
> >
> > Specifically, all attempts to use dnf/yum lead to examples similar to this:
> >
> > Error unpacking rpm package dnf-4.7.0-1.fc34.noarch
> >   Upgrading        :
> > python3-dnf-plugins-core-4.0.21-1.fc34.noarch
> > 8/20
> > error: unpacking of archive failed on file /usr/bin/dnf;60b1b277: cpio:
> > (error 0x2)
> > error: dnf-4.7.0-1.fc34.noarch: install failed
> > error: lsetfilecon: (/etc/dnf/plugins/copr.conf,
> > system_u:object_r:etc_t:s0) Operation not permitted
> > error: Plugin selinux: hook fsm_file_prepare failed
>
> CCing Dan Walsh and Ondrej. They might have an idea.

I believe this was reported in
https://bugzilla.redhat.com/show_bug.cgi?id=1965786 - I put some
comments there, though I'm not sure yet where the problem lies...

>
> Thanks
> Vivek
>
> >
> > (
> >
> > For all packages.  No updates are possible.  Possibly related to:
> > https://github.com/fedora-selinux/selinux-policy/pull/478/files/21a2df26cd605c55de7edc80e16907fcb76ccf08
> > ?  What really gets me, is this error exists even though
> >
> > # getenforce
> > Permissive
> >
> > )
> >
> > The host is running btrfs.  ... virtiofsd --fd=50 -o
> > source=/vmsystems/fedora_generic,xattr,flock,posix_lock
> >
> > same effect with  .... virtiofsd --fd=36 -o
> > source=/vmsystems/dbl1,xattr,flock,no_posix_lock
> >
> > /etc/fstab:
> >
> > myfs / virtiofs seclabel 0 0
> >
> >
> >
> >
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://listman.redhat.com/mailman/listinfo/virtio-fs
>

-- 
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

