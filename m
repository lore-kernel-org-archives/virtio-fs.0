MIME-Version: 1.0
References: <20200506153832.240812-1-mreitz@redhat.com>
	<20200506154010.241055-2-mreitz@redhat.com>
	<20200506160411.GO2743@work-vm>
	<52f6dc62-496e-2337-72dc-a9b762732848@redhat.com>
In-Reply-To: <52f6dc62-496e-2337-72dc-a9b762732848@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Thu, 7 May 2020 13:43:56 +0200
Message-ID: <CAOssrKfcZH3Bu1g2U4XbGn_b5LenLoHQOO=WWqT71J4sMVTv3w@mail.gmail.com>
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

On Thu, May 7, 2020 at 12:56 PM Max Reitz <mreitz@redhat.com> wrote:
>
> On 06.05.20 18:04, Dr. David Alan Gilbert wrote:
> > * Max Reitz (mreitz@redhat.com) wrote:
> >> Whenever we encounter a directory with an st_dev that differs from that
> >> of its parent, we set st_rdev accordingly so the guest can create a
> >> submount for it.
> >>
> >> Make this behavior optional, so submounts are only announced to the
> >> guest with the announce_submounts option.  Some users may prefer the
> >> current behavior, so that the guest learns nothing about the host mount
> >> structure.
> >>
> >> Signed-off-by: Max Reitz <mreitz@redhat.com>
> >
> > Does this need to be wired to a flag in the INIT message (like say
> > FUSE_ASYNC_READ) to indicate that the kernel/daemon supports this, or is
> > it really safe just to start sending the changed rdev?
>
> I supposed it to be safe, given that rdev is never used for anything but
> device files, so basically it was just a reserved field for directories.

You assume only directories can be mounted, but that's not so.  A
device can also be the source or destination of a bind mount.

We need to extend fuse_entry_out with a flags field.  We could
possibly reuse the upper bits of entry_valid (i.e. timeouts above say
INT_MAX seconds could be taken as  "infinity").  Unfortunately that's
not as easy as splitting it into two fields due to endianness :(

Thanks,
Miklos


