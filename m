Date: Mon, 2 Nov 2020 13:55:24 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
Message-ID: <20201102185524.GT5733@habkost.net>
References: <20201102161859.156603-1-mreitz@redhat.com>
	<20201102161859.156603-8-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201102161859.156603-8-mreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 7/7] tests/acceptance: Add
	virtiofs_submounts.py
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Mon, Nov 02, 2020 at 05:18:59PM +0100, Max Reitz wrote:
> This test invokes several shell scripts to create a random directory
> tree full of submounts, and then check in the VM whether every submount
> has its own ID and the structure looks as expected.
> 
> (Note that the test scripts must be non-executable, so Avocado will not
> try to execute them as if they were tests on their own, too.)
> 
> Because at this commit's date it is unlikely that the Linux kernel on
> the image provided by boot_linux.py supports submounts in virtio-fs, the
> test will be cancelled if no custom Linux binary is provided through the
> vmlinuz parameter.  (The on-image kernel can be used by providing an
> empty string via vmlinuz=.)
> 
> So, invoking the test can be done as follows:
> $ avocado run \
>     tests/acceptance/virtiofs_submounts.py \
>     -p vmlinuz=/path/to/linux/build/arch/x86/boot/bzImage
> 
> This test requires root privileges (through passwordless sudo -n),
> because at this point, virtiofsd requires them.  (If you have a
> timestamp_timeout period for sudoers (e.g. the default of 5 min), you
> can provide this by executing something like "sudo true" before invoking
> Avocado.)
> 
> Signed-off-by: Max Reitz <mreitz@redhat.com>

Fixes the issue detected in v3.

Tested-by: Eduardo Habkost <ehabkost@redhat.com>

-- 
Eduardo

