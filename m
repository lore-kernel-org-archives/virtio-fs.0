MIME-Version: 1.0
References: <410cfe7a-5d38-7670-7e34-6eeae4b5a4fc@redhat.com>
In-Reply-To: <410cfe7a-5d38-7670-7e34-6eeae4b5a4fc@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Tue, 14 Jan 2020 17:13:40 +0100
Message-ID: <CAOssrKc2ESAiQmE8GSqkh6_rtcSqX2ok=Rm=bnG5MGcaJs-31g@mail.gmail.com>
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

On Mon, Jan 13, 2020 at 6:47 PM Max Reitz <mreitz@redhat.com> wrote:
>
> Hi,
>
> As discussed in today’s meeting, there is a problem with uniquely and
> persistently identifying nodes in the guest.
>
> Actually, there are multiple problems:
>
> (1) stat’s st_ino in the guest is not necessarily unique.  Currently, it
> just the st_ino from the host file, so if you have mounted multiple
> different filesystems in the exported directory tree, you may get
> collisions.
>
> (2) The FUSE 64-bit fuse_ino_t (which identifies an open file,
> basically) is not persistent.  It is just an index into a vector that
> contains all open inodes, and whenever virtiofsd is restarted, the
> vector is renewed.  That means that whenever this happens, all
> fuse_ino_t values the guest holds will become invalid.  (And when
> virtiofsd starts handing out new fuse_ino_t values, those will probably
> not point to the same inodes as before.)
>
> (3) name_to_handle_at()/open_by_handle_at() are implemented by FUSE just
> by handing out the fuse_ino_t value as the handle.  This is not only a
> problem as long as fuse_ino_t is not persistent (see (2)), but also in
> general, because the fuse_ino_t value is only valid (per FUSE protocol)
> as long as the inode is referenced by the guest.
>
> The first question that I think needs to be asked is whether we care
> about each of this points at all.
>
> (1) Maybe it just doesn’t matter whether the st_ino values are unique.

It does matter, otherwise we can't claim it's a POSIX filesystem, and
applications can't rely on the guarantees made by the standard.
st_ino is used to find hard links by backup utilities and st_ino +
d_ino values are used by tree traversal (such as find(1)).

>
> (2) Maybe we don’t care about virtiofsd being restarted while the guest
> is running or only paused.  (“Restarting” includes migration of the
> daemon to a different host.)
>
> (3) I suppose we do care about this.
>
>
> Assuming we do care about the points, here are some ways I have
> considered of addressing them:
>
> (1)
>
> (a)
>
> If we could make the 64-bit fuse_ino_t unique and persistent (see (2)),
> we could use that for st_ino (also a 64-bit field).

My gut feeling is that we'd want to avoid boundless maps stored in
memory or any kind of storage.

In fact we want to do the opposite: avoid having to keep map of
objects currently in guest cache.  We want to flush the server maps
independently of the guest cache when the maps grow too large or there
are too many open file descriptors (a big issue with running virtiofsd
unprivileged)...

