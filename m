References: <5f49cefd-a051-8af4-86a2-3ea94acd9eee@redhat.com>
	<20190827130207.GC4290@stefanha-x1.localdomain>
From: Laszlo Ersek <lersek@redhat.com>
Message-ID: <b2d18411-d518-788a-0783-1d55a11407c6@redhat.com>
Date: Tue, 27 Aug 2019 23:05:45 +0200
MIME-Version: 1.0
In-Reply-To: <20190827130207.GC4290@stefanha-x1.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] basic questions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com

On 08/27/19 15:02, Stefan Hajnoczi wrote:
> On Sat, Aug 24, 2019 at 01:09:18PM +0200, Laszlo Ersek wrote:
>> [...]
> [...]

Thanks for the updates for / answers to my questions (1) through (5). In
particular I hadn't realized that it's virtiofsd to process the virtqueues!

>> (6) I seem to recall that virtio-fs allows guests to notice if files
>> have changed since they last looked.
>>
>> Is that functionality tied to "ireg" daemon, and to the "versiontable"
>> property added in commit 8fb5b17bea63 ("virtio-fs: Allow mapping of meta
>> data version table", 2019-08-23)?
> 
> Currently only virtiofsd -o cache=none guarantees fresh metadata (at a
> performance cost).  The ireg daemon is experimental and incomplete, but
> it will make coherent metadata cheaper in the future.
> 
> There is currently no inotify support in FUSE, so the guest does not
> receive notifications when the file system changes.  Right now guests
> would have to poll for changes.

Sorry, I was unclear. It's fine for my use case if the guest has to ask
actively about intermittent metadata changes. My interest is not in
notifications.

E.g. assume the guest tries to read or write a file it has opened
earlier. (With explicit FUSE_READ / FUSE_WRITE requests, wrapped into
the usual virtio descriptor chains.) Can the guest ask, in the read or
write request, "please reject this request of mine if the file has
changed since I last looked"? [1]

Is the "ireg" daemon, or "-o cache=none", required for that?

>> (7) Are guests required to access the virtio-fs device at the PCI level
>> -- such as an MMIO region -- in order to observe async file changes, or
>> is this functionality available purely at the virtio communication level
>> (i.e., transport-independently)?
>>
>> It doesn't seem to be explained at
>> <https://stefanha.github.io/virtio/virtio-fs.html>.
> 
> Coherent shared file system access is not supported yet (that's where
> the ireg daemon comes in and it's still under development).  Today
> virtio-fs is good for the use case where the guest is the only one
> accessing the file system.

Understood, thanks!

> In terms of the VIRTIO spec, everything is done at the device model
> level.  Even the DAX Window is a "shared memory region", which is a
> well-defined device model concept.  The MMIO and PCI transports
> implement shared memory regions differently, though.

Ah, that makes a lot of sense. I've now read the shared memory region
sections at <https://stefanha.github.io/virtio/virtio-fs.html>. So this
is a new generic virtio facility.

It looks like virtio-fs defines shmid#0 for the time being, namely for
the DAX Window. The DAX window is not important for my use case (I plan
to use FUSE_READ/FUSE_WRITE).

However: is another (different) shared memory region planned, for the
kind of stale metadata detection that I describe above, at [1]?

Thank you!
Laszlo

