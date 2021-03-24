References: <47a35ffe-ef39-d098-2c29-34cf7d4eb7ef@redhat.com>
	<YFsnwtUqfmr3e7dI@stefanha-x1.localdomain>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <f28daab1-515e-3282-f126-c599438f0833@redhat.com>
Date: Wed, 24 Mar 2021 13:28:48 +0100
MIME-Version: 1.0
In-Reply-To: <YFsnwtUqfmr3e7dI@stefanha-x1.localdomain>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] Current file handle status and open questions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On 24.03.21 12:51, Stefan Hajnoczi wrote:
> On Thu, Mar 18, 2021 at 06:09:58PM +0100, Max Reitz wrote:
>> So, overall it seems like it may be workable to extend the in-kernel MAC
>> verification to allow for persistent keys, but I still have some open
>> questions, and I don’t know whether I should just defer them until we
>> get to the point where we need persistency.
> 
> It seems worth refining these ideas a little bit further until they
> reach solid ground. Then we can be sure that there is at least one
> possible solution. At the moment it seems like most the components of a
> solution are known but it's not clear how they all fit together - and
> they have a nasty tendency of failing to meet the requirements if they
> aren't put together in exactly the right way :).
> 
>> (Of note: If we implement something where a user space process (or
>> multiple in conjunction) can arbitrarily choose a MAC key, then this
>> will also be usable for live migration, because you can continue to use
>> the key from the source on the destination.)
> 
> Definitely. Taking migration into account is worthwhile. One question
> about that:
> 
> Are Linux file handles transferrable between systems? Basic
> configurations that come to mind:
> 1. XFS, brtfs, ext4 on SAN (e.g. FibreChannel SCSI LUN)
> 2. NFS
> 
> I assumed they were in previous discussions but has anyone checked the
> file handle implementations to see whether this is really the case?

I’m not exactly sure what you mean.  I think you’re asking whether for a 
single (shared) filesystem a file handle always works independently of 
which Linux instance is using it?

If so, depends on the filesystem, I guess, but for the ones where I know 
how file handles work, yes, it does.

XFS and ext4 just have an inode ID plus a generation ID.  For XFS, the 
generation ID is stored in the inode structure (I don’t know about ext4, 
but I assume it’s the same), so this handle has no information that 
would change at runtime, it’s just about on-disk information.

I’ve described the NFS handle structure before, the only notable thing 
here is the FS ID it contains.  If it’s a UUID, I would assume it is 
transferrable, because this UUID is part of the on-disk filesystem.  If 
such a UUID is not available, AFAIA NFS may fall back to a device ID, 
which of course may not be transferrable, but that’s a fallback that I 
haven’t seen happen.

>> Final minor question that doesn’t really fit in fully elsewhere: When
>> generating a MAC over a file handle, should the mount ID be included?
>> I’m worried that this might definitely break persistency, but I think we
>> should include some FS ID.  Maybe the kernel should query the FS UUID
>> for this MAC calculation, and use that instead of the mount ID?
> 
> This is a good point. If the file handle is not tied to a particular
> file system mount then an application can stash a well-known file handle
> (e.g. /) from one mount it has full access to and then use open a file
> on a mount that it does not have full directory treeaccess to (e.g. a
> bind mount/sub-tree?).

Oh, that’s absolutely true.  / on XFS at least has the generation ID 0, 
so this would absolutely be usable at least for other XFS filesystems.

So we probably do need to include some FS ID, like the UUID.

Max

