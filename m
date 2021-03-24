Date: Wed, 24 Mar 2021 16:44:53 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YFtshUTbNF9omBGv@work-vm>
References: <47a35ffe-ef39-d098-2c29-34cf7d4eb7ef@redhat.com>
	<YFsnwtUqfmr3e7dI@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YFsnwtUqfmr3e7dI@stefanha-x1.localdomain>
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
Cc: virtio-fs-list <virtio-fs@redhat.com>, Max Reitz <mreitz@redhat.com>

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Thu, Mar 18, 2021 at 06:09:58PM +0100, Max Reitz wrote:
> > So, overall it seems like it may be workable to extend the in-kernel MAC
> > verification to allow for persistent keys, but I still have some open
> > questions, and I don’t know whether I should just defer them until we
> > get to the point where we need persistency.
> 
> It seems worth refining these ideas a little bit further until they
> reach solid ground. Then we can be sure that there is at least one
> possible solution. At the moment it seems like most the components of a
> solution are known but it's not clear how they all fit together - and
> they have a nasty tendency of failing to meet the requirements if they
> aren't put together in exactly the right way :).
> 
> > (Of note: If we implement something where a user space process (or
> > multiple in conjunction) can arbitrarily choose a MAC key, then this
> > will also be usable for live migration, because you can continue to use
> > the key from the source on the destination.)
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
> 
> > Final minor question that doesn’t really fit in fully elsewhere: When
> > generating a MAC over a file handle, should the mount ID be included?
> > I’m worried that this might definitely break persistency, but I think we
> > should include some FS ID.  Maybe the kernel should query the FS UUID
> > for this MAC calculation, and use that instead of the mount ID?
> 
> This is a good point. If the file handle is not tied to a particular
> file system mount then an application can stash a well-known file handle
> (e.g. /) from one mount it has full access to and then use open a file
> on a mount that it does not have full directory treeaccess to (e.g. a
> bind mount/sub-tree?).

I'd be surprised if the mount-id was the same between two hosts.

Dave

> Stefan



> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs

-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

