Return-Path: <hreitz@redhat.com>
Message-ID: <ec3a9cf9-1e43-f91a-b64d-9bd57b93fc16@redhat.com>
Date: Tue, 7 Feb 2023 10:35:30 +0100
MIME-Version: 1.0
References: <fb523956-7a8c-608b-6db1-961686b73e9c@redhat.com>
 <CAJSP0QWnq6av7j6x_n-C2mLSPMYBhMeEthr6ayPN-cmsEB3UnA@mail.gmail.com>
 <87mt5qv76d.fsf@secure.mitica>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <87mt5qv76d.fsf@secure.mitica>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] vhost-user (virtio-fs) migration: back end state
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: quintela@redhat.com, Stefan Hajnoczi <stefanha@gmail.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>, =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>, Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Dave Gilbert <dgilbert@redhat.com>

On 06.02.23 22:02, Juan Quintela wrote:
> Stefan Hajnoczi <stefanha@gmail.com> wrote:
>> On Mon, 6 Feb 2023 at 07:36, Hanna Czenczek <hreitz@redhat.com> wrote:
>>> Hi Stefan,
>>>
>>> For true virtio-fs migration, we need to migrate the daemon’s (back
>>> end’s) state somehow.  I’m addressing you because you had a talk on this
>>> topic at KVM Forum 2021. :)
>>>
>>> As far as I understood your talk, the only standardized way to migrate a
>>> vhost-user back end’s state is via dbus-vmstate.  I believe that
>>> interface is unsuitable for our use case, because we will need to
>>> migrate more than 1 MB of state.  Now, that 1 MB limit has supposedly
>>> been chosen arbitrarily, but the introducing commit’s message says that
>>> it’s based on the idea that the data must be supplied basically
>>> immediately anyway (due to both dbus and qemu migration requirements),
>>> and I don’t think we can meet that requirement.
>> Yes, dbus-vmstate is the available today. It's independent of
>> vhost-user and VIRTIO.
> Once that we are here:
> - typical size of your starte (either vhost-user or whatever)

Difficult to say, completely depends on the use case.  When identifying 
files by path and organizing them in a tree structure, probably ~48 
bytes per indexed file, plus, say, 16 bytes per open file.

So for a small shared filesystem, the state can be very small, but we’ll 
also have to prepare for cases where it is in the range of several MB.

The main problem isn’t size but that (when identifying files by path) 
we’ll probably want to construct the paths when migrating, which won’t 
be done instantaneously.

> - what are the posibilities that you can enter the iterative stage
>    negotiation (i.e. that you can create a dirty bitmap about your state)

Very good.  We should know when parts of the state (information about a 
specific indexed or open file) changes.  (Exceptions apply, but they 
mostly come down to whether indexed files are identified by path or file 
handle, which is a choice the user will probably need to make.  Either 
one comes with caveats.)

[...]

>>> Of course, we could use a channel that completely bypasses qemu, but I
>>> think we’d like to avoid that if possible.  First, this would require
>>> adding functionality to virtiofsd to configure this channel.  Second,
>>> not storing the state in the central VM state means that migrating to
>>> file doesn’t work (well, we could migrate to a dedicated state file,
>>> but...).
> How much is migration to file used in practice?
> I would like to have some information here.
> It could be necessary probably to be able to encrypt it.  And that is a
> (different) whole can of worms.

I don’t think virtio-fs state needs to be encrypted any more than any 
other state.  It’ll basically just map FUSE inode IDs to a file in the 
shared directory, either via path or file handle; and then also track 
open(2) flags for opened files.  (At least that’s what’s currently on my 
radar.)  That information should actually be replicated in the guest, 
too (because it too will have mapped the filesystem paths to FUSE inode 
IDs), so isn’t more security relevant than guest memory.

Hanna

