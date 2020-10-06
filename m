Date: Tue, 6 Oct 2020 09:12:00 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
Message-ID: <20201006161200.GB17610@linux.intel.com>
References: <20201002200214.GB10232@redhat.com>
	<20201002211314.GE24460@linux.intel.com>
	<20201005153318.GA4302@redhat.com>
	<20201005161620.GC11938@linux.intel.com>
	<20201006134629.GB5306@redhat.com>
	<877ds38n6r.fsf@vitty.brq.redhat.com>
	<20201006141501.GC5306@redhat.com>
	<874kn78l2z.fsf@vitty.brq.redhat.com>
	<20201006150817.GD5306@redhat.com>
	<871rib8ji1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
In-Reply-To: <871rib8ji1.fsf@vitty.brq.redhat.com>
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
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com, kvm@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org

On Tue, Oct 06, 2020 at 05:24:54PM +0200, Vitaly Kuznetsov wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> > So you will have to report token (along with -EFAULT) to user space. So this
> > is basically the 3rd proposal which is extension of kvm API and will
> > report say HVA/GFN also to user space along with -EFAULT.
> 
> Right, I meant to say that guest kernel has full register state of the
> userspace process which caused APF to get queued and instead of trying
> to extract it in KVM and pass to userspace in case of a (later) failure
> we limit KVM api change to contain token or GFN only and somehow keep
> the rest in the guest. This should help with TDX/SEV-ES.

Whatever gets reported to userspace should be identical with and without
async page faults, i.e. it definitely shouldn't have token information.

Note, TDX doesn't allow injection exceptions, so reflecting a #PF back
into the guest is not an option.  Nor do I think that's "correct"
behavior (see everyone's objections to using #PF for APF fixed).  I.e. the
event should probably be an IRQ.

