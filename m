From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 31 Mar 2020 15:40:07 -0400
Message-Id: <20200331194011.24834-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC PATCH 0/4] kvm, x86,
	async_pf: Add capability to return page fault error
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: aarcange@redhat.com, miklos@szeredi.hu, virtio-fs@redhat.com, dhildenb@redhat.com, vgoyal@redhat.com

Current page fault logic in kvm seems to assume that host will always
be able to successfully resolve page fault soon or later. There does not
seem to be any mechanism for hypervisor to return an error say -EFAULT
to guest.

We are writing DAX support for virtiofs filesystem. This will allow
directly mapping host page cache page into guest user space process.

This mechanism now needs additional support from kvm where a page
fault error needs to be propagated back into guest. For example, say
guest process mmaped a file (and this did an mmap of portion of file
on host into qemu address space). Now file gets truncated and guest
process tries to access mapped region. It will generate page fault
in host and it will try to map the file page. But page is not there
any more so it will get back -EFAULT. But there is no mechanism to
send this information back to guest and currently host sends PAGE_READY
to guest, guest retries and fault happens again and host tries to
resolve page fault again and this becomes an infinite loop.

This is an RFC patch series which tries to extend async page fault
mechanism to also be able to communicate back that an error occurred
while resolving the page fault. Then guest can send SIGBUS to guest
process accessing the truncated portion of file. Or if access happened
in guest kernel, then it can try to fixup the exception and jump
to error handling portion if there is one.  

This patch series tries to solve it only for x86 architecture on intel
vmx only. Also it does not solve the problem for nested virtualization.

Is extending async page fault mechanism to report error back to
guest is right thing to do? Or there needs to be another way.

Any feedback or comments are welcome. 

Thanks
Vivek

Vivek Goyal (4):
  kvm: Add capability to be able to report async pf error to guest
  kvm: async_pf: Send faulting gva address in case of error
  kvm: Always get async page notifications
  kvm,x86,async_pf: Search exception tables in case of error

 Documentation/virt/kvm/cpuid.rst     |  4 ++
 Documentation/virt/kvm/msr.rst       | 11 +++--
 arch/x86/include/asm/kvm_host.h      | 17 ++++++-
 arch/x86/include/asm/kvm_para.h      | 13 +++---
 arch/x86/include/asm/vmx.h           |  2 +
 arch/x86/include/uapi/asm/kvm_para.h | 12 ++++-
 arch/x86/kernel/kvm.c                | 69 ++++++++++++++++++++++------
 arch/x86/kvm/cpuid.c                 |  3 +-
 arch/x86/kvm/mmu/mmu.c               | 12 +++--
 arch/x86/kvm/vmx/nested.c            |  2 +-
 arch/x86/kvm/vmx/vmx.c               | 11 ++++-
 arch/x86/kvm/x86.c                   | 37 +++++++++++----
 include/linux/kvm_host.h             |  1 +
 virt/kvm/async_pf.c                  |  6 ++-
 14 files changed, 156 insertions(+), 44 deletions(-)

-- 
2.25.1

