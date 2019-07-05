From: "Liu, Changpeng" <changpeng.liu@intel.com>
Date: Fri, 5 Jul 2019 09:56:42 +0000
Message-ID: <FF7FC980937D6342B9D289F5F3C7C2625B82A0F6@SHSMSX103.ccr.corp.intel.com>
References: <20190704104650.GF1609@stefanha-x1.localdomain>
	<5D1ED564.6040705@huawei.com>
	<20190705080401.GC10995@stefanha-x1.localdomain>
	<CACGKRzUCvUsghMR5t3aC4XRgi14xbRVFz+gZEnA+s63tShn1Pg@mail.gmail.com>
In-Reply-To: <CACGKRzUCvUsghMR5t3aC4XRgi14xbRVFz+gZEnA+s63tShn1Pg@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] Achieving parallelism in virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Peng Tao <bergwolf@hyper.sh>, Stefan Hajnoczi <stefanha@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>



> -----Original Message-----
> From: virtio-fs-bounces@redhat.com [mailto:virtio-fs-bounces@redhat.com] On
> Behalf Of Peng Tao
> Sent: Friday, July 5, 2019 4:14 PM
> To: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: virtio-fs@redhat.com
> Subject: Re: [Virtio-fs] Achieving parallelism in virtiofsd
> 
> On Fri, Jul 5, 2019 at 4:04 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> >
> > On Fri, Jul 05, 2019 at 12:43:16PM +0800, piaojun wrote:
> > > From your description, virtiofsd does the same work as SPDK, and I
> > > wonder if we could adapt it to SPDK-vhost-fs which is widely used.
> >
> > I don't see 9P code in spdk.git/master.  How does the guest access
> > SPDK's vhost-fs device and where is the code?
> >
> > A quick look at blobfs suggests additional work is needed to introduce
> > the concept of inodes instead of performing path name traversal on most
> > operations.  This also changes the semantics of the file system since
> > POSIX files can still be accessed after they are unlinked or renamed.
> >
> > In theory SPDK can implement the vhost-user-fs device interface and
> > replace virtiofsd but SPDK needs a POSIX file system implementation
> > first.
> Intel has presented virtiofsd+blobfs+SPDK in KubeCon Shanghai last
> month. As you have spotted, the main problem is on blobfs side and
> virtio-fs DAX sharing is not working because of blobfs limitation.
> 
I'm planning to add similar mmap API in SPDK, hopefully it can work in next few weeks.
> Cheers,
> Tao
> --
> Into something rich and strange.
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

