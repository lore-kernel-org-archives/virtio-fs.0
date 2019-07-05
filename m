References: <20190704104650.GF1609@stefanha-x1.localdomain>
	<5D1ED564.6040705@huawei.com>
	<20190705080401.GC10995@stefanha-x1.localdomain>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D1F08B6.8000900@huawei.com>
Date: Fri, 5 Jul 2019 16:22:14 +0800
MIME-Version: 1.0
In-Reply-To: <20190705080401.GC10995@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] Achieving parallelism in virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com



On 2019/7/5 16:04, Stefan Hajnoczi wrote:
> On Fri, Jul 05, 2019 at 12:43:16PM +0800, piaojun wrote:
>> From your description, virtiofsd does the same work as SPDK, and I
>> wonder if we could adapt it to SPDK-vhost-fs which is widely used.
> 
> I don't see 9P code in spdk.git/master.  How does the guest access
> SPDK's vhost-fs device and where is the code?

Yes, 9P code is not in spdk yet, and they can comunicate though share
memory. But it needs some extra work.

> 
> A quick look at blobfs suggests additional work is needed to introduce
> the concept of inodes instead of performing path name traversal on most
> operations.  This also changes the semantics of the file system since
> POSIX files can still be accessed after they are unlinked or renamed.
> 
> In theory SPDK can implement the vhost-user-fs device interface and
> replace virtiofsd but SPDK needs a POSIX file system implementation
> first.

Right, SPDK could only support blobfs now, and I wish it supporting any
local file system as backend in the future. SPDK vhost-fs patches is in
developing as below:

https://review.gerrithub.io/c/spdk/spdk/+/449163/5
https://review.gerrithub.io/c/spdk/spdk/+/449162/5

Thanks,
Jun

> 
> Stefan
> 

