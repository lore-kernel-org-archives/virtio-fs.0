DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=yYstloyjSDBsfXqj0xN9y3n2xT5TvhmuPjIH/+3aQXs=;
	b=CN6h+SZZXGMRL7xBGgzsqNmrvEMzQZtY/l6+bBIlxzyo85Z91S646qkO7ZW9BJ6Zr2
	V2mVw7VxaBpyszHjNPwsTjexhpGKLwwimgF5d4ZT/Zsv4pK7sNmHP9DP71/9MBk82TXA
	RC9aA2v3IjW4Xejpuup1XbPdkGeX2kC8gkTpQ=
MIME-Version: 1.0
References: <5abd7616-5351-761c-0c14-21d511251006@huawei.com>
	<20190820091650.GE9855@stefanha-x1.localdomain>
	<CAJfpegs8fSLoUaWKhC1543Hoy9821vq8=nYZy-pw1+95+Yv4gQ@mail.gmail.com>
	<20190821160551.GD9095@stefanha-x1.localdomain>
	<954b5f8a-4007-f29c-f38e-dd5585879541@huawei.com>
In-Reply-To: <954b5f8a-4007-f29c-f38e-dd5585879541@huawei.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 22 Aug 2019 13:43:27 +0200
Message-ID: <CAJfpegtBYLJLWM8GJ1h66PMf2J9o38FG6udcd2hmamEEQddf5w@mail.gmail.com>
Content-Type: multipart/mixed; boundary="0000000000005d57bb0590b33322"
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
Cc: linux-fsdevel@vger.kernel.org, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, Miklos Szeredi <mszeredi@redhat.com>

--0000000000005d57bb0590b33322
Content-Type: text/plain; charset="UTF-8"

On Thu, Aug 22, 2019 at 2:59 AM wangyan <wangyan122@huawei.com> wrote:
> I will test it when I get the patch, and post the compared result with
> 9p.

Could you please try the attached patch?  My guess is that it should
improve the performance, perhaps by a big margin.

Further improvement is possible by eliminating page copies, but that
is less trivial.

Thanks,
Miklos

--0000000000005d57bb0590b33322
Content-Type: text/x-patch; charset="US-ASCII"; name="virtio-fs-nostrict.patch"
Content-Disposition: attachment; filename="virtio-fs-nostrict.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jzmm8sy40>
X-Attachment-Id: f_jzmm8sy40

SW5kZXg6IGxpbnV4L2ZzL2Z1c2UvdmlydGlvX2ZzLmMKPT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgub3Jp
Zy9mcy9mdXNlL3ZpcnRpb19mcy5jCTIwMTktMDgtMjIgMTM6Mzg6MzEuNzgyODMzNTY0ICswMjAw
CisrKyBsaW51eC9mcy9mdXNlL3ZpcnRpb19mcy5jCTIwMTktMDgtMjIgMTM6Mzc6NTUuNDM2NDA2
MjYxICswMjAwCkBAIC04OTEsNiArODkxLDkgQEAgc3RhdGljIGludCB2aXJ0aW9fZnNfZmlsbF9z
dXBlcihzdHJ1Y3QgcwogCWlmIChlcnIgPCAwKQogCQlnb3RvIGVycl9mcmVlX2luaXRfcmVxOwog
CisJLyogTm8gc3RyaWN0IGFjY291bnRpbmcgbmVlZGVkIGZvciB2aXJ0aW8tZnMgKi8KKwlzYi0+
c19iZGktPmNhcGFiaWxpdGllcyA9IDA7CisKIAlmYyA9IGZzLT52cXNbVlFfUkVRVUVTVF0uZnVk
LT5mYzsKIAogCS8qIFRPRE8gdGFrZSBmdXNlX211dGV4IGFyb3VuZCB0aGlzIGxvb3A/ICovCg==
--0000000000005d57bb0590b33322--

