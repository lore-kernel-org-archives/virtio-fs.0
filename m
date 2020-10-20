MIME-Version: 1.0
References: <20201014180209.49299-1-dgilbert@redhat.com>
	<20201014180209.49299-4-dgilbert@redhat.com>
	<bd3c072f-dc6c-23a8-cd48-543bafa46363@gmail.com>
	<20201020095401.GD140014@stefanha-x1.localdomain>
In-Reply-To: <20201020095401.GD140014@stefanha-x1.localdomain>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Tue, 20 Oct 2020 14:57:20 +0200
Message-ID: <CAOssrKfbOF7UgkWDZ6t8mmPLt8Vr+4aPpMFpZvV_bYznThZPZg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] Puzzle about rootflags,
	restorecon "operation not supported"
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Tue, Oct 20, 2020 at 11:54 AM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Thu, Oct 15, 2020 at 06:57:09PM -0500, Harry G. Coin wrote:
> > The 'mainline generic' version of the latest kernel fails to parse
> > 'fuse' virtiofs options on root kernel boots.  Not only dax, but all the
> > 'fuse' usual ones as well.  (None of
> > default_permissions,allow_other,user_id=0 etc are accepted).
> >
> > Is that what you expected of the mainline kernel?  I learned of this
> > when trying to understand this further problem:
> >
> > SELinux's 'restorecon' and other attempts to change security attributes
> > then fails with "operation not supported".
> >
> > I could only get sshd able to accept connections by changing SELinux to
> > permissive.  The commands necessary to change the security attributes
> > failed with the 'operation not supported' issue.
> >
> > Ideas?
>
> Hi Harry,
> FUSE mount options were removed from virtiofs at one point. I think this
> is expected. The reason is because the options you listed are the
> default for virtiofs and don't need to be specified explicitly.
>
> I have CCed Miklos in case things have changed or I missed something.

Removing the fuse mount options is expected.  Removing the selinux
option is probably a bug.

With the DAX patches the option parsing was restored.  Was the selinux
option parsing also restored?

Thanks,
Miklos


>
> Stefan

