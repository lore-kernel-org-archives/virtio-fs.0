DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=cj9aU3bU6Mlez1/jNuR19+XJKdPcL+MH8EXhEAlY4Uo=;
	b=lol22UeLwiMXamApuDJFhU2xmyUymt91OXHzV2LUp33ZXuJpYQgpx6XtX1QJ6WmtCC
	OZYJnZAuJI/irOUzVyzDgJlNyZ7+w+mSX4A3mORO2OG2i9eJqfgqx8LAU5/d0gfnjsHV
	iVMnqrg5+zRNArjxud2hqEv5d2S6/ypVev6HY=
MIME-Version: 1.0
References: <c4cb4b41655bc890b9dbf40bd2c133cbcbef734d.camel@redhat.com>
	<89f0dbf6713ebd44ec519425e3a947e71f7aed55.camel@redhat.com>
	<CAJfpegv4jLewQ4G_GdxraTE8fGHy7-d52gPSi4ZAOp0N4aYJnw@mail.gmail.com>
	<77529e99ca9c2d228a67dd8d789d83afdcd1ace3.camel@redhat.com>
In-Reply-To: <77529e99ca9c2d228a67dd8d789d83afdcd1ace3.camel@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 6 Nov 2020 10:29:28 +0100
Message-ID: <CAJfpegsuYAW+W7xN3QGdfzEHROdMhVOJS5K=u8JQe-_WaY8VsA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] WARN_ON(fuse_insert_writeback(root,
	wpa)) in tree_insert()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Qian Cai <cai@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org

On Mon, Nov 2, 2020 at 3:26 PM Qian Cai <cai@redhat.com> wrote:
>
> On Thu, 2020-10-29 at 16:20 +0100, Miklos Szeredi wrote:
> > On Thu, Oct 29, 2020 at 4:02 PM Qian Cai <cai@redhat.com> wrote:
> > > On Wed, 2020-10-07 at 16:08 -0400, Qian Cai wrote:
> > > > Running some fuzzing by a unprivileged user on virtiofs could trigger the
> > > > warning below. The warning was introduced not long ago by the commit
> > > > c146024ec44c ("fuse: fix warning in tree_insert() and clean up writepage
> > > > insertion").
> > > >
> > > > From the logs, the last piece of the fuzzing code is:
> > > >
> > > > fgetxattr(fd=426, name=0x7f39a69af000, value=0x7f39a8abf000, size=1)
> > >
> > > I can still reproduce it on today's linux-next. Any idea on how to debug it
> > > further?
> >
> > Can you please try the attached patch?
>
> It has survived the testing over the weekend. There is a issue that virtiofsd
> hung, but it looks like a separate issue.

Thanks very much for the testing.   Queued up the patch.

Miklos

