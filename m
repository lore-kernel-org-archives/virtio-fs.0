DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=riT6AVEJgwn+PmSTyXL1HofigTgFsXoXcX9J9RDhsz4=;
	b=qIdXBxhL6PrPPezsuUYZVoxj34IFLfzqksDbhy8dfQ7U9a0f1Ku9xWY+aIgHFTaHuNYQdfPnaEWGmlspoPYXCWEEKhJLfB1rPSznyOmdWxBoTtO5Q38WqNzFd7jkt6ybqZRx494l5UzG2gExPd0h6KGfLmExt/E4877o5HFH0ls=
From: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
Date: Thu, 27 Feb 2020 05:20:53 +0000
Message-ID: <OSBPR01MB4582CCBF920F0817BC318BBFE5EB0@OSBPR01MB4582.jpnprd01.prod.outlook.com>
References: <20200220114704.11592-1-misono.tomohiro@jp.fujitsu.com>
	<20200221185047.GE25974@redhat.com>
In-Reply-To: <20200221185047.GE25974@redhat.com>
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
Cc: "'virtio-fs@redhat.com'" <virtio-fs@redhat.com>

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
> >
> > One question; I remove error handling of fchdir() in v3 since I
> > believe fchdir to proc_self_fd/root.fd cannot fail in the situation
> > but should I add error handling?
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
> 
> Hi Misono,
> 
> This patchset passes my basic test. I have not run xfstests. I am relying on your testing.
> 
> Can you please take care of minor nits I had and repost patces. I will ack it.

Thanks for review/comments. I will update the patches and send them soon.

Thanks,
Misono

> 
> Thanks
> Vivek
> 
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
> >
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs


