DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=hyper-sh.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=c9gTx/1j6AU0mFmnHn80cswnwj1fIRvo2LDz/thRzik=;
	b=wj/cFmrK4dJQiUXQYHXGGj4mnkg0x3sAGCORTat6ir3K7nAJEfLKS6SllSlEDkSwXv
	XVgG2hxUcsQIn3h+0nwLa72YipiQkEPR0wBvJ0bgoNbrzyBAPwOWEwdC6XOvuGeC0+Pp
	X4nYvnMG9ylv9Ghxcmvncbw743aVH+jJDfkeulr8yxCwi4ZmSTRYXejERmMZBjvuRzuz
	UnplzenOUDL9gXxp2M1WElEe6Sf6ks9jJ+R/1hrcEH6gvh3kTuOuId18QwjSGSzd+jyN
	olHIQVRxgCVliiwH8VizDeK0QuGV1JnuqZY/mfumO+pmZAChD8znvceXYkTonUms0nZ4
	Uuog==
MIME-Version: 1.0
References: <20190704104650.GF1609@stefanha-x1.localdomain>
	<5D1ED564.6040705@huawei.com>
	<20190705080401.GC10995@stefanha-x1.localdomain>
In-Reply-To: <20190705080401.GC10995@stefanha-x1.localdomain>
From: Peng Tao <bergwolf@hyper.sh>
Date: Fri, 5 Jul 2019 16:14:24 +0800
Message-ID: <CACGKRzUCvUsghMR5t3aC4XRgi14xbRVFz+gZEnA+s63tShn1Pg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Jul 5, 2019 at 4:04 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Fri, Jul 05, 2019 at 12:43:16PM +0800, piaojun wrote:
> > From your description, virtiofsd does the same work as SPDK, and I
> > wonder if we could adapt it to SPDK-vhost-fs which is widely used.
>
> I don't see 9P code in spdk.git/master.  How does the guest access
> SPDK's vhost-fs device and where is the code?
>
> A quick look at blobfs suggests additional work is needed to introduce
> the concept of inodes instead of performing path name traversal on most
> operations.  This also changes the semantics of the file system since
> POSIX files can still be accessed after they are unlinked or renamed.
>
> In theory SPDK can implement the vhost-user-fs device interface and
> replace virtiofsd but SPDK needs a POSIX file system implementation
> first.
Intel has presented virtiofsd+blobfs+SPDK in KubeCon Shanghai last
month. As you have spotted, the main problem is on blobfs side and
virtio-fs DAX sharing is not working because of blobfs limitation.

Cheers,
Tao
-- 
Into something rich and strange.

