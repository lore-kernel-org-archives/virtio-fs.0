Date: Wed, 21 Aug 2019 09:12:33 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190821131233.GB2304@redhat.com>
References: <20190820134545.GA4233@redhat.com>
	<d6fe5b15-5ca4-c189-3319-2b90150704d2@huawei.com>
	<20190820183614.GE4233@redhat.com> <5D5CAE18.50407@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D5CAE18.50407@huawei.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Reset O_DIRECT flag during file
 open
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, aneesh.kumar@linux.vnet.ibm.com

On Wed, Aug 21, 2019 at 10:36:08AM +0800, piaojun wrote:
> 
> 
> On 2019/8/21 2:36, Vivek Goyal wrote:
> > On Tue, Aug 20, 2019 at 10:33:29PM +0800, piaojun wrote:
> >> Hi Vivek & Aneesh,
> >>
> >> On 2019/8/20 21:45, Vivek Goyal wrote:
> >>> If an application wants to do direct IO and opens a file with O_DIRECT
> >>> in guest, that does not necessarily mean that we need to bypass page
> >>> cache on host as well. So reset this flag on host.
> >>
> >> I have a different understanding about this. The I/O mode should be kept
> >> same both in Guest and Host. When doing direct io in Guest, the user may
> >> want the data go to disk rather than kept in Host page cache which means
> >> volatile. So it seems more reasonable that Guest and Host have the same
> >> file I/0 semantics.
> > 
> > I look at it other way. If we open a file O_DIRECT, it should bypass
> > page cache on kernel it is running on. It does not guarantee anything
> > on underlying storage stack. For example, virtual block device or physical
> > disks could still be caching data with O_DIRECT.
> > 
> > To me same analogy should apply for caching on host. Atleast by default
> > O_DIRECT should only mean bypassing page cache in guest. If there is
> > an application which requires bypassing page cache on host as well, then
> > it should be a server option to control this behavior. But we can do when
> > there is a real user.
> 
> This strategy also looks good to me if the user could control caches
> both in Guest and Host separatly. So the knob you mentioned will be OK.

I am not adding any more knobs right now. Once there are real users who
need this functionality, we can add it later.

Thanks
Vivek

