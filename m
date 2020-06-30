From: Vitaly Kuznetsov <vkuznets@redhat.com>
In-Reply-To: <20200629220353.GC269627@redhat.com>
References: <20200625214701.GA180786@redhat.com>
	<87lfkach6o.fsf@vitty.brq.redhat.com>
	<20200626150303.GC195150@redhat.com>
	<874kqtd212.fsf@vitty.brq.redhat.com>
	<20200629220353.GC269627@redhat.com>
Date: Tue, 30 Jun 2020 15:24:43 +0200
Message-ID: <87sgecbs9w.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [Virtio-fs] [RFC PATCH] kvm,
	x86: Exit to user space in case of page fault error
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, pbonzini@redhat.com, sean.j.christopherson@intel.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Mon, Jun 29, 2020 at 10:56:25PM +0200, Vitaly Kuznetsov wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>> 
>> > On Fri, Jun 26, 2020 at 11:25:19AM +0200, Vitaly Kuznetsov wrote:
>> >
>> > [..]
>> >> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> >> > index 76817d13c86e..a882a6a9f7a7 100644
>> >> > --- a/arch/x86/kvm/mmu/mmu.c
>> >> > +++ b/arch/x86/kvm/mmu/mmu.c
>> >> > @@ -4078,7 +4078,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>> >> >  	if (!async)
>> >> >  		return false; /* *pfn has correct page already */
>> >> >  
>> >> > -	if (!prefault && kvm_can_do_async_pf(vcpu)) {
>> >> > +	if (!prefault && kvm_can_do_async_pf(vcpu, cr2_or_gpa >> PAGE_SHIFT)) {
>> >> 
>> >> gpa_to_gfn(cr2_or_gpa) ?
>> >
>> > Will do.
>> >
>> > [..]
>> >> > -bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
>> >> > +bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu, gfn_t gfn)
>> >> >  {
>> >> >  	if (unlikely(!lapic_in_kernel(vcpu) ||
>> >> >  		     kvm_event_needs_reinjection(vcpu) ||
>> >> > @@ -10504,7 +10506,13 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
>> >> >  	 * If interrupts are off we cannot even use an artificial
>> >> >  	 * halt state.
>> >> >  	 */
>> >> > -	return kvm_arch_interrupt_allowed(vcpu);
>> >> > +	if (!kvm_arch_interrupt_allowed(vcpu))
>> >> > +		return false;
>> >> > +
>> >> > +	if (vcpu->arch.apf.error_gfn == gfn)
>> >> > +		return false;
>> >> > +
>> >> > +	return true;
>> >> >  }
>> >> >  
>> >> >  bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>> >> 
>> >> I'm a little bit afraid that a single error_gfn may not give us
>> >> deterministric behavior. E.g. when we have a lot of faulting processes
>> >> it may take many iterations to hit 'error_gfn == gfn' because we'll
>> >> always be overwriting 'error_gfn' with new values and waking up some
>> >> (random) process.
>> >> 
>> >> What if we just temporary disable the whole APF mechanism? That would
>> >> ensure we're making forward progress. Something like (completely
>> >> untested):
>> >> 
>> >> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> >> index f8998e97457f..945b3d5a2796 100644
>> >> --- a/arch/x86/include/asm/kvm_host.h
>> >> +++ b/arch/x86/include/asm/kvm_host.h
>> >> @@ -778,6 +778,7 @@ struct kvm_vcpu_arch {
>> >>  		unsigned long nested_apf_token;
>> >>  		bool delivery_as_pf_vmexit;
>> >>  		bool pageready_pending;
>> >> +		bool error_pending;
>> >>  	} apf;
>> >>  
>> >>  	/* OSVW MSRs (AMD only) */
>> >> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> >> index fdd05c233308..e5f04ae97e91 100644
>> >> --- a/arch/x86/kvm/mmu/mmu.c
>> >> +++ b/arch/x86/kvm/mmu/mmu.c
>> >> @@ -4124,8 +4124,18 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>> >>  	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
>> >>  		return RET_PF_RETRY;
>> >>  
>> >> -	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
>> >> +	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r)) {
>> >> +		/*
>> >> +		 * In case APF mechanism was previously disabled due to an error
>> >> +		 * we are ready to re-enable it here as we're about to inject an
>> >> +		 * error to userspace. There is no guarantee we are handling the
>> >> +		 * same GFN which failed in APF here but at least we are making
>> >> +		 * forward progress.
>> >> +		 */
>> >> +
>> >> +		vcpu->arch.apf.error_pending = false;
>> >
>> > I like this idea. It is simple. But I have a concern with it though.
>> >
>> > - Can it happen that we never retry faulting in error pfn.  Say a process
>> >   accessed a pfn, we set error_pending, and then process got killed due
>> >   to pending signal. Now process will not retry error pfn. And
>> >   error_pending will remain set and we completely disabled APF
>> >   mechanism till next error happens (if it happens).
>> 
>> Can a process in kvm_async_pf_task_wait_schedule() get killed? I don't
>> see us checking signals/... in the loop, just 'if
>> (hlist_unhashed(&n.link))' -- and this only happens when APF task
>> completes. I don't know much about processes to be honest, could easily
>> be wrong completely :-)
>
> I think a waiting process will be woken up and scheduled again. And
> when it is starts running again and goes back to user space (faulting
> instruction was in user space), then we should check for pending SIGNAL
> and kill it.
>
> That's how my patches for sending SIGBUS were working. I queued SIGBUS
> and then when process got scheduled, it got SIGBUS and got killed and
> stopped retrying instruction. (Otherwise this fault cycle will never
> end).
>
> Hence, I think it is possible. Another process can send SIGKILL to
> this process which is waiting for APF. Once APF page ready event
> comes in, process will be killed after that without retrying the
> instruct. I will be glad to be corrected if I understood it wrong.
>

