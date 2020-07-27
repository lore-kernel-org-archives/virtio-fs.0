Date: Mon, 27 Jul 2020 14:40:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200727184053.GB39559@redhat.com>
References: <20200720211359.GF502563@redhat.com>
	<20200727135603.GA39559@redhat.com>
	<87ft9dlz2b.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ft9dlz2b.fsf@vitty.brq.redhat.com>
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
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com, sean.j.christopherson@intel.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org

On Mon, Jul 27, 2020 at 06:09:32PM +0200, Vitaly Kuznetsov wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Mon, Jul 20, 2020 at 05:13:59PM -0400, Vivek Goyal wrote:
> >> Page fault error handling behavior in kvm seems little inconsistent when
> >> page fault reports error. If we are doing fault synchronously
> >> then we capture error (-EFAULT) returned by __gfn_to_pfn_memslot() and
> >> exit to user space and qemu reports error, "error: kvm run failed Bad address".
> >
> > Hi Vitaly,
> >
> > A gentle reminder. How does this patch look now?
> >
> 
> Sorry, I even reviewd it but never replied. It looks good to me!
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks Vitaly.

Paolo, what do you think about this patch. Do you have concerns with
this. Can this be merged.

Thanks
Vivek

