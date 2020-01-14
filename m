MIME-Version: 1.0
References: <410cfe7a-5d38-7670-7e34-6eeae4b5a4fc@redhat.com>
	<CAOssrKc2ESAiQmE8GSqkh6_rtcSqX2ok=Rm=bnG5MGcaJs-31g@mail.gmail.com>
	<6d763002-258b-1bec-43a5-8ab5ae1f63de@redhat.com>
In-Reply-To: <6d763002-258b-1bec-43a5-8ab5ae1f63de@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Tue, 14 Jan 2020 20:24:51 +0100
Message-ID: <CAOssrKeDEjEjBGMD+qXpGzA680TYKDie++whKp25S4x8v-MxOQ@mail.gmail.com>
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

On Tue, Jan 14, 2020 at 6:13 PM Max Reitz <mreitz@redhat.com> wrote:
> What worries me most is how to pass that object around to all FUSE
> functions, and that they all need a new interface.

You mean libfuse API?

> I just had a very fuzzy (and maybe stupid) idea: Maybe we could keep an
> internal vector of currently active handles and then when variable-size
> handles are enabled, fuse_ino_t would just act as an index into that vector?
>
> I suppose we could then use the full-size handles in all messages and
> just hand out temporary indices to existing functions (just so we don’t
> have to change their interface).  Server and client have their own
> vectors, because when they communicate, only the full handles have meaning.
>
> Or we could implement the table on top of the current system by sharing
> it between the client and server.  Whenever the server creates a
> fuse_ino_t value, it then also creates a full-size handle, and returns
> both the handle and its corresponding fuse_ino_t value to the server.
> The server can use the fuse_ino_t normally most of the time, but with a
> catch: The client would be able to invalidate it.  Then the server needs
> to obtain a new fuse_ino_t value for the existing handle.
> (Invalidating and reacquiring a fuse_ino_t value would be new FUSE
> operations.)

I think you may have accidentally switched "server" and "client" in
the above description a couple of times.

But if I'm reading this correctly, your idea is to keep the 64bit
value on the interface (this could be just libfuse or both libfuse and
the kernel API) and add new interfaces to establish and reestablish
the mapping from (non-persistent) fuse_ino_t to (persistent) handle.

Thanks,
Miklos


