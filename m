Date: Mon, 16 Dec 2019 09:54:58 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20191216145458.GB6106@redhat.com>
References: <20191213175733.txnfv6bxxf4vauzb@gabell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213175733.txnfv6bxxf4vauzb@gabell>
Subject: Re: [Virtio-fs] Question: atime update behavior of virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: virtio-fs@redhat.com, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Dec 13, 2019 at 12:57:33PM -0500, Masayoshi Mizuma wrote:
> Hello,
> 
> Let me ask questions about atime update behavior of virtiofs.
> 
> Background:
> 
> I believe the atime update behavior of virtiofs is same as
> the underlying filesystem and the atime mount option of virtiofs
> is ignored.

[ CC Miklos. He does not seem to be on virtio-fs list yet ]

Hi Masayoshi,

I have not paid too much of attention to atime behavior but I think it
will be a combination of atime settings on virtio-fs as well as underlying
filesystem.

In this particular case read request will go to virtiofsd server
(especially in case of cache=none) and when virtiofsd access file
on host, atime will be updated according to the atime settings on
host filesystem.


> 
> For example, the underlying fileysystem is XFS and the atime option
> is strictatime Then, mount the filesystem from the guest with noatime.
> 
> # mount -t virtiofs -o noatime myfs0 /mnt/myfs0
> 
> # cat /proc/mounts
> ...
> myfs0 /mnt/myfs0 virtiofs rw,noatime 0 0
> ...
> 
> Check the atime as following script atime.h:
> ============
> #!/bin/bash
> 
> FILE=/mnt/myfs0/foo
> 
> rm -f $FILE
> 
> echo "hello" > $FILE
> stat --format=%x $FILE
> 
> sleep 10
> 
> cat $FILE > /dev/null
> stat --format=%x $FILE
> ============
> 
> I can see the following result. The atime is updated even if the mount
> option is noatime.
> 
> ~]# ./atime.sh
> 2019-12-13 12:32:46.733024358 -0500
> 2019-12-13 12:32:56.752898507 -0500
> ~]#
> 
> Questions:
> 
> Q1. Is the atime behavior a specification for virtiofs, that means
>     it's not a bug?
> 

I will not call it a bug. We have not actually defined atime behavior of
virtio-fs as such and its dependency on host filesystem.

> Q2. If Q1 is yes, I think it would be better if the atime behavior
>     could be described to documents so that user can know the behavior.
>     What is the appropriate document?
>     - man page of virtiofsd which Dave is trying to merge?
>       https://lists.gnu.org/archive/html/qemu-devel/2019-12/msg02475.html
>     - man page of mount(8)?
>     - The official page (https://virtio-fs.gitlab.io/)?
>     - Or...?

It probably is a good idea to atleast add a section in
Documentation/filesystem/virtiofs.rst and talk about atime behavior in
different configurations.

Thanks
Vivek

