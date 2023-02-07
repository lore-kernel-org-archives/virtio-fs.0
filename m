Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
In-Reply-To: <ec3a9cf9-1e43-f91a-b64d-9bd57b93fc16@redhat.com> (Hanna
 Czenczek's message of "Tue, 7 Feb 2023 10:35:30 +0100")
References: <fb523956-7a8c-608b-6db1-961686b73e9c@redhat.com>
 <CAJSP0QWnq6av7j6x_n-C2mLSPMYBhMeEthr6ayPN-cmsEB3UnA@mail.gmail.com>
 <87mt5qv76d.fsf@secure.mitica>
 <ec3a9cf9-1e43-f91a-b64d-9bd57b93fc16@redhat.com>
Reply-To: quintela@redhat.com
Date: Tue, 07 Feb 2023 16:13:21 +0100
Message-ID: <87lel9o6em.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] vhost-user (virtio-fs) migration: back end state
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, =?utf-8?Q?Marc-Andr?= =?utf-8?Q?=C3=A9?= Lureau <marcandre.lureau@redhat.com>, Eugenio =?utf-8?Q?P=C3=A9rez?= <eperezma@redhat.com>, Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Dave Gilbert <dgilbert@redhat.com>

Hanna Czenczek <hreitz@redhat.com> wrote:
> On 06.02.23 22:02, Juan Quintela wrote:
>> Stefan Hajnoczi <stefanha@gmail.com> wrote:
>>> On Mon, 6 Feb 2023 at 07:36, Hanna Czenczek <hreitz@redhat.com> wrote:
>>>> Hi Stefan,
>>>>
>>>> For true virtio-fs migration, we need to migrate the daemon=E2=80=99s =
(back
>>>> end=E2=80=99s) state somehow.  I=E2=80=99m addressing you because you =
had a talk on this
>>>> topic at KVM Forum 2021. :)
>>>>
>>>> As far as I understood your talk, the only standardized way to migrate=
 a
>>>> vhost-user back end=E2=80=99s state is via dbus-vmstate.  I believe th=
at
>>>> interface is unsuitable for our use case, because we will need to
>>>> migrate more than 1 MB of state.  Now, that 1 MB limit has supposedly
>>>> been chosen arbitrarily, but the introducing commit=E2=80=99s message =
says that
>>>> it=E2=80=99s based on the idea that the data must be supplied basicall=
y
>>>> immediately anyway (due to both dbus and qemu migration requirements),
>>>> and I don=E2=80=99t think we can meet that requirement.
>>> Yes, dbus-vmstate is the available today. It's independent of
>>> vhost-user and VIRTIO.
>> Once that we are here:
>> - typical size of your starte (either vhost-user or whatever)
>
> Difficult to say, completely depends on the use case.=C2=A0 When
> identifying files by path and organizing them in a tree structure,
> probably ~48 bytes per indexed file, plus, say, 16 bytes per open
> file.
>
> So for a small shared filesystem, the state can be very small, but
> we=E2=80=99ll also have to prepare for cases where it is in the range of
> several MB.

That is not two bad.  Anything below a few tens megabytes is easy to
manage.  Anything in the hundred of megabytes or more really need thought.

> The main problem isn=E2=80=99t size but that (when identifying files by p=
ath)
> we=E2=80=99ll probably want to construct the paths when migrating, which =
won=E2=80=99t
> be done instantaneously.
>
>> - what are the posibilities that you can enter the iterative stage
>>    negotiation (i.e. that you can create a dirty bitmap about your state=
)
>
> Very good.=C2=A0 We should know when parts of the state (information abou=
t
> a specific indexed or open file) changes.=C2=A0 (Exceptions apply, but th=
ey
> mostly come down to whether indexed files are identified by path or
> file handle, which is a choice the user will probably need to make.=C2=A0
> Either one comes with caveats.)

That is good.

>> How much is migration to file used in practice?
>> I would like to have some information here.
>> It could be necessary probably to be able to encrypt it.  And that is a
>> (different) whole can of worms.
>
> I don=E2=80=99t think virtio-fs state needs to be encrypted any more than=
 any
> other state.=C2=A0 It=E2=80=99ll basically just map FUSE inode IDs to a f=
ile in the
> shared directory, either via path or file handle; and then also track
> open(2) flags for opened files.=C2=A0 (At least that=E2=80=99s what=E2=80=
=99s currently on
> my radar.)=C2=A0 That information should actually be replicated in the
> guest, too (because it too will have mapped the filesystem paths to
> FUSE inode IDs), so isn=E2=80=99t more security relevant than guest memor=
y.

Oh, that was not about virtio-fs at all.

Is because you talked about file migration.

Right now, we need to use exec migration to do this.  but it is clearly
suboptimal.  Basically we just do a normal migration, but that means
that we have a lot of duplicated pages on the destination.

But we can do better.  Just create a file that is as big as the memory,
and write everypage in its own place.  So loading is going to be really
fast.  (yes holes on RAM is a different issue, but we can ignore that
for now).
And the other thing is that we have to really encrypt it somehow, so I
guess that a block cipher should work, but encryption is not my field of
expertise at all.

In vhost-user-fs case, I fully agree with you that if you are
"exporting" part of the local filesystem, encryption don't buy you
anything.

Later, Juan.


