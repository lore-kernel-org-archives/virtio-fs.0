MIME-Version: 1.0
References: <20201105194416.GA1384085@redhat.com>
	<20201105195253.GB1384085@redhat.com>
	<D9233684-9B76-468E-A5F1-B35DA3F3C091@intel.com>
	<20201106223524.GG1436035@redhat.com>
	<CAOssrKcJr9a_5EUTU19BTp1UaST64Shh9w0UeR6TXPLqkN7bBw@mail.gmail.com>
In-Reply-To: <CAOssrKcJr9a_5EUTU19BTp1UaST64Shh9w0UeR6TXPLqkN7bBw@mail.gmail.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Thu, 12 Nov 2020 10:57:11 +0100
Message-ID: <CAOssrKeyRVSxCCyvPJvjoXgPYd3Dkkwn5fwAzxeyj-h3g8FqqA@mail.gmail.com>
Content-Type: multipart/mixed; boundary="0000000000003a764e05b3e5f007"
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Use --thread-pool-size=0 to mean
 no thread pool
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, "Shinde,
	Archana M" <archana.m.shinde@intel.com>, "Venegas Munoz,
	Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, Miklos Szeredi <miklos@szeredi.hu>

--0000000000003a764e05b3e5f007
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 12, 2020 at 10:06 AM Miklos Szeredi <mszeredi@redhat.com> wrote:
>
> On Fri, Nov 6, 2020 at 11:35 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Fri, Nov 06, 2020 at 08:33:50PM +0000, Venegas Munoz, Jose Carlos wrote:
> > > Hi Vivek,
> > >
> > > I have tested with Kata 1.12-apha0, the results seems that are better for the use fio config I am tracking.
> > >
> > > The fio config does  randrw:
> > >
> > > fio --direct=1 --gtod_reduce=1 --name=test --filename=random_read_write.fio --bs=4k --iodepth=64 --size=200M --readwrite=randrw --rwmixread=75
> > >
> >
> > Hi Carlos,
> >
> > Thanks for the testing.
> >
> > So basically two conclusions from your tests.
> >
> > - for virtiofs, --thread-pool-size=0 is performing better as comapred
> >   to --thread-pool-size=1 as well as --thread-pool-size=64. Approximately
> >   35-40% better.
> >
> > - virtio-9p is still approximately 30% better than virtiofs
> >   --thread-pool-size=0.
> >
> > As I had done the analysis that this particular workload (mixed read and
> > write) is bad with virtiofs because after every write we are invalidating
> > attrs and cache so next read ends up fetching attrs again. I had posted
> > patches to gain some of the performance.
> >
> > https://lore.kernel.org/linux-fsdevel/20200929185015.GG220516@redhat.com/
> >
> > But I got the feedback to look into implementing file leases instead.
>
> Hmm, the FUSE_AUTO_INVAL_DATA feature is buggy, how about turning it
> off for now?   9p doesn't have it, so no point in enabling it for
> virtiofs by default.
>
> Also I think some confusion comes from cache=auto being the default
> for virtiofs.    Not sure what the default is for 9p, but comparing
> default to default will definitely not be apples to apples since this
> mode is nonexistent in 9p.
>
> 9p:cache=none  <-> virtiofs:cache=none
> 9p:cache=loose <-> virtiofs:cache=always
>
> "9p:cache=mmap" and "virtiofs:cache=auto" have no match.
>
> Untested patch attached.

Another performance issue with virtiofs could be due to the strict
page writeback rules in fuse that are meant to prevent misuse of
kernel memory by unprivileged processes.   Since virtiofs isn't
subject to that limitation, these could be relaxed.

Attaching a patch that does one half of this.  The other half is
getting rid of the page copying, that's a bit more involved, but
shouldn't be too difficult.  Just need to duplicate the cached
writeback callbacks for virtiofs and do away with the complex temp
page stuff.

Thanks,
Miklos

--0000000000003a764e05b3e5f007
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="virtiofs-relax-writeback-restrictions.patch"
Content-Disposition: attachment; 
	filename="virtiofs-relax-writeback-restrictions.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_khenr3g40>
X-Attachment-Id: f_khenr3g40

