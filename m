From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 16 Jun 2020 17:48:44 -0400
Message-Id: <20200616214847.24482-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC PATCH 0/3] kvm,
	x86: Improve kvm page fault error handling
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: wanpengli@tencent.com, miklos@szeredi.hu, sean.j.christopherson@intel.com, virtio-fs@redhat.com, pbonzini@redhat.com, vkuznets@redhat.com, vgoyal@redhat.com

Hi,

This is an RFC patch series to improve error handling. Compiled and
tested only on x86. Have not tested or thought about nested
configuration yet.

This is built on top of Vitaly's patches sending "page ready" events
using interrupts. But it has not been rebased on top of recent
interrupt rework yet. Patches are also available here.

https://github.com/rhvgoyal/linux/commits/asyncpf-error-v1

Problem
=======
Currently kvm page fault error handling seems very unpredictable. If
a page fault fails and kvm decided not to do async page fault, then
upon error, we exit to user space and qemu prints
"error: kvm run failed Bad address" and associated cpu state and VM
freezes.

But if kvm decided to async page fault, then async_pf_execute() simply
ignores the error code (-EFAULT) returned by get_user_pages_remote()
and injects "page ready" event into guest. Guest retries the faulting
instruction and takes exit again and kvm again retries async page
fault and this cycle continues and forms an infinite loop.

I can reproduce this -EFAULT situation easily. Created a file
(nvdimm.img) and exported it to guest as nvdimm device. Inside the guest
created ext4 filesystem on device and mounted with dax enabled. Now mmap a
file (/mnt/pmem0/foo.txt) and load from it one page at a time. Also
truncate nvdimm.img on host. So when guest tries to load from nvdimm,
its not mapped in page tables anymore (due to truncation) and we take
exit and try to fault in the page. Now we either exit to user space
with bad address or and get into infinite loop depending on state of
filesystem in guest whether at the time of exit we were in kernel mode
or user space mode.

I am implementing DAX support in virtiofs (which is very close to what
nvdimm will do) and I have scenarios where a DAX mapped file in guest
can get truncated on host and page fault errors can happen. I need to
do better error handling instead of guest and host spinning infinitely.
It otherwise sort of creates an attack vector where a kata container
has to mount virtiofs using DAX, mmap a file, and then truncate that
file on host and then access it inside guest and we can hog kvm on
host in this infinite loop of trying to fault in page.

Proposed Solution
=================
So first idea is that how about we make the error behavior uniform. That
is when an error is encountered, we exit to qemu which prints the
error message and VM freezes. That will end the discrepancy in the
behavior of sync/async page fault. First patch of the series does
that.

Second idea is that if we are doing async page fault and if guest is
in a state so that we can inject "page not present" and "page ready"
events, then instead of exiting to user space, send error back to
guest as part of "page ready" event. This will allow guest to do
finer grained error handling. For example, send SIGBUS to offending
process. And whole of the VM does not have to go down. Second patch
implemented it.

Third idea is that find a way to inject error even when async page
fault can't be injected. Now if we disabled any kind of async page
fault delivery if guest is in kernel mode because this was racy.
Once we figure out a race free way  to be able to inject page
fault in guest (using #VE?), then use that to report errors back
to guest even when it is in kernel mode. And that will allow
guest to call fixup_exception() and possibly recover from situation
otherwise panic(). This can only be implemented once we have a
way race free way to inject an async page event into guest. So this
is a future TBD item. For now, if we took exit and guest is in kernel
mode and error happened, we will vcpu_run() will fail and exit
to user space.  

I have only compiled and tested this series on x86. Before I refine
it further, wanted to post it for some feedback and see if this
the right direction or not.

Any feedback or comments are welcome.

Thanks
Vivek 

Vivek Goyal (3):
  kvm,x86: Force sync fault if previous attempts failed
  kvm: Add capability to be able to report async pf error to guest
  kvm, async_pf: Use FOLL_WRITE only for write faults

 Documentation/virt/kvm/cpuid.rst     |  4 +++
 Documentation/virt/kvm/msr.rst       | 10 +++---
 arch/x86/include/asm/kvm_host.h      |  4 +++
 arch/x86/include/asm/kvm_para.h      |  8 ++---
 arch/x86/include/uapi/asm/kvm_para.h | 10 ++++--
 arch/x86/kernel/kvm.c                | 34 +++++++++++++++----
 arch/x86/kvm/cpuid.c                 |  3 +-
 arch/x86/kvm/mmu.h                   |  2 +-
 arch/x86/kvm/mmu/mmu.c               | 11 ++++---
 arch/x86/kvm/x86.c                   | 49 +++++++++++++++++++++++-----
 include/linux/kvm_host.h             |  5 ++-
 virt/kvm/async_pf.c                  | 15 +++++++--
 12 files changed, 119 insertions(+), 36 deletions(-)

-- 
2.25.4

