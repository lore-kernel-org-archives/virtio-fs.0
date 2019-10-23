DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=OkdtDYnCWFFdvrP76EmuKgOMcDDsmTMenLe+xeYtECc=;
	b=hUN3+Is0WXl/BPGq+nRVlDB2Xz0pF3Vo1aDL3RnENtJb3sUHDFXzD7FSK8Pn1mrVr1tgQnooILyjafI4tlnf/iwxC6OUbWgisHU/VMn18nguskq4dA+3oqoEoL7/LV/sqBaJcgfYBnoxUi3G4GBk78SQWhmTyfYePHbmFXW22OI=
From: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
Date: Wed, 23 Oct 2019 11:42:50 +0000
Message-ID: <OSBPR01MB3783A810FEC4C2F3AE7248BAE56B0@OSBPR01MB3783.jpnprd01.prod.outlook.com>
References: <20191016103754.2047-1-misono.tomohiro@jp.fujitsu.com>
	<20191017100528.GA24790@stefanha-x1.localdomain>
	<CAOssrKfR=sfE1RzOXzvPbdQg-g7i5-f8W9y8bWFnO=gyJ2VMsg@mail.gmail.com>
	<20191017160953.GC1266@stefanha-x1.localdomain>
	<CAOssrKejcfVWXw6Nu1owyEeofTdVp6BNx4bL91ma2g7bg9-nmg@mail.gmail.com>
	<CAOssrKdbAT5s=CYG6PBtE6OYdqgwG8vp9T6QMJpwZ7X3tKjPmg@mail.gmail.com>
	<OSBPR01MB37835DC3A2F179AFD3A9074BE56C0@OSBPR01MB3783.jpnprd01.prod.outlook.com>
	<20191021094047.GF22659@stefanha-x1.localdomain>
In-Reply-To: <20191021094047.GF22659@stefanha-x1.localdomain>
Content-Language: ja-JP
Content-Type: text/plain; charset="iso-2022-jp"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: Two fix for xattr operation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: 'Stefan Hajnoczi' <stefanha@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, 'Miklos Szeredi' <mszeredi@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>

> -----Original Message-----
> From: Stefan Hajnoczi [mailto:stefanha@redhat.com]
> Sent: Monday, October 21, 2019 6:41 PM
> To: Misono, Tomohiro/味曽野 智礼 <misono.tomohiro@fujitsu.com>
> Cc: 'Miklos Szeredi' <mszeredi@redhat.com>; virtio-fs@redhat.com; qemu-devel@nongnu.org
> Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: Two fix for xattr operation
> 
> On Fri, Oct 18, 2019 at 08:51:20AM +0000, misono.tomohiro@fujitsu.com wrote:
> > > Doing unshare(CLONE_FS) after thread startup seems safe, though must
> > > be careful to change the working directory to the root of the mount
> > > *before* starting any threads.
> >
> > I think working directry is changed in setup_sandbox() -> setup_mount_namespace() -> setup_pivot_root().
> > So, can we just add unshare(CLONE_FS) in fv_queue_worker()?
> 
> fv_queue_worker() is the thread pool worker function that is called for each request.  Calling unshare(CLONE_FS) for each request
> is not necessary and will reduce performance.
> 
> A thread-local variable can be used to avoid repeated calls to
> unshare(CLONE_FS) from the same worker thread:
> 
>   static __thread bool clone_fs_called;
> 
>   static void fv_queue_worker(gpointer data, gpointer user_data)
>   {
>       ...
>       if (!clone_fs_called) {
>           int ret;
> 
> 	  ret = unshare(CLONE_FS);
> 	  assert(ret == 0); /* errors not expected according to man page */
> 
> 	  clone_fs_called = true;
>       }
> 
> Another issue is the seccomp policy.  Since worker threads are spawned at runtime it is necessary to add the unshare(2) syscall
> to the seccomp whitelist in contrib/virtiofsd/seccomp.c.
> 

Thanks for suggesting.

I tried above code with fchdir() + ...xattr() + fchdir() in lo_...xattr
and it solves all the problem about xattr I see.

However, it seems the fix causes some performance issue in stress test
as ACL check issues getxattr() and a lot of fchdir() happens. So, I may
try to combine the old method for regular file and this method for special
files.

Thanks,
Misono


