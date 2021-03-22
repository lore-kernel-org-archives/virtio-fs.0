Date: Mon, 22 Mar 2021 10:42:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210322144241.GB446288@redhat.com>
References: <CAAQbG+XwZdcyEopmBV9J=Y8m++QCV8BOKAnPWTrsnwk4sesG1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAQbG+XwZdcyEopmBV9J=Y8m++QCV8BOKAnPWTrsnwk4sesG1Q@mail.gmail.com>
Subject: Re: [Virtio-fs] Large memory consumption by virtiofsd,
 suspecting fd's aren't being closed?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eric Ernst <eric.g.ernst@gmail.com>
Cc: virtio-fs@redhat.com

On Sun, Mar 21, 2021 at 09:14:37PM -0700, Eric Ernst wrote:
> Hey ya’ll,
> 
> One challenge I’ve been looking at is how to setup an appropriate memory
> cgroup limit for workloads that are leveraging virtiofs (ie, running pods
> with Kata Containers that leverage virtiofs). I noticed that memory usage
> of the daemon itself can grow considerably depending on the workload;
> though much more than I’d expect.
> 
> I’m running workload that simply runs a build on kernel sources with -j3.
> In doing this, the source of the linux kernel are shared via virtiofs (no
> DAX), so as the build goes on, there are a lot of files opened, closed, as
> well as created. The rss memory of virtiofsd grows into several hundreds of
> MBs.
> 
> When taking a look, I’m suspecting that virtiofsd is carrying out the
> opens, but never actually closing fds. In the guest, I’m seeing fd’s on the
> order of 10-40 for all the container processes as it runs, whereas I see
> the number of fds for virtiofsd continually increasing, reaching over
> 80,000 fds. I’m guessing this isn’t expected?
> 
> Can any ya’ll help shed some light, or where I can look?

Hi Eric,

What cache mode you are using? cache=auto? 

Yes virtiofsd keeps inode->fd open (using O_PATH). Guest kernel caches
inodes (and dentries), and that means equivalent inode is cached
in virtiofsd and that also means that inode->fd will remain open.

Max Reitz is looking into making file handle work with virtiofsd so
that inode->fd can be closed and reopened using open_by_handle_at(). But
there are technical challenges there and it might take a while.

But that only takes care  of inode->fd. Inode will continue to be
cached. So I think real issue is that guest is caching inodes and
that leads to caching on virtiofsd and memory usage grows.

If you try with cache=none, then memory usage might be significanlty
lower (as once file is closed in guest, inode will be dropped).

To experiment, you can try "echo 3 > /proc/sys/vm/drop_caches" in guest and
that should drop dentry/inode caches for some inode and free up 
memory in virtiofsd.

Vivek.
> 
> Thanks,
> Eric

> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs

