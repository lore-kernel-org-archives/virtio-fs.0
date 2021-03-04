Date: Thu, 4 Mar 2021 15:00:30 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210304200030.GG47782@redhat.com>
References: <20210303182027.GA3793@redhat.com>
	<d205a848-845c-bea0-25bf-a10db1f3fafc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d205a848-845c-bea0-25bf-a10db1f3fafc@redhat.com>
Subject: Re: [Virtio-fs] Query about announce_submounts and ro/rw mounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Mar 04, 2021 at 10:02:32AM +0100, Max Reitz wrote:
> On 03.03.21 19:20, Vivek Goyal wrote:
> > Hi Max,
> 
> Hi Vivek,
> 
> > I was playing with "announce_submounts". I have a read-only bind mounted
> > mount point in shared directory. Inside guest, when I step into that
> > directory, I see that a mount point got created but its "rw" and not "ro".
> > 
> > Is that intentional.
> 
> No, that isn’t intentional.  I just didn’t think of sharing such information
> with the guest.
> 
> > Can we send property of mount also to guest when
> > notifying guest about mount point.
> 
> I suppose we can send it (by adding a new flag alongside
> FUSE_ATTR_SUBMOUNT), and we can make the mount ro by setting the SB_RDONLY
> flag in fuse_dentry_automount().
> 
> If we implemented this for RDONLY, are there other flags that we might want
> to consider as well?  (e.g. nodev etc.)

Hi Max,

[ cc miklos ]

I was thinking of same thing. Looks like there lot more attributes of
mount. This is from include/uapi/linux/mount.h

#define MOUNT_ATTR_RDONLY       0x00000001 /* Mount read-only */
#define MOUNT_ATTR_NOSUID       0x00000002 /* Ignore suid and sgid bits */
#define MOUNT_ATTR_NODEV        0x00000004 /* Disallow access to device special files */
#define MOUNT_ATTR_NOEXEC       0x00000008 /* Disallow program execution */
#define MOUNT_ATTR__ATIME       0x00000070 /* Setting on how atime should be updated */
#define MOUNT_ATTR_RELATIME     0x00000000 /* - Update atime relative to mtime/ctime. */
#define MOUNT_ATTR_NOATIME      0x00000010 /* - Do not update access times. */
#define MOUNT_ATTR_STRICTATIME  0x00000020 /* - Always perform atime updates */
#define MOUNT_ATTR_NODIRATIME   0x00000080 /* Do not update directory access times */
#define MOUNT_ATTR_IDMAP        0x00100000 /* Idmap mount to @userns_fd in struct mount_attr. */

So read-only is just one of the attributes. If we propagate all
attributes, then each will use 1 precious bit.


> 
> OTOH, I just tested NFS, and it doesn’t pass through the RO flag:
> 
> [...]
> /tmp/xfs.img on ~/tmp/test-nfs/mount type xfs (ro,...)
> [...]
> 127.0.0.1:~/tmp/test-nfs on /mnt/tmp type nfs4 (rw,...)
> 127.0.0.1:~/tmp/test-nfs/mount on /mnt/tmp/mount type nfs4 (rw,...)
> 
> So is it really important or more a matter of style?

Atleast for read-only it does not seem too important because server
will deny opening file for write and return error to client. So no
big deal.

MOUNT_ATTR_NODEV might not be a problem as well as we will not allow
opening special files on server.

MOUNT_ATTR_NOSUID, MOUNT_ATTR_NOEXEC might matter because I think
guest will not see these flags and will allow setting suid and allow
exec. Server will not know anything about it I think so server can't
deny it. 

And then there are settings with repsect to time update, these wil
not take affect in guest.

Given there are many attributes and each will consume a bit if we
choose to propagate, I would say, we look into it if it becomes
a serious problem. Or just stick to what NFS is doing right now. 
I am assuming they too are not propagating other flags too.

IOW, submounts in virtiofs only help with avoiding file st_dev:inode
pair conflict and rest of the mount properties don't propagate and
don't take affect as of now.

> 
> > Does it make sense? I guess then next problem will be what if mount
> > changes back to "rw" and how to we propagate to guest. IIUC, we will
> > probably need monitor it and send notifications. Or notice this chagne
> > on next lookup.
> 
> Yes, I imagine that would be rather complicated.  Is there a way to monitor
> mount changes?

There are bunch of notification mechanisms (dnotify, inotify, fanotify),
but frankly speaking I am not sure if any of these offer the ability to 
monitor changes to mount properties. I have never looked into this. 

Vivek

