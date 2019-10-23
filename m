Date: Wed, 23 Oct 2019 10:58:36 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20191023095836.GC2834@work-vm>
References: <20191021150414.GD5837@work-vm>
	<20191022155641.GA762@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022155641.GA762@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] Upstreaming virtiofsd
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

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Mon, Oct 21, 2019 at 04:04:14PM +0100, Dr. David Alan Gilbert wrote:
> > Hi,
> >   I've started upstreaming virtiofsd to qemu's contrib directory;
> > my first set (
> > https://lists.gnu.org/archive/html/qemu-devel/2019-10/msg05200.html )
> > is a minimal base set of patches that mounts and basically works - it
> > has none of the security work, the performance or many of the fixes.
> > 
> > In parallel with responding to any comments on that set, I'll be
> > working up the security set to be sent next; then performance and then
> > fixes.
> 
> Please include "[PATCH 0/2] virtiofsd: add net and pid namespace
> sandboxing" (<20191016160157.12414-1-stefanha@redhat.com>) in the
> security patch series.

Yep, got those.

Dave

> Thanks,
> Stefan


--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