ZGlmZiAtLWdpdCBhL2ZzL2Z1c2UvZnVzZV9pLmggYi9mcy9mdXNlL2Z1c2VfaS5oCmluZGV4IGQ0
MTRjNzg3ZTM2Mi4uOTJjOTJjNDgyYzU3IDEwMDY0NAotLS0gYS9mcy9mdXNlL2Z1c2VfaS5oCisr
KyBiL2ZzL2Z1c2UvZnVzZV9pLmgKQEAgLTUwMiw2ICs1MDIsNyBAQCBzdHJ1Y3QgZnVzZV9mc19j
b250ZXh0IHsKIAlib29sIG5vX2ZvcmNlX3Vtb3VudDoxOwogCWJvb2wgbGVnYWN5X29wdHNfc2hv
dzoxOwogCWJvb2wgZGF4OjE7CisJYm9vbCByZWxheF93cml0ZWJhY2s6MTsKIAl1bnNpZ25lZCBp
bnQgbWF4X3JlYWQ7CiAJdW5zaWduZWQgaW50IGJsa3NpemU7CiAJY29uc3QgY2hhciAqc3VidHlw
ZTsKZGlmZiAtLWdpdCBhL2ZzL2Z1c2UvaW5vZGUuYyBiL2ZzL2Z1c2UvaW5vZGUuYwppbmRleCAz
NmFiMDUzMTU4MjguLjAyOTMyNWViZDFiMyAxMDA2NDQKLS0tIGEvZnMvZnVzZS9pbm9kZS5jCisr
KyBiL2ZzL2Z1c2UvaW5vZGUuYwpAQCAtMTEzMCw3ICsxMTMwLDggQEAgdm9pZCBmdXNlX2ZyZWVf
Y29ubihzdHJ1Y3QgZnVzZV9jb25uICpmYykKIH0KIEVYUE9SVF9TWU1CT0xfR1BMKGZ1c2VfZnJl
ZV9jb25uKTsKIAotc3RhdGljIGludCBmdXNlX2JkaV9pbml0KHN0cnVjdCBmdXNlX2Nvbm4gKmZj
LCBzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiKQorc3RhdGljIGludCBmdXNlX2JkaV9pbml0KHN0cnVj
dCBmdXNlX2Nvbm4gKmZjLCBzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLAorCQkJIHN0cnVjdCBmdXNl
X2ZzX2NvbnRleHQgKmN0eCkKIHsKIAlpbnQgZXJyOwogCWNoYXIgKnN1ZmZpeCA9ICIiOwpAQCAt
MTE1MSwyMSArMTE1MiwyNCBAQCBzdGF0aWMgaW50IGZ1c2VfYmRpX2luaXQoc3RydWN0IGZ1c2Vf
Y29ubiAqZmMsIHN0cnVjdCBzdXBlcl9ibG9jayAqc2IpCiAKIAkvKiBmdXNlIGRvZXMgaXQncyBv
d24gd3JpdGViYWNrIGFjY291bnRpbmcgKi8KIAlzYi0+c19iZGktPmNhcGFiaWxpdGllcyAmPSB+
QkRJX0NBUF9XUklURUJBQ0tfQUNDVDsKLQlzYi0+c19iZGktPmNhcGFiaWxpdGllcyB8PSBCRElf
Q0FQX1NUUklDVExJTUlUOwogCi0JLyoKLQkgKiBGb3IgYSBzaW5nbGUgZnVzZSBmaWxlc3lzdGVt
IHVzZSBtYXggMSUgb2YgZGlydHkgKwotCSAqIHdyaXRlYmFjayB0aHJlc2hvbGQuCi0JICoKLQkg
KiBUaGlzIGdpdmVzIGFib3V0IDFNIG9mIHdyaXRlIGJ1ZmZlciBmb3IgbWVtb3J5IG1hcHMgb24g
YQotCSAqIG1hY2hpbmUgd2l0aCAxRyBhbmQgMTAlIGRpcnR5X3JhdGlvLCB3aGljaCBzaG91bGQg
YmUgbW9yZQotCSAqIHRoYW4gZW5vdWdoLgotCSAqCi0JICogUHJpdmlsZWdlZCB1c2VycyBjYW4g
cmFpc2UgaXQgYnkgd3JpdGluZyB0bwotCSAqCi0JICogICAgL3N5cy9jbGFzcy9iZGkvPGJkaT4v
bWF4X3JhdGlvCi0JICovCi0JYmRpX3NldF9tYXhfcmF0aW8oc2ItPnNfYmRpLCAxKTsKKwlpZiAo
IWN0eC0+cmVsYXhfd3JpdGViYWNrKSB7CisJCXNiLT5zX2JkaS0+Y2FwYWJpbGl0aWVzIHw9IEJE
SV9DQVBfU1RSSUNUTElNSVQ7CisKKwkJLyoKKwkJICogRm9yIGEgc2luZ2xlIGZ1c2UgZmlsZXN5
c3RlbSB1c2UgbWF4IDElIG9mIGRpcnR5ICsKKwkJICogd3JpdGViYWNrIHRocmVzaG9sZC4KKwkJ
ICoKKwkJICogVGhpcyBnaXZlcyBhYm91dCAxTSBvZiB3cml0ZSBidWZmZXIgZm9yIG1lbW9yeSBt
YXBzIG9uIGEKKwkJICogbWFjaGluZSB3aXRoIDFHIGFuZCAxMCUgZGlydHlfcmF0aW8sIHdoaWNo
IHNob3VsZCBiZSBtb3JlCisJCSAqIHRoYW4gZW5vdWdoLgorCQkgKgorCQkgKiBQcml2aWxlZ2Vk
IHVzZXJzIGNhbiByYWlzZSBpdCBieSB3cml0aW5nIHRvCisJCSAqCisJCSAqICAgIC9zeXMvY2xh
c3MvYmRpLzxiZGk+L21heF9yYXRpbworCQkgKi8KKwkJYmRpX3NldF9tYXhfcmF0aW8oc2ItPnNf
YmRpLCAxKTsKKwl9CiAKIAlyZXR1cm4gMDsKIH0KQEAgLTEzNTQsNyArMTM1OCw3IEBAIGludCBm
dXNlX2ZpbGxfc3VwZXJfY29tbW9uKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHN0cnVjdCBmdXNl
X2ZzX2NvbnRleHQgKmN0eCkKIAogCWZjLT5kZXYgPSBzYi0+c19kZXY7CiAJZm0tPnNiID0gc2I7
Ci0JZXJyID0gZnVzZV9iZGlfaW5pdChmYywgc2IpOworCWVyciA9IGZ1c2VfYmRpX2luaXQoZmMs
IHNiLCBjdHgpOwogCWlmIChlcnIpCiAJCWdvdG8gZXJyX2Rldl9mcmVlOwogCmRpZmYgLS1naXQg
YS9mcy9mdXNlL3ZpcnRpb19mcy5jIGIvZnMvZnVzZS92aXJ0aW9fZnMuYwppbmRleCA4ODY4YWMz
MWEzYzAuLmVmYmUxNjk3NjEyZSAxMDA2NDQKLS0tIGEvZnMvZnVzZS92aXJ0aW9fZnMuYworKysg
Yi9mcy9mdXNlL3ZpcnRpb19mcy5jCkBAIC0xMjg4LDYgKzEyODgsNyBAQCBzdGF0aWMgaW5saW5l
IHZvaWQgdmlydGlvX2ZzX2N0eF9zZXRfZGVmYXVsdHMoc3RydWN0IGZ1c2VfZnNfY29udGV4dCAq
Y3R4KQogCWN0eC0+ZGVzdHJveSA9IHRydWU7CiAJY3R4LT5ub19jb250cm9sID0gdHJ1ZTsKIAlj
dHgtPm5vX2ZvcmNlX3Vtb3VudCA9IHRydWU7CisJY3R4LT5yZWxheF93cml0ZWJhY2sgPSB0cnVl
OwogfQogCiBzdGF0aWMgaW50IHZpcnRpb19mc19maWxsX3N1cGVyKHN0cnVjdCBzdXBlcl9ibG9j
ayAqc2IsIHN0cnVjdCBmc19jb250ZXh0ICpmc2MpCg==
--0000000000003a764e05b3e5f007--

