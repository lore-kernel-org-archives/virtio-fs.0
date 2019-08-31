DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=WOhpJr5tHKYGv4ZK0AZEodoAvczvxbwsxiG+g58CPSs=;
	b=AzNCUdOEXkVwKcnJjrrzdT8T9BXEGdnj5LnXTA3jsHKPVwhxRTS54L+zKAJfk1McCZ
	v2iSDmsKiPscsLnl1Q75W2eXy5q7fRUcnEG32yp0RRQ+huKkKuvGVbQGQT54TWd9O9JZ
	EGlVNMqeKOnWWUGl3SbbozlhVrqQ0d5tZ+dV8=
MIME-Version: 1.0
References: <20190821173742.24574-1-vgoyal@redhat.com>
	<CAJfpegv_XS=kLxw_FzWNM2Xao5wsn7oGbk3ow78gU8tpXwo-sg@mail.gmail.com>
	<20190829160106.GC6744@redhat.com>
In-Reply-To: <20190829160106.GC6744@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 31 Aug 2019 07:46:28 +0200
Message-ID: <CAJfpegvnx=Na67367hAXNX17P6qv2nJ-OaL6FPSEa07qL4Jxgw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v3 00/13] virtio-fs: shared file system for
	virtual machines
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org

On Thu, Aug 29, 2019 at 6:01 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Thu, Aug 29, 2019 at 11:28:27AM +0200, Miklos Szeredi wrote:
>
> [..]
> > There are miscellaneous changes, so needs to be thoroughly tested.
>
> Hi Miklos,
>
> First round of tests passed. Ran pjdfstests, blogbench and bunch of fio
> jobs and everyting looks good.

fsx-linux with cache=always revealed a couple of bugs in the argpages
case.  Pushed fixes for those too.

Thanks,
Miklos

