DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=4TnJrAnLCksHO7Xrs8hwqGbpGC0O/JmQVPgA7yX9GdU=;
	b=KX2SW9Z8CjiQa4X5Ko/tNnHGENzuzgvbdIwo12Qh8CPc0bDj6xEgYFUmy1CO+j7V/q
	w6kuubMggFDJ7PTDp+n+OcIGScflkEy1Lpaha+WV333oRjYO/ed4mvVM5nq2f/WsCrWB
	IWBQbALS4eHLSeHZn5xjxK2edkejJnaMbYZEI=
MIME-Version: 1.0
References: <20211102055646.103337-1-jefflexu@linux.alibaba.com>
	<Ya9y7uqsMoDfGIbc@redhat.com>
	<dab8877d-54ad-9384-4a0f-34eae2c93b75@linux.alibaba.com>
	<YbEP/1IeGVkDhbaC@redhat.com>
	<7815cbb4-4889-4d37-14d1-a23a0a960204@linux.alibaba.com>
	<YbeK8HOF5F8n+ZG8@redhat.com>
	<CAJfpeguNSubpAwFZ7wzZjQsQMLTTUSSWHEvMwu56-oAdx_TZnA@mail.gmail.com>
	<60796c88-eae1-3ae0-019d-73b49c9d4c1e@linux.alibaba.com>
In-Reply-To: <60796c88-eae1-3ae0-019d-73b49c9d4c1e@linux.alibaba.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 14 Dec 2021 17:10:29 +0100
Message-ID: <CAJfpegv1uMvsBbezcRVCpER6sjLS-X0LeJipR25FzFY3COrEYA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v7 0/6] virtiofsd: support per inode DAX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: JeffleXu <jefflexu@linux.alibaba.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, Vivek Goyal <vgoyal@redhat.com>

On Tue, 14 Dec 2021 at 16:51, JeffleXu <jefflexu@linux.alibaba.com> wrote:
>
>
>
> On 12/14/21 6:17 PM, Miklos Szeredi wrote:
> > On Mon, 13 Dec 2021 at 19:03, Vivek Goyal <vgoyal@redhat.com> wrote:
> >>
> >> On Fri, Dec 10, 2021 at 10:54:20AM +0800, JeffleXu wrote:
> >>> Hi Vivek,
> >>>
> >>> Besides, I'd like to know that, to make the per inode DAX feature merged
> >>> into v5.17, shall the patches for virtiofsd also be ready during the
> >>> merge window?
> >>
> >> I think having virtiofsd patches ready is not a strict requirement to
> >> merge kernel patches. I will provide my ack for the kernel patches.
> >> After that it is up to the Miklos to accept or reject those patches.
> >
> > Pushed to fuse.git#for-next.
> >
> > The user API needed porting, the userspace part will have to take that
> > into account.  The only other change I did was replace the !!
> > construct with a (bool) cast.
>
>
> Hi, what do you mean by 'The user API needed porting'? Do you mean this
> patch set for virtiofsd?

What I meant is that the  FUSE_HAS_INODE_DAX value had to be changed
due to already pushed changes.   So any userspace code relying on the
old value in the original patchset would no longer work.

Thanks,
Miklos

