Date: Thu, 24 Sep 2020 18:10:23 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200924221023.GB132653@redhat.com>
References: <20200918213436.GA3520@redhat.com> <20200921153243.GK3221@work-vm>
	<20200922102531.GA2837@work-vm> <20200922174733.GD57620@redhat.com>
	<46D726A6-72F3-40FE-9382-A189513F783D@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D726A6-72F3-40FE-9382-A189513F783D@intel.com>
Subject: [Virtio-fs] virtiofs vs 9p performance(Re: tools/virtiofs: Multi
 threading seems to hurt performance)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Venegas Munoz, Jose Carlos" <jose.carlos.venegas.munoz@intel.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "cdupontd@redhat.com" <cdupontd@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, "Shinde,
	Archana M" <archana.m.shinde@intel.com>

On Thu, Sep 24, 2020 at 09:33:01PM +0000, Venegas Munoz, Jose Carlos wrote:
> Hi Folks,
> 
> Sorry for the delay about how to reproduce `fio` data.
> 
> I have some code to automate testing for multiple kata configs and collect info like:
> - Kata-env, kata configuration.toml, qemu command, virtiofsd command.
> 
> See: 
> https://github.com/jcvenegas/mrunner/
> 
> 
> Last time we agreed to narrow the cases and configs to compare virtiofs and 9pfs
> 
> The configs where the following:
> 
> - qemu + virtiofs(cache=auto, dax=0) a.ka. `kata-qemu-virtiofs` WITOUT xattr
> - qemu + 9pfs a.k.a `kata-qemu`
> 
> Please take a look to the html and raw results I attach in this mail.

Hi Carlos,

So you are running following test.

fio --direct=1 --gtod_reduce=1 --name=test --filename=random_read_write.fio --bs=4k --iodepth=64 --size=4G --readwrite=randrw --rwmixread=75 --output=/output/fio.txt

And following are your results.

9p
--
READ: bw=211MiB/s (222MB/s), 211MiB/s-211MiB/s (222MB/s-222MB/s), io=3070MiB (3219MB), run=14532-14532msec

WRITE: bw=70.6MiB/s (74.0MB/s), 70.6MiB/s-70.6MiB/s (74.0MB/s-74.0MB/s), io=1026MiB (1076MB), run=14532-14532msec

virtiofs
--------
Run status group 0 (all jobs):
   READ: bw=159MiB/s (167MB/s), 159MiB/s-159MiB/s (167MB/s-167MB/s), io=3070MiB (3219MB), run=19321-19321msec
  WRITE: bw=53.1MiB/s (55.7MB/s), 53.1MiB/s-53.1MiB/s (55.7MB/s-55.7MB/s), io=1026MiB (1076MB), run=19321-19321msec

So looks like you are getting better performance with 9p in this case.

Can you apply "shared pool" patch to qemu for virtiofsd and re-run this
test and see if you see any better results.

In my testing, with cache=none, virtiofs performed better than 9p in 
all the fio jobs I was running. For the case of cache=auto  for virtiofs
(with xattr enabled), 9p performed better in certain write workloads. I
have identified root cause of that problem and working on
HANDLE_KILLPRIV_V2 patches to improve WRITE performance of virtiofs
with cache=auto and xattr enabled.

I will post my 9p and virtiofs comparison numbers next week. In the
mean time will be great if you could apply following qemu patch, rebuild
qemu and re-run above test.

https://www.redhat.com/archives/virtio-fs/2020-September/msg00081.html

Also what's the status of file cache on host in both the cases. Are
you booting host fresh for these tests so that cache is cold on host
or cache is warm?

Thanks
Vivek

