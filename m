From: Max Reitz <mreitz@redhat.com>
Date: Thu, 29 Oct 2020 18:17:44 +0100
Message-Id: <20201029171744.150726-8-mreitz@redhat.com>
In-Reply-To: <20201029171744.150726-1-mreitz@redhat.com>
References: <20201029171744.150726-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 7/7] tests/acceptance: Add
	virtiofs_submounts.py
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, Max Reitz <mreitz@redhat.com>

This test invokes several shell scripts to create a random directory
tree full of submounts, and then check in the VM whether every submount
has its own ID and the structure looks as expected.

(Note that the test scripts must be non-executable, so Avocado will not
try to execute them as if they were tests on their own, too.)

Because at this commit's date it is unlikely that the Linux kernel on
the image provided by boot_linux.py supports submounts in virtio-fs, the
test will be cancelled if no custom Linux binary is provided through the
vmlinuz parameter.  (The on-image kernel can be used by providing an
empty string via vmlinuz=.)

So, invoking the test can be done as follows:
$ avocado run \
    tests/acceptance/virtiofs_submounts.py \
    -p vmlinuz=/path/to/linux/build/arch/x86/boot/bzImage

This test requires root privileges (through passwordless sudo -n),
because at this point, virtiofsd requires them.  (If you have a
timestamp_timeout period for sudoers (e.g. the default of 5 min), you
can provide this by executing something like "sudo true" before invoking
Avocado.)

Signed-off-by: Max Reitz <mreitz@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 tests/acceptance/virtiofs_submounts.py        | 289 ++++++++++++++++++
 .../virtiofs_submounts.py.data/cleanup.sh     |  46 +++
 .../guest-cleanup.sh                          |  30 ++
 .../virtiofs_submounts.py.data/guest.sh       | 138 +++++++++
 .../virtiofs_submounts.py.data/host.sh        | 127 ++++++++
 5 files changed, 630 insertions(+)
 create mode 100644 tests/acceptance/virtiofs_submounts.py
 create mode 100644 tests/acceptance/virtiofs_submounts.py.data/cleanup.sh
 create mode 100644 tests/acceptance/virtiofs_submounts.py.data/guest-cleanup.sh
 create mode 100644 tests/acceptance/virtiofs_submounts.py.data/guest.sh
 create mode 100644 tests/acceptance/virtiofs_submounts.py.data/host.sh

