Return-Path: <vgoyal@redhat.com>
Date: Mon, 9 Oct 2023 16:21:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <ZSRg2uiBNmY4mKHr@redhat.com>
References: <20231005203030.223489-1-vgoyal@redhat.com>
 <CAJfpegspVnkXAa5xfvjEQ9r5__vXpcgR4qubdG8=p=aiS2goRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegspVnkXAa5xfvjEQ9r5__vXpcgR4qubdG8=p=aiS2goRg@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofs: Export filesystem tags through
 sysfs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, mzxreary@0pointer.de, stefanha@redhat.com

On Mon, Oct 09, 2023 at 11:53:42AM +0200, Miklos Szeredi wrote:
> On Thu, 5 Oct 2023 at 22:30, Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > virtiofs filesystem is mounted using a "tag" which is exported by the
> > virtiofs device. virtiofs driver knows about all the available tags but
> > these are not exported to user space.
> >
> > People have asked these tags to be exported to user space. Most recently
> > Lennart Poettering has asked for it as he wants to scan the tags and mount
> > virtiofs automatically in certain cases.
> >
> > https://gitlab.com/virtio-fs/virtiofsd/-/issues/128
> >
> > This patch exports tags through sysfs. One tag is associated with each
> > virtiofs device. A new "tag" file appears under virtiofs device dir.
> > Actual filesystem tag can be obtained by reading this "tag" file.
> >
> > For example, if a virtiofs device exports tag "myfs", a new file "tag"
> > will show up here.
> >
> > /sys/bus/virtio/devices/virtio<N>/tag
> >
> > # cat /sys/bus/virtio/devices/virtio<N>/tag
> > myfs
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> Hi Vivek,
> 
> This needs something under Documentation/.

Hi Miklos,

Hmm.., I can easily update the virtiofs documentation.

Initially I was thinking to put something in Documentation/ABI/testing/
as well. But I don't see any virtio related. In fact can't find any
files related to "virtio" at all.

So I will just update the Documentation/filesystems/virtiofs.rst for now.

> 
> While the interface looks good to me, I think we need an ack on that
> from the virtio maintainer.

I am assuming Stefan should be able to provide an ACK. But I will also
add Michael and Paolo in the V2 of the patch and hoping we should be
able to get atleast 1 ACK.

Thanks
Vivek
