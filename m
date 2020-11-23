From: "Venegas Munoz, Jose Carlos" <jose.carlos.venegas.munoz@intel.com>
Date: Mon, 23 Nov 2020 15:06:27 +0000
Message-ID: <2BBB73D4-5C09-4DA1-B491-22A5134819FA@intel.com>
References: <20201105194416.GA1384085@redhat.com>
	<20201105195253.GB1384085@redhat.com>
	<D9233684-9B76-468E-A5F1-B35DA3F3C091@intel.com>
	<20201106223524.GG1436035@redhat.com>
	<CAOssrKcJr9a_5EUTU19BTp1UaST64Shh9w0UeR6TXPLqkN7bBw@mail.gmail.com>
	<C5CAD300-DB1D-4C6A-A2D3-2E6BA9F901DF@intel.com>
	<20201117185540.GB91497@redhat.com>
In-Reply-To: <20201117185540.GB91497@redhat.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD26DC93E1B7C2458AF6AC81B0C0D975@intel.com>
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

For all the cases the memory for the guest is 2G.


﻿On 17/11/20 12:55, "Vivek Goyal" <vgoyal@redhat.com> wrote:

    On Tue, Nov 17, 2020 at 04:00:09PM +0000, Venegas Munoz, Jose Carlos wrote:
    > >   Not sure what the default is for 9p, but comparing
    > >   default to default will definitely not be apples to apples since this
    > >   mode is nonexistent in 9p.
    > 
    > In Kata we are looking for the best config for fs compatibility and performance. So even if are no apples to apples,
    > we are for the best config for both and comparing the best that each of them can do.
    > 
    > In the case of Kata for 9pfs(this is the config we have found has better performance and fs compatibility  in general) we have:
    > ```
    > -device virtio-9p-pci # device type
    > ,disable-modern=false 
    > ,fsdev=extra-9p-kataShared # attr: device id  for fsdev
    > ,mount_tag=kataShared  # attr: tag on how will be found de sharedfs 
    > ,romfile= 
    > -fsdev local  #local: Simply lets QEMU call the individual VFS functions (more or less) directly on host.
    > ,id=extra-9p-kataShared 
    > ,path=${SHARED_PATH} # attrs: path to share
    > ,security_model=none #    
    > #    passthrough: Files are stored using the same credentials as they are created on the guest. This requires QEMU to run as # root.
    > #    none: Same as "passthrough" except the sever won't report failures if it fails to set file attributes like ownership # 
    > #  (chown). This makes a passthrough like security model usable for people who run kvm as non root.
    > ,multidevs=remap
    > ```
    > 
    > The mount options are:
    > ```
    > trans=virtio 
    >     ,version=9p2000.L 
    >     ,cache=mmap 
    >     ,"nodev" # Security: The nodev mount option specifies that the filesystem cannot contain special devices. 
    >     ,"msize=8192" # msize: Maximum packet size including any headers.
    > ```

    How much RAM you are giving to these containers when using virtio-9p?

    Vivek



