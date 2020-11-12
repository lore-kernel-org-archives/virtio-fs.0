MIME-Version: 1.0
References: <20201105194416.GA1384085@redhat.com>
	<20201105195253.GB1384085@redhat.com>
	<D9233684-9B76-468E-A5F1-B35DA3F3C091@intel.com>
	<20201106223524.GG1436035@redhat.com>
In-Reply-To: <20201106223524.GG1436035@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Thu, 12 Nov 2020 10:06:37 +0100
Message-ID: <CAOssrKcJr9a_5EUTU19BTp1UaST64Shh9w0UeR6TXPLqkN7bBw@mail.gmail.com>
Content-Type: multipart/mixed; boundary="00000000000058113d05b3e53bc6"
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

--00000000000058113d05b3e53bc6
Content-Type: text/plain; charset="UTF-8"

On Fri, Nov 6, 2020 at 11:35 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Fri, Nov 06, 2020 at 08:33:50PM +0000, Venegas Munoz, Jose Carlos wrote:
> > Hi Vivek,
> >
> > I have tested with Kata 1.12-apha0, the results seems that are better for the use fio config I am tracking.
> >
> > The fio config does  randrw:
> >
> > fio --direct=1 --gtod_reduce=1 --name=test --filename=random_read_write.fio --bs=4k --iodepth=64 --size=200M --readwrite=randrw --rwmixread=75
> >
>
> Hi Carlos,
>
> Thanks for the testing.
>
> So basically two conclusions from your tests.
>
> - for virtiofs, --thread-pool-size=0 is performing better as comapred
>   to --thread-pool-size=1 as well as --thread-pool-size=64. Approximately
>   35-40% better.
>
> - virtio-9p is still approximately 30% better than virtiofs
>   --thread-pool-size=0.
>
> As I had done the analysis that this particular workload (mixed read and
> write) is bad with virtiofs because after every write we are invalidating
> attrs and cache so next read ends up fetching attrs again. I had posted
> patches to gain some of the performance.
>
> https://lore.kernel.org/linux-fsdevel/20200929185015.GG220516@redhat.com/
>
> But I got the feedback to look into implementing file leases instead.

Hmm, the FUSE_AUTO_INVAL_DATA feature is buggy, how about turning it
off for now?   9p doesn't have it, so no point in enabling it for
virtiofs by default.

Also I think some confusion comes from cache=auto being the default
for virtiofs.    Not sure what the default is for 9p, but comparing
default to default will definitely not be apples to apples since this
mode is nonexistent in 9p.

9p:cache=none  <-> virtiofs:cache=none
9p:cache=loose <-> virtiofs:cache=always

"9p:cache=mmap" and "virtiofs:cache=auto" have no match.

Untested patch attached.

Thanks,
Miklos

--00000000000058113d05b3e53bc6
Content-Type: application/x-patch; name="virtiofs-perf-fix.patch"
Content-Disposition: attachment; filename="virtiofs-perf-fix.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kheldrw30>
X-Attachment-Id: f_kheldrw30

ZGlmZiAtLWdpdCBhL3Rvb2xzL3ZpcnRpb2ZzZC9wYXNzdGhyb3VnaF9sbC5jIGIvdG9vbHMvdmly
dGlvZnNkL3Bhc3N0aHJvdWdoX2xsLmMKaW5kZXggZWMxMDA4YmNlYmE4Li5kNDc0YzU1M2JiNWMg
MTAwNjQ0Ci0tLSBhL3Rvb2xzL3ZpcnRpb2ZzZC9wYXNzdGhyb3VnaF9sbC5jCisrKyBiL3Rvb2xz
L3ZpcnRpb2ZzZC9wYXNzdGhyb3VnaF9sbC5jCkBAIC02MTgsNiArNjE4LDkgQEAgc3RhdGljIHZv
aWQgbG9faW5pdCh2b2lkICp1c2VyZGF0YSwgc3RydWN0IGZ1c2VfY29ubl9pbmZvICpjb25uKQog
ICAgICAgICBsby0+YW5ub3VuY2Vfc3VibW91bnRzID0gZmFsc2U7CiAgICAgfQogI2VuZGlmCisK
KyAgICAvKiBUaGlzIGlzIGN1cnJlbnRseSBidWdneSB3aXRoIG1peGVkIHJlYWQtd3JpdGUgbG9h
ZCwgc28gZGlzYWJsZSAqLworICAgIGNvbm4tPndhbnQgJj0gfkZVU0VfQ0FQX0FVVE9fSU5WQUxf
REFUQTsKIH0KIAogc3RhdGljIHZvaWQgbG9fZ2V0YXR0cihmdXNlX3JlcV90IHJlcSwgZnVzZV9p
bm9fdCBpbm8sCkBAIC0zNDQ0LDcgKzM0NDcsNyBAQCBpbnQgbWFpbihpbnQgYXJnYywgY2hhciAq
YXJndltdKQogICAgIGxvLmlub2RlcyA9IGdfaGFzaF90YWJsZV9uZXcobG9fa2V5X2hhc2gsIGxv
X2tleV9lcXVhbCk7CiAgICAgbG8ucm9vdC5mZCA9IC0xOwogICAgIGxvLnJvb3QuZnVzZV9pbm8g
PSBGVVNFX1JPT1RfSUQ7Ci0gICAgbG8uY2FjaGUgPSBDQUNIRV9BVVRPOworICAgIGxvLmNhY2hl
ID0gQ0FDSEVfQUxXQVlTOwogCiAgICAgLyoKICAgICAgKiBTZXQgdXAgdGhlIGlubyBtYXAgbGlr
ZSB0aGlzOgo=
--00000000000058113d05b3e53bc6--

