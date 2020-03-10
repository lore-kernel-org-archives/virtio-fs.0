DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=REgvRIGaQFX0rJ2F2E0SSglQVamoeuGWdGmoF/N5lus=;
	b=HJVoZ3BVHYzJMf4JMkMnAD/QpaYgATC2WqGx7eeKdOmuRZictZ/zGUEUJt4b1gMiXu
	0hawPVlcNtzk8ul9yZ6a3Y6I2WQaEeTlcyn5Z3vQTvShCy89CqDr1vcYG5JRvKrTEs+s
	nGCJPvFnL9RJmti4Z6r3S8VHzjAQ5mxioY1DQ=
MIME-Version: 1.0
References: <1583270111-76859-1-git-send-email-bo.liu@linux.alibaba.com>
	<CAJfpegtFWqEAV-Jb_KoHihJ5-UpU=JkdxEg_stz6JM5OP_LXMQ@mail.gmail.com>
	<20200310184640.5djxclzt6gqkq4v3@rsjd01523.et2sqa>
In-Reply-To: <20200310184640.5djxclzt6gqkq4v3@rsjd01523.et2sqa>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 10 Mar 2020 20:08:49 +0100
Message-ID: <CAJfpegtUkfwZXZ977HeC7pJ+2rFVwyr0pk-ru4J7z1-TVafcSQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] fuse: make written data persistent after
	writing
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com

On Tue, Mar 10, 2020 at 7:46 PM Liu Bo <bo.liu@linux.alibaba.com> wrote:
>
> On Tue, Mar 10, 2020 at 11:14:17AM +0100, Miklos Szeredi wrote:
> > On Tue, Mar 3, 2020 at 10:15 PM Liu Bo <bo.liu@linux.alibaba.com> wrote:
> > >
> > > If this is a DSYNC write, make sure we push it to stable storage now
> > > that we've written data.
> >
> > If this is direct I/O then why do we need an fysnc() call?
> >
> > The only thing needed should be correct setting O_DSYNC in the flags
> > field of the WRITE request, and it appears to me that that is already
> > being done.
>
> Given direct IO itself doesn't guarantee FUA or FLUSH, I think we
> still need such a fsync() call to make sure a FUA/FLUSH is sent after
> direct IO.

What I mean is that the server itself can call fsync(2) from the WRITE
request if it finds that fi->flags contains O_DSYNC.

Thanks,
Miklos


