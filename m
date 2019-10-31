DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=rcVRXAcFrnCuqHU04xI3xLY+QoninWBY9E19K2Hm/s8=;
	b=P/S9F0jAi3i0HLjoPTq4jM2zw/HfAv3q0pUyRqrupwDngK7r1Z1w6lkzajlrGZ2Zm2Z+qk+i+PzX/zyHyRQxvxzV2MFEIJi/t+H9qbCXznzoCgSJMd9znGZ48HFobR9vSNfQGn6GuPbWw5n7JaveSeA9dn2MJi3sRYJVScf8L5E=
From: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
Date: Thu, 31 Oct 2019 09:39:23 +0000
Message-ID: <OSBPR01MB3783739E4F9545DABEF3E230E5630@OSBPR01MB3783.jpnprd01.prod.outlook.com>
References: <20191023122523.1816-1-misono.tomohiro@jp.fujitsu.com>
	<20191023200752.GB6942@redhat.com> <20191024150225.GB6903@redhat.com>
	<OSBPR01MB3783EBE1BB481BD1B14B8D45E5650@OSBPR01MB3783.jpnprd01.prod.outlook.com>
	<OSBPR01MB37833C9325AD3D9190108FAEE5610@OSBPR01MB3783.jpnprd01.prod.outlook.com>
In-Reply-To: <OSBPR01MB37833C9325AD3D9190108FAEE5610@OSBPR01MB3783.jpnprd01.prod.outlook.com>
Content-Language: ja-JP
Content-Type: text/plain; charset="iso-2022-jp"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Fix data corruption with
 O_APPEND wirte in writeback mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: 'Vivek Goyal' <vgoyal@redhat.com>
Cc: "'virtio-fs@redhat.com'" <virtio-fs@redhat.com>, "'qemu-devel@nongnu.org'" <qemu-devel@nongnu.org>

> > -----Original Message-----
> > From: virtio-fs-bounces@redhat.com
> > [mailto:virtio-fs-bounces@redhat.com] On Behalf Of
> > misono.tomohiro@fujitsu.com
> > Sent: Friday, October 25, 2019 7:02 PM
> > To: 'Vivek Goyal' <vgoyal@redhat.com>
> > Cc: virtio-fs@redhat.com; qemu-devel@nongnu.org
> > Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Fix data corruption with
> > O_APPEND wirte in writeback mode
> >
> > > On Wed, Oct 23, 2019 at 04:07:52PM -0400, Vivek Goyal wrote:
> > > > On Wed, Oct 23, 2019 at 09:25:23PM +0900, Misono Tomohiro wrote:
> > > > > When writeback mode is enabled (-o writeback), O_APPEND handling
> > > > > is done in kernel. Therefore virtiofsd clears O_APPEND flag when open.
> > > > > Otherwise O_APPEND flag takes precedence over pwrite() and write
> > > > > data may corrupt.
> > > > >
> > > > > Currently clearing O_APPEND flag is done in lo_open(), but we
> > > > > also need the same operation in lo_create().
> > > >
> > > > > So, factor out the flag
> > > > > update operation in lo_open() to update_open_flags() and call it
> > > > > in both lo_open() and lo_create().
> > > > >
> > > > > This fixes the failure of xfstest generic/069 in writeback mode
> > > > > (which tests O_APPEND write data integrity).
> > > > >
> > >
> > > Hi Misono,
> > >
> > > Have you tried running pjdfstests. Looks like with the patch applied
> > > I see following tests failing which were passing without the patch.
> > > Can you please have a look. I ran daemon with options "-o
> > cache=always -o writeback"
> 
> I see these errors in both with and without this patch but not always.
> Do you always see the failure?
> 
> I use:
>   Kernel: Fuse's for-next branch
>   Qemu: virtio-fs-dev branch
>   backend: XFS (relatime)
> 
> These tests fail because a/c/m time is not updated as expected.
> So it seems this is related to the failure of xfstest generic/003.
> I will look into the problem more.
> 

Hi,

So I fugured out the problem. 
The failure occurs when guest clock is earlier than host clock in writeback mode.

The failure case checks:
 1. get current c/time of file
 2. sleep 1 second
 3. modify file's metadata/data
 4. check if c/mtime is updated

And the tests fail because:
 1. when file is opened, guest inode's time is initialized by host's inode information
 2. In writeback mode, guest clock is used for c/mtime update
 3. if guest clock is earlier than host clock, c/mtime could be updated
    earlier than current inode time. 

I can reproduce the problem reliably by deliberately setting guest clock earlier
than host clock. I'm not sure if virtiofs is to be blmaed in this case, but should
we not update c/mtime in guest if it is earlier then current c/mtime?

Anyway, I believe this O_APPEND fix patch is irrelevant to the problem,
could you please check it again?

Thanks,
Misono

