Date: Tue, 29 Sep 2020 09:17:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200929131753.GB220516@redhat.com>
References: <20200918213436.GA3520@redhat.com> <20200921153243.GK3221@work-vm>
	<20200922102531.GA2837@work-vm> <20200922174733.GD57620@redhat.com>
	<46D726A6-72F3-40FE-9382-A189513F783D@intel.com>
	<20200924221023.GB132653@redhat.com>
	<20200925124139.GJ2873@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925124139.GJ2873@work-vm>
Subject: Re: [Virtio-fs] virtiofs vs 9p performance(Re: tools/virtiofs:
 Multi threading seems to hurt performance)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: "Venegas Munoz, Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "cdupontd@redhat.com" <cdupontd@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, "Shinde,
	Archana M" <archana.m.shinde@intel.com>

On Fri, Sep 25, 2020 at 01:41:39PM +0100, Dr. David Alan Gilbert wrote:

[..]
> So I'm sitll beating 9p; the thread-pool-size=1 seems to be great for
> read performance here.
> 

Hi Dave,

I spent some time making changes to virtiofs-tests so that I can test
a mix of random read and random write workload. That testsuite runs
a workload 3 times and reports the average. So I like to use it to
reduce run to run variation effect.

So I ran following to mimic carlos's workload.

$ ./run-fio-test.sh test -direct=1 -c <test-dir> fio-jobs/randrw-psync.job >
testresults.txt

$ ./parse-fio-results.sh testresults.txt

I am using a SSD at the host to back these files. Option "-c" always
creates new files for testing.

Following are my results in various configurations. Used cache=mmap mode
for 9p and cache=auto (and cache=none) modes for virtiofs. Also tested
9p default as well as msize=16m. Tested virtiofs both with exclusive
as well as shared thread pool.

NAME                    WORKLOAD                Bandwidth       IOPS            
9p-mmap-randrw          randrw-psync            42.8mb/14.3mb   10.7k/3666      
9p-mmap-msize16m        randrw-psync            42.8mb/14.3mb   10.7k/3674      
vtfs-auto-ex-randrw     randrw-psync            27.8mb/9547kb   7136/2386       
vtfs-auto-sh-randrw     randrw-psync            43.3mb/14.4mb   10.8k/3709      
vtfs-none-sh-randrw     randrw-psync            54.1mb/18.1mb   13.5k/4649      


- Increasing msize to 16m did not help with performance for this workload.
- virtiofs exclusive thread pool ("ex"), is slower than 9p.
- virtiofs shared thread pool ("sh"), matches the performance of 9p.
- virtiofs cache=none mode is faster than cache=auto mode for this
  workload.

Carlos, I am looking at more ways to optimize it further for virtiofs.
In the mean time I think switching to "shared" thread pool should
bring you very close to 9p in your setup I think.

Thanks
Vivek

