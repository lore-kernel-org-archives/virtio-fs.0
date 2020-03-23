From: Max Reitz <mreitz@redhat.com>
Message-ID: <cb5bc383-a669-ebaa-3919-a5f860e10a52@redhat.com>
Date: Mon, 23 Mar 2020 19:18:57 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="7Hh6u4xaW2Y8oyUbWGtyNd8fj2ZHtHgiA"
Subject: [Virtio-fs] xfstest generic/503 hangs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7Hh6u4xaW2Y8oyUbWGtyNd8fj2ZHtHgiA
Content-Type: multipart/mixed; boundary="NKqy5MSgy3aFJuQhOuP2blXFIIN5xTotS"

--NKqy5MSgy3aFJuQhOuP2blXFIIN5xTotS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

I have this bug report here:
https://bugzilla.redhat.com/show_bug.cgi?id=3D1813885

And I=E2=80=99m afraid I=E2=80=99m not really making progress on debuggin=
g it, so I was
wondering whether any of you might have some insights.

The problem is that the generic/503 xfstest hangs on virtio-fs.  Now, I
don=E2=80=99t know how the reporter got that test to run in the first pla=
ce,
because for me, it requires fcollapse and fzero, which as far as I can
tell are currently not supported for virtio-fs.

So I first had to disable those requirements, and then let the helper
program (src/t_mmap_collision.c) not test those operations.

Then, the test hangs.  What I could find out so far is that the hang
occurs in src/t_mmap_collision.c=E2=80=99s truncate_down_fn() (run throug=
h
run_test(&truncate_down_fn), namely in one of the pread()s.  I can also
see that some of the pread()s before fail with EFAULT.

A bit more context: t_mmap_collision.c opens a test file twice (I think
the idea is that you open it once on an FS with DAX, and once without,
but AFAIU it should work either way).  For the relevant test, it mmap()s
the DAX FD, truncates it, then fallocates it to increase the size again.
 Then it reads from the non-DAX FD.

It does all of that in two threads simultaneously for a second.

The EFAULT seems to come from the guest kernel.  I don=E2=80=99t see virt=
iofsd
returning an error anywhere.  I don=E2=80=99t know where it comes from ex=
actly,
only that when I replace all occurrences of =E2=80=9CEFAULT=E2=80=9D by e=
=2Eg. =E2=80=9CEBADSLT=E2=80=9D
in mm/, the test crashes instead of hanging, so I take that to mean that
the error comes from something in mm/ (which I suppose isn=E2=80=99t too
unexpected).

The test passes if running the test function in a single thread instead
of two, or if you use a separate TEST_DEV and SCRATCH_DEV =E2=80=93 but i=
n the
latter case, you really have two separate files, so the test becomes
rather moot (AFAIU).

The fact that truncate_down_fn() uses fallocate() seems irrelevant.
When you replace it by ftruncate() (i.e. the dax_fd is just first
truncated to 0, and then truncated back to @file_size), the test fails
in the same way.  So maybe there is some interaction between the
ftruncate() and a concurrent pread()?  But where does the EFAULT come fro=
m?

Does anyone have any spontaneous ideas? :/


In any case, thanks already for reading this,

Max


(I suppose my plan now is that instead of debugging the kernel further,
I should come up with a simpler reproducer, to see whether the problem
is really just a concurrent ftruncate() + pread() on two FDs that point
to the same file.)


--NKqy5MSgy3aFJuQhOuP2blXFIIN5xTotS--

--7Hh6u4xaW2Y8oyUbWGtyNd8fj2ZHtHgiA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl54/ZEACgkQ9AfbAGHV
z0AU4Qf/aqncEflR6fHD54tPoG9qn23tkBY6cHq4FokWeTkWi9IP1eHVPmfyCaYW
xEuGECkajijhbOoV0CBETH6K2xO4N5qX8io4JpKe7RrbeuGOL7u6HtR0takFKqPJ
dQUVccQC7bzVRFrDs/mqPyUnjYueGzL52JhgnRyr+/BhVcJL2SAzQGyKjiZqOf5f
gM3MD4JMFE7XXFbpABwcycqXeucLy7GZC99M3gcqjs4e4gFsFBGk+jywsZyVP5OR
HDPjgntjOkVkgTpImlZIBpQ+N5i9r7wnvhtkOom0fchz0DyzRGXiEhYPQLVZa7UG
sYJMB1ZvALPzLbrWrOJklhFbJowh6A==
=lgfn
-----END PGP SIGNATURE-----

--7Hh6u4xaW2Y8oyUbWGtyNd8fj2ZHtHgiA--

