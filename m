DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=1D/stRInaG/B0oiGaQ/Y2em5iSkjBb4j7/1WQmQSPlk=;
	b=kX1t1pYVzDBtynIeNroUD+4pMZ+Sk7MQpN01u5fmTOX37BYSYS25U5qhauO+bU7vaD
	RNGigmtEuXj1wGLyFC32YIYBySSbD2EwU26/0HRM18LvR9BsE8UB3Va8SyfNvEYzdNhY
	l2B4zj1oReaTshSU2ktuvvzIczvOyoxH9kMN8=
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
	<CAOssrKd7bKts2tCAZaXLJt+BVoQtqWoJV6HfT76-qxg7W4g9PQ@mail.gmail.com>
In-Reply-To: <CAOssrKd7bKts2tCAZaXLJt+BVoQtqWoJV6HfT76-qxg7W4g9PQ@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 22 Aug 2019 16:02:06 +0200
Message-ID: <CAJfpegt574w1Rzge-59-1dRVtfPgCrFuCpJ5DjLQwSWg+G3ArA@mail.gmail.com>
Content-Type: multipart/mixed; boundary="0000000000003042650590b5237e"
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
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>

--0000000000003042650590b5237e
Content-Type: text/plain; charset="UTF-8"

On Thu, Aug 22, 2019 at 3:30 PM Miklos Szeredi <mszeredi@redhat.com> wrote:
>
> On Thu, Aug 22, 2019 at 3:18 PM wangyan <wangyan122@huawei.com> wrote:
>
> > I used these commands:
> > virtiofsd cmd:
> >         ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu -o source=/mnt/share/
> > -o cache=always -o writeback
> > mount cmd:
> >         mount -t virtio_fs myfs /mnt/virtiofs -o
> > rootmode=040000,user_id=0,group_id=0
>
> Good.
>
> I think I got it now, updated patch attached.
>
> Thanks for your patience!
>
> Miklos

Previous one was broken as well.   I hope this one works...

--0000000000003042650590b5237e
Content-Type: text/x-patch; charset="US-ASCII";
	name="virtio-fs-nostrict-v3.patch"
Content-Disposition: attachment; filename="virtio-fs-nostrict-v3.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jzmr81lb0>
X-Attachment-Id: f_jzmr81lb0

LS0tCiBmcy9mdXNlL3ZpcnRpb19mcy5jIHwgICAgNCArKysrCiAxIGZpbGUgY2hhbmdlZCwgNCBp
bnNlcnRpb25zKCspCgotLS0gYS9mcy9mdXNlL3ZpcnRpb19mcy5jCisrKyBiL2ZzL2Z1c2Uvdmly
dGlvX2ZzLmMKQEAgLTg5MSw2ICs4OTEsMTAgQEAgc3RhdGljIGludCB2aXJ0aW9fZnNfZmlsbF9z
dXBlcihzdHJ1Y3QgcwogCWlmIChlcnIgPCAwKQogCQlnb3RvIGVycl9mcmVlX2luaXRfcmVxOwog
CisJLyogTm8gc3RyaWN0IGFjY291bnRpbmcgbmVlZGVkIGZvciB2aXJ0aW8tZnMgKi8KKwlzYi0+
c19iZGktPmNhcGFiaWxpdGllcyA9IEJESV9DQVBfTk9fQUNDVF9XQjsKKwliZGlfc2V0X21heF9y
YXRpbyhzYi0+c19iZGksIDEwMCk7CisKIAlmYyA9IGZzLT52cXNbVlFfUkVRVUVTVF0uZnVkLT5m
YzsKIAogCS8qIFRPRE8gdGFrZSBmdXNlX211dGV4IGFyb3VuZCB0aGlzIGxvb3A/ICovCg==
--0000000000003042650590b5237e--

