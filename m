Date: Fri, 14 Feb 2020 15:37:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200214203725.GA31140@redhat.com>
References: <20200128101819.21766-1-misono.tomohiro@jp.fujitsu.com>
	<20200130141350.GA21264@redhat.com>
	<OSBPR01MB458283800922F1C74C094ABDE5070@OSBPR01MB4582.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSBPR01MB458283800922F1C74C094ABDE5070@OSBPR01MB4582.jpnprd01.prod.outlook.com>
Subject: Re: [Virtio-fs] [PATCH v2 0/2] virtiofsd: Fix xattr and ACL
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

On Fri, Jan 31, 2020 at 02:06:51AM +0000, misono.tomohiro@fujitsu.com wrote:
> > On Tue, Jan 28, 2020 at 07:18:17PM +0900, Misono Tomohiro wrote:
> > > Hi,
> > >
> > > This is a second version of xattr fix for virtiofsd.
> > > I included ACL fix (which introduces new option posix_acl) in this
> > > version too as ACL mostly depends on xattr.
> > >
> > > I run xfstests with XFS backend using "-o xattr -o posix_acl" option
> > > and only new failure is generic/375 which checks if sgid bit is
> > > cleared after setfacl. I'll try to investigate it.
> > >
> > > change in v1 -> v2
> > >  - rebased to current dev branch
> > >
> > >  - Always chdir for xattr (1st patch)
> > >    In v1, I keep current implementation for regular file/dir since it
> > >    show better performance in my environment. But I notice opening file
> > >    for xattr causes seek sanity test fails (xfstest generic/285, 436).
> > >
> > >    I'm not sure what is the fundamental problem here but I believe
> > >    performance can be improved by introducing some caching mechanism
> > >    in general.
> > 
> > Hi Misono,
> > 
> > How much is performance degradation due to fchdir(). If it is significant, then I will be inclined to keep original code for dir/file
> > till some other mechanism is introduced to offset the perofrmance loss.
> 
> Please refer this replay: https://www.redhat.com/archives/virtio-fs/2020-January/msg00063.html

As per your email, regression due to fchdir() seems to be in the range of
5% to 10%. It is not trivial, IMO. May be its a good idea to keep original
logic and use fchdir() only when need be.

Thanks
Vivek

