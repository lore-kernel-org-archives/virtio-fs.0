References: <20201029171744.150726-1-mreitz@redhat.com>
	<20201029171744.150726-8-mreitz@redhat.com>
	<20201029204601.GM5733@habkost.net>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <20680712-df27-3a7d-13bc-720c37121274@redhat.com>
Date: Fri, 30 Oct 2020 10:14:38 +0100
MIME-Version: 1.0
In-Reply-To: <20201029204601.GM5733@habkost.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="kQ6oBDaZ53EqzpVqDqjuL2arePh4sQckW"
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
To: Eduardo Habkost <ehabkost@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kQ6oBDaZ53EqzpVqDqjuL2arePh4sQckW
Content-Type: multipart/mixed; boundary="re4RYIjmYwKatmkUQHS60A7dAi5BAKYC6"

--re4RYIjmYwKatmkUQHS60A7dAi5BAKYC6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 29.10.20 21:46, Eduardo Habkost wrote:
> On Thu, Oct 29, 2020 at 06:17:44PM +0100, Max Reitz wrote:
>> This test invokes several shell scripts to create a random directory
>> tree full of submounts, and then check in the VM whether every submoun=
t
>> has its own ID and the structure looks as expected.
>>
>> (Note that the test scripts must be non-executable, so Avocado will no=
t
>> try to execute them as if they were tests on their own, too.)
>>
>> Because at this commit's date it is unlikely that the Linux kernel on
>> the image provided by boot_linux.py supports submounts in virtio-fs, t=
he
>> test will be cancelled if no custom Linux binary is provided through t=
he
>> vmlinuz parameter.  (The on-image kernel can be used by providing an
>> empty string via vmlinuz=3D.)
>>
>> So, invoking the test can be done as follows:
>> $ avocado run \
>>     tests/acceptance/virtiofs_submounts.py \
>>     -p vmlinuz=3D/path/to/linux/build/arch/x86/boot/bzImage
>>
>> This test requires root privileges (through passwordless sudo -n),
>> because at this point, virtiofsd requires them.  (If you have a
>> timestamp_timeout period for sudoers (e.g. the default of 5 min), you
>> can provide this by executing something like "sudo true" before invoki=
ng
>> Avocado.)
>>
>> Signed-off-by: Max Reitz <mreitz@redhat.com>
>> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>> ---
>>  tests/acceptance/virtiofs_submounts.py        | 289 +++++++++++++++++=
+
>>  .../virtiofs_submounts.py.data/cleanup.sh     |  46 +++
>>  .../guest-cleanup.sh                          |  30 ++
>>  .../virtiofs_submounts.py.data/guest.sh       | 138 +++++++++
>>  .../virtiofs_submounts.py.data/host.sh        | 127 ++++++++
>>  5 files changed, 630 insertions(+)
>>  create mode 100644 tests/acceptance/virtiofs_submounts.py
>>  create mode 100644 tests/acceptance/virtiofs_submounts.py.data/cleanu=
p.sh
>>  create mode 100644 tests/acceptance/virtiofs_submounts.py.data/guest-=
cleanup.sh
>>  create mode 100644 tests/acceptance/virtiofs_submounts.py.data/guest.=
sh
>>  create mode 100644 tests/acceptance/virtiofs_submounts.py.data/host.s=
h
>>
>> diff --git a/tests/acceptance/virtiofs_submounts.py b/tests/acceptance=
/virtiofs_submounts.py
>> new file mode 100644
>> index 0000000000..8b207b3e57
>> --- /dev/null
>> +++ b/tests/acceptance/virtiofs_submounts.py
>> @@ -0,0 +1,289 @@
>> +import logging
>> +import re
>> +import os
>> +import subprocess
>> +import time
>> +
>> +from avocado import skipUnless
>> +from avocado_qemu import Test, BUILD_DIR
>> +from avocado_qemu import wait_for_console_pattern
>> +from avocado.utils import ssh
>> +
>> +from qemu.accel import kvm_available
>> +
>> +from boot_linux import BootLinux
>> +
>> +
>> +def run_cmd(args):
>> +    subp =3D subprocess.Popen(args,
>> +                            stdout=3Dsubprocess.PIPE,
>> +                            stderr=3Dsubprocess.PIPE,
>> +                            universal_newlines=3DTrue)
>> +    stdout, stderr =3D subp.communicate()
>> +    ret =3D subp.returncode
>> +
>> +    return (stdout, stderr, ret)
>> +
>> +def has_passwordless_sudo():
>> +    """
>> +    This function is for use in a @avocado.skipUnless decorator, e.g.=
:
>> +
>> +        @skipUnless(*has_passwordless_sudo())
>> +        def test_something_that_needs_sudo(self):
>> +            ...
>> +    """
>> +
>> +    _, stderr, exitcode =3D run_cmd(('sudo', '-n', 'true'))
>=20
> This seems to break if sudo is not available in the host:

