DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc:content-transfer-encoding;
	bh=DusenhJf7zgZTt8h/CNi5vfStyUG9q2o6UYyIZzlp3Q=;
	b=p7jGcET4azWy7py48LAb2/IpE9DhEm3L+2u3S7QTXM/yKpZdFhWUSznKR1OHBIYHSE
	vkFfleTITLYkmu1odQSir93qM1a2iMQLURx76b0aAD8nnVeyOBrCq39H2vgIo/Ik75bU
	CuNRj6eUt4QeGURv+aCYPHur4aAF5iL0In9EM3WZQ694cmRk1hlaLxzmZNDiV9VNMRBs
	CTkeYUA/DPwSFLGlmfgBeOnrhDtlGSn3j6zMAl15wWZx6U0GB7deO/JrchdvBOgyO2Bd
	uXejoQyvWvHw8FI6zE7xFHWG02rokoSj4tXLtfoffAAwvYaqukNxckOI8KC0XYY+fLKs
	iVrQ==
MIME-Version: 1.0
References: <CAFKS8hWbckrE_cyJCf0pgFresD-JQk66wo-6uJA=Gu2MhReHVw@mail.gmail.com>
	<20200728134936.GA21660@stefanha-x1.localdomain>
	<20200728152719.GD78409@redhat.com>
In-Reply-To: <20200728152719.GD78409@redhat.com>
From: Derek Su <jwsu1986@gmail.com>
Date: Tue, 4 Aug 2020 15:51:50 +0800
Message-ID: <CAFKS8hUPdx=eHpvYqB3T__ZBWyztfNPGSBtiBDiqMotA8Cca9Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] virtio-fs performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, qemu-discuss@nongnu.org

Vivek Goyal <vgoyal@redhat.com> 於 2020年7月28日 週二 下午11:27寫道：
>
> On Tue, Jul 28, 2020 at 02:49:36PM +0100, Stefan Hajnoczi wrote:
> > > I'm trying and testing the virtio-fs feature in QEMU v5.0.0.
> > > My host and guest OS are both ubuntu 18.04 with kernel 5.4, and the
> > > underlying storage is one single SSD.
> > >
> > > The configuations are:
> > > (1) virtiofsd
> > > ./virtiofsd -o
> > > source=/mnt/ssd/virtiofs,cache=auto,flock,posix_lock,writeback,xattr
> > > --thread-pool-size=1 --socket-path=/tmp/vhostqemu
> > >
> > > (2) qemu
> > > qemu-system-x86_64 \
> > > -enable-kvm \
> > > -name ubuntu \
> > > -cpu Westmere \
> > > -m 4096 \
> > > -global kvm-apic.vapic=false \
> > > -netdev tap,id=hn0,vhost=off,br=br0,helper=/usr/local/libexec/qemu-bridge-helper
> > > \
> > > -device e1000,id=e0,netdev=hn0 \
> > > -blockdev '{"node-name": "disk0", "driver": "qcow2",
> > > "refcount-cache-size": 1638400, "l2-cache-size": 6553600, "file": {
> > > "driver": "file", "filename": "'${imagefolder}\/ubuntu.qcow2'"}}' \
> > > -device virtio-blk,drive=disk0,id=disk0 \
> > > -chardev socket,id=ch0,path=/tmp/vhostqemu \
> > > -device vhost-user-fs-pci,chardev=ch0,tag=myfs \
> > > -object memory-backend-memfd,id=mem,size=4G,share=on \
> > > -numa node,memdev=mem \
> > > -qmp stdio \
> > > -vnc :0
> > >
> > > (3) guest
> > > mount -t virtiofs myfs /mnt/virtiofs
> > >
> > > I tried to change virtiofsd's --thread-pool-size value and test the
> > > storage performance by fio.
> > > Before each read/write/randread/randwrite test, the pagecaches of
> > > guest and host are dropped.
> > >
> > > ```
> > > RW="read" # or write/randread/randwrite
> > > fio --name=test --rw=$RW --bs=4k --numjobs=1 --ioengine=libaio
> > > --runtime=60 --direct=0 --iodepth=64 --size=10g
> > > --filename=/mnt/virtiofs/testfile
> > > done
>
> Couple of things.
>
> - Can you try cache=none option in virtiofsd. That will bypass page
>   cache in guest. It also gets rid of latencies related to
>   file_remove_privs() as of now.
>
> - Also with direct=0, are we really driving iodepth of 64? With direct=0
>   it is cached I/O. Is it still asynchronous at this point of time of
>   we have fallen back to synchronous I/O and driving queue depth of
>   1.

Hi, Vivek

I did not see any difference in queue depth with direct={0|1} in my fio test.
Are there more clues to dig into this issue?

>
> - With cache=auto/always, I am seeing performance issues with small writes
>   and trying to address it.
>
> https://lore.kernel.org/linux-fsdevel/20200716144032.GC422759@redhat.com/
> https://lore.kernel.org/linux-fsdevel/20200724183812.19573-1-vgoyal@redhat.com/

No problem, I'll try it, thanks.

Regards,
Derek

>
> Thanks
> Vivek
>
> > > ```
> > >
> > > --thread-pool-size=64 (default)
> > >     seq read: 305 MB/s
> > >     seq write: 118 MB/s
> > >     rand 4KB read: 2222 IOPS
> > >     rand 4KB write: 21100 IOPS
> > >
> > > --thread-pool-size=1
> > >     seq read: 387 MB/s
> > >     seq write: 160 MB/s
> > >     rand 4KB read: 2622 IOPS
> > >     rand 4KB write: 30400 IOPS
> > >
> > > The results show the performance using default-pool-size (64) is
> > > poorer than using single thread.
> > > Is it due to the lock contention of the multiple threads?
> > > When can virtio-fs get better performance using multiple threads?
> > >
> > >
> > > I also tested the performance that guest accesses host's files via
> > > NFSv4/CIFS network filesystem.
> > > The "seq read" and "randread" performance of virtio-fs are also worse
> > > than the NFSv4 and CIFS.
> > >
> > > NFSv4:
> > >   seq write: 244 MB/s
> > >   rand 4K read: 4086 IOPS
> > >
> > > I cannot figure out why the perf of NFSv4/CIFS with the network stack
> > > is better than virtio-fs.
> > > Is it expected? Or, do I have an incorrect configuration?
> >
> > No, I remember benchmarking the thread pool and did not see such a big
> > difference.
> >
> > Please use direct=1 so that each I/O results in a virtio-fs request.
> > Otherwise the I/O pattern is not directly controlled by the benchmark
> > but by the page cache (readahead, etc).
> >
> > Using numactl(8) or taskset(1) to launch virtiofsd allows you to control
> > NUMA and CPU scheduling properties. For example, you could force all 64
> > threads to run on the same host CPU using taskset to see if that helps
> > this I/O bound workload.
> >
> > fio can collect detailed statistics on queue depths and a latency
> > histogram. It would be interesting to compare the --thread-pool-size=64
> > and --thread-pool-size=1 numbers.
> >
> > Comparing the "perf record -e kvm:kvm_exit" counts between the two might
> > also be interesting.
> >
> > Stefan
>
>
>
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs
>


