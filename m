MIME-Version: 1.0
References: <20210902152228.665959-1-vgoyal@redhat.com>
	<YTDyE9wVQQBxS77r@redhat.com>
In-Reply-To: <YTDyE9wVQQBxS77r@redhat.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 3 Sep 2021 08:31:03 +0200
Message-ID: <CAHc6FU4ytU5eo4bmJcL6MW+qJZAtYTX0=wTZnv4myhDBv-qZHQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: gscrivan@redhat.com, Theodore Ts'o <tytso@mit.edu>, Miklos Szeredi <miklos@szeredi.hu>, selinux@vger.kernel.org, stephen.smalley.work@gmail.com, Dave Chinner <david@fromorbit.com>, LKML <linux-kernel@vger.kernel.org>, fstests <fstests@vger.kernel.org>, virtio-fs@redhat.com, casey.schaufler@intel.com, LSM <linux-security-module@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Fields,
	Bruce" <bfields@redhat.com>, christian.brauner@ubuntu.com

On Thu, Sep 2, 2021 at 5:47 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> xfstests: generic/062: Do not run on newer kernels
>
> This test has been written with assumption that setting user.* xattrs will
> fail on symlink and special files. When newer kernels support setting
> user.* xattrs on symlink and special files, this test starts failing.

It's actually a good thing that this test case triggers for the kernel
change you're proposing; that change should never be merged. The
user.* namespace is meant for data with the same access permissions as
the file data, and it has been for many years. We may have
applications that assume the existing behavior. In addition, this
change would create backwards compatibility problems for things like
backups.

I'm not convinced that what you're actually proposing (mapping
security.selinux to a different attribute name) actually makes sense,
but that's a question for the selinux folks to decide. Mapping it to a
user.* attribute is definitely wrong though. The modified behavior
would affect anybody, not only users of selinux and/or virtiofs. If
mapping attribute names is actually the right approach, then you need
to look at trusted.* xattrs, which exist specifically for this kind of
purpose. You've noted that trusted.* xattrs aren't supported over nfs.
That's unfortunate, but not an acceptable excuse for messing up user.*
xattrs.

Thanks,
Andreas

