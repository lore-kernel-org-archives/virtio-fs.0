Date: Thu, 6 Aug 2020 16:07:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200806200729.GH367847@redhat.com>
References: <CAFKS8hWbckrE_cyJCf0pgFresD-JQk66wo-6uJA=Gu2MhReHVw@mail.gmail.com>
	<20200728134936.GA21660@stefanha-x1.localdomain>
	<20200728152719.GD78409@redhat.com>
	<CAFKS8hUPdx=eHpvYqB3T__ZBWyztfNPGSBtiBDiqMotA8Cca9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFKS8hUPdx=eHpvYqB3T__ZBWyztfNPGSBtiBDiqMotA8Cca9Q@mail.gmail.com>
Subject: Re: [Virtio-fs] virtio-fs performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Derek Su <jwsu1986@gmail.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, qemu-discuss@nongnu.org

On Tue, Aug 04, 2020 at 03:51:50PM +0800, Derek Su wrote:
> Vivek Goyal <vgoyal@redhat.com> 於 2020年7月28日 週二 下午11:27寫道：
> >
> > On Tue, Jul 28, 2020 at 02:49:36PM +0100, Stefan Hajnoczi wrote:
> > > > I'm trying and testing the virtio-fs feature in QEMU v5.0.0.
> > > > My host and guest OS are both ubuntu 18.04 with kernel 5.4, and the
> > > > underlying storage is one single SSD.
> > > >
> > > > The configuations are:
> > > > (1) virtiofsd
> > > > ./virtiofsd -o
> > > > source=/mnt/ssd/virtiofs,cache=auto,flock,posix_lock,writeback,xattr
> > > > --thread-pool-size=1 --socket-path=/tmp/vhostqemu
> > > >
> > > > (2) qemu
> > > > qemu-system-x86_64 \
> > > > -enable-kvm \
> > > > -name ubuntu \
> > > > -cpu Westmere \
> > > > -m 4096 \
> > > > -global kvm-apic.vapic=false \
> > > > -netdev tap,id=hn0,vhost=off,br=br0,helper=/usr/local/libexec/qemu-bridge-helper
> > > > \
> > > > -device e1000,id=e0,netdev=hn0 \
> > > > -blockdev '{"node-name": "disk0", "driver": "qcow2",
> > > > "refcount-cache-size": 1638400, "l2-cache-size": 6553600, "file": {
> > > > "driver": "file", "filename": "'${imagefolder}\/ubuntu.qcow2'"}}' \
> > > > -device virtio-blk,drive=disk0,id=disk0 \
> > > > -chardev socket,id=ch0,path=/tmp/vhostqemu \
> > > > -device vhost-user-fs-pci,chardev=ch0,tag=myfs \
> > > > -object memory-backend-memfd,id=mem,size=4G,share=on \
> > > > -numa node,memdev=mem \
> > > > -qmp stdio \
> > > > -vnc :0
> > > >
> > > > (3) guest
> > > > mount -t virtiofs myfs /mnt/virtiofs
> > > >
> > > > I tried to change virtiofsd's --thread-pool-size value and test the
> > > > storage performance by fio.
> > > > Before each read/write/randread/randwrite test, the pagecaches of
> > > > guest and host are dropped.
> > > >
> > > > ```
> > > > RW="read" # or write/randread/randwrite
> > > > fio --name=test --rw=$RW --bs=4k --numjobs=1 --ioengine=libaio
> > > > --runtime=60 --direct=0 --iodepth=64 --size=10g
> > > > --filename=/mnt/virtiofs/testfile
> > > > done
> >
> > Couple of things.
> >
> > - Can you try cache=none option in virtiofsd. That will bypass page
> >   cache in guest. It also gets rid of latencies related to
> >   file_remove_privs() as of now.
> >
> > - Also with direct=0, are we really driving iodepth of 64? With direct=0
> >   it is cached I/O. Is it still asynchronous at this point of time of
> >   we have fallen back to synchronous I/O and driving queue depth of
> >   1.
> 
> Hi, Vivek
> 
> I did not see any difference in queue depth with direct={0|1} in my fio test.
> Are there more clues to dig into this issue?

I tried it just again. fio seems to say queue depth 64 in both the cases
but I am not sure if this is correct. Reason being that I get much
better performance with direct=1. Also fio man page says.

 libaio Linux native asynchronous I/O. Note that Linux may
        only support queued behavior with non-buffered I/O
        (set  `direct=1'  or  `buffered=0').   This engine
        defines engine specific options.

Are you see difference in effective bandwidth/iops when you run with
direct=0/1. I see it. 

Anyway, in an attempt to narrow down the issues, I ran virtiofsd 
with cache=none and did not enable xattr. (As of now xattr case
needs to be optimized with SB_NOSEC).

I ran virtiofsd as follows.

./virtiofsd --socket-path=/tmp/vhostqemu2 -o source=/mnt/sdb/virtiofs-source2/ -o no_posix_lock -o modcaps=+sys_admin -o log_level=info -o cache=none --daemonize

And then ran following fio commands with direct=0 and direct=1.

fio --name=test --rw=randwrite --bs=4K --numjobs=1 --ioengine=libaio --runtime=30 --direct=0 --iodepth=64 --filename=fio-file1

direct=0
--------
write: IOPS=8712, BW=34.0MiB/s (35.7MB/s)(1021MiB/30001msec)

direct=1
--------
write: IOPS=84.4k, BW=330MiB/s (346MB/s)(4096MiB/12428msec)

So I see almost 10 fold jump in throughput with direct=1. So I believe
direct=0 is not driving the queue depth.

You raised interesting issue of --thread-pool-size=1 vs 64 and I decided
to give it a try. I ran same tests as above with thread pool size 1
and following are results.

with direct=0
-------------
write: IOPS=14.7k, BW=57.4MiB/s (60.2MB/s)(1721MiB/30001msec)

with direct=1
-------------
write: IOPS=71.7k, BW=280MiB/s (294MB/s)(4096MiB/14622msec);

So with we are driving queue depth 1 (direct=0), looks like
--thread-pool-size 1 is helping. I see higher IOPS. But when we are
driving queue depth of 64, then --thread-pool-size=1 seems to hurt.

Now question is, why thread pool size 64 by default hurts so much
for the case of queue depth 1.

You raised anohter issue of it being slower than NFSv4/CIFS. I think
you can run virtiofsd with cache=none and without enabling xattr
and post results here so that we have some idea how much better
NFSv4/CIFS is.

Thanks
Vivek