>
> (b)
>
> Otherwise, we probably want to continue passing through st_ino and then
> ensure that stat’s st_dev is unique for each submount in the exported
> tree.  We can achieve that by extending the FUSE protocol for virtiofsd
> to announce submounts and then the FUSE kernel driver to automount them.
>  (This means that these submounts in the guest are then technically
> unrelated filesystems.  It also means that the FUSE driver would need to
> automount them with the “virtiofs” fs type, which is kind of weird, and
> restricts this solution to virtiofs.)
>
>
> (2)
>
> (a)
>
> We can keep the current way if we just store the in-memory mapping while
> virtiofsd is suspended (and migrate it it if we want to migrate the
> virtiofsd instance).  The table may grow to be very large, though, and
> it contains for example file descriptors that we would need to migrate,
> too (perhaps as file handles?).
>
> (b)
>
> We could extend the fuse_ino_t type to an arbitrary size basically, to
> be negotiated between FUSE server and client.  This would require
> extensive modification of the FUSE protocol and kernel driver (and would
> ask for respective modification of libfuse, too), though.  Such a larger
> value could then capture both a submount ID and a unique identifier for
> inodes on the respective host filesystems, such as st_ino.  This would
> ensure that every virtiofsd instance would generate the same fuse_ino_t
> values for the same nodes on the same exported tree.
>
> However, note that this doesn’t auto-populate the fuse_ino_t mappings:
> When after restarting virtiofsd the server wants to access an existing
> inode, it can’t, because there is no good way to translate even larger
> fuse_ino_t values to a file descriptor.  (We could do that if the
> fuse_ino_t value encapsulated a handle.  (As in open_by_handle_at().)

...and this is the proposal that would solve that one as well.  If we
could encapsulate the file handle into all messages, than we wouldn't
have to worry about refcounting objects and keeping files open.  The
server could just flush it's caches independently of the guest.

> The problem is that we can’t trust the guest to keep a handle, so we
> must ensure that the handle returned points to a file the guest is
> allowed to access.  Doing that cryptographically (e.g. with a MAC) is
> probably out of the question, because that would make fuse_ino_t really
> big.

I'm not a crypto expert, but why would that need to be big?  AES has
16 byte block size, so the handle would need to be padded to be a
multiple of 16 bytes, but that doesn't sound excessive at all.

What worries me more is the variable nature of the field size, but I
suppose there's no good way to get around that.

>   Another idea would be to set a flag on the host FS for files that
> the guest has a handle to.  But this flag would need to be
> guest-specific...  So we’d probably again end up with a large database
> just as in (2a).  (It doesn’t need to be a flag on the FS, it could also
> be a database, I suppose.))
>
> We could also re-enumerate the exported tree after reopening (perhaps
> lazily for each exported filesystem) and thus recreate the mapping.  But
> this would take as much time as a “find” over the whole exported tree.
>
> (c)
>
> We could complement the fuse_ino_t value by a context ID, that in our
> case would probably be derived from the submount ID (e.g. the relative
> mount point).  This would only require minor modification of the FUSE
> protocol: Detecting mount points in lookups; a new command to retrieve a
> mount point’s context ID; and some way to set this context ID.
>
> We could set the context ID either explicitly with a new command; or as
> part of every FUSE request (a field in the request header); or just as
> part of virtio-fs (be it with one virtqueue per context (which may or
> may not be feasible), or just by prefixing every FUSE request on the
> line with a context ID).
>
> One of the questions here is: If we just choose the context ID to be 32
> or 64 bit in size, will we ever run into the same problem of “96/128
> bits aren’t enough”?

I wouldn't worry about that.   32bits for the number of submounts is
definitely enough for the foreseeable future.

>
> The other problem is the same as in (2b): We cannot get an FD from a
> context ID + fuse_ino_t alone, so if virtiofsd is restarted, the guest
> cannot keep using existing inodes without reopening them.
>
> The only way I see here to get around this problem is to re-enumerate
> the whole exported tree (or at least lazily by context ID a.k.a.
> filesystem) and thus reconstruct the mapping from ID to inode after
> resuming virtiofsd.
>
>
> (3)
>
> (a)
>
> If the fuse_ino_t keeps to be 64 bit and persistent (we don’t reuse IDs
> and we keep existing mappings around even when their refcount drops to 0
> (but why would we do that?)), we don’t have to change anything.
>
> (b)
>
> We probably just want new FUSE commands to query handles and open
> handles.  We could then decide whether we want them to use persistent
> IDs that we get from solving (2), or just pass through the handles from
> the host.
>
> If we do the latter, we have the same problem I mentioned in (2b): We
> can’t trust the guest to keep the handle unmodified, and if it does
> modify it, we have to keep the guest from accessing files it must not see.
>
> The two ways that have been proposed so far are
>
> (I) Enrich the host’s file handle by cryptographic information to prove
> its integrity, e.g. a MAC based on a randomly generated
> virtiofsd-internal symmetric key.  The two problems I see are that the
> file handle gets rather big, and that the guest might be able to guess
> the MAC (very improbable, though, especially if we were to terminate the
> connection when the guest tries to use a file handle with an invalid MAC).
>
> (II) Keep notes somewhere of what file handles the guest may use.  This
> could be implemented by storing a virtiofsd instance ID as metadata in
> the filesystem (attached to the file, so virtiofsd can read it when
> opening the file by its handle); or as a database for each virtiofsd
> instance (where it puts all handles handed out to a guest).
>
>
>
> You can see that all of these problems are kind of intertwined, but not
> really.  Many solutions look similar, and some solutions can solve
> multiple problems; but it doesn’t mean we have to think about everything
> at once.  I think we should first think about how to handle the
> identification problem (1/2).  Maybe there isn’t much to do there anyway
> because we don’t care about it and can just use the existing fuse_ino_t
> as st_ino for the guest.
>
> Then we can think about (3).  If we decide to add new FUSE commands for
> getting/opening file handles, then this works with pretty much every way
> we go about (1) and (2).
>
>
>
> Side note:
>
> As for migrating a virtiofsd instance: Note that everything above that
> depends on host file handles or host ino_t values will make it
> impossible to migrate to a different filesystem.  But maybe doing that
> would lead to all kind of other problems anyway.

If filesystem exported to guests is backed by a common server (e.g.
NFS) than that should solve the ino_t and file handle persistency
across migration.

Thanks,
Miklos


