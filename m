MIME-Version: 1.0
References: <20191016103754.2047-1-misono.tomohiro@jp.fujitsu.com>
	<20191017100528.GA24790@stefanha-x1.localdomain>
	<CAOssrKfR=sfE1RzOXzvPbdQg-g7i5-f8W9y8bWFnO=gyJ2VMsg@mail.gmail.com>
	<20191017160953.GC1266@stefanha-x1.localdomain>
	<CAOssrKejcfVWXw6Nu1owyEeofTdVp6BNx4bL91ma2g7bg9-nmg@mail.gmail.com>
In-Reply-To: <CAOssrKejcfVWXw6Nu1owyEeofTdVp6BNx4bL91ma2g7bg9-nmg@mail.gmail.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Fri, 18 Oct 2019 09:16:36 +0200
Message-ID: <CAOssrKdbAT5s=CYG6PBtE6OYdqgwG8vp9T6QMJpwZ7X3tKjPmg@mail.gmail.com>
Content-Type: multipart/mixed; boundary="00000000000001b63d05952a1eed"
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: Two fix for xattr operation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

--00000000000001b63d05952a1eed
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 17, 2019 at 6:48 PM Miklos Szeredi <mszeredi@redhat.com> wrote:

> Even simpler: allow O_PATH descriptors for f*xattr().

Attached patch.  Will post shortly.

However, I think it would make sense to fix virtiofsd as well, as this
will take time to percolate down, even if Al doesn't find anything
wrong with it.

Doing unshare(CLONE_FS) after thread startup seems safe, though must
be careful to change the working directory to the root of the mount
*before* starting any threads.

Thanks,
Miklos

--00000000000001b63d05952a1eed
Content-Type: text/x-patch; charset="US-ASCII";
	name="xattr-allow-o_path-descriptors.patch"
Content-Disposition: attachment; 
	filename="xattr-allow-o_path-descriptors.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k1vspdh90>
X-Attachment-Id: f_k1vspdh90

ZGlmZiAtLWdpdCBhL2ZzL3hhdHRyLmMgYi9mcy94YXR0ci5jCmluZGV4IDkwZGQ3OGYwZWIyNy4u
ZmQxMzM1Yjg2ZTYwIDEwMDY0NAotLS0gYS9mcy94YXR0ci5jCisrKyBiL2ZzL3hhdHRyLmMKQEAg
LTQ5NSw3ICs0OTUsNyBAQCBTWVNDQUxMX0RFRklORTUobHNldHhhdHRyLCBjb25zdCBjaGFyIF9f
dXNlciAqLCBwYXRobmFtZSwKIFNZU0NBTExfREVGSU5FNShmc2V0eGF0dHIsIGludCwgZmQsIGNv
bnN0IGNoYXIgX191c2VyICosIG5hbWUsCiAJCWNvbnN0IHZvaWQgX191c2VyICosdmFsdWUsIHNp
emVfdCwgc2l6ZSwgaW50LCBmbGFncykKIHsKLQlzdHJ1Y3QgZmQgZiA9IGZkZ2V0KGZkKTsKKwlz
dHJ1Y3QgZmQgZiA9IGZkZ2V0X3JhdyhmZCk7CiAJaW50IGVycm9yID0gLUVCQURGOwogCiAJaWYg
KCFmLmZpbGUpCkBAIC01ODcsNyArNTg3LDcgQEAgU1lTQ0FMTF9ERUZJTkU0KGxnZXR4YXR0ciwg
Y29uc3QgY2hhciBfX3VzZXIgKiwgcGF0aG5hbWUsCiBTWVNDQUxMX0RFRklORTQoZmdldHhhdHRy
LCBpbnQsIGZkLCBjb25zdCBjaGFyIF9fdXNlciAqLCBuYW1lLAogCQl2b2lkIF9fdXNlciAqLCB2
YWx1ZSwgc2l6ZV90LCBzaXplKQogewotCXN0cnVjdCBmZCBmID0gZmRnZXQoZmQpOworCXN0cnVj
dCBmZCBmID0gZmRnZXRfcmF3KGZkKTsKIAlzc2l6ZV90IGVycm9yID0gLUVCQURGOwogCiAJaWYg
KCFmLmZpbGUpCkBAIC02NjIsNyArNjYyLDcgQEAgU1lTQ0FMTF9ERUZJTkUzKGxsaXN0eGF0dHIs
IGNvbnN0IGNoYXIgX191c2VyICosIHBhdGhuYW1lLCBjaGFyIF9fdXNlciAqLCBsaXN0LAogCiBT
WVNDQUxMX0RFRklORTMoZmxpc3R4YXR0ciwgaW50LCBmZCwgY2hhciBfX3VzZXIgKiwgbGlzdCwg
c2l6ZV90LCBzaXplKQogewotCXN0cnVjdCBmZCBmID0gZmRnZXQoZmQpOworCXN0cnVjdCBmZCBm
ID0gZmRnZXRfcmF3KGZkKTsKIAlzc2l6ZV90IGVycm9yID0gLUVCQURGOwogCiAJaWYgKCFmLmZp
bGUpCkBAIC03MjcsNyArNzI3LDcgQEAgU1lTQ0FMTF9ERUZJTkUyKGxyZW1vdmV4YXR0ciwgY29u
c3QgY2hhciBfX3VzZXIgKiwgcGF0aG5hbWUsCiAKIFNZU0NBTExfREVGSU5FMihmcmVtb3ZleGF0
dHIsIGludCwgZmQsIGNvbnN0IGNoYXIgX191c2VyICosIG5hbWUpCiB7Ci0Jc3RydWN0IGZkIGYg
PSBmZGdldChmZCk7CisJc3RydWN0IGZkIGYgPSBmZGdldF9yYXcoZmQpOwogCWludCBlcnJvciA9
IC1FQkFERjsKIAogCWlmICghZi5maWxlKQo=
--00000000000001b63d05952a1eed--

