DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=7obl6Fp+/DjgBAh+ym2fyHr0OgVa5nDHOGYUXxF5LCg=;
	b=DqfAJMC05AjUecUVmkxv1zAw9q
	r8h+EKukE8S2pxoOFKBn2CuSgV21HF4EmoeIIZroA78zWGWRIt4mRmS9JaNJfvpbtBiWj4m1IPg/E
	+/T8j/H0FXF6IZN35fgs4GZDSMMSmsdtt/W1iv4ZHseuHlYiw2x5oZV115v4dZWMek4+tBy7bNvW2
	O3Vbw07MAJ6MM52oGKxnJjtUPvSyvXCwqB2Zq6hL7jjBqklcC/+8RBBMi/ICwi9CJGO+K4NywoS9y
	Ic6tG4x9JjVdVBg/Q4A7ButVQKkH3CK+HkHg25qho8y6sQO6F7Qr8umSJu11vQ9NA1AwzVDsE5vms
	ppQvLLBWQOduuh5gcpUm/K/niCjMFTOw0CFPAPzXton+bPwlYOxXRzxgV0IzMK3dFS0StD8sV9+TL
	BcT+o9bRw6dyS25NMwv8Oxl4xO1xdawB1+i76dn8XHqh/E7BjBR+nOHL/yHamI/3fhhcQKUel0710
	k6daK+vTKv2mWA/Yb175XVYJNJd1ESNVgtdOl+ROp8tFa6quaJL8F4W2OFyt3CEjhA621pLMXAZcR
	k3OQCBOYh7C1ixQ3/vn31LAimZ7KfmMjQhNyOjYdmP0skAoj8hZ+bPRtLxGowD6ff3Y1FtDOmo4TS
	rMAf/es031cmoI+cU3fyZh54xQuJEiTRdXaEog6c8=
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Fri, 19 Feb 2021 18:33:46 +0100
Message-ID: <2709384.cAWMFGR5kF@silver>
In-Reply-To: <20210219160848.GB3270@redhat.com>
References: <20200918213436.GA3520@redhat.com> <17216624.eqST2d0sUl@silver>
	<20210219160848.GB3270@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: Re: [Virtio-fs] Can not set high msize with virtio-9p (Was: Re:
	virtiofs vs 9p performance)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "cdupontd@redhat.com" <cdupontd@redhat.com>, "Venegas Munoz,
	Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, virtio-fs-list <virtio-fs@redhat.com>, "Shinde,
	Archana M" <archana.m.shinde@intel.com>, Vivek Goyal <vgoyal@redhat.com>

On Freitag, 19. Februar 2021 17:08:48 CET Vivek Goyal wrote:
> On Fri, Sep 25, 2020 at 10:06:41AM +0200, Christian Schoenebeck wrote:
> > On Freitag, 25. September 2020 00:10:23 CEST Vivek Goyal wrote:
> > > In my testing, with cache=none, virtiofs performed better than 9p in
> > > all the fio jobs I was running. For the case of cache=auto  for virtiofs
> > > (with xattr enabled), 9p performed better in certain write workloads. I
> > > have identified root cause of that problem and working on
> > > HANDLE_KILLPRIV_V2 patches to improve WRITE performance of virtiofs
> > > with cache=auto and xattr enabled.
> > 
> > Please note, when it comes to performance aspects, you should set a
> > reasonable high value for 'msize' on 9p client side:
> > https://wiki.qemu.org/Documentation/9psetup#msize
> 
> Hi Christian,
> 
> I am not able to set msize to a higher value. If I try to specify msize
> 16MB, and then read back msize from /proc/mounts, it sees to cap it
> at 512000. Is that intended?

9p server side in QEMU does not perform any msize capping. The code in this
case is very simple, it's just what you see in function v9fs_version():

https://github.com/qemu/qemu/blob/6de76c5f324904c93e69f9a1e8e4fd0bd6f6b57a/hw/9pfs/9p.c#L1332

> $ mount -t 9p -o trans=virtio,version=9p2000.L,cache=none,msize=16777216
> hostShared /mnt/virtio-9p
> 
> $ cat /proc/mounts | grep 9p
> hostShared /mnt/virtio-9p 9p
> rw,sync,dirsync,relatime,access=client,msize=512000,trans=virtio 0 0
> 
> I am using 5.11 kernel.

Must be something on client (guest kernel) side. I don't see this here with
guest kernel 4.9.0 happening with my setup in a quick test:

$ cat /etc/mtab | grep 9p
svnRoot / 9p rw,dirsync,relatime,trans=virtio,version=9p2000.L,msize=104857600,cache=mmap 0 0
$ 

Looks like the root cause of your issue is this:

struct p9_client *p9_client_create(const char *dev_name, char *options)
{
	...
	if (clnt->msize > clnt->trans_mod->maxsize)
		clnt->msize = clnt->trans_mod->maxsize;

https://github.com/torvalds/linux/blob/f40ddce88593482919761f74910f42f4b84c004b/net/9p/client.c#L1045

Best regards,
Christian Schoenebeck


