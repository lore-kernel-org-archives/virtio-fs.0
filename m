References: <5f49cefd-a051-8af4-86a2-3ea94acd9eee@redhat.com>
	<20190827130207.GC4290@stefanha-x1.localdomain>
	<b2d18411-d518-788a-0783-1d55a11407c6@redhat.com>
	<20190828113639.GI5573@stefanha-x1.localdomain>
From: Laszlo Ersek <lersek@redhat.com>
Message-ID: <bf9d73ed-0533-1cc1-9884-3c08281dd961@redhat.com>
Date: Thu, 29 Aug 2019 16:08:00 +0200
MIME-Version: 1.0
In-Reply-To: <20190828113639.GI5573@stefanha-x1.localdomain>
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

On 08/28/19 13:36, Stefan Hajnoczi wrote:
> On Tue, Aug 27, 2019 at 11:05:45PM +0200, Laszlo Ersek wrote:
>> On 08/27/19 15:02, Stefan Hajnoczi wrote:
>>> On Sat, Aug 24, 2019 at 01:09:18PM +0200, Laszlo Ersek wrote:
>>>> [...]
>>> [...]
>>
>> Thanks for the updates for / answers to my questions (1) through (5). In
>> particular I hadn't realized that it's virtiofsd to process the virtqueues!
>>
>>>> (6) I seem to recall that virtio-fs allows guests to notice if files
>>>> have changed since they last looked.
>>>>
>>>> Is that functionality tied to "ireg" daemon, and to the "versiontable"
>>>> property added in commit 8fb5b17bea63 ("virtio-fs: Allow mapping of meta
>>>> data version table", 2019-08-23)?
>>>
>>> Currently only virtiofsd -o cache=none guarantees fresh metadata (at a
>>> performance cost).  The ireg daemon is experimental and incomplete, but
>>> it will make coherent metadata cheaper in the future.
>>>
>>> There is currently no inotify support in FUSE, so the guest does not
>>> receive notifications when the file system changes.  Right now guests
>>> would have to poll for changes.
>>
>> Sorry, I was unclear. It's fine for my use case if the guest has to ask
>> actively about intermittent metadata changes. My interest is not in
>> notifications.
>>
>> E.g. assume the guest tries to read or write a file it has opened
>> earlier. (With explicit FUSE_READ / FUSE_WRITE requests, wrapped into
>> the usual virtio descriptor chains.) Can the guest ask, in the read or
>> write request, "please reject this request of mine if the file has
>> changed since I last looked"? [1]
> 
> No, FUSE_READ/FUSE_WRITE don't support that.
> 
>> Is the "ireg" daemon, or "-o cache=none", required for that?
> 
> No.  Userspace applications that share access to a file with at least
> one writer need to synchronize via file locks or out-of-band
> communication.  This is how existing applications work so even if
> virtio-fs offered Compare-and-Swap semantics or similar conditional I/O
> primitives, I think very few applications would use them.
> 
>> However: is another (different) shared memory region planned, for the
>> kind of stale metadata detection that I describe above, at [1]?
> 
> Yes, there will be a second region containing inode version numbers.
> This way FUSE clients can check if the inode was modified by another
> client without making a FUSE request to the server.

I think I understand now:

* "inode version number has changed"

  implies

  "it makes sense to look at the file again"

* "inode version number has not changed"

  does *not* imply

  "my next FUSE_READ / FUSE_WRITE will apply to state I've seen"

--*--

Here's why I've raised this line of questions. In the UEFI-2.8 spec,
EFI_SIMPLE_FILE_SYSTEM_PROTOCOL.OpenVolume() says,

    [...] If the medium is changed while there are open file handles to
    the volume, all file handles to the volume will return
    EFI_MEDIA_CHANGED. To access the files on the new medium, the volume
    must be reopened with OpenVolume(). [...]

Additionally, in EFI_FILE_PROTOCOL.Open():

    [...] If the medium of the device changes, all accesses (including
    the File handle) will result in EFI_MEDIA_CHANGED. To access the new
    medium, the volume must be reopened. [...]

And I've been wondering if the UEFI driver could check inode versions
for returning EFI_MEDIA_CHANGED.

- For that however, extending our VIRTIO_DEVICE_PROTOCOL with shared
memory region mapping facilities would be a pre-requisite. That would
not be a trivial amount of work.

- And even if the UEFI driver checked the inode version before
submitting a FUSE_READ / FUSE_WRITE, that would be a TOC/TOU race.

So I think we'll take EFI_MEDIA_CHANGED (and shared memory region
mapping) off the table. Instead, we should document -- whenever we get
there -- that with EFI_SIMPLE_FILE_SYSTEM_PROTOCOL abstracting a
virtio-fs device, the file system could change asynchronously to the
guest firmware.

--*--

I think this is good enough for the basic purposes that the firmware has
for virtio-fs:

(1) booting (and maybe shutting down)
(2) interactive use (development / testing)

Case (1) in more detail:
- host prepares boot filesystem and possibly input files for tests
- QEMU launches, guest boots, possibly runs tests (meaning UEFI shell
  commands or other UEFI applications) and writes output files
- QEMU shuts down
- host possibly consumes test output files

In other words, the "barriers" are QEMU's startup and shutdown. I think
this falls under the out-of-band communication that you mention.

Case (2) in more detail:
- The developer/tester is working with the UEFI shell and needs some
(unplanned) additional data from the host side.
- The developer copies the file in place on the host side.
- The developer switches to the UEFI shell, and consumes the new file.

So in case (2) it's the interactive user that synchronizes accesses to
the file(s). I seem to remember doing similar things with sshfs (using
it for moving data between the local and the remote host, and working
with the data on the remote host through normal ssh). This appears to be
out-of-band communication again.

--*--

Should we ever need synchronization more flexible than (1) and (2), we
could expose discretionary file locks to specific UEFI applications that
cared:

EFI_FILE_PROTOCOL.GetInfo() and EFI_FILE_PROTOCOL.SetInfo() take a GUID
that identifies the "type of information", plus a (Buffer, Size) pair.
We can invent a new GUID with "uuidgen", for handling file locks.

(The SetInfo() and GetInfo() APIs were deliberately designed like this
in UEFI. There are a few standardized GUIDs that all filesystems are
expected to support -- EFI_FILE_INFO, EFI_FILE_SYSTEM_INFO,
EFI_FILE_SYSTEM_VOLUME_LABEL --, but filesystem implementations are free
to extend these interfaces with new GUIDs that they invent and document.)

Thanks!
Laszlo

