Date: Tue, 24 Aug 2021 15:22:23 +0200
From: Sergio Lopez <slp@redhat.com>
Message-ID: <20210824132223.7ujg7joxq2pwu5jo@mhamilton>
References: <20210823093107.okqkowakgwwwvvzv@mhamilton>
	<CAJFHJroOBS=H+YkYNkvhgS3wz1N5juYRESBPzaJMGYQ1_e0QHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="g3ip4owkdlurswba"
Content-Disposition: inline
In-Reply-To: <CAJFHJroOBS=H+YkYNkvhgS3wz1N5juYRESBPzaJMGYQ1_e0QHg@mail.gmail.com>
Subject: Re: [Virtio-fs] Problem using gdb/lldb on a binary residing on a
 DAX-enabled volume
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: virtio-fs-list <virtio-fs@redhat.com>, David Riley <davidriley@google.com>, Sergey Senozhatsky <senozhatsky@google.com>, Yu Zhao <yuzhao@google.com>


--g3ip4owkdlurswba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 24, 2021 at 02:04:45PM +0900, Chirantan Ekbote wrote:
> Hi Sergio,
>=20
> On Mon, Aug 23, 2021 at 6:31 PM Sergio Lopez <slp@redhat.com> wrote:
> >
> > Hi,
> >
> > I've noticed that trying to use gdb/lldb on any binary residing on a
> > DAX-enabled virtio-fs volume leads to a SIGSEGV in userspace...
> >
> > Seems like DAX breaks something in the ptrace_access_vm path. On a
> > volume without DAX works fine.
> >
>=20
> We've seen this as well and unfortunately it doesn't appear to be
> limited to virtio-fs.  Using DAX on a ext4 formatted virtio-pmem disk
> image has the same problem.  We've actually disabled DAX everywhere
> because of this.
>=20
> Unfortunately most of the details are in an internal bug report but
> I'll try to extract the relevant bits here.  This is well outside my
> depth so I've CC'd some of the people who have looked at this.  The
> initial bug report was for virtio-pmem+ext4 so some of the details are
> specific to pmem but I suspect something similar is happening for
> virtio-fs as well.
>=20
> The issue is that process_vm_readv() corrupts the memory of files that
> are mmap()'d when DAX is enabled.
>=20
> 1. A filesystem is mounted with DAX enabled.  pmem_attach_disk() sets
> pfn_flags to PFN_DEV|PFN_MAP.  In the fuse case, this appears to
> happen here [1].
> 2. When the (strace/gdb/etc) process does its initial read of the
> mmap()'d region, the pfn flags for the page are inherited from the
> pmem structure set to PFN_DEV|PFN_MAP in step 1.  During a call to
> insert_pfn(), pte_mkdevmap is called to mark the pte as devmap.
> 3. If you follow the ftrace of the process_vm_readv(), it eventually
> reaches do_wp_page(). If the target process had not previously read
> the page in, this would not call do_wp_page() and instead just fault
> in the page normally through the ext4/dax logic.
> 4. do_wp_page() calls vm_normal_page() which returns NULL due to the
> remote pte being marked special and devmap (from above).  If we just
> ignore the devmap check and return the page that has been found and
> allow the normal copy to occur, then no problem occurs.  However, that
> can't be safely done in normal dax cases.  Due to vm_normal_page()
> returning NULL, wp_page_copy() is called (first call site) with a null
> vmf->address.  If the mmap()d file is originally from a non-dax
> filesystem (eg tmpfs), the second wp_page_copy() ends up being called
> with a valid vmf->address.
> 5. cow_user_page() ends up in this unexpected case since
> src=3D=3Dvmf->address is NULL, delimited with the following comment:
>=20
>         /*
>          * If the source page was a PFN mapping, we don't have
>          * a "struct page" for it. We do a best-effort copy by
>          * just copying from the original user address. If that
>          * fails, we just zero-fill it. Live with it.
>          */
>=20
> The end effect of this is that there is the
> __copy_from_user_inatomic() call with an invalid uaddr because the
> uaddr is from the remote address space.   This results in another page
> fault because that remote address isn't valid in the process calling
> process_vm_readv().  It seems that there's a few issues here, a) that
> it's trying to read from the remote address space as if it were local,
> and b) that the failure here is corrupting the remote processes memory
> and not just returning an empty page which would be less broken.
>=20
> In the good case of the mmap()d file being from tmpfs,
> src=3D=3Dvmf->address is non-NULL and copy_user_highpage can properly do
> the copy of the page.  At that point, the caller is able to copy data
> from that page to its own local buffer and return data successfully,
> as well as avoid corrupting the remote process.
>=20
> We've also found that reverting "17839856fd58: gup: document and work
> around "COW can break either way" issue" seems to make the problem go
> away.

Thanks a lot for the super-detailed write-up. Do you know if someone
is already working on a fix that can be upstreamed?

Sergio.

--g3ip4owkdlurswba
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAmEk8o4ACgkQ9GknjS8M
AjWkuBAApX148unbM0HQ9q5MJGQgcvQ636sDMZuBYMWvnsLXn0/BVdU4m5OCtPq0
7YLEzkMsAKv9G+ksrbKOcT9K0uK8srnZSX9r0kYCRr6zx/rMl2+WQMVt1ch5CdeB
+V3AERbYqf2MwRBwN49vD758pmbyPlBVFJ0yCfzxvZ5mstqZ7Mb94mX3afiXoxQe
56f0AHovZx3Jdku1bIEin+bLcIY8/HSVh0otUK6jpummqGDRURE26jiGPsWSb3rp
kWRnGPmEGyqUWzCm69F8wVH8MgfNDfKQgBt60uXCeivj+0GEEU/i+o5bfShD0nuK
uaHId2P4BXr79DM98qYUmyif7qXMhd9FZYDj/M1ptUOYQkRP/MBb8Npc3LVBGhkg
m0ghrToA2cnt4+541hnqSyms7/h5qCmW9ZR8rc9w/c9W29eN9qwrOzE83QqFDRuJ
mZOt9fIdkUW/Veb+sas8JKCdYjWLUGAsN4q7uIDqAubGVgb0JZNgpn3RTbXM6wK3
miIt9l3VT9jc5UvNLNG0WalwuwCoGPa523pyMc1wIGzG7kSmnJmWaIl8anR1nx+B
TYrPJTCSiolUHK+hQUTAtof62a8XlW9dNpQ81AI/e1gF4d6TKvktiJPfJKGVWsTO
fK56BlLH7bCtiFG7kluvFMlGnulAP9Qck3MxSKgNsOHKWtcKzrQ=
=XHqx
-----END PGP SIGNATURE-----

--g3ip4owkdlurswba--

