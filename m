Date: Tue, 16 Feb 2021 09:36:35 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210216143635.GA3196@redhat.com>
References: <rprnspo3-119s-qnoo-2o93-sn40rq40ns@erqung.pbz>
	<20210114133424.GA299876@stefanha-x1.localdomain>
	<qn527287-65qq-227p-2r48-1528r6rr386@erqung.pbz>
	<20210118165541.GD255498@stefanha-x1.localdomain>
	<9qo964n3-7p75-7992-7s7p-3srrs4q650n@erqung.pbz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9qo964n3-7p75-7992-7s7p-3srrs4q650n@erqung.pbz>
Subject: Re: [Virtio-fs] [RFC] About non-root virtiofsd(1) process
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: P J P <ppandit@redhat.com>
Cc: virtio-fs@redhat.com

On Tue, Jan 19, 2021 at 08:04:29PM +0530, P J P wrote:
> +-- On Mon, 18 Jan 2021, Stefan Hajnoczi wrote --+
> | Guest applications may run with different uids/gids. The host has no control 
> | over that.
> | 
> | Imagine booting a guest form a virtio-fs root file system and installing 
> | packages. The guest must be able to control uids/gids for that to work.
> 
> * I see; I'll try to better understand how it's done.
> 
> * With UID namespaces, I thought virtiofsd(1) would be able to operate files 
>   with arbitrary uid/gid, even after dropping its root privileges to acquire 
>   non-root privileges on the host; Because it has 'root' privileges under the 
>   shared directory & UID namespace.
> 
> | > $ ./virtiofsd -runas test -o source=...
> | 
> | Patches for this are welcome.
> 
> * Okay, will try.

Catching up with this thread now.

I had posted minimal patches to allow running virtiofsd unpriviliged.
They did not make further progress though.

https://patchew.org/QEMU/20200730194736.173994-1-vgoyal@redhat.com/

While being able to run virtiofsd in a user namespace is certainly
valuable, I feel being able to run virtiofsd unpriviliged has it
use cases as well. For example, if a user wants to share just its
home directory on host with guest. In that case, we probably don't
require lot of priviliged operations to be performed by virtiofsd.

Vivek

