MIME-Version: 1.0
References: <410cfe7a-5d38-7670-7e34-6eeae4b5a4fc@redhat.com>
	<CAOssrKc2ESAiQmE8GSqkh6_rtcSqX2ok=Rm=bnG5MGcaJs-31g@mail.gmail.com>
	<6d763002-258b-1bec-43a5-8ab5ae1f63de@redhat.com>
	<CAOssrKeDEjEjBGMD+qXpGzA680TYKDie++whKp25S4x8v-MxOQ@mail.gmail.com>
	<19bfff9f-5024-a104-a639-d02bea178440@redhat.com>
In-Reply-To: <19bfff9f-5024-a104-a639-d02bea178440@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Wed, 15 Jan 2020 11:10:26 +0100
Message-ID: <CAOssrKcXKb5B=9mTaPxXwNLSZWpUAZ=3UdcDQ8wCWVbEg0A2-w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] Ways to uniquely and persistently identify nodes
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

On Wed, Jan 15, 2020 at 10:37 AM Max Reitz <mreitz@redhat.com> wrote:

> >> Or we could implement the table on top of the current system by sharing
> >> it between the client and server.  Whenever the server creates a
> >> fuse_ino_t value, it then also creates a full-size handle, and returns
> >> both the handle and its corresponding fuse_ino_t value to the server.
> >> The server can use the fuse_ino_t normally most of the time, but with a
> >> catch: The client would be able to invalidate it.  Then the server needs
> >> to obtain a new fuse_ino_t value for the existing handle.
> >> (Invalidating and reacquiring a fuse_ino_t value would be new FUSE
> >> operations.)
> >
> > I think you may have accidentally switched "server" and "client" in
> > the above description a couple of times.
>
> Isn’t the kernel (i.e., the guest) the client and virtiofsd the server?

It is.

So it is the server that creates a temporary fuse_ino_t and sends the
persistent handle and the temporary fuse_ino_t to the client.

The client stores both as opaque objects, and it cannot invalidate
fuse_ino_t (although it could theoretically drop it, then re-request
it based on the stored handle).   The server on the other hand could
invalidate fuse_ino_t and force the client to request a new temporary
fuse_ino_t based on the persistent handle.  This could be achieved, by
returning a special error value in case of an invalid fuse_ino_t.

New operations needed:

LOOKUP_WITH_HANDLE: same as LOOKUP, but returns handle in addition to
fuse_ino_t and attributes.
LOOKUP_BY_HANDLE: same as LOOKUP, but gets a handle as input.

Thanks,
Miklos


