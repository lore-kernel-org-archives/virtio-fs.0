From: Max Reitz <mreitz@redhat.com>
References: <20210609155551.44437-1-mreitz@redhat.com>
	<20210609155551.44437-8-mreitz@redhat.com>
	<20210611200459.GB767764@redhat.com>
	<9cea5642-e5ea-961f-d816-0998e52aad9f@redhat.com>
	<20210617212143.GD1142820@redhat.com>
	<1e5dafd2-34e0-1a25-2cb5-6822eaf2502c@redhat.com>
	<20210618182901.GB1252241@redhat.com>
	<eec1bcd6-957d-8e9f-457c-fb717b71336b@redhat.com>
Message-ID: <eda4ee02-56f8-079d-0829-041ed3471aed@redhat.com>
Date: Tue, 13 Jul 2021 17:07:31 +0200
MIME-Version: 1.0
In-Reply-To: <eec1bcd6-957d-8e9f-457c-fb717b71336b@redhat.com>
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

So I’m coming back to this after three weeks (well, PTO), and this again 
turns into a bit of a pain, actually.

I don’t think it’s anything serious, but I had thought we had found 
something that would make us both happy because it wouldn’t be too ugly, 
and now it’s turning ugly again...  So I’m sending this mail as a heads 
up before I send v3 in the next days, to explain my thought process.

On 21.06.21 11:02, Max Reitz wrote:
> On 18.06.21 20:29, Vivek Goyal wrote:
>

[...]

>> I am still reading your code and trying to understand it. But one
>> question came to mind. What happens if we can generate file handle
>> during lookup. But can't generate when same file is looked up again.
>>
>> - A file foo.txt is looked. We can create file handle and we add it
>>    to lo->inodes_by_handle as well as lo->inodes_by_ds.
>>
>> - Say somebody deleted file and created again and inode number got
>>    reused.
>>
>> - Now during ->revalidation path, lookup happens again. This time say
>>    we can't generate file handle. If am reading lo_do_find() code
>>    correctly, it will find the old inode using ids and return same
>>    inode as result of lookup. And we did not recognize that inode
>>    number has been reused.
>
> Oh, that’s a good point.  If an lo_inode has no O_PATH fd but is only 
> addressed by handle, we must always look it up by handle.

Also, just wanted to throw in this remark:

Now that I read the code again, lo_do_find() already has a condition to 
prevent this.  It’s this:

if (p && fhandle != NULL && p->fhandle != NULL) {
     p = NULL;
}

There’s just one thing wrong with it, and that is the `fhandle != NULL` 
part.  It has no place there.  But this piece of code does exactly what 
we’d need it do if it were just:

if (p && p->fhandle != NULL) {
     p = NULL;
}

[...]

> However, you made a good point in that we must require 
> name_to_handle_at() to work if it worked before for some inode, not 
> because it would be simpler, but because it would be wrong otherwise.
>
> As for the other way around...  Well, now I don’t have a strong 
> opinion on it.  Handling temporary name_to_handle_at() failure after 
> it worked the first time should not add extra complexity, but it 
> wouldn’t be symmetric.  Like, allowing temporary failure sometimes but 
> not at other times.

(I think I mistyped here, it should be “Handling name_to_handle_at() 
randomly working after it failed the first time”.)

> The next question is, how do we detect temporary failure, because if 
> we look up some new inode, name_to_handle_at() fails, we ignore it, 
> and then it starts to work and we fail all further lookups, that’s not 
> good.  We should have the first lookup fail.  I suppose ENOTSUPP means 
> “OK to ignore”, and for everything else we should let lookup fail?  
> (And that pretty much answers my "what if name_to_handle_at() works 
> the first time, but then fails" question.  If we let anything but 
> ENOTSUPP let the lookup fail, then we should do so every time.)

I don’t think this will work as cleanly as I’d hoped.

The problem I’m facing is that get_file_handle() doesn’t only call 
name_to_handle_at(), but also contains a lot of code managing 
mount_fds.  There are a lot of places that can fail, too, and I think we 
should have them fall back to using an O_PATH FD:

Say mount_fds doesn’t contain an FD for the new handle’s mount ID yet, 
so we want to add one.  However, it turns out that the file is not a 
regular file or directory, so we cannot open it as a regular FD and add 
it to mount_fds; or that it is a regular file, but without permission to 
open it O_RDONLY.  So we cannot return a file handle, because it will 
not be usable until a mount FD is added.

I think in such a case we should fall back to an O_PATH FD, because this 
is not some unexpected error, but just an unfortunate (but reproducible 
and valid) circumstance where using `-o inode_file_handles` fails to do 
something that works without it.

Now, however, this means that the next time we try to generate a handle 
for this file (to look it up), it will absolutely work if some other FD 
was added to mount_fds for this mount ID in the meantime.


We could get around this by not trying to open the file for which we are 
to generate a handle to add its FD to mount_fds, but instead doing what 
the open_by_handle_at() man page suggests:

> The mount_id argument returns an identifier for the filesystem mount 
> that corresponds to pathname. This corresponds to the first field in 
> one of the records in /proc/self/mountinfo. Opening the pathname in 
> the fifth field of that record yields a file descriptor for the mount 
> point; that file descriptor can be used in a subsequent call to 
> open_by_handle_at().

However, I’d rather avoid parsing mountinfo.  And as far as I 
understand, the only problem here is that we’ll have to cope with the 
fact that sometimes on lookups, we can generate a file handle, but the 
lo_inode we want to find has no file handle attached to it (because 
get_file_handle() failed the first time), and so we won’t find it by 
that handle but have to look it up by its inode ID. (Which is safe, 
because that lo_inode must have an O_PATH FD attached to it, so the 
inode ID cannot be reused.)  And that’s something that this series 
already does, so I tend to favor that over parsing mountinfo.

Max

