DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=/wUc2OfdjdbqnjL6W8FMiwr8yZ9/oxUaW69sqUYNuKM=;
	b=kNFfY93yyM1OSr4ACCCk1RSsFVhJXWC1MfeZ/3ASEmu5JYM6r+oD/0AT8FYuuOZp3e
	Z8qLnCYtJiNwPTuT0ipSTL6GWLVciFocanwPijZfqyIaD+yTIrGlutD0qmKWNsTosETJ
	ZXWxRR+HfQ9bd2jRuElwI9C5LQ8cDz/1J/fAg=
MIME-Version: 1.0
References: <20200722090758.3221812-1-chirantan@chromium.org>
	<20210614212808.GD869400@redhat.com>
In-Reply-To: <20210614212808.GD869400@redhat.com>
From: Chirantan Ekbote <chirantan@chromium.org>
Date: Tue, 15 Jun 2021 18:35:21 +0900
Message-ID: <CAJFHJrpu9vewcD2er6oB_xwtF4Pc-njkRaA7rfJwsTvw5Fi2og@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [RESEND] [PATCHv4 1/2] uapi: fuse: Add
	FUSE_SECURITY_CTX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel <fuse-devel@lists.sourceforge.net>, Stephen Smalley <stephen.smalley.work@gmail.com>, Suleiman Souhlal <suleiman@chromium.org>, virtio-fs-list <virtio-fs@redhat.com>, SElinux list <selinux@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Dylan Reid <dgreid@chromium.org>

Hi Vivek,

On Tue, Jun 15, 2021 at 6:28 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, Jul 22, 2020 at 06:07:57PM +0900, Chirantan Ekbote wrote:
> > Add the FUSE_SECURITY_CTX flag for the `flags` field of the
> > fuse_init_out struct.  When this flag is set the kernel will append the
> > security context for a newly created inode to the request (create,
> > mkdir, mknod, and symlink).  The server is responsible for ensuring that
> > the inode appears atomically with the requested security context.
> >
> > For example, if the server is backed by a "real" linux file system then
> > it can write the security context value to
> > /proc/thread-self/attr/fscreate before making the syscall to create the
> > inode.
> >
> > Signed-off-by: Chirantan Ekbote <chirantan@chromium.org>
>
> Hi Chirantan,
>
> I am wondering what's the status of this work now. Looks like it
> was not merged.
>
> We also need the capability to set selinux security xattrs on newly
> created files in virtiofs.
>
> Will you be interested in reviving this work and send patches again
> and copy the selinux as well as linux security module list
> (linux-security-module@vger.kernel.org) as suggested by casey.
>

Not really.  We have our own local solution for this (see below) so if
you or someone else wants to pick it up, please go ahead.

> How are you managing in the meantime. Carrying patches in your own
> kernel?
>

Kind of. This patch series changes the protocol and the feature bit we
were using was claimed by FUSE_SUBMOUNTS instead so carrying it
locally is not really viable long term.  Instead we're carrying a
patch similar to the original RFC patch that doesn't change the
protocol [1].

Chirantan

[1]: https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/2581172

