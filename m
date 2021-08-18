DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=UnXThZRC3fAssEX0f0mLCZ6Q9w2tlCC2Smhk9kY/6CA=;
	b=gCuCVqPtp3VcrqtAtdQ9/T1hLISv/SoLG3FxW0WozJv9qF+VkP6lJy5+8o4RK3PHGe
	B/zhH0L3cY3+1C7tiCUx+apwtps1Hr63DN6B7vtkdtGE4R8dIUDR/DOrbruYk3WODqTS
	rS+LP7odFUxNB+5/Y04KwmguxE/ql3g3O/SRA=
MIME-Version: 1.0
References: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
	<CAJfpeguw1hMOaxpDmjmijhf=-JEW95aEjxfVo_=D_LyWx8LDgw@mail.gmail.com>
	<YRut5sioYfc2M1p7@redhat.com>
	<6043c0b8-0ff1-2e11-0dd0-e23f9ff6b952@linux.alibaba.com>
	<CAJfpegv01k5hEyJ3LPDWJoqB+vL8hwTan9dLu1pkkD0xoRuFzw@mail.gmail.com>
	<1100b711-012d-d68b-7078-20eea6fa4bab@linux.alibaba.com>
In-Reply-To: <1100b711-012d-d68b-7078-20eea6fa4bab@linux.alibaba.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 18 Aug 2021 07:08:24 +0200
Message-ID: <CAJfpegsdX1H_=ZMORA-9YiBGdszG0WVmAjFY2QSZPa0iLUEjXw@mail.gmail.com>
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

On Wed, 18 Aug 2021 at 05:40, JeffleXu <jefflexu@linux.alibaba.com> wrote:

> I'm not sure if I fully understand your idea. Then in this case, host
> daemon only prepares 4KB while guest thinks that the whole DAX window
> (e.g., 2MB) has been fully mapped. Then when guest really accesses the
> remained part (2MB - 4KB), page fault is triggered, and now host daemon
> is responsible for downloading the remained part?

Yes.  Mapping an area just means setting up the page tables, it does
not result in actual data transfer.

Thanks,
Miklos

