Date: Fri, 8 Jan 2021 10:26:46 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210108152646.GC46319@redhat.com>
References: <20210104184527.GC63879@redhat.com> <20210104185655.GN2972@work-vm>
	<CAOQ4uxiw2rXnzFUdixo7qPTiKihsSoxZAbGappGdMcjssgSVSA@mail.gmail.com>
	<CAJfpegtHh_m9DpMqC+hBvvV1ioRcydj2cHqMzo41rLcXc148Zw@mail.gmail.com>
	<CAOQ4uxgfW2BZ04hSahymzyerz==YVNLyRmxkUysZPYmnt6n7QA@mail.gmail.com>
	<CAJfpegsSKfaFbpovOZpJQOP_xrpQpJa2mBK=xefV5k1XsCbfbQ@mail.gmail.com>
	<20210106165759.GA9679@redhat.com>
	<CAJfpegtO+X9rk5pTTRmDv9LWGK4fbvUuwNJvRP_o77B5Y5D3mA@mail.gmail.com>
	<CAOQ4uxjTerAAxvjpDmDMQO363ju01MsEhbgBmHHSQb92hoL1_g@mail.gmail.com>
	<20210108041252.GT80581@e18g06458.et15sqa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108041252.GT80581@e18g06458.et15sqa>
Subject: Re: [Virtio-fs] [fuse-devel] 'FORGET' ordering semantics (vs unlink
 & NFS)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eryu Guan <eguan@linux.alibaba.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel <fuse-devel@lists.sourceforge.net>, Amir Goldstein <amir73il@gmail.com>, Max Reitz <mreitz@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, gerry@linux.alibaba.com, bergwolf@hyper.sh

On Fri, Jan 08, 2021 at 12:12:52PM +0800, Eryu Guan wrote:

[..]
> > Anyone has other thoughts about how to reduce fragmentation in
> > implementations?
> 
> There's an fuse-backend-rs[1] project hosted on cloud-hypervisor, it is
> a library to communicate with the Linux FUSE clients, which includes:
> 
> - ABI layer, which defines all data structures shared between linux Fuse
>   framework and Fuse daemons.
> - API layer, defines the interfaces for Fuse daemons to implement a
>   userspace file system.
> - Transport layer, which supports both the Linux Fuse device and
>   virtio-fs protocol.
> - VFS/pseudo_fs, an abstraction layer to support multiple file systems
>   by a single virtio-fs device.
> - A sample passthrough file system implementation, which passes through
>   files from daemons to clients.
> 

So at a high level, is this equivalent of libfuse written in rust?

Vivek

> I'm wondering if fuse-backend-rs is a proper project to work on, and
> maybe virtiofsd-rs could be switched to use it as well in the future.
> 
> Thanks,
> Eryu
> 
> [1] https://github.com/cloud-hypervisor/fuse-backend-rs
> 

