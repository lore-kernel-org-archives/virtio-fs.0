DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=date:from:to:subject:message-id:references:mime-version
	:content-disposition:in-reply-to;
	bh=cf5q6DUENyhwfvLjdF2+7Zx6TKMpUaayofUfmSkl25s=;
	b=q8irQz/cJc+KJo9IqBgAqG9ZnY18geJrLbBJSVQvoXg3o2L8wuxcuQJjU5F4bS/EBv
	+kyOVp3B4dG2DqNo0UmhmsRnAKRBy/7QuaH4OxkXtGYU2OKB7TNkc3fcsAdfLRRoN+xm
	rv64jU1hbqOAf4dpl+xvv7vSkzTEswMKrGMludnr6o85tORF+kjSnMFTF4AU8OVI7tsI
	0EWM0lJ0fLVQ6ulSXtKF9AU0Ov8aq0ytbQXi/IF8Uwahy/zCtYTX55l8HBcXdVX5EJOk
	oMD/HqBLd0O6hxLJ/JSXhFU7tYDI93gDc1wboa7r9JqR8Ysh8+eBT/cxJuaGYmv9V4JI
	ewTA==
Date: Mon, 20 Jan 2020 11:41:19 -0500
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <20200120164119.kpnhtbkgdlcdawbu@gabell>
References: <20191213175733.txnfv6bxxf4vauzb@gabell>
	<20191216145458.GB6106@redhat.com>
	<20191217210225.tnnudbdbxgxee7oh@gabell>
MIME-Version: 1.0
In-Reply-To: <20191217210225.tnnudbdbxgxee7oh@gabell>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] Question: atime update behavior of virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, virtio-fs@redhat.com, Miklos Szeredi <miklos@szeredi.hu>

On Tue, Dec 17, 2019 at 04:02:25PM -0500, Masayoshi Mizuma wrote:
> Hi Vivek,
> 
> On Mon, Dec 16, 2019 at 09:54:58AM -0500, Vivek Goyal wrote:
> > On Fri, Dec 13, 2019 at 12:57:33PM -0500, Masayoshi Mizuma wrote:
> > > Hello,
> > > 
> > > Let me ask questions about atime update behavior of virtiofs.
> > > 
> > > Background:
> > > 
> > > I believe the atime update behavior of virtiofs is same as
> > > the underlying filesystem and the atime mount option of virtiofs
> > > is ignored.
> > 
> > [ CC Miklos. He does not seem to be on virtio-fs list yet ]
> > 
> > Hi Masayoshi,
> > 
> > I have not paid too much of attention to atime behavior but I think it
> > will be a combination of atime settings on virtio-fs as well as underlying
> > filesystem.
> > 
> > In this particular case read request will go to virtiofsd server
> > (especially in case of cache=none) and when virtiofsd access file
> > on host, atime will be updated according to the atime settings on
> > host filesystem.
> > 
> > 
> > > 
> > > For example, the underlying fileysystem is XFS and the atime option
> > > is strictatime Then, mount the filesystem from the guest with noatime.
> > > 
> > > # mount -t virtiofs -o noatime myfs0 /mnt/myfs0
> > > 
> > > # cat /proc/mounts
> > > ...
> > > myfs0 /mnt/myfs0 virtiofs rw,noatime 0 0
> > > ...
> > > 
> > > Check the atime as following script atime.h:
> > > ============
> > > #!/bin/bash
> > > 
> > > FILE=/mnt/myfs0/foo
> > > 
> > > rm -f $FILE
> > > 
> > > echo "hello" > $FILE
> > > stat --format=%x $FILE
> > > 
> > > sleep 10
> > > 
> > > cat $FILE > /dev/null
> > > stat --format=%x $FILE
> > > ============
> > > 
> > > I can see the following result. The atime is updated even if the mount
> > > option is noatime.
> > > 
> > > ~]# ./atime.sh
> > > 2019-12-13 12:32:46.733024358 -0500
> > > 2019-12-13 12:32:56.752898507 -0500
> > > ~]#
> > > 
> > > Questions:
> > > 
> > > Q1. Is the atime behavior a specification for virtiofs, that means
> > >     it's not a bug?
> > > 
> > 
> > I will not call it a bug. We have not actually defined atime behavior of
> > virtio-fs as such and its dependency on host filesystem.
> 
> Got it, thanks.
> 
> > 
> > > Q2. If Q1 is yes, I think it would be better if the atime behavior
> > >     could be described to documents so that user can know the behavior.
> > >     What is the appropriate document?
> > >     - man page of virtiofsd which Dave is trying to merge?
> > >       https://lists.gnu.org/archive/html/qemu-devel/2019-12/msg02475.html
> > >     - man page of mount(8)?
> > >     - The official page (https://virtio-fs.gitlab.io/)?
> > >     - Or...?
> > 
> > It probably is a good idea to atleast add a section in
> > Documentation/filesystem/virtiofs.rst and talk about atime behavior in
> > different configurations.
> 
> I created a patch for virtiofs.rst to add the mount options and the
> atime behavior as following.
> Does it make sense?

Hello,

Could you review the follwing doc patch to tell the atime behaivor
for users?

> 
> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> Date: Tue, 17 Dec 2019 15:55:20 -0500
> Subject: [PATCH] virtio-fs: Add mount option and atime behavior to the doc
> 
> Add a section to show the mount option and a subsection to show
> the atime behavior.
> 
> Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> ---
>  Documentation/filesystems/virtiofs.rst | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/Documentation/filesystems/virtiofs.rst b/Documentation/filesystems/virtiofs.rst
> index 4f338e3cb3f7..8b04160061fd 100644
> --- a/Documentation/filesystems/virtiofs.rst
> +++ b/Documentation/filesystems/virtiofs.rst
> @@ -37,6 +37,20 @@ Mount file system with tag ``myfs`` on ``/mnt``:
>  Please see https://virtio-fs.gitlab.io/ for details on how to configure QEMU
>  and the virtiofsd daemon.
>  
> +Mount options
> +-------------
> +
> +virtiofs supports general VFS mount options, for example, remount,
> +ro, rw, context, etc. It also supports FUSE mount options.
> +
> +atime behavior
> +^^^^^^^^^^^^^^
> +
> +The atime-related mount options, for example, noatime, strictatime,
> +are ignored. The atime behavior for virtiofs is the same as the
> +underlying filesystem of the directory that has been exported
> +on the host.
> +
>  Internals
>  =========
>  Since the virtio-fs device uses the FUSE protocol for file system requests, the
> -- 
> 2.18.1
> 

Thanks,
Masa


