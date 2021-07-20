Date: Tue, 20 Jul 2021 10:50:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YPbit/qbA4Ussaa5@redhat.com>
References: <20210609155551.44437-1-mreitz@redhat.com>
	<20210609155551.44437-8-mreitz@redhat.com>
	<20210611200459.GB767764@redhat.com>
	<9cea5642-e5ea-961f-d816-0998e52aad9f@redhat.com>
	<20210617212143.GD1142820@redhat.com>
	<1e5dafd2-34e0-1a25-2cb5-6822eaf2502c@redhat.com>
	<20210618182901.GB1252241@redhat.com>
	<eec1bcd6-957d-8e9f-457c-fb717b71336b@redhat.com>
	<eda4ee02-56f8-079d-0829-041ed3471aed@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eda4ee02-56f8-079d-0829-041ed3471aed@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 7/9] virtiofsd: Add inodes_by_handle hash
 table
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Tue, Jul 13, 2021 at 05:07:31PM +0200, Max Reitz wrote:

[..]
> > The next question is, how do we detect temporary failure, because if we
> > look up some new inode, name_to_handle_at() fails, we ignore it, and
> > then it starts to work and we fail all further lookups, that’s not
> > good.  We should have the first lookup fail.  I suppose ENOTSUPP means
> > “OK to ignore”, and for everything else we should let lookup fail?  (And
> > that pretty much answers my "what if name_to_handle_at() works the first
> > time, but then fails" question.  If we let anything but ENOTSUPP let the
> > lookup fail, then we should do so every time.)
> 
> I don’t think this will work as cleanly as I’d hoped.
> 
> The problem I’m facing is that get_file_handle() doesn’t only call
> name_to_handle_at(), but also contains a lot of code managing mount_fds. 
> There are a lot of places that can fail, too, and I think we should have
> them fall back to using an O_PATH FD:
> 
> Say mount_fds doesn’t contain an FD for the new handle’s mount ID yet, so we
> want to add one.  However, it turns out that the file is not a regular file
> or directory, so we cannot open it as a regular FD and add it to mount_fds;

Hi Max,

So an fd opened using O_PATH can't be used as "mount_fd" in
open_by_handle_at()? (I see that you are already first opening O_PATH
fd and then verifying if this is a regular file/dir or not).

> or that it is a regular file, but without permission to open it O_RDONLY. 
> So we cannot return a file handle, because it will not be usable until a
> mount FD is added.
> 
> I think in such a case we should fall back to an O_PATH FD, because this is
> not some unexpected error, but just an unfortunate (but reproducible and
> valid) circumstance where using `-o inode_file_handles` fails to do
> something that works without it.
> 
> Now, however, this means that the next time we try to generate a handle for
> this file (to look it up), it will absolutely work if some other FD was
> added to mount_fds for this mount ID in the meantime.
> 
> 
> We could get around this by not trying to open the file for which we are to
> generate a handle to add its FD to mount_fds, but instead doing what the
> open_by_handle_at() man page suggests:
> 
> > The mount_id argument returns an identifier for the filesystem mount
> > that corresponds to pathname. This corresponds to the first field in one
> > of the records in /proc/self/mountinfo. Opening the pathname in the
> > fifth field of that record yields a file descriptor for the mount point;
> > that file descriptor can be used in a subsequent call to
> > open_by_handle_at().
> 
> However, I’d rather avoid parsing mountinfo.

Hmm.., not sure what's wrong with parsing mountinfo. Example code does
not look too bad. Also it mentions that libmount provides helpers
(if we don't want to write our own function to parse mountinfo).

I would think parsing mountinfo is a good idea because it solves
your problem of not wanting to open device nodes for mount_fds. And
in turn not relying on a fallback to O_PATH fds.

Few thoughts overall.

- We are primarily disagreeing on whether we should fallback to O_PATH
  fds or not if something goes wrong w.r.t handle generation.

  My preference is that atleast in the initial patches we should not try
  to fall back. EOPNOTSUPP is the only case we need to take care of.
  Otherwise if there is any temporary error (EMOMEM, running out of
  fds or something else), we return it to the caller. That's what
  rest of the code is doing. If some operation fails due to some
  temporary error (say ENOMEM), we return error to the caller.

- If above apporach creates problem, we can always add the fallback
  path later.

- If you have strong preference for fallback path, can we have it
  as last patch of the series and not bake it in from the beginning
  of the patch series.

- Even if we add fallback path, can we not make that assumption in
  other areas of the code. For example, can we not avoid parsing
  mountinfo to generate mount_fd, because we have a fallback path
  and we can afford to not generate handle. I mean if we were to
  remove fallback logic at some point of time, it will be much
  easier to do if dependency on this assumption did not spread
  too much.

Thanks
Vivek


> And as far as I understand,
> the only problem here is that we’ll have to cope with the fact that
> sometimes on lookups, we can generate a file handle, but the lo_inode we
> want to find has no file handle attached to it (because get_file_handle()
> failed the first time), and so we won’t find it by that handle but have to
> look it up by its inode ID. (Which is safe, because that lo_inode must have
> an O_PATH FD attached to it, so the inode ID cannot be reused.)  And that’s
> something that this series already does, so I tend to favor that over
> parsing mountinfo.

> 
> Max
> 

