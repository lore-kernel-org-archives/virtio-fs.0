DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=OUoINOaJPVctmAdwWdTs4x4MO9cqUIkC05X7XVRS7go=;
	b=Cg4q/DKAzg+efK9GXT9vKZ11tqCMxXokt7mGy010kugW0aAveWzCQs1+AcF18iVH5WMSYbMJKYlduUlSL2j0ktTWlqw7BogiInuJP2RF8RFaX41zo4cdn12OJIJN5jUGeXi8/FcXlQZ8eL/KrcGBZjN9Kpcqky3MDGOQrL2JbXg=
From: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
Date: Fri, 10 Jan 2020 00:50:19 +0000
Message-ID: <OSBPR01MB4582ED38FD140E1CA1592966E5380@OSBPR01MB4582.jpnprd01.prod.outlook.com>
References: <20200108202422.GF1995@redhat.com>
	<20200109022303.GA79586@e18g06458.et15sqa>
	<OSBPR01MB4582182B3FFD047E2FEC6326E5390@OSBPR01MB4582.jpnprd01.prod.outlook.com>
	<20200109191028.GC1964@redhat.com>
In-Reply-To: <20200109191028.GC1964@redhat.com>
Content-Language: ja-JP
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Open fd O_RDONLY in
 setxattr/removexattr
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: 'Vivek Goyal' <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

> On Thu, Jan 09, 2020 at 09:27:15AM +0000, misono.tomohiro@fujitsu.com wrote:
> > > On Wed, Jan 08, 2020 at 03:24:22PM -0500, Vivek Goyal wrote:
> > > > Do not open fd O_RDWR as it will fail for directories with EISDIR.
> > > > This code can be called both for regular files as well as directories.
> > > >
> > > > I noticed this when I tried "setfattr -n user.foo -v test <dir>"
> > > > inside the guest and got EISDIR.
> > > >
> > > > To write xattr, we don't have to open fd with write permissions.
> > > > Looks like kernel will do permission checks on inode.
> > > >
> > > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > >
> > > Looks good to me.
> > >
> > > Reviewed-by: Eryu Guan <eguan@linux.alibaba.com>
> > >
> > > > ---
> > > >  contrib/virtiofsd/passthrough_ll.c |    4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > Index: qemu/contrib/virtiofsd/passthrough_ll.c
> > > > ===================================================================
> > > > --- qemu.orig/contrib/virtiofsd/passthrough_ll.c	2020-01-08 15:01:03.821980889 -0500
> > > > +++ qemu/contrib/virtiofsd/passthrough_ll.c	2020-01-08 15:05:15.209384352 -0500
> > > > @@ -2424,7 +2424,7 @@ static void lo_setxattr(fuse_req_t req,
> > > >  	}
> > > >
> > > >  	sprintf(procname, "%i", inode->fd);
> > > > -	fd = openat(lo->proc_self_fd, procname, O_RDWR);
> > > > +	fd = openat(lo->proc_self_fd, procname, O_RDONLY);
> > > >  	if (fd < 0) {
> > > >  		saverr = errno;
> > > >  		goto out;
> > > > @@ -2473,7 +2473,7 @@ static void lo_removexattr(fuse_req_t re
> > > >  	}
> > > >
> > > >  	sprintf(procname, "%i", inode->fd);
> > > > -	fd = openat(lo->proc_self_fd, procname, O_RDWR);
> > > > +	fd = openat(lo->proc_self_fd, procname, O_RDONLY);
> > > >  	if (fd < 0) {
> > > >  		saverr = errno;
> > > >  		goto out;
> > > >
> >
> > Hello,
> >
> > So I sent the same patch last October[1] and got comments that it's
> > would be better to fix the fundamental problem (do not call openat()
> > to non regular file/directory) [2].
> >   [1] https://www.redhat.com/archives/virtio-fs/2019-October/msg00030.html
> >   [2]
> > https://www.redhat.com/archives/virtio-fs/2019-October/msg00046.html
> >
> > I tried the suggested approach which uses fchdir(proc_self_fd) +
> > ...xattr() + fchdir(root.fd) combination instead of current openat() + f...xattr().
> > However, it seems that always fchdir on xattr operation for regular
> > files too incurs some performance overhead (~10% or more).
> >
> > So I think hybrid approach is better:
> >   For regular file/directory: use f...xattr
> >   For other file types: use fchdir + ...xattr + fchdir
> >
> > Attached patch adopts the above solution.
> 
> Hi Misono,
> 
> Can you post this patch again separately so that it is easier to give comments and discuss this patch. I have a quick look and
> this patch does look reasonable.

Thanks for the check, I will post it shortly.
Misono

