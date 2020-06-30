Date: Tue, 30 Jun 2020 08:50:28 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
Message-ID: <20200630155028.GE7733@linux.intel.com>
References: <20200625214701.GA180786@redhat.com>
	<87lfkach6o.fsf@vitty.brq.redhat.com>
	<20200626150303.GC195150@redhat.com>
	<874kqtd212.fsf@vitty.brq.redhat.com>
	<20200629220353.GC269627@redhat.com>
	<87sgecbs9w.fsf@vitty.brq.redhat.com>
	<20200630145303.GB322149@redhat.com>
	<87mu4kbn7x.fsf@vitty.brq.redhat.com>
	<20200630152529.GC322149@redhat.com>
	<87k0zobltx.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
In-Reply-To: <87k0zobltx.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: virtio-fs@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org

On Tue, Jun 30, 2020 at 05:43:54PM +0200, Vitaly Kuznetsov wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Tue, Jun 30, 2020 at 05:13:54PM +0200, Vitaly Kuznetsov wrote:
> >> 
> >> > - If you retry in kernel, we will change the context completely that
> >> >   who was trying to access the gfn in question. We want to retain
> >> >   the real context and retain information who was trying to access
> >> >   gfn in question.
> >> 
> >> (Just so I understand the idea better) does the guest context matter to
> >> the host? Or, more specifically, are we going to do anything besides
> >> get_user_pages() which will actually analyze who triggered the access
> >> *in the guest*?
> >
> > When we exit to user space, qemu prints bunch of register state. I am
> > wondering what does that state represent. Does some of that traces
> > back to the process which was trying to access that hva? I don't
> > know.
> 
> We can get the full CPU state when the fault happens if we need to but
> generally we are not analyzing it. I can imagine looking at CPL, for
> example, but trying to distinguish guest's 'process A' from 'process B'
> may not be simple.
> 
> >
> > I think keeping a cache of error gfns might not be too bad from
> > implemetation point of view. I will give it a try and see how
> > bad does it look.
> 
> Right; I'm only worried about the fact that every cache (or hash) has a
> limited size and under certain curcumstances we may overflow it. When an
> overflow happens, we will follow the APF path again and this can go over
> and over. Maybe we can punch a hole in EPT/NPT making the PFN reserved/
> not-present so when the guest tries to access it again we trap the
> access in KVM and, if the error persists, don't follow the APF path?

Just to make sure I'm somewhat keeping track, is the problem we're trying to
solve that the guest may not immediately retry the "bad" GPA and so KVM may
not detect that the async #PF already came back as -EFAULT or whatever? 

