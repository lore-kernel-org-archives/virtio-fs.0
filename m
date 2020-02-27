DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=Xjv4zXdAY9jn9uIxUYsqbC+VpGkusRQsrmDMoonPCMI=;
	b=KmWZKZZ8eeOMu9E8hRybeMsGfBH+EVqNjTS/W+Wlj7DiR7f8VMzP86IptbVTItOgLFGkKsRpDeD9ooZqUYhS+PROzU/Q2I+flgJSO+5h/vcpsyhMVLQumDgpWxb01RET6Kin8s8CPCe8KLiqEI9zEVzfepIOcQck/0PQoW+iL8Y=
From: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
Date: Thu, 27 Feb 2020 05:16:21 +0000
Message-ID: <OSBPR01MB45820867DC2EBE6B20CFDDCAE5EB0@OSBPR01MB4582.jpnprd01.prod.outlook.com>
References: <20200220114704.11592-1-misono.tomohiro@jp.fujitsu.com>
	<20200221151835.GB25974@redhat.com>
In-Reply-To: <20200221151835.GB25974@redhat.com>
Content-Language: ja-JP
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v3 0/2] Fix xattr operation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: 'Vivek Goyal' <vgoyal@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

> On Thu, Feb 20, 2020 at 08:47:02PM +0900, Misono Tomohiro wrote:
> > This fixes the xattr operation for directory and special files (which
> > can be tested by xfstests generic/062 with -o xattr option).
> >
> > The overall logic is switched back to the same as v1 in favor of
> > performance (i.e. keep original implementation for regular
> > files/directories) but I add a cleanup patch to improve readability as requested by Vivek.
> >
> > Known issue is that if xattr enabled, seek sanity tests (generic/285,
> > 436) will fail. However, I understand this is not a very serious bug
> > like data corruption so leave it for now.
> 
> Hi Misono,
> 
> Do you know why generic/285 and generic/436 fail with xattr enabled.  Is it something easily fixable later.

Not sure if it can be fixed easily, but here is what I figured out:

The failure case checks lseek SEEK_DATA/SEEK_HOLE with some unwritten extent (by fallocate).
I notice that open/close affects lseek behavior in that case on xfs: 

# on xfs
 xfs_io> open -ft temp
 xfs_io> falloc 0 40k
 xfs_io> seek -a 0 # show both SEEK_HOLE/SEEK_DATA with offset 0
 Whence  Result
 HOLE    0      # hole only (fallocated block is treated as hole at this time)

# close and open again
 xfs_io> close
 xfs_io> open temp
 xfs_io> seek -a 0
 Whence  Result
 DATA    0       # fallocated block is treated as data now
 HOLE    40960  # hole position is now EOF

I have not yet understand what really causes this in detail (didn't check other fs neither).

Since getxattr operation happens during the test to check "security.capability"
file attribute when writing some data, it seems this behavior affects the test on virtiofs with xfs.

Thanks.
Misono

> 
> >
> > One question; I remove error handling of fchdir() in v3 since I
> > believe fchdir to proc_self_fd/root.fd cannot fail in the situation
> > but should I add error handling?
> 
> I would think its good to have error handling for fchdir() case. We don't expect it, but if something goes wrong, we will like
> to catch it.
> 
> Thanks
> Vivek
> 
> >
> > change v2 -> v3:
> >  - rebased to current dev branch
> >  - add cleanup path (first one) to simplify main patch (second patch)
> >  - restore the logic of v1 in favor of performance
> >    (as a result seek sanity test failure is not fixed by this series)
> >  - remove error handling of fchdir
> >  - drop ACL fix included in v2 for now to focus xattr
> >
> > v2 patch:
> > https://www.redhat.com/archives/virtio-fs/2020-January/msg00131.html
> >
> > Thanks!
> >
> > Misono Tomohiro (2):
> >   virtiofs: passthrough_ll: cleanup getxattr/listxattr
> >   virtiofs: Fix xattr operations
> >
> >  tools/virtiofsd/fuse_virtio.c    |  13 +++
> >  tools/virtiofsd/passthrough_ll.c | 141 +++++++++++++++----------------
> >  tools/virtiofsd/seccomp.c        |   6 ++
> >  3 files changed, 87 insertions(+), 73 deletions(-)
> >
> > --
> > 2.21.1
> >


