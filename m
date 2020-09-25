Date: Fri, 25 Sep 2020 09:11:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200925131142.GC132653@redhat.com>
References: <20200918213436.GA3520@redhat.com> <20200921153243.GK3221@work-vm>
	<20200922102531.GA2837@work-vm> <20200922174733.GD57620@redhat.com>
	<20200925121127.GI2873@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925121127.GI2873@work-vm>
Subject: Re: [Virtio-fs] tools/virtiofs: Multi threading seems to hurt
	performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: jose.carlos.venegas.munoz@intel.com, qemu-devel@nongnu.org, cdupontd@redhat.com, virtio-fs-list <virtio-fs@redhat.com>, archana.m.shinde@intel.com

On Fri, Sep 25, 2020 at 01:11:27PM +0100, Dr. David Alan Gilbert wrote:
> * Vivek Goyal (vgoyal@redhat.com) wrote:
> > On Tue, Sep 22, 2020 at 11:25:31AM +0100, Dr. David Alan Gilbert wrote:
> > > * Dr. David Alan Gilbert (dgilbert@redhat.com) wrote:
> > > > Hi,
> > > >   I've been doing some of my own perf tests and I think I agree
> > > > about the thread pool size;  my test is a kernel build
> > > > and I've tried a bunch of different options.
> > > > 
> > > > My config:
> > > >   Host: 16 core AMD EPYC (32 thread), 128G RAM,
> > > >      5.9.0-rc4 kernel, rhel 8.2ish userspace.
> > > >   5.1.0 qemu/virtiofsd built from git.
> > > >   Guest: Fedora 32 from cloud image with just enough extra installed for
> > > > a kernel build.
> > > > 
> > > >   git cloned and checkout v5.8 of Linux into /dev/shm/linux on the host
> > > > fresh before each test.  Then log into the guest, make defconfig,
> > > > time make -j 16 bzImage,  make clean; time make -j 16 bzImage 
> > > > The numbers below are the 'real' time in the guest from the initial make
> > > > (the subsequent makes dont vary much)
> > > > 
> > > > Below are the detauls of what each of these means, but here are the
> > > > numbers first
> > > > 
> > > > virtiofsdefault        4m0.978s
> > > > 9pdefault              9m41.660s
> > > > virtiofscache=none    10m29.700s
> > > > 9pmmappass             9m30.047s
> > > > 9pmbigmsize           12m4.208s
> > > > 9pmsecnone             9m21.363s
> > > > virtiofscache=noneT1   7m17.494s
> > > > virtiofsdefaultT1      3m43.326s
> > > > 
> > > > So the winner there by far is the 'virtiofsdefaultT1' - that's
> > > > the default virtiofs settings, but with --thread-pool-size=1 - so
> > > > yes it gives a small benefit.
> > > > But interestingly the cache=none virtiofs performance is pretty bad,
> > > > but thread-pool-size=1 on that makes a BIG improvement.
> > > 
> > > Here are fio runs that Vivek asked me to run in my same environment
> > > (there are some 0's in some of the mmap cases, and I've not investigated
> > > why yet).
> > 
> > cache=none does not allow mmap in case of virtiofs. That's when you
> > are seeing 0.
> > 
> > >virtiofs is looking good here in I think all of the cases;
> > > there's some division over which cinfig; cache=none
> > > seems faster in some cases which surprises me.
> > 
> > I know cache=none is faster in case of write workloads. It forces
> > direct write where we don't call file_remove_privs(). While cache=auto
> > goes through file_remove_privs() and that adds a GETXATTR request to
> > every WRITE request.
> 
> Can you point me to how cache=auto causes the file_remove_privs?

fs/fuse/file.c

fuse_cache_write_iter() {
	err = file_remove_privs(file);
}

Above path is taken when cache=auto/cache=always is used. If virtiofsd
is running with noxattr, then it does not impose any cost. But if xattr
are enabled, then every WRITE first results in a
getxattr(security.capability) and that slows down WRITES tremendously.

When cache=none is used, we go through following path instead.

fuse_direct_write_iter() and it does not have file_remove_privs(). We
set a flag in WRITE request to tell server to kill
suid/sgid/security.capability, instead.

fuse_direct_io() {
	ia->write.in.write_flags |= FUSE_WRITE_KILL_PRIV
}

Vivek

