DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=QBLTyGqlHZCgObDk8Tr6nGXs3RyMMnyywHENnM9TerE=;
	b=ggB4nwd7Py5NXYnnYqRsil4n2m2qGQORtmbt1HKvDWiEipJKu2/lsXbfBMCln1LcJuFwcY09JeUsKKZh1iBaTX6nuM4761WDAceHrjKrIMCqJLa+K/u35SpLKLPSRzgysiTG0zxgVrN/FhAjHyPtfMnBlPGzfcOcSSAkX9B8EmA=
From: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
Date: Fri, 31 Jan 2020 02:06:51 +0000
Message-ID: <OSBPR01MB458283800922F1C74C094ABDE5070@OSBPR01MB4582.jpnprd01.prod.outlook.com>
References: <20200128101819.21766-1-misono.tomohiro@jp.fujitsu.com>
	<20200130141350.GA21264@redhat.com>
In-Reply-To: <20200130141350.GA21264@redhat.com>
Content-Language: ja-JP
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v2 0/2] virtiofsd: Fix xattr and ACL
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

> On Tue, Jan 28, 2020 at 07:18:17PM +0900, Misono Tomohiro wrote:
> > Hi,
> >
> > This is a second version of xattr fix for virtiofsd.
> > I included ACL fix (which introduces new option posix_acl) in this
> > version too as ACL mostly depends on xattr.
> >
> > I run xfstests with XFS backend using "-o xattr -o posix_acl" option
> > and only new failure is generic/375 which checks if sgid bit is
> > cleared after setfacl. I'll try to investigate it.
> >
> > change in v1 -> v2
> >  - rebased to current dev branch
> >
> >  - Always chdir for xattr (1st patch)
> >    In v1, I keep current implementation for regular file/dir since it
> >    show better performance in my environment. But I notice opening file
> >    for xattr causes seek sanity test fails (xfstest generic/285, 436).
> >
> >    I'm not sure what is the fundamental problem here but I believe
> >    performance can be improved by introducing some caching mechanism
> >    in general.
> 
> Hi Misono,
> 
> How much is performance degradation due to fchdir(). If it is significant, then I will be inclined to keep original code for dir/file
> till some other mechanism is introduced to offset the perofrmance loss.

Please refer this replay: https://www.redhat.com/archives/virtio-fs/2020-January/msg00063.html

> 
> > So I change the code to always fchdir to avoid the
> >    problem for now. This results in simpler code too.
> >
> >  - Add ACL fix (2nd patch)
> >    ACL mostly works if xattr option is enabled.
> >    To support default ACL behavior, add new option posix_acl which
> >    handles umasking in virtiofsd instead of guest kernel.
> 
> Ideally I would preferred ACL changes in a separapte patch series. We had been discussing xattr related changes and it will be
> easier to test and review xattr changes and then followed by ACL changes. 

One motivation I included ACL fix comes from the fact that -o xattr option also enables ACL.

> Anyway, now you have already posted these changes in smae patch series, I will review it.
> But if you happen to post another patch series, then lets separate out xattr changes and ACL changes in separate patch series.

Thanks, If it is better I will do it next version.
(btw, I take a leave next week so my response will be delayed) 

Thanks for all the comments!
Misono

> 
> Thanks
> Vivek
> 
> >
> > Thanks,
> > Misono
> >
> > Misono Tomohiro (2):
> >   virtiofsd: Fix xattr operations
> >   virtiofsd: Add support of posix_acl
> >
> >  tools/virtiofsd/fuse_virtio.c    |  13 +++
> >  tools/virtiofsd/helper.c         |   3 +
> >  tools/virtiofsd/passthrough_ll.c | 136 +++++++++++++++++++++----------
> >  tools/virtiofsd/seccomp.c        |  11 ++-
> >  4 files changed, 115 insertions(+), 48 deletions(-)
> >
> > --
> > 2.21.1
> >