Oh, makes sense.  I=E2=80=99ll wrap it in a try-except.  Thanks!

Max

> https://gitlab.com/ehabkost/qemu/-/jobs/820072411#L152
>=20
> 0:37:08 ERROR| ERROR 32-tests/acceptance/virtiofs_submounts.py:Virtiofs=
SubmountsTest.test_pre_virtiofsd_set_up -> TestError: Traceback (most rec=
ent call last):
>   File "/usr/lib64/python3.6/imp.py", line 235, in load_module
>     return load_source(name, filename, file)
>   File "/usr/lib64/python3.6/imp.py", line 172, in load_source
>     module =3D _load(spec)
>   File "<frozen importlib._bootstrap>", line 684, in _load
>   File "<frozen importlib._bootstrap>", line 665, in _load_unlocked
>   File "<frozen importlib._bootstrap_external>", line 678, in exec_modu=
le
>   File "<frozen importlib._bootstrap>", line 219, in _call_with_frames_=
removed
>   File "/builds/ehabkost/qemu/build/tests/acceptance/virtiofs_submounts=
=2Epy", line 43, in <module>
>     class VirtiofsSubmountsTest(BootLinux):
>   File "/builds/ehabkost/qemu/build/tests/acceptance/virtiofs_submounts=
=2Epy", line 195, in VirtiofsSubmountsTest
>     @skipUnless(*has_passwordless_sudo())
>   File "/builds/ehabkost/qemu/build/tests/acceptance/virtiofs_submounts=
=2Epy", line 36, in has_passwordless_sudo
>     _, stderr, exitcode =3D run_cmd(('sudo', '-n', 'true'))
>   File "/builds/ehabkost/qemu/build/tests/acceptance/virtiofs_submounts=
=2Epy", line 21, in run_cmd
>     universal_newlines=3DTrue)
>   File "/usr/lib64/python3.6/subprocess.py", line 729, in __init__
>     restore_signals, start_new_session)
>   File "/usr/lib64/python3.6/subprocess.py", line 1364, in _execute_chi=
ld
>     raise child_exception_type(errno_num, err_msg, err_filename)
> FileNotFoundError: [Errno 2] No such file or directory: 'sudo': 'sudo'
> 20:37:08 INFO |=20
>=20
>> +    if exitcode !=3D 0:
>> +        return (False, f'Failed to use sudo -n: {stderr.strip()}')
>> +    else:
>> +        return (True, '')
>> +
>> +
> [...]
>=20



--re4RYIjmYwKatmkUQHS60A7dAi5BAKYC6--

--kQ6oBDaZ53EqzpVqDqjuL2arePh4sQckW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl+b2X4ACgkQ9AfbAGHV
z0AdIgf8Dich9OAPZTYWLvH5kV0dnWtPasCeHHKYWo0dswKuUJmeKndvgfDXLQN2
NSVVefyKtMAiZ90hGvpGF26+mi81BnTOVWKtMSU5pP99S1rsxb2eLyOhWFIktbds
k54VSITwrpFUAX+hh4M11iefvyVCuFFZlpynE5Neu9Kgp3LzrTX2340kYnpJmuib
imogM+G2fSEm+Lm0yDks1IaRjD/0xu3KAY1ael8OPmCfl85KT1564QKv6EwiDezp
MgNrXbRco8EeVVdkNZ6nNO4jdk0moVHjb1ioGpFWkQ6c0YWhaV3pC6HGFv9F2Dme
v7VB08UkPAivvZpwlEXR900j/cfw1g==
=Fq4H
-----END PGP SIGNATURE-----

--kQ6oBDaZ53EqzpVqDqjuL2arePh4sQckW--