It's probably me who's missing something important here :-) but I think
you describe how it *should* work as I'm not seeing how we can leave the
loop in kvm_async_pf_task_wait_schedule() other than by 
"if (hlist_unhashed(&n.link)) break;" and this only happens when APF
completes.

>> 
>> >
>> > In another idea, we could think of maintaining another hash of error
>> > gfns. Similar to "vcpu->arch.apf.gfns[]". Say "vgpu->arch.apf.error_gfns[]"
>> >
>> > - When error happens on a gfn, add it to hash. If slot is busy, overwrite
>> >   it.
>> >
>> > - When kvm_can_do_async_pf(gfn) is called, check if this gfn is present
>> >   in error_gfn, if yes, clear it and force sync fault.
>> >
>> > This is more complicated but should take care of your concerns. Also 
>> > even if process never retries that gfn, we are fine. At max that
>> > gfn will remain error_gfn array but will not disable APF completely.
>> 
>> Yes, we can do that but I'm not sure it wouldn't be an overkill: we are
>> not trying to protect the mechanism against a malicious guest. Using APF
>> is guest's choice anyway so even if there's going to be an easy way to
>> disable it completely (poke an address and never retry upon wakeup) from
>> guest's side it doesn't sound like a big deal.
>
> Sure but if guest chose APF and then it got disabled completely
> intentionally, then its a probelm, isn't it. This is just a race
> condition which can disable APF unintentionally and leave it like
> that till next error happens. 
>
>> 
>> Also, we can introduce a status bit in the APF 'page ready' notification
>> stating that the page is actually NOT ready and the mecanism was blocked
>> because if that, the guest will have to access the GFN to get the error
>> injected (and unblock the mechanism).
>
> I am not sure how will we force guest to access that pfn if accessing
> process gets killed. This actually feels like least preferred of all
> options.

When guest receives the 'page ready' event with an error it (like for
every other 'page ready' event) tries to wake up the corresponding
process but if the process is dead already it can do in-kernel probing
of the GFN, this way we guarantee that the error is always injected. I'm
not sure if it is needed though but in case it is, this can be a
solution. We can add a new feature bit and only deliver errors when the
guest indicates that it knows what to do with them.

-- 
Vitaly

