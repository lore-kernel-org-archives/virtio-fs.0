Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20210112; t=1678898045;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to;
 bh=MeCMC8UVxnfNnGa1kuwPfz3Mk2N5NEKae7N+GRlze08=;
 b=Hqe0WGAkdVZ0vGlmEXnrfEcCJH+Mc+8Cu5WYXSSy+ANFx9eUcd+4mAeKhnzr4B0uGA
 9//DshLo48pr3S1PhnWitO7mZ5Hn+o3wP7isWMr+4MTizl+wKZk76IHDUYTYXBE/4oPc
 T6VdZLwUmSGpQv5oG3lRZhCcvcDwb9XmjqgaDK9ZFfu3L/4yFTUu2isxvEqMzZY6Pi7+
 uSb4kPFiDKTEIoL3G/zTYfw/xoYnQJrZDYhVrnhQAtKGkNwxHDYbYCLL7Qg3rc4cvPu+
 sOru9V2BbdDwwxOHXmoFZ1+NB6QkA+Z90gdcJAKKYC8tbouTQXniqXRrSfWE1VKVgxvW
 hzpw==
MIME-Version: 1.0
References: <20230313174833.28790-1-hreitz@redhat.com>
 <20230313174833.28790-2-hreitz@redhat.com>
 <20230315135844.GC6146@fedora>
 <aca54f19-1c95-01b6-5c5d-bfcee7942c16@redhat.com>
In-Reply-To: <aca54f19-1c95-01b6-5c5d-bfcee7942c16@redhat.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Wed, 15 Mar 2023 12:33:53 -0400
Message-ID: <CAJSP0QX1+YvFeHqbOfysKOmR-oZqz35BfWBgyNUiZOce=zWobA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [RFC 1/2] vhost-user: Add interface for virtio-fs
 migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, "Michael S . Tsirkin" <mst@redhat.com>, "Dr . David Alan Gilbert" <dgilbert@redhat.com>, Juan Quintela <quintela@redhat.com>

On Wed, 15 Mar 2023 at 11:56, Hanna Czenczek <hreitz@redhat.com> wrote:
>
> On 15.03.23 14:58, Stefan Hajnoczi wrote:
> > On Mon, Mar 13, 2023 at 06:48:32PM +0100, Hanna Czenczek wrote:
> >> Add a virtio-fs-specific vhost-user interface to facilitate migrating
> >> back-end-internal state.  We plan to migrate the internal state simply
> > Luckily the interface does not need to be virtiofs-specific since it
> > only transfers opaque data. Any stateful device can use this for
> > migration. Please make it generic both at the vhost-user protocol
> > message level and at the QEMU vhost API level.
>
> OK, sure.
>
> >> as a binary blob after the streaming phase, so all we need is a way to
> >> transfer such a blob from and to the back-end.  We do so by using a
> >> dedicated area of shared memory through which the blob is transferred =
in
> >> chunks.
> > Keeping the migration data transfer separate from the vhost-user UNIX
> > domain socket is a good idea since the amount of data could be large an=
d
> > may congest the UNIX domain socket. The shared memory interface solves
> > this.
> >
> > Where I get lost is why it needs to be shared memory instead of simply
> > an fd? On the source, the front-end could read the fd until EOF and
> > transfer the opaque data. On the destination, the front-end could write
> > to the fd and then close it. I think that would be simpler than the
> > shared memory interface and could potentially support zero-copy via
> > splice(2) (QEMU doesn't need to look at the data being transferred!).
> >
> > Here is an outline of an fd-based interface:
> >
> > - SET_DEVICE_STATE_FD: The front-end passes a file descriptor for
> >    transferring device state.
> >
> >    The @direction argument:
> >    - SAVE: the back-end transfers an outgoing device state over the fd.
> >    - LOAD: the back-end transfers an incoming device state over the fd.
> >
> >    The @phase argument:
> >    - STOPPED: the device is stopped.
> >    - PRE_COPY: reserved for future use.
> >    - POST_COPY: reserved for future use.
> >
> >    The back-end transfers data over the fd according to @direction and
> >    @phase upon receiving the SET_DEVICE_STATE_FD message.
> >
> > There are loose ends like how the message interacts with the virtqueue
> > enabled state, what happens if multiple SET_DEVICE_STATE_FD messages ar=
e
> > sent, etc. I have ignored them for now.
> >
> > What I wanted to mention about the fd-based interface is:
> >
> > - It's just one message. The I/O activity happens via the fd and does
> >    not involve GET_STATE/SET_STATE messages over the vhost-user domain
> >    socket.
> >
> > - Buffer management is up to the front-end and back-end implementations
> >    and a bit simpler than the shared memory interface.
> >
> > Did you choose the shared memory approach because it has certain
> > advantages?
>
> I simply chose it because I didn=E2=80=99t think of anything else. :)
>
> Using just an FD for a pipe-like interface sounds perfect to me.  I
> expect that to make the code simpler and, as you point out, it=E2=80=99s =
just
> better in general.  Thanks!

The Linux VFIO Migration v2 API could be interesting to look at too:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/inc=
lude/uapi/linux/vfio.h#n814

It has a state machine that puts the device into
pre-copy/saving/loading/etc states.

> > What is the rationale for waiting to receive the entire incoming state
> > before parsing it rather than parsing it in a streaming fashion? Can
> > this be left as an implementation detail of the vhost-user back-end so
> > that there's freedom in choosing either approach?
>
> The rationale was that when using the shared memory approach, you need
> to specify the offset into the state of the chunk that you=E2=80=99re cur=
rently
> transferring.  So to allow streaming, you=E2=80=99d need to make the fron=
t-end
> transfer the chunks in a streaming fashion, so that these offsets are
> continuously increasing.  Definitely possible, and reasonable, I just
> thought it=E2=80=99d be easier not to define it at this point and just st=
ate
> that decoding at the end is always safe.
>
> When using a pipe/splicing, however, that won=E2=80=99t be a concern anym=
ore, so
> yes, then we can definitely allow the back-end to decode its state while
> it=E2=80=99s still being received.

I see.

Stefan

