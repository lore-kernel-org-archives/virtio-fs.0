Date: Fri, 24 Apr 2020 10:15:00 +0800
From: Eryu Guan <eguan@linux.alibaba.com>
Message-ID: <20200424021500.GT47669@e18g06458.et15sqa>
References: <5D4D0D06.1090602@huawei.com>
	<20190821153802.GB9095@stefanha-x1.localdomain>
	<5D633104.6030000@huawei.com>
	<20190827144258.GF6901@stefanha-x1.localdomain>
	<5D66279D.5000507@huawei.com>
MIME-Version: 1.0
In-Reply-To: <5D66279D.5000507@huawei.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH][RFC] Support multiqueue mode by setting cpu
 affinity
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: virtio-fs@redhat.com

Hi Jun,

On Wed, Aug 28, 2019 at 03:05:01PM +0800, piaojun wrote:
> 
> 
> On 2019/8/27 22:42, Stefan Hajnoczi wrote:
> > On Mon, Aug 26, 2019 at 09:08:20AM +0800, piaojun wrote:
> >> On 2019/8/21 23:38, Stefan Hajnoczi wrote:
> >>> On Fri, Aug 09, 2019 at 02:04:54PM +0800, piaojun wrote:
> >>>> Set cpu affinity for each queue in multiqueue mode to improve the iops
> >>>> performance.

[snip]

> > 
> > Doing the setup before entering the sandbox sounds like a good idea.
> > That way the sandbox does not need to whitelist the required syscalls.
> > 
> > Will you add an option similar to:
> > 
> >   --request-queues N
> >   --request-queue-cpu-affinity N=CPU_A[,CPU_B][-CPU_C]
> > 
> > ?
> 
> I'm writing the multi-queue code for virtiofsd according to your
> suggestion, but the final shape may look a bit different.

Just curious, what's the status of this multi-queue support? I'd like to
try it out :)

Thanks,
Eryu


