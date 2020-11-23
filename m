From: "Venegas Munoz, Jose Carlos" <jose.carlos.venegas.munoz@intel.com>
Date: Mon, 23 Nov 2020 15:07:46 +0000
Message-ID: <BAA622CA-4535-4577-B16F-66C8BE74E574@intel.com>
References: <20201105194416.GA1384085@redhat.com>
	<20201105195253.GB1384085@redhat.com>
	<D9233684-9B76-468E-A5F1-B35DA3F3C091@intel.com>
	<20201106223524.GG1436035@redhat.com>
	<CAOssrKcJr9a_5EUTU19BTp1UaST64Shh9w0UeR6TXPLqkN7bBw@mail.gmail.com>
	<C5CAD300-DB1D-4C6A-A2D3-2E6BA9F901DF@intel.com>
	<20201117222450.GC91497@redhat.com>
In-Reply-To: <20201117222450.GC91497@redhat.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <E1D9DF7FD306CE4CB97CFFC47142CD61@intel.com>
Content-Transfer-Encoding: 8bit
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, "Shinde,
	Archana M" <archana.m.shinde@intel.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, Miklos Szeredi <miklos@szeredi.hu>

Cool, thanks I will bring some results this week.

﻿On 17/11/20 16:24, "Vivek Goyal" <vgoyal@redhat.com> wrote:

    On Tue, Nov 17, 2020 at 04:00:09PM +0000, Venegas Munoz, Jose Carlos wrote:
    > >   Not sure what the default is for 9p, but comparing
    > >   default to default will definitely not be apples to apples since this
    > >   mode is nonexistent in 9p.
    > 
    > In Kata we are looking for the best config for fs compatibility and performance. So even if are no apples to apples,
    > we are for the best config for both and comparing the best that each of them can do.

    Can we run tests in more than one configuration. Right now you are using
    cache=mmap for virtio-9p and cache=auto for virtiofs and as Miklos
    said this is not apples to apples comparison.

    So you can continue to run above but also run additional tests if
    time permits.

    virtio-9p	virtio-fs

    cache=mmap	cache=none + DAX
    cache=none	cache=none
    cache=loose	cache=always

    Given you are using cache=mmap for virtio-9p, "cache=none + DAX" is
    somewhat equivalent of that. Provides strong coherency as well as
    allow for mmap() to work.

    Now kernel virtiofs DAX support got merged in 5.10-rc1. For qemu,
    you can use virtio-fs-dev branch.

    https://gitlab.com/virtio-fs/qemu/-/commits/virtio-fs-dev

    Thanks
    Vivek



