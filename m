Date: Thu, 18 Jun 2020 08:47:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200618124700.GA3814@redhat.com>
References: <20200616214847.24482-1-vgoyal@redhat.com>
	<20200616214847.24482-3-vgoyal@redhat.com>
	<87lfklhm58.fsf@vitty.brq.redhat.com>
	<20200617183224.GK26818@linux.intel.com>
	<20200617215152.GF26770@redhat.com>
	<20200617230052.GB27751@linux.intel.com>
	<20200617230548.GC27751@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617230548.GC27751@linux.intel.com>
Subject: Re: [Virtio-fs] [PATCH 2/3] kvm: Add capability to be able to
 report async pf error to guest
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: wanpengli@tencent.com, kvm@vger.kernel.org, miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, pbonzini@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>

On Wed, Jun 17, 2020 at 04:05:48PM -0700, Sean Christopherson wrote:
> On Wed, Jun 17, 2020 at 04:00:52PM -0700, Sean Christopherson wrote:
> > On Wed, Jun 17, 2020 at 05:51:52PM -0400, Vivek Goyal wrote:
> > What I'm saying is that KVM cannot do the filtering.  KVM, by design, does
> > not know what lies behind any given hva, or what the associated gpa maps to
> > in the guest.  As is, userspace can't even opt out of this behavior, e.g.
> > it can't even "filter" on a per-VM granularity, since kvm_pv_enable_async_pf()
> > unconditionally allows the guest to enable the behavior[*].
> 
> Let me rephrase that slightly.  KVM can do the filtering, but it cannot make
> the decision on what to filter.  E.g. if the use case is compatible with doing
> this at a memslot level, then a memslot flag could be added to control the
> behavior.

Ok, may be. But what is that thing which you want to filter out. Just
creating a framework for filtering selective regions without any specific
use case is hard.

Right now we have one switch to enable/disable error reporting and
this can be turned off both at qemu level as well as guest level.

If the desire is that this needs to me more finer grained, I need
to have some examples which show that in these cases we don't want
to report page fault errors.

Anyway, it seems that atleast first patch is less contentious and
can be relatively easily be done. That is exit to user space if
page fault error happens instead of getting into an infinite loop.
I will post that separately.

Thanks
Vivek

