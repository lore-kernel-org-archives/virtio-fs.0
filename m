Date: Wed, 17 Jun 2020 11:32:24 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
Message-ID: <20200617183224.GK26818@linux.intel.com>
References: <20200616214847.24482-1-vgoyal@redhat.com>
	<20200616214847.24482-3-vgoyal@redhat.com>
	<87lfklhm58.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
In-Reply-To: <87lfklhm58.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: wanpengli@tencent.com, kvm@vger.kernel.org, miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, pbonzini@redhat.com, Vivek Goyal <vgoyal@redhat.com>

On Wed, Jun 17, 2020 at 03:12:03PM +0200, Vitaly Kuznetsov wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > As of now asynchronous page fault mecahanism assumes host will always be
> > successful in resolving page fault. So there are only two states, that
> > is page is not present and page is ready.
> >
> > If a page is backed by a file and that file has been truncated (as
> > can be the case with virtio-fs), then page fault handler on host returns
> > -EFAULT.
> >
> > As of now async page fault logic does not look at error code (-EFAULT)
> > returned by get_user_pages_remote() and returns PAGE_READY to guest.
> > Guest tries to access page and page fault happnes again. And this
> > gets kvm into an infinite loop. (Killing host process gets kvm out of
> > this loop though).

Isn't this already fixed by patch 1/3 "kvm,x86: Force sync fault if previous
attempts failed"?  If it isn't, it should be, i.e. we should fix KVM before
adding what are effectively optimizations on top.   And, it's not clear that
the optimizations are necessary, e.g. I assume the virtio-fs truncation
scenario is relatively uncommon, i.e. not performance sensitive?

> >
> > This patch adds another state to async page fault logic which allows
> > host to return error to guest. Once guest knows that async page fault
> > can't be resolved, it can send SIGBUS to host process (if user space

I assume this is supposed to be "it can send SIGBUS to guest process"?
Otherwise none of this makes sense (to me).

> > was accessing the page in question).

Allowing the guest to opt-in to intercepting host page allocation failures
feels wrong, and fragile.  KVM can't possibly know whether an allocation
failure is something that should be forwarded to the guest, as KVM doesn't
know the physical backing for any given hva/gfn, e.g. the error could be
due to a physical device failure or a configuration issue.  Relying on the
async #PF mechanism to prevent allocation failures from crashing the guest
is fragile because there is no guarantee that a #PF can be async.

IMO, the virtio-fs truncation use case should first be addressed in a way
that requires explicit userspace intervention, e.g. by enhancing
kvm_handle_bad_page() to provide the necessary information to userspace so
that userspace can reflect select errors into the guest.  The reflection
could piggyback whatever vector is used by async page faults (#PF or #VE),
but would not be an async page fault per se.  If an async #PF happens to
encounter an allocation failure, it would naturally fall back to the
synchronous path (provided by patch 1/3) and the synchronous path would
automagically handle the error as above.

In other words, I think the guest should be able to enable "error handling"
support without first enabling async #PF.  From a functional perspective it
probably won't change a whole lot, but it would hopefully force us to
concoct an overall "paravirt page fault" design as opposed to simply async
#PF v2.

