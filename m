DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=CnhVeehijPVP3nRpK1w8awkTiUYL8Okf3l9pn5NH7fE=;
	b=LacHyyDRGaTYRaTaP6Udvh6AsAGpdrEGx/w+5stHImTsQ3KDQ2j68wkTThJbB2bEgO
	DmMog9Q2XNCNzYX2ltL50AK1+hXouF5mjFcw63V1ffpZxlP+7E4jLy8iVbiWptUEnFq1
	vfOc/eSdNOdnX9TNuOLU7UOfaAWYS4JJ40kKA=
MIME-Version: 1.0
References: <20210104160013.GG2972@work-vm> <20210104184527.GC63879@redhat.com>
	<20210104185655.GN2972@work-vm>
In-Reply-To: <20210104185655.GN2972@work-vm>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 5 Jan 2021 12:24:48 +0100
Message-ID: <CAJfpegvm0ZYojTeakkXgJ+Q1=k1UFiu=p3VeOST29PXjZGDreA@mail.gmail.com>
Content-Type: multipart/mixed; boundary="000000000000f86ca305b82574e9"
Subject: Re: [Virtio-fs] [fuse-devel] 'FORGET' ordering semantics (vs unlink
	& NFS)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>, virtio-fs-list <virtio-fs@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

--000000000000f86ca305b82574e9
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 4, 2021 at 7:57 PM Dr. David Alan Gilbert
<dgilbert@redhat.com> wrote:
>
> * Vivek Goyal (vgoyal@redhat.com) wrote:
> > On Mon, Jan 04, 2021 at 04:00:13PM +0000, Dr. David Alan Gilbert wrote:
> > > Hi,
> > >   On virtio-fs we're hitting a problem with NFS, where
> > > unlinking a file in a directory and then rmdir'ing that
> > > directory fails complaining about the directory not being empty.
> > >
> > > The problem here is that if a file has an open fd, NFS doesn't
> > > actually delete the file on unlink, it just renames it to
> > > a hidden file (e.g. .nfs*******).  That open file is there because
> > > the 'FORGET' hasn't completed yet by the time the rmdir is issued.
> > >
> > > Question:
> > >   a) In the FUSE protocol, are requests assumed to complete in order;
> > > i.e.  unlink, forget, rmdir   is it required that 'forget' completes
> > > before the rmdir is processed?
> > >      (In virtiofs we've been processing requests, in parallel, and
> > > have sent forgets down a separate queue to keep them out of the way).
> > >
> > >   b) 'forget' doesn't send a reply - so the kernel can't wait for the
> > > client to have finished it;  do we need a synchronous forget here?
> >
> > Even if we introduce a synchronous forget, will that really fix the
> > issue. For example, this could also happen if file has been unlinked
> > but it is still open and directory is being removed.
> >
> > fd = open(foo/bar.txt)
> > unlink foo/bar.txt
> > rmdir foo
> > close(fd).
> >
> > In this case, final forget should go after fd has been closed. Its
> > not a forget race.
> >
> > I wrote a test case for this and it works on regular file systems.
> >
> > https://github.com/rhvgoyal/misc/blob/master/virtiofs-tests/rmdir.c
> >
> > I suspect it will fail on nfs because I am assuming that temporary
> > file will be there till final close(fd) happens. If that's the
> > case this is a NFS specific issue because its behavior is different
> > from other file systems.
>
> That's true; but that's NFS just being NFS; in our case we're keeping
> an fd open even though the guest has been smart enough not to; so we're
> causing the NFS oddity when it wouldn't normally happen.

Can't think of anything better than a synchronous forget.   Compile
only tested patch attached.

Thanks,
Miklos

--000000000000f86ca305b82574e9
Content-Type: text/x-patch; charset="US-ASCII"; name="fuse-sync-forget.patch"
Content-Disposition: attachment; filename="fuse-sync-forget.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kjjwo1440>
X-Attachment-Id: f_kjjwo1440

