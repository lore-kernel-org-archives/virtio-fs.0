MIME-Version: 1.0
References: <20200210160639.GA411895@stefanha-x1.localdomain>
	<bbcbd9a0-a036-1c1e-ed66-ac2aaca454a5@redhat.com>
In-Reply-To: <bbcbd9a0-a036-1c1e-ed66-ac2aaca454a5@redhat.com>
From: Ondrej Mosnacek <omosnace@redhat.com>
Date: Wed, 19 Feb 2020 17:11:21 +0100
Message-ID: <CAFqZXNsL4nC4N2XKgMmTNJGCayJ1E=ppiKCBhv2yFCt39dLWqg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [selinux-internal] SELinux support in virtio-fs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Daniel Walsh <dwalsh@redhat.com>
Cc: virtio-fs@redhat.com, SElinux list <selinux@vger.kernel.org>

On Wed, Feb 12, 2020 at 4:29 PM Daniel Walsh <dwalsh@redhat.com> wrote:
> On 2/10/20 11:06 AM, Stefan Hajnoczi wrote:
> > Hi Dan,
> > I've CCed the public virtio-fs mailing list because SELinux support in
> > virtio-fs has been asked about recently.
> >
> > It's time to figure out what level of SELinux support will be available
> > in virtio-fs.  The file system client shares most of its code with FUSE
> > and SELinux labels on files are currently not supported in FUSE.
> >
> > It would be possible to pass through extended attributes to the
> > virtiofsd daemon running on the host.  However, passing through xattrs
> > allows the client to relabel files on the host file system and this
> > could pose a security problem.  virtiofsd already allows the client to
> > set the uid/gid and permissions, but is passing through SELinux xattrs a
> > bad idea?
> >
> > virtiofsd is in a position to mangle extended attribute names
> > ("security.selinux" -> "virtiofs.security.selinux") in order to separate
> > guest SELinux labels from host SELinux labels.
> >
> > As someone who knows very little about SELinux I'm eager to hear what
> > you think would be a good approach.  Secure containers (e.g. Kata
> > Containers) are an important use case but virtio-fs can also be used as
> > the root file system for a guest (a scenario where full SELinux support
> > is needed).
> >
> > Thanks,
> > Stefan
>
> I am traveling right now.  We should add in the SELinux team, and I will
> be able to look at this on Friday.

Cc'ing the upstream SELinux mailing list for more insight. Here is a
public archive of the full thread:

https://www.redhat.com/archives/virtio-fs/2020-February/msg00005.html

-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.


