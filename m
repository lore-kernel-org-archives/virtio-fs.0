Date: Fri, 19 Feb 2021 11:08:48 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210219160848.GB3270@redhat.com>
References: <20200918213436.GA3520@redhat.com>
	<46D726A6-72F3-40FE-9382-A189513F783D@intel.com>
	<20200924221023.GB132653@redhat.com> <17216624.eqST2d0sUl@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17216624.eqST2d0sUl@silver>
Subject: [Virtio-fs] Can not set high msize with virtio-9p (Was: Re:
 virtiofs vs 9p performance)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christian Schoenebeck <qemu_oss@crudebyte.com>
Cc: "Shinde, Archana M" <archana.m.shinde@intel.com>, "Venegas Munoz,
	Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, qemu-devel@nongnu.org, virtio-fs-list <virtio-fs@redhat.com>, "cdupontd@redhat.com" <cdupontd@redhat.com>

On Fri, Sep 25, 2020 at 10:06:41AM +0200, Christian Schoenebeck wrote:
> On Freitag, 25. September 2020 00:10:23 CEST Vivek Goyal wrote:
> > In my testing, with cache=none, virtiofs performed better than 9p in
> > all the fio jobs I was running. For the case of cache=auto  for virtiofs
> > (with xattr enabled), 9p performed better in certain write workloads. I
> > have identified root cause of that problem and working on
> > HANDLE_KILLPRIV_V2 patches to improve WRITE performance of virtiofs
> > with cache=auto and xattr enabled.
> 
> Please note, when it comes to performance aspects, you should set a reasonable 
> high value for 'msize' on 9p client side:
> https://wiki.qemu.org/Documentation/9psetup#msize

Hi Christian,

I am not able to set msize to a higher value. If I try to specify msize
16MB, and then read back msize from /proc/mounts, it sees to cap it
at 512000. Is that intended?

$ mount -t 9p -o trans=virtio,version=9p2000.L,cache=none,msize=16777216 hostShared /mnt/virtio-9p

$ cat /proc/mounts | grep 9p
hostShared /mnt/virtio-9p 9p rw,sync,dirsync,relatime,access=client,msize=512000,trans=virtio 0 0

I am using 5.11 kernel.

Thanks
Vivek

