DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=OhvGWYbd6i+9LyJq3j7yIZkL8jqg1hxfCOejeLbe8Qw=;
	b=Cq2HqxAgAZyEpm1Yuuk/cS9cDd/pWPIc5OfuCq5A4W9rryPdCFdng78Uym3lmRr5Mb
	9oYrzweOyKHsWDPd3GdAH++YjYpAMeQEy6J/U0jyOBfOkk90qhmZ9NxmUndAWBKo1xuj
	iu64CHvaqxqRt7Ir3g0/QldlTHx5qnGvK3ZU8=
MIME-Version: 1.0
References: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
	<CAJfpeguw1hMOaxpDmjmijhf=-JEW95aEjxfVo_=D_LyWx8LDgw@mail.gmail.com>
	<YRut5sioYfc2M1p7@redhat.com>
	<6043c0b8-0ff1-2e11-0dd0-e23f9ff6b952@linux.alibaba.com>
In-Reply-To: <6043c0b8-0ff1-2e11-0dd0-e23f9ff6b952@linux.alibaba.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 17 Aug 2021 16:08:21 +0200
Message-ID: <CAJfpegv01k5hEyJ3LPDWJoqB+vL8hwTan9dLu1pkkD0xoRuFzw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v4 0/8] fuse,virtiofs: support per-file DAX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: JeffleXu <jefflexu@linux.alibaba.com>
Cc: virtualization@lists.linux-foundation.org, virtio-fs-list <virtio-fs@redhat.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

On Tue, 17 Aug 2021 at 15:22, JeffleXu <jefflexu@linux.alibaba.com> wrote:
>
>
>
> On 8/17/21 8:39 PM, Vivek Goyal wrote:
> > On Tue, Aug 17, 2021 at 10:06:53AM +0200, Miklos Szeredi wrote:
> >> On Tue, 17 Aug 2021 at 04:22, Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> >>>
> >>> This patchset adds support of per-file DAX for virtiofs, which is
> >>> inspired by Ira Weiny's work on ext4[1] and xfs[2].
> >>
> >> Can you please explain the background of this change in detail?
> >>
> >> Why would an admin want to enable DAX for a particular virtiofs file
> >> and not for others?
> >
> > Initially I thought that they needed it because they are downloading
> > files on the fly from server. So they don't want to enable dax on the file
> > till file is completely downloaded.
>
> Right, it's our initial requirement.
>
>
> > But later I realized that they should
> > be able to block in FUSE_SETUPMAPPING call and make sure associated
> > file section has been downloaded before returning and solve the problem.
> > So that can't be the primary reason.
>
> Saying we want to access 4KB of one file inside guest, if it goes
> through FUSE request routine, then the fuse daemon only need to download
> this 4KB from remote server. But if it goes through DAX, then the fuse
> daemon need to download the whole DAX window (e.g., 2MB) from remote
> server, so called amplification. Maybe we could decrease the DAX window
> size, but it's a trade off.

That could be achieved with a plain fuse filesystem on the host (which
will get 4k READ requests for accesses to mapped area inside guest).
Since this can be done selectively for files which are not yet
downloaded, the extra layer wouldn't be a performance problem.

Is there a reason why that wouldn't work?

Thanks,
Miklos

