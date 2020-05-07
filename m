MIME-Version: 1.0
References: <20200506153832.240812-1-mreitz@redhat.com>
	<20200506154010.241055-2-mreitz@redhat.com>
	<20200506160411.GO2743@work-vm>
	<52f6dc62-496e-2337-72dc-a9b762732848@redhat.com>
	<CAOssrKfcZH3Bu1g2U4XbGn_b5LenLoHQOO=WWqT71J4sMVTv3w@mail.gmail.com>
	<9a601294-a470-3df9-fd8f-0eb1ed5847b6@redhat.com>
	<CAOssrKcgQ7cFpG6Jh7B25bVNp419coHvFjCiGt4KiZ=oHsYhJw@mail.gmail.com>
	<4518b2a2-705b-9c13-1384-560e670f941f@redhat.com>
In-Reply-To: <4518b2a2-705b-9c13-1384-560e670f941f@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Thu, 7 May 2020 17:23:52 +0200
Message-ID: <CAOssrKdNBrnOFV2qh-8OR8sGatbt-vzUm9UDwUiThuYPdA+q7w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [RFC 2/2] virtiofsd: Set st_rdev for sub-mount
	points
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Thu, May 7, 2020 at 5:15 PM Max Reitz <mreitz@redhat.com> wrote:
>
> On 07.05.20 16:29, Miklos Szeredi wrote:

> > Hmm, do we need a separate bit, then?  Couldn't the kernel decide
> > based on st_dev whether a new submount is needed?  I.e. return root
> > st_dev in INIT reply, store it in root fuse_mount and lookups compare
> > attr.dev to fm->st_dev.
>
> That was the idea, but there is no fuse_attr.dev, which is why I
> (ab)used fuse_attr.rdev instead.

Ah, right.

Thanks,
Miklos


