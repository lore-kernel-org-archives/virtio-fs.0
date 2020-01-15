MIME-Version: 1.0
References: <410cfe7a-5d38-7670-7e34-6eeae4b5a4fc@redhat.com>
	<CAOssrKc2ESAiQmE8GSqkh6_rtcSqX2ok=Rm=bnG5MGcaJs-31g@mail.gmail.com>
	<6d763002-258b-1bec-43a5-8ab5ae1f63de@redhat.com>
	<CAOssrKeDEjEjBGMD+qXpGzA680TYKDie++whKp25S4x8v-MxOQ@mail.gmail.com>
	<19bfff9f-5024-a104-a639-d02bea178440@redhat.com>
	<CAOssrKcXKb5B=9mTaPxXwNLSZWpUAZ=3UdcDQ8wCWVbEg0A2-w@mail.gmail.com>
	<CAOssrKf8DN68+5aAseBYsnSXr+zWHy0UqNdVHMU5cSu0b-EvQw@mail.gmail.com>
	<9dfafbc1-6b64-ed12-a950-19dbf7b1eda2@redhat.com>
	<CAOssrKdXxN5iUpMocenvQZoHYinzVBYZEADersU7RHRy5Tf2tA@mail.gmail.com>
	<45b3e2a7-9524-1622-30dc-8f21275ec990@redhat.com>
In-Reply-To: <45b3e2a7-9524-1622-30dc-8f21275ec990@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Wed, 15 Jan 2020 16:46:45 +0100
Message-ID: <CAOssrKfRYGvKUPE90wbjwhg9DjRua8c6Kg45yRgSfVSJDi3=7w@mail.gmail.com>
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

On Wed, Jan 15, 2020 at 4:23 PM Max Reitz <mreitz@redhat.com> wrote:
>
> On 15.01.20 15:58, Miklos Szeredi wrote:
> > On Wed, Jan 15, 2020 at 1:51 PM Max Reitz <mreitz@redhat.com> wrote:
> >>
> >> On 15.01.20 12:51, Miklos Szeredi wrote:
> >>> On Wed, Jan 15, 2020 at 11:10 AM Miklos Szeredi <mszeredi@redhat.com> wrote:
> >>>
> >>>> New operations needed:
> >>>>
> >>>> LOOKUP_WITH_HANDLE: same as LOOKUP, but returns handle in addition to
> >>>> fuse_ino_t and attributes.
> >>>> LOOKUP_BY_HANDLE: same as LOOKUP, but gets a handle as input.
> >>>
> >>> And that can be reduced further to a single extended LOOKUP_HANDLE,
> >>> which takes a handle as input and returns a handle in addition to the
> >>> usual stuff.  The lookup-by-handle case can be done with a special
> >>> name.  Currently "." is used for this purpose in the fuse protocol,
> >>> which is a bit confusing since it has nothing to do the "." directory
> >>> entry, but at least we don't have to introduce a new concept for this.
> >>
> >> I’m afraid I don’t quite understand.  What handle would LOOKUP_HANDLE
> >> take as input when I want to open a new file (as in, LOOKUP_WITH_HANDLE)?
> >
> > For example open("/foo/bar", ...) would do:
> >
> > lookup_handle($ROOT_HANDLE, "foo") -> { FOO_HANDLE, FOO_NODEID }
> > lookup_handle($FOO_HANDLE, "bar") -> { BAR_HANDLE, BAR_NODEID }
> > open($BAR_NODEID, ...)
>
> OK.  It seems a bit weird to me because if all other commands used a
> fuse_ino_t to identify nodes, I think lookup should be no different.
>
> Sure, we’d only need one new command instead of two, but naively just
> adding two commands doesn’t seem fundamentally more difficult to me.
>
> Specifically, what seems a bit problematic to me is that for virtiofsd
> we’d probably want fuse_ino_t to stay as it is: An index into a vector.
>  We probably don’t want to store the handle in virtiofsd at all.
>
> So whenever a handle comes in, we’d first need to open it with
> open_by_handle_at().  That’s OK if handles only come in through
> lookup_by_handle(), i.e. when there is no valid fuse_ino_t value anyway.
>  But it seems a bit cumbersome if all lookups are based on handles.
>
> OTOH, we could keep the handles around, but that would probably require
> a hash map with the handle as a key (so we can let lookup() find the
> existing fd without having to open a new one).  Doable, sure, but I
> wonder whether it wouldn’t be just easier to have two separate commands.

So, let's modify that to

> > lookup_handle($ROOT_HANDLE, $ROOT_NODEID, "foo") -> { FOO_HANDLE, FOO_NODEID }
> > lookup_handle($FOO_HANDLE, $FOO_NODEID, "bar") -> { BAR_HANDLE, BAR_NODEID }
> > open($BAR_NODEID, ...)

I think that fixes your concern.  Implementation is free to use either
the nodeid or the handle.

Thanks,
Miklos


