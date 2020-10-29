Date: Thu, 29 Oct 2020 16:46:01 -0400
From: Eduardo Habkost <ehabkost@redhat.com>
Message-ID: <20201029204601.GM5733@habkost.net>
References: <20201029171744.150726-1-mreitz@redhat.com>
	<20201029171744.150726-8-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201029171744.150726-8-mreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 7/7] tests/acceptance: Add
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

On Thu, Oct 29, 2020 at 06:17:44PM +0100, Max Reitz wrote:
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
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  tests/acceptance/virtiofs_submounts.py        | 289 ++++++++++++++++++
>  .../virtiofs_submounts.py.data/cleanup.sh     |  46 +++
>  .../guest-cleanup.sh                          |  30 ++
>  .../virtiofs_submounts.py.data/guest.sh       | 138 +++++++++
>  .../virtiofs_submounts.py.data/host.sh        | 127 ++++++++
>  5 files changed, 630 insertions(+)
>  create mode 100644 tests/acceptance/virtiofs_submounts.py
>  create mode 100644 tests/acceptance/virtiofs_submounts.py.data/cleanup.sh
>  create mode 100644 tests/acceptance/virtiofs_submounts.py.data/guest-cleanup.sh
>  create mode 100644 tests/acceptance/virtiofs_submounts.py.data/guest.sh
>  create mode 100644 tests/acceptance/virtiofs_submounts.py.data/host.sh
> 
> diff --git a/tests/acceptance/virtiofs_submounts.py b/tests/acceptance/virtiofs_submounts.py
> new file mode 100644
> index 0000000000..8b207b3e57
> --- /dev/null
> +++ b/tests/acceptance/virtiofs_submounts.py
> @@ -0,0 +1,289 @@
> +import logging
> +import re
> +import os
> +import subprocess
> +import time
> +
> +from avocado import skipUnless
> +from avocado_qemu import Test, BUILD_DIR
> +from avocado_qemu import wait_for_console_pattern
> +from avocado.utils import ssh
> +
> +from qemu.accel import kvm_available
> +
> +from boot_linux import BootLinux
> +
> +
> +def run_cmd(args):
> +    subp = subprocess.Popen(args,
> +                            stdout=subprocess.PIPE,
> +                            stderr=subprocess.PIPE,
> +                            universal_newlines=True)
> +    stdout, stderr = subp.communicate()
> +    ret = subp.returncode
> +
> +    return (stdout, stderr, ret)
> +
> +def has_passwordless_sudo():
> +    """
> +    This function is for use in a @avocado.skipUnless decorator, e.g.:
> +
> +        @skipUnless(*has_passwordless_sudo())
> +        def test_something_that_needs_sudo(self):
> +            ...
> +    """
> +
> +    _, stderr, exitcode = run_cmd(('sudo', '-n', 'true'))

This seems to break if sudo is not available in the host:

https://gitlab.com/ehabkost/qemu/-/jobs/820072411#L152

0:37:08 ERROR| ERROR 32-tests/acceptance/virtiofs_submounts.py:VirtiofsSubmountsTest.test_pre_virtiofsd_set_up -> TestError: Traceback (most recent call last):
  File "/usr/lib64/python3.6/imp.py", line 235, in load_module
    return load_source(name, filename, file)
  File "/usr/lib64/python3.6/imp.py", line 172, in load_source
    module = _load(spec)
  File "<frozen importlib._bootstrap>", line 684, in _load
  File "<frozen importlib._bootstrap>", line 665, in _load_unlocked
  File "<frozen importlib._bootstrap_external>", line 678, in exec_module
  File "<frozen importlib._bootstrap>", line 219, in _call_with_frames_removed
  File "/builds/ehabkost/qemu/build/tests/acceptance/virtiofs_submounts.py", line 43, in <module>
    class VirtiofsSubmountsTest(BootLinux):
  File "/builds/ehabkost/qemu/build/tests/acceptance/virtiofs_submounts.py", line 195, in VirtiofsSubmountsTest
    @skipUnless(*has_passwordless_sudo())
  File "/builds/ehabkost/qemu/build/tests/acceptance/virtiofs_submounts.py", line 36, in has_passwordless_sudo
    _, stderr, exitcode = run_cmd(('sudo', '-n', 'true'))
  File "/builds/ehabkost/qemu/build/tests/acceptance/virtiofs_submounts.py", line 21, in run_cmd
    universal_newlines=True)
  File "/usr/lib64/python3.6/subprocess.py", line 729, in __init__
    restore_signals, start_new_session)
  File "/usr/lib64/python3.6/subprocess.py", line 1364, in _execute_child
    raise child_exception_type(errno_num, err_msg, err_filename)
FileNotFoundError: [Errno 2] No such file or directory: 'sudo': 'sudo'
20:37:08 INFO | 

> +    if exitcode != 0:
> +        return (False, f'Failed to use sudo -n: {stderr.strip()}')
> +    else:
> +        return (True, '')
> +
> +
[...]

-- 
Eduardo