ZGlmZiAtLWdpdCBhL2ZzL2Z1c2UvZGlyLmMgYi9mcy9mdXNlL2Rpci5jCmluZGV4IDc4ZjlmMjA5
MDc4Yy4uZGFhNGU2Njk0NDFkIDEwMDY0NAotLS0gYS9mcy9mdXNlL2Rpci5jCisrKyBiL2ZzL2Z1
c2UvZGlyLmMKQEAgLTM3Myw2ICszNzMsMjYgQEAgc3RhdGljIHN0cnVjdCB2ZnNtb3VudCAqZnVz
ZV9kZW50cnlfYXV0b21vdW50KHN0cnVjdCBwYXRoICpwYXRoKQogCXJldHVybiBFUlJfUFRSKGVy
cik7CiB9CiAKK3N0YXRpYyB2b2lkIGZ1c2VfZGVudHJ5X2lwdXQoc3RydWN0IGRlbnRyeSAqZGVu
dHJ5LCBzdHJ1Y3QgaW5vZGUgKmlub2RlKQoreworCWlmICghX19sb2NrcmVmX2lzX2RlYWQoJmRl
bnRyeS0+ZF9sb2NrcmVmKSkgeworCQkvKgorCQkgKiBUaGlzIGlzIGFuIHVubGluay9ybWRpciBh
bmQgcmVtb3ZpbmcgdGhlIGxhc3QgcmVmIHRvIHRoZQorCQkgKiBkZW50cnkuICBVc2Ugc3luY2hy
b25vdXMgRk9SR0VUIGluIGNhc2UgZmlsZXN5c3RlbSByZXF1ZXN0cworCQkgKiBpdC4KKwkJICoK
KwkJICogRklYTUU6IFRoaXMgaXMgcmFjeSEgIFR3byBvciBtb3JlIGluc3RhbmNlcyBvZgorCQkg
KiBmdXNlX2RlbnRyeV9pcHV0KCkgY291bGQgYmUgcnVubmluZyBjb25jdXJyZW50bHkgKHVubGlu
ayBvZgorCQkgKiBzZXZlcmFsIGFsaWFzZXMgaW4gZGlmZmVyZW50IGRpcmVjdG9yaWVzKS4KKwkJ
ICovCisJCXNldF9iaXQoRlVTRV9JX1NZTkNfRk9SR0VULCAmZ2V0X2Z1c2VfaW5vZGUoaW5vZGUp
LT5zdGF0ZSk7CisJCWlwdXQoaW5vZGUpOworCQljbGVhcl9iaXQoRlVTRV9JX1NZTkNfRk9SR0VU
LCAmZ2V0X2Z1c2VfaW5vZGUoaW5vZGUpLT5zdGF0ZSk7CisJfSBlbHNlIHsKKwkJaXB1dChpbm9k
ZSk7CisJfQorfQorCiBjb25zdCBzdHJ1Y3QgZGVudHJ5X29wZXJhdGlvbnMgZnVzZV9kZW50cnlf
b3BlcmF0aW9ucyA9IHsKIAkuZF9yZXZhbGlkYXRlCT0gZnVzZV9kZW50cnlfcmV2YWxpZGF0ZSwK
IAkuZF9kZWxldGUJPSBmdXNlX2RlbnRyeV9kZWxldGUsCkBAIC0zODEsNiArNDAxLDcgQEAgY29u
c3Qgc3RydWN0IGRlbnRyeV9vcGVyYXRpb25zIGZ1c2VfZGVudHJ5X29wZXJhdGlvbnMgPSB7CiAJ
LmRfcmVsZWFzZQk9IGZ1c2VfZGVudHJ5X3JlbGVhc2UsCiAjZW5kaWYKIAkuZF9hdXRvbW91bnQJ
PSBmdXNlX2RlbnRyeV9hdXRvbW91bnQsCisJLmRfaXB1dAkJPSBmdXNlX2RlbnRyeV9pcHV0LAog
fTsKIAogY29uc3Qgc3RydWN0IGRlbnRyeV9vcGVyYXRpb25zIGZ1c2Vfcm9vdF9kZW50cnlfb3Bl
cmF0aW9ucyA9IHsKZGlmZiAtLWdpdCBhL2ZzL2Z1c2UvZnVzZV9pLmggYi9mcy9mdXNlL2Z1c2Vf
aS5oCmluZGV4IDdjNGI4Y2I5M2Y5Zi4uMDgyMGI3YTYzY2E3IDEwMDY0NAotLS0gYS9mcy9mdXNl
L2Z1c2VfaS5oCisrKyBiL2ZzL2Z1c2UvZnVzZV9pLmgKQEAgLTE3NCw2ICsxNzQsOCBAQCBlbnVt
IHsKIAlGVVNFX0lfU0laRV9VTlNUQUJMRSwKIAkvKiBCYWQgaW5vZGUgKi8KIAlGVVNFX0lfQkFE
LAorCS8qIFN5bmNocm9ub3VzIGZvcmdldCByZXF1ZXN0ZWQgKi8KKwlGVVNFX0lfU1lOQ19GT1JH
RVQsCiB9OwogCiBzdHJ1Y3QgZnVzZV9jb25uOwpkaWZmIC0tZ2l0IGEvZnMvZnVzZS9pbm9kZS5j
IGIvZnMvZnVzZS9pbm9kZS5jCmluZGV4IGIwZTE4YjQ3MGU5MS4uYTQ5ZmYzMGQxZWNjIDEwMDY0
NAotLS0gYS9mcy9mdXNlL2lub2RlLmMKKysrIGIvZnMvZnVzZS9pbm9kZS5jCkBAIC0xMTUsNiAr
MTE1LDI2IEBAIHN0YXRpYyB2b2lkIGZ1c2VfZnJlZV9pbm9kZShzdHJ1Y3QgaW5vZGUgKmlub2Rl
KQogCWttZW1fY2FjaGVfZnJlZShmdXNlX2lub2RlX2NhY2hlcCwgZmkpOwogfQogCitzdGF0aWMg
dm9pZCBmdXNlX3N5bmNfZm9yZ2V0KHN0cnVjdCBpbm9kZSAqaW5vZGUpCit7CisJc3RydWN0IGZ1
c2VfbW91bnQgKmZtID0gZ2V0X2Z1c2VfbW91bnQoaW5vZGUpOworCXN0cnVjdCBmdXNlX2lub2Rl
ICpmaSA9IGdldF9mdXNlX2lub2RlKGlub2RlKTsKKwlzdHJ1Y3QgZnVzZV9mb3JnZXRfaW4gaW5h
cmc7CisJRlVTRV9BUkdTKGFyZ3MpOworCisJbWVtc2V0KCZpbmFyZywgMCwgc2l6ZW9mKGluYXJn
KSk7CisJaW5hcmcubmxvb2t1cCA9IGZpLT5ubG9va3VwOworCWFyZ3Mub3Bjb2RlID0gRlVTRV9T
WU5DX0ZPUkdFVDsKKwlhcmdzLm5vZGVpZCA9IGZpLT5ub2RlaWQ7CisJYXJncy5pbl9udW1hcmdz
ID0gMTsKKwlhcmdzLmluX2FyZ3NbMF0uc2l6ZSA9IHNpemVvZihpbmFyZyk7CisJYXJncy5pbl9h
cmdzWzBdLnZhbHVlID0gJmluYXJnOworCWFyZ3MuZm9yY2UgPSB0cnVlOworCisJZnVzZV9zaW1w
bGVfcmVxdWVzdChmbSwgJmFyZ3MpOworCS8qIGlnbm9yZSBlcnJvcnMgKi8KK30KKwogc3RhdGlj
IHZvaWQgZnVzZV9ldmljdF9pbm9kZShzdHJ1Y3QgaW5vZGUgKmlub2RlKQogewogCXN0cnVjdCBm
dXNlX2lub2RlICpmaSA9IGdldF9mdXNlX2lub2RlKGlub2RlKTsKQEAgLTEyNyw5ICsxNDcsMTMg
QEAgc3RhdGljIHZvaWQgZnVzZV9ldmljdF9pbm9kZShzdHJ1Y3QgaW5vZGUgKmlub2RlKQogCQlp
ZiAoRlVTRV9JU19EQVgoaW5vZGUpKQogCQkJZnVzZV9kYXhfaW5vZGVfY2xlYW51cChpbm9kZSk7
CiAJCWlmIChmaS0+bmxvb2t1cCkgewotCQkJZnVzZV9xdWV1ZV9mb3JnZXQoZmMsIGZpLT5mb3Jn
ZXQsIGZpLT5ub2RlaWQsCi0JCQkJCSAgZmktPm5sb29rdXApOwotCQkJZmktPmZvcmdldCA9IE5V
TEw7CisJCQlpZiAodGVzdF9iaXQoRlVTRV9JX1NZTkNfRk9SR0VULCAmZmktPnN0YXRlKSkgewor
CQkJCWZ1c2Vfc3luY19mb3JnZXQoaW5vZGUpOworCQkJfSBlbHNlIHsKKwkJCQlmdXNlX3F1ZXVl
X2ZvcmdldChmYywgZmktPmZvcmdldCwgZmktPm5vZGVpZCwKKwkJCQkJCSAgZmktPm5sb29rdXAp
OworCQkJCWZpLT5mb3JnZXQgPSBOVUxMOworCQkJfQogCQl9CiAJfQogCWlmIChTX0lTUkVHKGlu
b2RlLT5pX21vZGUpICYmICFmdXNlX2lzX2JhZChpbm9kZSkpIHsKZGlmZiAtLWdpdCBhL2luY2x1
ZGUvdWFwaS9saW51eC9mdXNlLmggYi9pbmNsdWRlL3VhcGkvbGludXgvZnVzZS5oCmluZGV4IDk4
Y2E2NGQxYmViNi4uY2ZjZjk1Y2ZkZTc2IDEwMDY0NAotLS0gYS9pbmNsdWRlL3VhcGkvbGludXgv
ZnVzZS5oCisrKyBiL2luY2x1ZGUvdWFwaS9saW51eC9mdXNlLmgKQEAgLTQ5OSw2ICs0OTksNyBA
QCBlbnVtIGZ1c2Vfb3Bjb2RlIHsKIAlGVVNFX0NPUFlfRklMRV9SQU5HRQk9IDQ3LAogCUZVU0Vf
U0VUVVBNQVBQSU5HCT0gNDgsCiAJRlVTRV9SRU1PVkVNQVBQSU5HCT0gNDksCisJRlVTRV9TWU5D
X0ZPUkdFVAk9IDUwLAogCiAJLyogQ1VTRSBzcGVjaWZpYyBvcGVyYXRpb25zICovCiAJQ1VTRV9J
TklUCQk9IDQwOTYsCg==
--000000000000f86ca305b82574e9--

