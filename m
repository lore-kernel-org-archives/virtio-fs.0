Date: Thu, 1 Oct 2020 15:33:20 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
Message-ID: <20201001223320.GI7474@linux.intel.com>
References: <20200720211359.GF502563@redhat.com>
	<20200929043700.GL31514@linux.intel.com>
	<20201001215508.GD3522@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20201001215508.GD3522@redhat.com>
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
Cc: virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com, vkuznets@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org

On Thu, Oct 01, 2020 at 05:55:08PM -0400, Vivek Goyal wrote:
> On Mon, Sep 28, 2020 at 09:37:00PM -0700, Sean Christopherson wrote:
> > On Mon, Jul 20, 2020 at 05:13:59PM -0400, Vivek Goyal wrote:
> > > @@ -10369,6 +10378,36 @@ void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
> > >  }
> > >  EXPORT_SYMBOL_GPL(kvm_set_rflags);
> > >  
> > > +static inline u32 kvm_error_gfn_hash_fn(gfn_t gfn)
> > > +{
> > > +	BUILD_BUG_ON(!is_power_of_2(ERROR_GFN_PER_VCPU));
> > > +
> > > +	return hash_32(gfn & 0xffffffff, order_base_2(ERROR_GFN_PER_VCPU));
> > > +}
> > > +
> > > +static void kvm_add_error_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> > > +{
> > > +	u32 key = kvm_error_gfn_hash_fn(gfn);
> > > +
> > > +	/*
> > > +	 * Overwrite the previous gfn. This is just a hint to do
> > > +	 * sync page fault.
> > > +	 */
> > > +	vcpu->arch.apf.error_gfns[key] = gfn;
> > > +}
> > > +
> > > +/* Returns true if gfn was found in hash table, false otherwise */
> > > +static bool kvm_find_and_remove_error_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> > > +{
> > > +	u32 key = kvm_error_gfn_hash_fn(gfn);
> > 
> > Mostly out of curiosity, do we really need a hash?  E.g. could we get away
> > with an array of 4 values?  2 values?  Just wondering if we can avoid 64*8
> > bytes per CPU.
> 
> We are relying on returning error when guest task retries fault. Fault
> will be retried on same address if same task is run by vcpu after
> "page ready" event. There is no guarantee that same task will be
> run. In theory, this cpu could have a large number of tasks queued
> and run these tasks before the faulting task is run again. Now say
> there are 128 tasks being run and 32 of them have page fault
> errors. Then if we keep 4 values, newer failures will simply
> overwrite older failures and we will keep spinning instead of
> exiting to user space.
> 
> That's why this array of 64 gfns and add gfns based on hash. This
> does not completely elimiante the above possibility but chances
> of one hitting this are very very slim.

But have you actually tried such a scenario?  In other words, is there good
justification for burning the extra memory?

Alternatively, what about adding a new KVM request type to handle this?
E.g. when the APF comes back with -EFAULT, snapshot the GFN and make a
request.  The vCPU then gets kicked and exits to userspace.  Before exiting
to userspace, the request handler resets vcpu->arch.apf.error_gfn.  Bad GFNs
simply get if error_gfn is "valid", i.e. there's a pending request.

That would guarantee the error is propagated to userspace, and doesn't lose
any guest information as dropping error GFNs just means the guest will take
more page fault exits.

> > One thought would be to use the index to handle the case of no error gfns so
> > that the size of the array doesn't affect lookup for the common case, e.g.
> 
> We are calculating hash of gfn (used as index in array). So lookup cost
> is not driven by size of array. Its O(1) and not O(N). We just lookup
> at one element in array and if it does not match, we return false.
> 
> 	u32 key = kvm_error_gfn_hash_fn(gfn);
> 
> 	if (vcpu->arch.apf.error_gfns[key] != gfn)
> 		return 0;
> 
> 
> > 
> > 	...
> > 
> > 		u8 error_gfn_head;
> > 		gfn_t error_gfns[ERROR_GFN_PER_VCPU];
> > 	} apf;	
> > 
> > 
> > 	if (vcpu->arch.apf.error_gfn_head == 0xff)
> > 		return false;
> > 
> > 	for (i = 0; i < vcpu->arch.apf.error_gfn_head; i++) {
> > 		if (vcpu->arch.apf.error_gfns[i] == gfn) {
> > 			vcpu->arch.apf.error_gfns[i] = INVALID_GFN;
> > 			return true;
> > 		}
> > 	}
> > 	return true;
> > 
> > Or you could even avoid INVALID_GFN altogether by compacting the array on
> > removal.  The VM is probably dead anyways, burning a few cycles to clean
> > things up is a non-issue.  Ditto for slow insertion.
> 
> Same for insertion. Its O(1) and not dependent on size of array. Also
> insertion anyway is very infrequent event because it will not be
> often that error will happen.

I know, I was saying that if we move to an array then we'd technically be
subject to O(whatever) search and delete, but that it's irrelevant from a
performance perspective because the guest is already toast if it hits a bad
GFN.

> > > +
> > > +	if (vcpu->arch.apf.error_gfns[key] != gfn)
> > > +		return 0;
> > 
> > Should be "return false".
> 
> Will fix.
> 
> Thanks
> Vivek
> 

