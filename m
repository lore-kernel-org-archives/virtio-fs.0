References: <20210512125544.9536-1-mreitz@redhat.com>
	<20210512125544.9536-2-mreitz@redhat.com>
	<20210602181958.GC115492@redhat.com>
	<CAJfpegtKjx7y8+bMQUivjxHuF0iiLYxKCtd0H3AisVymHHjtTA@mail.gmail.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <497d1ed1-fbd4-0aad-1349-826be8b49834@redhat.com>
Date: Fri, 4 Jun 2021 18:22:28 +0200
MIME-Version: 1.0
In-Reply-To: <CAJfpegtKjx7y8+bMQUivjxHuF0iiLYxKCtd0H3AisVymHHjtTA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH 1/3] virtiofsd: Find original inode ID of
	mount points
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

On 02.06.21 20:59, Miklos Szeredi wrote:
> On Wed, 2 Jun 2021 at 20:20, Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Wed, May 12, 2021 at 02:55:42PM +0200, Max Reitz wrote:
>>> Mount point directories represent two inodes: On one hand, they are a
>>> normal directory on their parent filesystem.  On the other, they are the
>>> root node of the filesystem mounted there.  Thus, they have two inode
>>> IDs.
>>>
>>> Right now, we only report the latter inode ID (i.e. the inode ID of the
>>> mounted filesystem's root node).  This is fine once the guest has
>>> auto-mounted a submount there (so this inode ID goes with a device ID
>>> that is distinct from the parent filesystem), but before the auto-mount,
>>> they have the device ID of the parent and the inode ID for the submount.
>>> This is problematic because this is likely exactly the same
>>> st_dev/st_ino combination as the parent filesystem's root node.  This
>>> leads to problems for example with `find`, which will thus complain
>>> about a filesystem loop if it has visited the parent filesystem's root
>>> node before, and then refuse to descend into the submount.
>>>
>>> There is a way to find the mount directory's original inode ID, and that
>>> is to readdir(3) the parent directory, look for the mount directory, and
>>> read the dirent.d_ino field.  Using this, we can let lookup and
>>> readdirplus return that original inode ID, which the guest will thus
>>> show until the submount is auto-mounted.  (Then, it will invoke getattr
>>> and that stat(2) call will return the inode ID for the submount.)
>> [ CC miklos ]
>>
>> Hi Max,
>>
>> Though we discussed this in chat room, I am still responding to this
>> email with the concern I have, so that there is a record of it.

That sounds scary :)

>> So with this patch for FUSE_LOOKUP  we always return submount's parentinode
>> id and with GETATTR request we return actual inode id of submount. That
>> kind of bothers me a bit as we are assuming that there is always going
>> to be a GETATTR request after FUSE_LOOKUP. FUSE_LOOKUP itself has attrs
>> returned with it and it might happen that after FUSE_LOOKUP, FUSE_GETATTR
>> might not be called at all because FUSE_LOOKUP itself got the latest
>> updated attrs with certain timeout.
>>
>> For example, if I call stat on a normal file (not submount), I see that
>> after FUSE_LOOKUP, no FUSE_GETATTR request is going and
>> fuse_update_get_attr() is using attrs from locally cached inode attrs.
>>
>> But same thing does not seem to be happening in case of submount. Once
>> submount is created in guest, I see that we never seem to be calling
>> ->revalidate() on newly created dentry of submount root. I am not sure
>> why. And that means we don't do FUSE_LOOKUP and that means FUSE_GETATTR
>> always gets called.

Even if it worked reliably, I have to admit it’s kind of relying on at 
most implementation-defined behavior.  Having two inodes would 
definitely be the right solution.

> Yes, this sounds normal.
>
> The lookup sequence for "/mnt/virtiofs/dir1/submount/file" will be:
>
> LOOKUP(1, "dir")
>      create inode I1 in sb1
>      create dentry "dir" with inode I1 in sb1
> LOOKUP(I1, "submount")
>      create inode I2 in sb1, set S_AUTOMOUNT
>      create dentry "submount" with inode I2 in sb1
>      automount triggered:
>      create sb2
>      create inode I2 in sb2
>      create dentry "/" with inode I2 in sb2
> GETATTR(I2)
>       fill inode I2
> LOOKUP(I2, "file")
>       create inode I3
>       create dentry "file" with inode I3 in sb2
>
> Notice how there's two inodes numbered I2, but in separate sb's.
> However the server has only the notion of a single I2 inode which is
> the root of the submount, since the mountpoint is not visible (except
> for d_ino in readdir()).
>
> Now AFAICS what this patch does is set the inode number in the
> attributes returned by LOOKUP(I1, "submount") to the covered inode, so
> that AT_NO_AUTOMOUNT stat will return the correct value.   While this
> seems to work, it's not a fundamental fix to the problem, since the
> attributes on sb1/I2 will time out and the next stat(...,
> AT_NO_AUTOMOUNT) will trigger a GETATTR request, which will return the
> inode number of the submount root.

Ah, yeah.

> Solving this properly would mean that the server would have to
> generate separate nodeid's for the mountpoint and the submount root
> and the protocol would have to be extended so that this information
> could be transferred to the client.

Yes, we’d somehow need to do a separate lookup for the root inode of the 
submount...

> Not sure whether this is worth it or not.

I’m wondering the same.  This series was mostly the result of an 
incidental finding and seeing that getting it to work and do what I want 
seemed to be pretty easy.  Turns out doing something right can never 
really be easy...

But we have already decided that we don’t deem the inode ID problem too 
important (not least considering NFS has the same issue), so fixing it 
is not really top priority.  Maybe I’ll get back to it, but I think for 
now I consider it on the backlog.

Max

