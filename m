DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=StYiT05HNbE1zzJk9oDEHJ94LT16dL7RYDuodbx7jaQ=;
	b=OSgEeDSu8TIsalgDLV8MtwWdDri62uZ9XtDsjzUJI8OJoWcHnSfG5Sk/FFcHvQ/8sc
	9LxNtg4d/hfUv6K7NIbia/5yoWddfqup0KWfrCPVlA4aWMqXq2kqHwXEwFxWQYkfy4rg
	KvVzIrnYq4NBW9FeDERVn7LZVeTex/eo5lhho=
MIME-Version: 1.0
References: <20200716144032.GC422759@redhat.com>
	<20200716181828.GE422759@redhat.com>
	<CAJfpegt-v6sjm2WyjXMWkObqLdL6TSAi=rjra4KK5sNy6hhhmA@mail.gmail.com>
	<20200720154112.GC502563@redhat.com>
	<CAJfpegtked-aUq0zbTQjmspG04LG3ar-j_BRsb88kR+cnHNO_w@mail.gmail.com>
	<20200721151655.GB551452@redhat.com>
	<CAJfpegtiSNVhnH_FF8qyd2+NO8EJyXoJhPzRVsus8qm4d6UABQ@mail.gmail.com>
	<20200721155503.GC551452@redhat.com>
	<CAJfpegsUsZ1DLW6rzR4PQ=M2MxCY1r87eu2rP0Nac4Li_VEm7Q@mail.gmail.com>
	<20200721213042.GE551452@redhat.com>
In-Reply-To: <20200721213042.GE551452@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 22 Jul 2020 12:00:55 +0200
Message-ID: <CAJfpegtpvDkKMhZsyjzHYQDpRN4e+bA9McV_em=GijnrmeEO7Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] virtiofs: Enable SB_NOSEC flag to improve
	small write performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, ganesh.mahalingam@intel.com

On Tue, Jul 21, 2020 at 11:30 PM Vivek Goyal <vgoyal@redhat.com> wrote:

> What about following race. Assume a client has set suid/sgid/caps
> and this client is doing write but cache metadata has not expired
> yet. That means fuse_update_attributes() will not clear S_NOSEC

If the write is done on the same client as the chmod/setxattr, than
that's not a problem since chmod and setxattr will clear S_NOSEC in
the suid/sgid/caps case.

> and that means file_remove_privs() will not clear suid/sgid/caps
> as well as WRITE will be buffered so that also will not clear
> suid/sgid/caps as well.
>
> IOW, even after WRITE has completed, suid/sgid/security.capability will
> still be there on file inode if inode metadata had not expired at the time
> of WRITE. Is that acceptable from coherency requirements point of view.


If they were on different clients, then yes, we'll have a coherency
issue, but that's not new.

>
> I have a question. Does general fuse allow this use case where multiple
> clients are distributed and not going through same VFS? virtiofs wants
> to support that at some point of time but what about existing fuse
> filesystems.

Fuse supports distributed fs through

 - dcache invalidation with timeout (can be zero to disable caching completely)
 - dcache invalidation with notification
 - metadata invalidation with timeout (can be zero to disable caching
completely)
 - metadata and data range invalidation with notification
 - disabling data caching (FOPEN_DIRECT_IO)
 - auto data invalidation on size/mtime change
 - data invalidation on open (!FOPEN_KEEP_CACHE)

So yes, supports a number of ways to handle the multiple client case.

What we could do additionally with virtiofs is to make clients running
in different guests but on the same host achieve strong coherency with
some sort of shared memory scheme.

> I also have concerns with being dependent on FUSE_HANDLE_KILLPRIV because
> it clear suid/sgid on WRITE and truncate evn if caller has
> CAP_SETID, breaking Linux behavior (Don't know what does POSIX say).

FUSE_HANDLE_KILLPRIV should handle writes properly (discovered by one
of the test suites, not real life report, as far as I remember).

Truncate is a different matter, currently there's no way to
distinguish between CAP_FSETID being set or clear.

Can't find POSIX saying anything about this.

> Shall we design FUSE_HANDLE_KILLPRIV2 instead which kills
> security.capability always but kills suid/sgid on on WRITE/truncate
> only if caller does not have CAP_FSETID. This also means that
> we probably will have to send this information in fuse_setattr()
> somehow.

Yes, that's a good plan.

Thanks,
Miklos

