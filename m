DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=mZvfNhyGscpkSZ3ArnN1Kn2Ohroj07E84u704Jirwf8=;
	b=CocCV7FT+vvRNv2WTAn65V30KzegW/8Wk/kvkKfN55wq3gpMeRFTLjdgzO8aZVdbwD
	jFD8DaMSQgqlXLPddVzX1pno2H45JX0LyiqJjxvBzVrBJgSSHJ1455S8XTeosJnFgsaw
	QQ3Iut++Ff0sTuIcBgiQSVw04Wzblj08sFkPY=
MIME-Version: 1.0
References: <5abd7616-5351-761c-0c14-21d511251006@huawei.com>
	<20190820091650.GE9855@stefanha-x1.localdomain>
In-Reply-To: <20190820091650.GE9855@stefanha-x1.localdomain>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 21 Aug 2019 09:51:20 +0200
Message-ID: <CAJfpegs8fSLoUaWKhC1543Hoy9821vq8=nYZy-pw1+95+Yv4gQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, Miklos Szeredi <mszeredi@redhat.com>

On Tue, Aug 20, 2019 at 11:16 AM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Thu, Aug 15, 2019 at 08:30:43AM +0800, wangyan wrote:
> > Hi all,
> >
> > I met a performance problem when I tested buffer write compared with 9p.
>
> CCing Miklos, FUSE maintainer, since this is mostly a FUSE file system
> writeback question.

This is expected.   FUSE contains lots of complexity in the buffered
write path related to preventing DoS caused by the userspace server.

This added complexity, which causes the performance issue, could be
disabled in virtio-fs, since the server lives on a different kernel
than the filesystem.

I'll do a patch..

Thanks,
Miklos

