References: <20210609155551.44437-1-mreitz@redhat.com>
	<20210609155551.44437-8-mreitz@redhat.com>
	<20210611200459.GB767764@redhat.com>
	<9cea5642-e5ea-961f-d816-0998e52aad9f@redhat.com>
	<20210617212143.GD1142820@redhat.com>
	<1e5dafd2-34e0-1a25-2cb5-6822eaf2502c@redhat.com>
	<20210618182901.GB1252241@redhat.com>
	<eec1bcd6-957d-8e9f-457c-fb717b71336b@redhat.com>
	<eda4ee02-56f8-079d-0829-041ed3471aed@redhat.com>
	<YPbit/qbA4Ussaa5@redhat.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <fe636905-5943-0212-d4d9-9320f6109e62@redhat.com>
Date: Wed, 21 Jul 2021 10:29:49 +0200
MIME-Version: 1.0
In-Reply-To: <YPbit/qbA4Ussaa5@redhat.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On 20.07.21 16:50, Vivek Goyal wrote:
> On Tue, Jul 13, 2021 at 05:07:31PM +0200, Max Reitz wrote:
>
> [..]
>>> The next question is, how do we detect temporary failure, because if we
>>> look up some new inode, name_to_handle_at() fails, we ignore it, and
>>> then it starts to work and we fail all further lookups, that’s not
>>> good.  We should have the first lookup fail.  I suppose ENOTSUPP means
>>> “OK to ignore”, and for everything else we should let lookup fail?  (And
>>> that pretty much answers my "what if name_to_handle_at() works the first
>>> time, but then fails" question.  If we let anything but ENOTSUPP let the
>>> lookup fail, then we should do so every time.)
>> I don’t think this will work as cleanly as I’d hoped.
>>
>> The problem I’m facing is that get_file_handle() doesn’t only call
>> name_to_handle_at(), but also contains a lot of code managing mount_fds.
>> There are a lot of places that can fail, too, and I think we should have
>> them fall back to using an O_PATH FD:
>>
>> Say mount_fds doesn’t contain an FD for the new handle’s mount ID yet, so we
>> want to add one.  However, it turns out that the file is not a regular file
>> or directory, so we cannot open it as a regular FD and add it to mount_fds;
> Hi Max,
>
> So an fd opened using O_PATH can't be used as "mount_fd" in
> open_by_handle_at()? (I see that you are already first opening O_PATH
> fd and then verifying if this is a regular file/dir or not).

Yep, unfortunately we need a non-O_PATH fd.

>> or that it is a regular file, but without permission to open it O_RDONLY.
>> So we cannot return a file handle, because it will not be usable until a
>> mount FD is added.
>>
>> I think in such a case we should fall back to an O_PATH FD, because this is
>> not some unexpected error, but just an unfortunate (but reproducible and
>> valid) circumstance where using `-o inode_file_handles` fails to do
>> something that works without it.
>>
>> Now, however, this means that the next time we try to generate a handle for
>> this file (to look it up), it will absolutely work if some other FD was
>> added to mount_fds for this mount ID in the meantime.
>>
>>
>> We could get around this by not trying to open the file for which we are to
>> generate a handle to add its FD to mount_fds, but instead doing what the
>> open_by_handle_at() man page suggests:
>>
>>> The mount_id argument returns an identifier for the filesystem mount
>>> that corresponds to pathname. This corresponds to the first field in one
>>> of the records in /proc/self/mountinfo. Opening the pathname in the
>>> fifth field of that record yields a file descriptor for the mount point;
>>> that file descriptor can be used in a subsequent call to
>>> open_by_handle_at().
>> However, I’d rather avoid parsing mountinfo.
> Hmm.., not sure what's wrong with parsing mountinfo.

Well, it’s just that it’s some additional complexity that I didn’t 
consider necessary.

(Because I was content with falling back in the rare case that the 
looked up file is not a regular file or directory.)

> Example code does
> not look too bad. Also it mentions that libmount provides helpers
> (if we don't want to write our own function to parse mountinfo).
>
> I would think parsing mountinfo is a good idea because it solves
> your problem of not wanting to open device nodes for mount_fds. And
> in turn not relying on a fallback to O_PATH fds.

Well.  Strictly speaking, it isn’t really my problem, because I didn’t 
really consider a rare fallback to be a problem.

Furthermore, I don’t even know whether it really solves the problem.  
Just as a mount point need not be a directory, it need not even be a 
regular file.  You absolutely can mount a filesystem on a device file, 
and have the root node be a device file, too:

(I did this by modifying the qemu FUSE block export code (to pass “dev” 
as a mount option, to drop the check whether the mount point is a 
regular file, and to report a device file instead of a regular file).  
It doesn’t work perfectly well because FUSE drops the rdev attribute, 
and so you can only create 0:0 device files, but, well...)

$ cat /proc/self/mountinfo
436 40 0:45 / /tmp/blub rw,nosuid,relatime shared:238 - fuse /dev/fuse 
rw,user_id=0,group_id=0,default_permissions,allow_other,max_read=67108864
$ stat /tmp/blub
File: /tmp/blub
Size: 1073741824 Blocks: 2097152 IO Block: 1 character special file
Device: 2dh/45d Inode: 1 Links: 1 Device type: 0,0
[...]

I know this is something that nobody will normally ever do, but I still 
don’t think we can absolutely safely assume a mount point to always be a 
regular file or directory.

> Few thoughts overall.
>
> - We are primarily disagreeing on whether we should fallback to O_PATH
>    fds or not if something goes wrong w.r.t handle generation.
>
>    My preference is that atleast in the initial patches we should not try
>    to fall back. EOPNOTSUPP is the only case we need to take care of.
>    Otherwise if there is any temporary error (EMOMEM, running out of
>    fds or something else), we return it to the caller. That's what
>    rest of the code is doing. If some operation fails due to some
>    temporary error (say ENOMEM), we return error to the caller.
>
> - If above apporach creates problem, we can always add the fallback
>    path later.
>
> - If you have strong preference for fallback path, can we have it
>    as last patch of the series and not bake it in from the beginning
>    of the patch series.
>
> - Even if we add fallback path, can we not make that assumption in
>    other areas of the code. For example, can we not avoid parsing
>    mountinfo to generate mount_fd, because we have a fallback path
>    and we can afford to not generate handle. I mean if we were to
>    remove fallback logic at some point of time, it will be much
>    easier to do if dependency on this assumption did not spread
>    too much.

The problem I see is that we always need a fallback path (for 
EOPNOTSUPP), and it’s very simple to have.  I see no reason to ever 
remove it, because removing it won’t really simplify anything.

As for when to report errors to the guest and when not, the simplest 
case is to have all errors fall back to O_PATH fds.  It’s naturally more 
difficult having to distinguish between errors that should be passed to 
the guest, and errors that should result in fallbacks.

In fact, frankly, I still don’t understand why it’s a problem to always 
fall back.  I thought I understood one problem in our discussion on v2, 
but then it turned out that it was just a single condition somewhere 
else that was wrong (i.e. the fact that we must never look up lo_inodes 
that have no O_PATH fd by a device ID without a generation ID).

I understand that intuitively erroring out is easier.  But technically, 
it isn’t, and I don’t see any technical advantage in passing 
file-handle-related errors to the guest immediately rather than trying 
to fall back first.  (Even if the fallback then fails, and one could 
argue that we could have seen it coming based on the file handle error, 
taking a bit more time for a case that will fail anyway shouldn’t be a 
real problem.  (And the “more time” is just a single openat(O_PATH).))

Max

