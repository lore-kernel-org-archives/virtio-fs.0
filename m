Date: Fri, 3 Sep 2021 11:43:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YTJCjGH0V5yzMnQB@redhat.com>
References: <20210902152228.665959-1-vgoyal@redhat.com>
	<YTDyE9wVQQBxS77r@redhat.com>
	<CAHc6FU4ytU5eo4bmJcL6MW+qJZAtYTX0=wTZnv4myhDBv-qZHQ@mail.gmail.com>
	<CAHc6FU5quZWQtZ3fRfM_ZseUsweEbJA0aAkZvQEF5u9MJhrqdQ@mail.gmail.com>
	<CAPL3RVH9MDoDAdiZ-nm3a4BgmRyZJUc_PV_MpsEWiuh6QPi+pA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPL3RVH9MDoDAdiZ-nm3a4BgmRyZJUc_PV_MpsEWiuh6QPi+pA@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 3/1] xfstests: generic/062: Do not run on
	newer kernels
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Bruce Fields <bfields@redhat.com>
Cc: Giuseppe Scrivano <gscrivan@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, selinux@vger.kernel.org, stephen.smalley.work@gmail.com, Dave Chinner <david@fromorbit.com>, LKML <linux-kernel@vger.kernel.org>, fstests <fstests@vger.kernel.org>, virtio-fs@redhat.com, Casey Schaufler <casey.schaufler@intel.com>, LSM <linux-security-module@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>

On Fri, Sep 03, 2021 at 10:42:34AM -0400, Bruce Fields wrote:
> Well, we could also look at supporting trusted.* xattrs over NFS.  I
> don't know much about them, but it looks like it wouldn't be a lot of
> work to specify, especially now that we've already got user xattrs?
> We'd just write a new internet draft that refers to the existing
> user.* xattr draft for most of the details.

Will be nice if we can support trusted.* xattrs on NFS.

Vivek

> 
> --b.
> 
> On Fri, Sep 3, 2021 at 2:56 AM Andreas Gruenbacher <agruenba@redhat.com> wrote:
> >
> > On Fri, Sep 3, 2021 at 8:31 AM Andreas Gruenbacher <agruenba@redhat.com> wrote:
> > > On Thu, Sep 2, 2021 at 5:47 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > xfstests: generic/062: Do not run on newer kernels
> > > >
> > > > This test has been written with assumption that setting user.* xattrs will
> > > > fail on symlink and special files. When newer kernels support setting
> > > > user.* xattrs on symlink and special files, this test starts failing.
> > >
> > > It's actually a good thing that this test case triggers for the kernel
> > > change you're proposing; that change should never be merged. The
> > > user.* namespace is meant for data with the same access permissions as
> > > the file data, and it has been for many years. We may have
> > > applications that assume the existing behavior. In addition, this
> > > change would create backwards compatibility problems for things like
> > > backups.
> > >
> > > I'm not convinced that what you're actually proposing (mapping
> > > security.selinux to a different attribute name) actually makes sense,
> > > but that's a question for the selinux folks to decide. Mapping it to a
> > > user.* attribute is definitely wrong though. The modified behavior
> > > would affect anybody, not only users of selinux and/or virtiofs. If
> > > mapping attribute names is actually the right approach, then you need
> > > to look at trusted.* xattrs, which exist specifically for this kind of
> > > purpose. You've noted that trusted.* xattrs aren't supported over nfs.
> > > That's unfortunate, but not an acceptable excuse for messing up user.*
> > > xattrs.
> >
> > Another possibility would be to make selinux use a different
> > security.* attribute for this nested selinux case. That way, the
> > "host" selinux would retain some control over the labels the "guest"
> > uses.
> >
> > Thanks,
> > Andreas
> >
> 

