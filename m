MIME-Version: 1.0
References: <20201105194416.GA1384085@redhat.com>
	<20201106223524.GG1436035@redhat.com>
	<CAOssrKcJr9a_5EUTU19BTp1UaST64Shh9w0UeR6TXPLqkN7bBw@mail.gmail.com>
	<2033635.TJ2JW7Qltq@silver>
In-Reply-To: <2033635.TJ2JW7Qltq@silver>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Thu, 12 Nov 2020 14:01:31 +0100
Message-ID: <CAOssrKdNVwXsXA_q3UzcN0c7QKt3Bn-V758d8UJp=72cofQvug@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Use --thread-pool-size=0 to mean
 no thread pool
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christian Schoenebeck <qemu_oss@crudebyte.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Venegas Munoz,
	Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, QEMU Developers <qemu-devel@nongnu.org>, Greg Kurz <groug@kaod.org>, virtio-fs-list <virtio-fs@redhat.com>, "Shinde,
	Archana M" <archana.m.shinde@intel.com>, Vivek Goyal <vgoyal@redhat.com>

On Thu, Nov 12, 2020 at 12:34 PM Christian Schoenebeck
<qemu_oss@crudebyte.com> wrote:
>
> On Donnerstag, 12. November 2020 10:06:37 CET Miklos Szeredi wrote:
> >
> > 9p:cache=none  <-> virtiofs:cache=none
> > 9p:cache=loose <-> virtiofs:cache=always
> >
> > "9p:cache=mmap" and "virtiofs:cache=auto" have no match.
>
> What does 'auto' do exactly?

It has a configurable timeout (default is 1s) for the attribute and
lookup cache and close-to-open consistency for data (flush on close,
invalidate on open).  This is similar to, but less refined as NFS.
It's something that could easily be improved if there's a need for it.

Thanks,
Miklos

