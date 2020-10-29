DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=G2vNhDEm3HbJWwlXQvfrqMnwz+Y6hXypKtoqXX91090=;
	b=ZeVFlYxbfCuY/CTkTlqJNy9tAAAQX1+083ZdKCIa7x1FWR21+Plm1CPrBsd03fL+a1
	9kxhuhqHA5xuykUmXmhTjs+dynTESM5EFHJjUSvzEMHqzuKqmcs6r4xBJiNaMTBnPwr9
	M9dts4aQTunZ21ku0hMwe6NKyEo9QpURz2Z28=
MIME-Version: 1.0
References: <c4cb4b41655bc890b9dbf40bd2c133cbcbef734d.camel@redhat.com>
	<89f0dbf6713ebd44ec519425e3a947e71f7aed55.camel@redhat.com>
In-Reply-To: <89f0dbf6713ebd44ec519425e3a947e71f7aed55.camel@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 29 Oct 2020 16:20:55 +0100
Message-ID: <CAJfpegv4jLewQ4G_GdxraTE8fGHy7-d52gPSi4ZAOp0N4aYJnw@mail.gmail.com>
Content-Type: multipart/mixed; boundary="00000000000031f1b005b2d0d437"
Subject: Re: [Virtio-fs] WARN_ON(fuse_insert_writeback(root,
	wpa)) in tree_insert()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Qian Cai <cai@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org

--00000000000031f1b005b2d0d437
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 29, 2020 at 4:02 PM Qian Cai <cai@redhat.com> wrote:
>
> On Wed, 2020-10-07 at 16:08 -0400, Qian Cai wrote:
> > Running some fuzzing by a unprivileged user on virtiofs could trigger the
> > warning below. The warning was introduced not long ago by the commit
> > c146024ec44c ("fuse: fix warning in tree_insert() and clean up writepage
> > insertion").
> >
> > From the logs, the last piece of the fuzzing code is:
> >
> > fgetxattr(fd=426, name=0x7f39a69af000, value=0x7f39a8abf000, size=1)
>
> I can still reproduce it on today's linux-next. Any idea on how to debug it
> further?

Can you please try the attached patch?

Thanks,
Miklos

--00000000000031f1b005b2d0d437
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="fuse-launder-page-should-wait-for-page-writeback.patch"
Content-Disposition: attachment; 
	filename="fuse-launder-page-should-wait-for-page-writeback.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kguz5cjv0>
X-Attachment-Id: f_kguz5cjv0

ZGlmZiAtLWdpdCBhL2ZzL2Z1c2UvZmlsZS5jIGIvZnMvZnVzZS9maWxlLmMKaW5kZXggYzAzMDM0
ZThjMTUyLi40MWIxZTE0ZjM4MjAgMTAwNjQ0Ci0tLSBhL2ZzL2Z1c2UvZmlsZS5jCisrKyBiL2Zz
L2Z1c2UvZmlsZS5jCkBAIC0yMjgxLDYgKzIyODEsOSBAQCBzdGF0aWMgaW50IGZ1c2VfbGF1bmRl
cl9wYWdlKHN0cnVjdCBwYWdlICpwYWdlKQogCWludCBlcnIgPSAwOwogCWlmIChjbGVhcl9wYWdl
X2RpcnR5X2Zvcl9pbyhwYWdlKSkgewogCQlzdHJ1Y3QgaW5vZGUgKmlub2RlID0gcGFnZS0+bWFw
cGluZy0+aG9zdDsKKworCQkvKiBTZXJpYWxpemUgd2l0aCBwZW5kaW5nIHdyaXRlYmFjayBmb3Ig
dGhlIHNhbWUgcGFnZSAqLworCQlmdXNlX3dhaXRfb25fcGFnZV93cml0ZWJhY2soaW5vZGUsIHBh
Z2UtPmluZGV4KTsKIAkJZXJyID0gZnVzZV93cml0ZXBhZ2VfbG9ja2VkKHBhZ2UpOwogCQlpZiAo
IWVycikKIAkJCWZ1c2Vfd2FpdF9vbl9wYWdlX3dyaXRlYmFjayhpbm9kZSwgcGFnZS0+aW5kZXgp
Owo=
--00000000000031f1b005b2d0d437--