diff --git a/tests/acceptance/virtiofs_submounts.py b/tests/acceptance/virtiofs_submounts.py
new file mode 100644
index 0000000000..8b207b3e57
--- /dev/null
+++ b/tests/acceptance/virtiofs_submounts.py
@@ -0,0 +1,289 @@
+import logging
+import re
+import os
+import subprocess
+import time
+
+from avocado import skipUnless
+from avocado_qemu import Test, BUILD_DIR
+from avocado_qemu import wait_for_console_pattern
+from avocado.utils import ssh
+
+from qemu.accel import kvm_available
+
+from boot_linux import BootLinux
+
+
+def run_cmd(args):
+    subp = subprocess.Popen(args,
+                            stdout=subprocess.PIPE,
+                            stderr=subprocess.PIPE,
+                            universal_newlines=True)
+    stdout, stderr = subp.communicate()
+    ret = subp.returncode
+
+    return (stdout, stderr, ret)
+
+def has_passwordless_sudo():
+    """
+    This function is for use in a @avocado.skipUnless decorator, e.g.:
+
+        @skipUnless(*has_passwordless_sudo())
+        def test_something_that_needs_sudo(self):
+            ...
+    """
+
+    _, stderr, exitcode = run_cmd(('sudo', '-n', 'true'))
+    if exitcode != 0:
+        return (False, f'Failed to use sudo -n: {stderr.strip()}')
+    else:
+        return (True, '')
+
+
+class VirtiofsSubmountsTest(BootLinux):
+    """
+    :avocado: tags=arch:x86_64
+    """
+
+    def get_portfwd(self):
+        port = None
+
+        res = self.vm.command('human-monitor-command',
+                              command_line='info usernet')
+        for line in res.split('\r\n'):
+            match = \
+                re.search(r'TCP.HOST_FORWARD.*127\.0\.0\.1\s*(\d+)\s+10\.',
+                          line)
+            if match is not None:
+                port = match[1]
+                break
+
+        self.assertIsNotNone(port)
+        self.log.debug('sshd listening on port: ' + port)
+        return port
+
+    def ssh_connect(self, username, keyfile):
+        self.ssh_logger = logging.getLogger('ssh')
+        port = self.get_portfwd()
+        self.ssh_session = ssh.Session('127.0.0.1', port=int(port),
+                                       user=username, key=keyfile)
+        for i in range(10):
+            try:
+                self.ssh_session.connect()
+                return
+            except:
+                time.sleep(4)
+                pass
+        self.fail('sshd timeout')
+
+    def ssh_command(self, command):
+        self.ssh_logger.info(command)
+        result = self.ssh_session.cmd(command)
+        stdout_lines = [line.rstrip() for line
+                        in result.stdout_text.splitlines()]
+        for line in stdout_lines:
+            self.ssh_logger.info(line)
+        stderr_lines = [line.rstrip() for line
+                        in result.stderr_text.splitlines()]
+        for line in stderr_lines:
+            self.ssh_logger.warning(line)
+
+        self.assertEqual(result.exit_status, 0,
+                         f'Guest command failed: {command}')
+        return stdout_lines, stderr_lines
+
+    def run(self, args, ignore_error=False):
+        stdout, stderr, ret = run_cmd(args)
+
+        if ret != 0:
+            cmdline = ' '.join(args)
+            if not ignore_error:
+                self.fail(f'{cmdline}: Returned {ret}: {stderr}')
+            else:
+                self.log.warn(f'{cmdline}: Returned {ret}: {stderr}')
+
+        return (stdout, stderr, ret)
+
+    def set_up_shared_dir(self):
+        atwd = os.getenv('AVOCADO_TEST_WORKDIR')
+        self.shared_dir = os.path.join(atwd, 'virtiofs-shared')
+
+        os.mkdir(self.shared_dir)
+
+        self.run(('cp', self.get_data('guest.sh'),
+                 os.path.join(self.shared_dir, 'check.sh')))
+
+        self.run(('cp', self.get_data('guest-cleanup.sh'),
+                 os.path.join(self.shared_dir, 'cleanup.sh')))
+
+    def set_up_virtiofs(self):
+        attmp = os.getenv('AVOCADO_TESTS_COMMON_TMPDIR')
+        self.vfsdsock = os.path.join(attmp, 'vfsdsock')
+
+        self.run(('sudo', '-n', 'rm', '-f', self.vfsdsock), ignore_error=True)
+
+        self.virtiofsd = \
+            subprocess.Popen(('sudo', '-n',
+                              'tools/virtiofsd/virtiofsd',
+                              f'--socket-path={self.vfsdsock}',
+                              '-o', f'source={self.shared_dir}',
+                              '-o', 'cache=always',
+                              '-o', 'xattr',
+                              '-o', 'announce_submounts',
+                              '-f'),
+                             stdout=subprocess.DEVNULL,
+                             stderr=subprocess.PIPE,
+                             universal_newlines=True)
+
+        while not os.path.exists(self.vfsdsock):
+            if self.virtiofsd.poll() is not None:
+                self.fail('virtiofsd exited prematurely: ' +
+                          self.virtiofsd.communicate()[1])
+            time.sleep(0.1)
+
+        self.run(('sudo', '-n', 'chmod', 'go+rw', self.vfsdsock))
+
+        self.vm.add_args('-chardev',
+                         f'socket,id=vfsdsock,path={self.vfsdsock}',
+                         '-device',
+                         'vhost-user-fs-pci,queue-size=1024,chardev=vfsdsock' \
+                             ',tag=host',
+                         '-object',
+                         'memory-backend-file,id=mem,size=1G,' \
+                             'mem-path=/dev/shm,share=on',
+                         '-numa',
+                         'node,memdev=mem')
+
+    def launch_vm(self):
+        self.launch_and_wait()
+        self.ssh_connect('root', self.ssh_key)
+
+    def set_up_nested_mounts(self):
+        scratch_dir = os.path.join(self.shared_dir, 'scratch')
+        try:
+            os.mkdir(scratch_dir)
+        except FileExistsError:
+            pass
+
+        args = ['bash', self.get_data('host.sh'), scratch_dir]
+        if self.seed:
+            args += [self.seed]
+
+        out, _, _ = self.run(args)
+        seed = re.search(r'^Seed: \d+', out)
+        self.log.info(seed[0])
+
+    def mount_in_guest(self):
+        self.ssh_command('mkdir -p /mnt/host')
+        self.ssh_command('mount -t virtiofs host /mnt/host')
+
+    def check_in_guest(self):
+        self.ssh_command('bash /mnt/host/check.sh /mnt/host/scratch/share')
+
+    def live_cleanup(self):
+        self.ssh_command('bash /mnt/host/cleanup.sh /mnt/host/scratch')
+
+        # It would be nice if the above was sufficient to make virtiofsd clear
+        # all references to the mounted directories (so they can be unmounted
+        # on the host), but unfortunately it is not.  To do so, we have to
+        # resort to a remount.
+        self.ssh_command('mount -o remount /mnt/host')
+
+        scratch_dir = os.path.join(self.shared_dir, 'scratch')
+        self.run(('bash', self.get_data('cleanup.sh'), scratch_dir))
+
+    @skipUnless(*has_passwordless_sudo())
+    def setUp(self):
+        vmlinuz = self.params.get('vmlinuz')
+        if vmlinuz is None:
+            self.cancel('vmlinuz parameter not set; you must point it to a '
+                        'Linux kernel binary to test (to run this test with ' \
+                        'the on-image kernel, set it to an empty string)')
+
+        self.seed = self.params.get('seed')
+
+        atwd = os.getenv('AVOCADO_TEST_WORKDIR')
+        self.ssh_key = os.path.join(atwd, 'id_ed25519')
+
+        self.run(('ssh-keygen', '-t', 'ed25519', '-f', self.ssh_key))
+
+        pubkey = open(self.ssh_key + '.pub').read()
+
+        super(VirtiofsSubmountsTest, self).setUp(pubkey)
+
+        if len(vmlinuz) > 0:
+            self.vm.add_args('-kernel', vmlinuz,
+                             '-append', 'console=ttyS0 root=/dev/sda1')
+
+        # Allow us to connect to SSH
+        self.vm.add_args('-netdev', 'user,id=vnet,hostfwd=:127.0.0.1:0-:22',
+                         '-device', 'e1000,netdev=vnet')
+
+        if not kvm_available(self.arch, self.qemu_bin):
+            self.cancel(KVM_NOT_AVAILABLE)
+        self.vm.add_args('-accel', 'kvm')
+
+    def tearDown(self):
+        try:
+            self.vm.shutdown()
+        except:
+            pass
+
+        scratch_dir = os.path.join(self.shared_dir, 'scratch')
+        self.run(('bash', self.get_data('cleanup.sh'), scratch_dir),
+                 ignore_error=True)
+
+    def test_pre_virtiofsd_set_up(self):
+        self.set_up_shared_dir()
+
+        self.set_up_nested_mounts()
+
+        self.set_up_virtiofs()
+        self.launch_vm()
+        self.mount_in_guest()
+        self.check_in_guest()
+
+    def test_pre_launch_set_up(self):
+        self.set_up_shared_dir()
+        self.set_up_virtiofs()
+
+        self.set_up_nested_mounts()
+
+        self.launch_vm()
+        self.mount_in_guest()
+        self.check_in_guest()
+
+    def test_post_launch_set_up(self):
+        self.set_up_shared_dir()
+        self.set_up_virtiofs()
+        self.launch_vm()
+
+        self.set_up_nested_mounts()
+
+        self.mount_in_guest()
+        self.check_in_guest()
+
+    def test_post_mount_set_up(self):
+        self.set_up_shared_dir()
+        self.set_up_virtiofs()
+        self.launch_vm()
+        self.mount_in_guest()
+
+        self.set_up_nested_mounts()
+
+        self.check_in_guest()
+
+    def test_two_runs(self):
+        self.set_up_shared_dir()
+
+        self.set_up_nested_mounts()
+
+        self.set_up_virtiofs()
+        self.launch_vm()
+        self.mount_in_guest()
+        self.check_in_guest()
+
+        self.live_cleanup()
+        self.set_up_nested_mounts()
+
+        self.check_in_guest()
diff --git a/tests/acceptance/virtiofs_submounts.py.data/cleanup.sh b/tests/acceptance/virtiofs_submounts.py.data/cleanup.sh
new file mode 100644
index 0000000000..2a6579a0fe
--- /dev/null
+++ b/tests/acceptance/virtiofs_submounts.py.data/cleanup.sh
@@ -0,0 +1,46 @@
+#!/bin/bash
+
+function print_usage()
+{
+    if [ -n "$2" ]; then
+        echo "Error: $2"
+        echo
+    fi
+    echo "Usage: $1 <scratch dir>"
+}
+
+scratch_dir=$1
+if [ -z "$scratch_dir" ]; then
+    print_usage "$0" 'Scratch dir not given' >&2
+    exit 1
+fi
+
+cd "$scratch_dir/share" || exit 1
+mps=(mnt*)
+mp_i=0
+for mp in "${mps[@]}"; do
+    mp_i=$((mp_i + 1))
+    printf "Unmounting %i/%i...\r" "$mp_i" "${#mps[@]}"
+
+    sudo umount -R "$mp"
+    rm -rf "$mp"
+done
+echo
+
+rm some-file
+cd ..
+rmdir share
+
+imgs=(fs*.img)
+img_i=0
+for img in "${imgs[@]}"; do
+    img_i=$((img_i + 1))
+    printf "Detaching and deleting %i/%i...\r" "$img_i" "${#imgs[@]}"
+
+    dev=$(losetup -j "$img" | sed -e 's/:.*//')
+    sudo losetup -d "$dev"
+    rm -f "$img"
+done
+echo
+
+echo 'Done.'
diff --git a/tests/acceptance/virtiofs_submounts.py.data/guest-cleanup.sh b/tests/acceptance/virtiofs_submounts.py.data/guest-cleanup.sh
new file mode 100644
index 0000000000..729cb2d1a5
--- /dev/null
+++ b/tests/acceptance/virtiofs_submounts.py.data/guest-cleanup.sh
@@ -0,0 +1,30 @@
+#!/bin/bash
+
+function print_usage()
+{
+    if [ -n "$2" ]; then
+        echo "Error: $2"
+        echo
+    fi
+    echo "Usage: $1 <scratch dir>"
+}
+
+scratch_dir=$1
+if [ -z "$scratch_dir" ]; then
+    print_usage "$0" 'Scratch dir not given' >&2
+    exit 1
+fi
+
+cd "$scratch_dir/share" || exit 1
+
+mps=(mnt*)
+mp_i=0
+for mp in "${mps[@]}"; do
+    mp_i=$((mp_i + 1))
+    printf "Unmounting %i/%i...\r" "$mp_i" "${#mps[@]}"
+
+    sudo umount -R "$mp"
+done
+echo
+
+echo 'Done.'
diff --git a/tests/acceptance/virtiofs_submounts.py.data/guest.sh b/tests/acceptance/virtiofs_submounts.py.data/guest.sh
new file mode 100644
index 0000000000..59ba40fde1
--- /dev/null
+++ b/tests/acceptance/virtiofs_submounts.py.data/guest.sh
@@ -0,0 +1,138 @@
+#!/bin/bash
+
+function print_usage()
+{
+    if [ -n "$2" ]; then
+        echo "Error: $2"
+        echo
+    fi
+    echo "Usage: $1 <shared dir>"
+    echo '(The shared directory is the "share" directory in the scratch' \
+         'directory)'
+}
+
+shared_dir=$1
+if [ -z "$shared_dir" ]; then
+    print_usage "$0" 'Shared dir not given' >&2
+    exit 1
+fi
+
+cd "$shared_dir"
+
+# FIXME: This should not be necessary, but it is.  In order for all
+# submounts to be proper mount points, we need to visit them.
+# (Before we visit them, they will not be auto-mounted, and so just
+# appear as normal directories, with the catch that their st_ino will
+# be the st_ino of the filesystem they host, while the st_dev will
+# still be the st_dev of the parent.)
+# `find` does not work, because it will refuse to touch the mount
+# points as long as they are not mounted; their st_dev being shared
+# with the parent and st_ino just being the root node's inode ID
+# will practically ensure that this node exists elsewhere on the
+# filesystem, and `find` is required to recognize loops and not to
+# follow them.
+# Thus, we have to manually visit all nodes first.
+
+mnt_i=0
+
+function recursively_visit()
+{
+    pushd "$1" >/dev/null
+    for entry in *; do
+        if [[ "$entry" == mnt* ]]; then
+            mnt_i=$((mnt_i + 1))
+            printf "Triggering auto-mount $mnt_i...\r"
+        fi
+
+        if [ -d "$entry" ]; then
+            recursively_visit "$entry"
+        fi
+    done
+    popd >/dev/null
+}
+
+recursively_visit .
+echo
+
+
+if [ -n "$(find -name not-mounted)" ]; then
+    echo "Error: not-mounted files visible on mount points:" >&2
+    find -name not-mounted >&2
+    exit 1
+fi
+
+if [ ! -f some-file -o "$(cat some-file)" != 'root' ]; then
+    echo "Error: Bad file in the share root" >&2
+    exit 1
+fi
+
+shopt -s nullglob
+
+function check_submounts()
+{
+    local base_path=$1
+
+    for mp in mnt*; do
+        printf "Checking submount %i...\r" "$((${#devs[@]} + 1))"
+
+        mp_i=$(echo "$mp" | sed -e 's/mnt//')
+        dev=$(stat -c '%D' "$mp")
+
+        if [ -n "${devs[mp_i]}" ]; then
+            echo "Error: $mp encountered twice" >&2
+            exit 1
+        fi
+        devs[mp_i]=$dev
+
+        pushd "$mp" >/dev/null
+        path="$base_path$mp"
+        while true; do
+            expected_content="$(printf '%s\n%s\n' "$mp_i" "$path")"
+            if [ ! -f some-file ]; then
+                echo "Error: $PWD/some-file does not exist" >&2
+                exit 1
+            fi
+
+            if [ "$(cat some-file)" != "$expected_content" ]; then
+                echo "Error: Bad content in $PWD/some-file:" >&2
+                echo '--- found ---'
+                cat some-file
+                echo '--- expected ---'
+                echo "$expected_content"
+                exit 1
+            fi
+            if [ "$(stat -c '%D' some-file)" != "$dev" ]; then
+                echo "Error: $PWD/some-file has the wrong device ID" >&2
+                exit 1
+            fi
+
+            if [ -d sub ]; then
+                if [ "$(stat -c '%D' sub)" != "$dev" ]; then
+                    echo "Error: $PWD/some-file has the wrong device ID" >&2
+                    exit 1
+                fi
+                cd sub
+                path="$path/sub"
+            else
+                if [ -n "$(echo mnt*)" ]; then
+                    check_submounts "$path/"
+                fi
+                break
+            fi
+        done
+        popd >/dev/null
+    done
+}
+
+root_dev=$(stat -c '%D' some-file)
+devs=()
+check_submounts ''
+echo
+
+reused_devs=$(echo "$root_dev ${devs[@]}" | tr ' ' '\n' | sort | uniq -d)
+if [ -n "$reused_devs" ]; then
+    echo "Error: Reused device IDs: $reused_devs" >&2
+    exit 1
+fi
+
+echo "Test passed for ${#devs[@]} submounts."
diff --git a/tests/acceptance/virtiofs_submounts.py.data/host.sh b/tests/acceptance/virtiofs_submounts.py.data/host.sh
new file mode 100644
index 0000000000..d8a9afebdb
--- /dev/null
+++ b/tests/acceptance/virtiofs_submounts.py.data/host.sh
@@ -0,0 +1,127 @@
+#!/bin/bash
+
+mount_count=128
+
+function print_usage()
+{
+    if [ -n "$2" ]; then
+        echo "Error: $2"
+        echo
+    fi
+    echo "Usage: $1 <scratch dir> [seed]"
+    echo "(If no seed is given, it will be randomly generated.)"
+}
+
+scratch_dir=$1
+if [ -z "$scratch_dir" ]; then
+    print_usage "$0" 'No scratch dir given' >&2
+    exit 1
+fi
+
+if [ ! -d "$scratch_dir" ]; then
+    print_usage "$0" "$scratch_dir is not a directory" >&2
+    exit 1
+fi
+
+seed=$2
+if [ -z "$seed" ]; then
+    seed=$RANDOM
+fi
+RANDOM=$seed
+
+echo "Seed: $seed"
+
+set -e
+shopt -s nullglob
+
+cd "$scratch_dir"
+if [ -d share ]; then
+    echo 'Error: This directory seems to be in use already' >&2
+    exit 1
+fi
+
+for ((i = 0; i < $mount_count; i++)); do
+    printf "Setting up fs %i/%i...\r" "$((i + 1))" "$mount_count"
+
+    rm -f fs$i.img
+    truncate -s 512M fs$i.img
+    mkfs.xfs -q fs$i.img
+    devs[i]=$(sudo losetup -f --show fs$i.img)
+done
+echo
+
+top_level_mounts=$((RANDOM % mount_count + 1))
+
+mkdir -p share
+echo 'root' > share/some-file
+
+for ((i = 0; i < $top_level_mounts; i++)); do
+    printf "Mounting fs %i/%i...\r" "$((i + 1))" "$mount_count"
+
+    mkdir -p share/mnt$i
+    touch share/mnt$i/not-mounted
+    sudo mount "${devs[i]}" share/mnt$i
+    sudo chown "$(id -u):$(id -g)" share/mnt$i
+
+    pushd share/mnt$i >/dev/null
+    path=mnt$i
+    nesting=$((RANDOM % 4))
+    for ((j = 0; j < $nesting; j++)); do
+        cat > some-file <<EOF
+$i
+$path
+EOF
+        mkdir sub
+        cd sub
+        path="$path/sub"
+    done
+cat > some-file <<EOF
+$i
+$path
+EOF
+    popd >/dev/null
+done
+
+for ((; i < $mount_count; i++)); do
+    printf "Mounting fs %i/%i...\r" "$((i + 1))" "$mount_count"
+
+    mp_i=$((i % top_level_mounts))
+
+    pushd share/mnt$mp_i >/dev/null
+    path=mnt$mp_i
+    while true; do
+        sub_mp="$(echo mnt*)"
+        if cd sub 2>/dev/null; then
+            path="$path/sub"
+        elif [ -n "$sub_mp" ] && cd "$sub_mp" 2>/dev/null; then
+            path="$path/$sub_mp"
+        else
+            break
+        fi
+    done
+    mkdir mnt$i
+    touch mnt$i/not-mounted
+    sudo mount "${devs[i]}" mnt$i
+    sudo chown "$(id -u):$(id -g)" mnt$i
+
+    cd mnt$i
+    path="$path/mnt$i"
+    nesting=$((RANDOM % 4))
+    for ((j = 0; j < $nesting; j++)); do
+        cat > some-file <<EOF
+$i
+$path
+EOF
+        mkdir sub
+        cd sub
+        path="$path/sub"
+    done
+    cat > some-file <<EOF
+$i
+$path
+EOF
+    popd >/dev/null
+done
+echo
+
+echo 'Done.'
-- 
2.26.2

