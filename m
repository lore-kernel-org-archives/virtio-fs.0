MIME-Version: 1.0
References: <5abd7616-5351-761c-0c14-21d511251006@huawei.com>
	<20190820091650.GE9855@stefanha-x1.localdomain>
	<CAJfpegs8fSLoUaWKhC1543Hoy9821vq8=nYZy-pw1+95+Yv4gQ@mail.gmail.com>
	<20190821160551.GD9095@stefanha-x1.localdomain>
	<954b5f8a-4007-f29c-f38e-dd5585879541@huawei.com>
	<CAJfpegtBYLJLWM8GJ1h66PMf2J9o38FG6udcd2hmamEEQddf5w@mail.gmail.com>
	<0e8090c7-0c7c-bcbe-af75-33054d3a3efb@huawei.com>
	<CAJfpegurYLAApon5Ai6Q33vEy+GPxtOTUwDCCbJ2JAbg4csDSg@mail.gmail.com>
	<a19866be-3693-648e-ee6c-8d302c830834@huawei.com>
In-Reply-To: <a19866be-3693-648e-ee6c-8d302c830834@huawei.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Thu, 22 Aug 2019 15:29:46 +0200
Message-ID: <CAOssrKd7bKts2tCAZaXLJt+BVoQtqWoJV6HfT76-qxg7W4g9PQ@mail.gmail.com>
Content-Type: multipart/mixed; boundary="0000000000009451d30590b4afb3"
Subject: Re: [Virtio-fs] [QUESTION] A performance problem for buffer write
 compared with 9p
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: wangyan <wangyan122@huawei.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>

--0000000000009451d30590b4afb3
Content-Type: text/plain; charset="UTF-8"

On Thu, Aug 22, 2019 at 3:18 PM wangyan <wangyan122@huawei.com> wrote:

> I used these commands:
> virtiofsd cmd:
>         ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu -o source=/mnt/share/
> -o cache=always -o writeback
> mount cmd:
>         mount -t virtio_fs myfs /mnt/virtiofs -o
> rootmode=040000,user_id=0,group_id=0

Good.

I think I got it now, updated patch attached.

Thanks for your patience!

Miklos

--0000000000009451d30590b4afb3
Content-Type: text/x-patch; charset="US-ASCII";
	name="virtio-fs-nostrict-v2.patch"
Content-Disposition: attachment; filename="virtio-fs-nostrict-v2.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jzmq2zcx0>
X-Attachment-Id: f_jzmq2zcx0

LS0tCiBmcy9mdXNlL3ZpcnRpb19mcy5jIHwgICAgNCArKysrCiAxIGZpbGUgY2hhbmdlZCwgNCBp
bnNlcnRpb25zKCspCgotLS0gYS9mcy9mdXNlL3ZpcnRpb19mcy5jCisrKyBiL2ZzL2Z1c2Uvdmly
dGlvX2ZzLmMKQEAgLTg5MSw2ICs4OTEsMTAgQEAgc3RhdGljIGludCB2aXJ0aW9fZnNfZmlsbF9z
dXBlcihzdHJ1Y3QgcwogCWlmIChlcnIgPCAwKQogCQlnb3RvIGVycl9mcmVlX2luaXRfcmVxOwog
CisJLyogTm8gc3RyaWN0IGFjY291bnRpbmcgbmVlZGVkIGZvciB2aXJ0aW8tZnMgKi8KKwlzYi0+
c19iZGktPmNhcGFiaWxpdGllcyA9IDA7CisJYmRpX3NldF9tYXhfcmF0aW8oc2ItPnNfYmRpLCAx
MDApOworCiAJZmMgPSBmcy0+dnFzW1ZRX1JFUVVFU1RdLmZ1ZC0+ZmM7CiAKIAkvKiBUT0RPIHRh
a2UgZnVzZV9tdXRleCBhcm91bmQgdGhpcyBsb29wPyAqLwo=
--0000000000009451d30590b4afb3--

