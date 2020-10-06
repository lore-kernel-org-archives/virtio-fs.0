From: Vitaly Kuznetsov <vkuznets@redhat.com>
In-Reply-To: <20201006134629.GB5306@redhat.com>
References: <20201001215508.GD3522@redhat.com>
	<20201001223320.GI7474@linux.intel.com>
	<20201002153854.GC3119@redhat.com>
	<20201002183036.GB24460@linux.intel.com>
	<20201002192734.GD3119@redhat.com>
	<20201002194517.GD24460@linux.intel.com>
	<20201002200214.GB10232@redhat.com>
	<20201002211314.GE24460@linux.intel.com>
	<20201005153318.GA4302@redhat.com>
	<20201005161620.GC11938@linux.intel.com>
	<20201006134629.GB5306@redhat.com>
Date: Tue, 06 Oct 2020 16:05:16 +0200
Message-ID: <877ds38n6r.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
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
To: Vivek Goyal <vgoyal@redhat.com>, Sean Christopherson <sean.j.christopherson@intel.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> A. Just exit to user space with -EFAULT (using kvm request) and don't
>    wait for the accessing task to run on vcpu again. 

What if we also save the required information (RIP, GFN, ...) in the
guest along with the APF token so in case of -EFAULT we can just 'crash'
the guest and the required information can easily be obtained from
kdump? This will solve the debugging problem even for TDX/SEV-ES (if
kdump is possible there).

-- 
Vitaly

