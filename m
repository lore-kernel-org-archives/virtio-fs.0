DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=juc6GNuKcyXpuUYv6naPnNX7n61FrJvqDNyd1qQNmfA=;
	b=VxpFG6ulXvLPv0wY1dGqQV50D0kntB5kNCtxWOGgj3Yxsk0Xu7wcWevT0ue3eaM9NBdjBeHMb0ESj7qUr1dR313nmGrFGx/lX7pApiLO6pfWymeT1QfmnTB0rRKATBj2O0CQc4sutuKKxr3Q1/qB77mrZIGUSMyBdL8LUsnKnRE=
From: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
Date: Fri, 18 Oct 2019 08:51:20 +0000
Message-ID: <OSBPR01MB37835DC3A2F179AFD3A9074BE56C0@OSBPR01MB3783.jpnprd01.prod.outlook.com>
References: <20191016103754.2047-1-misono.tomohiro@jp.fujitsu.com>
	<20191017100528.GA24790@stefanha-x1.localdomain>
	<CAOssrKfR=sfE1RzOXzvPbdQg-g7i5-f8W9y8bWFnO=gyJ2VMsg@mail.gmail.com>
	<20191017160953.GC1266@stefanha-x1.localdomain>
	<CAOssrKejcfVWXw6Nu1owyEeofTdVp6BNx4bL91ma2g7bg9-nmg@mail.gmail.com>
	<CAOssrKdbAT5s=CYG6PBtE6OYdqgwG8vp9T6QMJpwZ7X3tKjPmg@mail.gmail.com>
In-Reply-To: <CAOssrKdbAT5s=CYG6PBtE6OYdqgwG8vp9T6QMJpwZ7X3tKjPmg@mail.gmail.com>
Content-Language: ja-JP
Content-Type: text/plain; charset="utf-8"
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
To: 'Miklos Szeredi' <mszeredi@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>

> > Even simpler: allow O_PATH descriptors for f*xattr().
> 
> Attached patch.  Will post shortly.
> 
> However, I think it would make sense to fix virtiofsd as well, as this will take time to percolate down, even if Al doesn't find
> anything wrong with it.

Thanks for you comments.

Though I'm still learning virtiofsd code, if nobody will try I'm willing to work on this.

> Doing unshare(CLONE_FS) after thread startup seems safe, though must be careful to change the working directory to the root of
> the mount
> *before* starting any threads.

I think working directry is changed in setup_sandbox() -> setup_mount_namespace() -> setup_pivot_root().
So, can we just add unshare(CLONE_FS) in fv_queue_worker()?

Sorry if I'm totally misunderstood the situation.

Thanks,
Misono

