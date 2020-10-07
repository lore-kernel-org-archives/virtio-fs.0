Date: Tue, 6 Oct 2020 17:04:24 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
Message-ID: <20201007000424.GD28981@linux.intel.com>
References: <20201006134629.GB5306@redhat.com>
	<877ds38n6r.fsf@vitty.brq.redhat.com>
	<20201006141501.GC5306@redhat.com>
	<874kn78l2z.fsf@vitty.brq.redhat.com>
	<20201006150817.GD5306@redhat.com>
	<871rib8ji1.fsf@vitty.brq.redhat.com>
	<20201006161200.GB17610@linux.intel.com>
	<87y2kj71gj.fsf@vitty.brq.redhat.com>
	<20201006171704.GC17610@linux.intel.com>
	<20201006173527.GG5306@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20201006173527.GG5306@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v4] kvm,
	x86: Exit to user space in case page fault error
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org

On Tue, Oct 06, 2020 at 01:35:27PM -0400, Vivek Goyal wrote:
> On Tue, Oct 06, 2020 at 10:17:04AM -0700, Sean Christopherson wrote:
> 
> [..]
> > > > Note, TDX doesn't allow injection exceptions, so reflecting a #PF back
> > > > into the guest is not an option.  
> > > 
> > > Not even #MC? So sad :-)
> > 
> > Heh, #MC isn't allowed either, yet...
> 
> If #MC is not allowd, logic related to hwpoison memory will not work
> as that seems to inject #MC.

Yep.  Piggybacking #MC is undesirable for other reasons, e.g. adds a "hardware"
dependency for what is really a paravirt feature.

