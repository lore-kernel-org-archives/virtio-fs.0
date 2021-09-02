DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
	t=1630608919; bh=0WOeJpk/zazIMthMyub2nCD0LfMvutspgWyuKpVKBQ8=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To;
	b=dm+1+cFX1mXKPPvenxSl5lSM0hXw7HZgEyBytyO34ugBwSbNWHENw/W4vnj3js5wy+ZFRFYxdZ7wQlgyfU60mRCp23Qa/ASY9c37dTfG6yVSjVBzy8eZSOJY24IRDDOCbYMRtsZUqVNi7TGXSFhM5UDi0b5HiTzoVo1UnUEYmRn9zYF6sBxaoNLe6SvQT5Lhn9E93PHm8ZzcgH7nOQszLR2rsgf4lQehRlUm9S3uMzyf7zAdFgXyFiOO0LP5U4efKRDmjiccgAGpM5gcIudCct6lyrs+VgfnqHIJ1Q204VQT+NkMrv0loFCvrWnHA+G2E85ziU4BkbkUQpnGYjgPGQ==
References: <20210902152228.665959-1-vgoyal@redhat.com>
	<79dcd300-a441-cdba-e523-324733f892ca@schaufler-ca.com>
	<YTEEPZJ3kxWkcM9x@redhat.com> <YTENEAv6dw9QoYcY@redhat.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <3bca47d0-747d-dd49-a03f-e0fa98eaa2f7@schaufler-ca.com>
Date: Thu, 2 Sep 2021 11:55:11 -0700
MIME-Version: 1.0
In-Reply-To: <YTENEAv6dw9QoYcY@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v3 0/1] Relax restrictions on user.* xattr
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: gscrivan@redhat.com, tytso@mit.edu, agruenba@redhat.com, miklos@szeredi.hu, selinux@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>, stephen.smalley.work@gmail.com, david@fromorbit.com, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, casey.schaufler@intel.com, linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, bfields@redhat.com, christian.brauner@ubuntu.com

On 9/2/2021 10:42 AM, Vivek Goyal wrote:
> On Thu, Sep 02, 2021 at 01:05:01PM -0400, Vivek Goyal wrote:
>> On Thu, Sep 02, 2021 at 08:43:50AM -0700, Casey Schaufler wrote:
>>> On 9/2/2021 8:22 AM, Vivek Goyal wrote:
>>>> Hi,
>>>>
>>>> This is V3 of the patch. Previous versions were posted here.
>>>>
>>>> v2:
>>>> https://lore.kernel.org/linux-fsdevel/20210708175738.360757-1-vgoyal@redhat.com/
>>>> v1:
>>>> https://lore.kernel.org/linux-fsdevel/20210625191229.1752531-1-vgoyal@redhat.co
>>>> +m/
>>>>
>>>> Changes since v2
>>>> ----------------
>>>> - Do not call inode_permission() for special files as file mode bits
>>>>   on these files represent permissions to read/write from/to device
>>>>   and not necessarily permission to read/write xattrs. In this case
>>>>   now user.* extended xattrs can be read/written on special files
>>>>   as long as caller is owner of file or has CAP_FOWNER.
>>>>  
>>>> - Fixed "man xattr". Will post a patch in same thread little later. (J.
>>>>   Bruce Fields)
>>>>
>>>> - Fixed xfstest 062. Changed it to run only on older kernels where
>>>>   user extended xattrs are not allowed on symlinks/special files. Added
>>>>   a new replacement test 648 which does exactly what 062. Just that
>>>>   it is supposed to run on newer kernels where user extended xattrs
>>>>   are allowed on symlinks and special files. Will post patch in 
>>>>   same thread (Ted Ts'o).
>>>>
>>>> Testing
>>>> -------
>>>> - Ran xfstest "./check -g auto" with and without patches and did not
>>>>   notice any new failures.
>>>>
>>>> - Tested setting "user.*" xattr with ext4/xfs/btrfs/overlay/nfs
>>>>   filesystems and it works.
>>>>  
>>>> Description
>>>> ===========
>>>>
>>>> Right now we don't allow setting user.* xattrs on symlinks and special
>>>> files at all. Initially I thought that real reason behind this
>>>> restriction is quota limitations but from last conversation it seemed
>>>> that real reason is that permission bits on symlink and special files
>>>> are special and different from regular files and directories, hence
>>>> this restriction is in place. (I tested with xfs user quota enabled and
>>>> quota restrictions kicked in on symlink).
>>>>
>>>> This version of patch allows reading/writing user.* xattr on symlink and
>>>> special files if caller is owner or priviliged (has CAP_FOWNER) w.r.t inode.
>>> This part of your project makes perfect sense. There's no good
>>> security reason that you shouldn't set user.* xattrs on symlinks
>>> and/or special files.
>>>
>>> However, your virtiofs use case is unreasonable.
>> Ok. So we can merge this patch irrespective of the fact whether virtiofs
>> should make use of this mechanism or not, right?

I don't see a security objection. I did see that Andreas Gruenbacher
<agruenba@redhat.com> has objections to the behavior.


>>>> Who wants to set user.* xattr on symlink/special files
>>>> -----------------------------------------------------
>>>> I have primarily two users at this point of time.
>>>>
>>>> - virtiofs daemon.
>>>>
>>>> - fuse-overlay. Giuseppe, seems to set user.* xattr attrs on unpriviliged
>>>>   fuse-overlay as well and he ran into similar issue. So fuse-overlay
>>>>   should benefit from this change as well.
>>>>
>>>> Why virtiofsd wants to set user.* xattr on symlink/special files
>>>> ----------------------------------------------------------------
>>>> In virtiofs, actual file server is virtiosd daemon running on host.
>>>> There we have a mode where xattrs can be remapped to something else.
>>>> For example security.selinux can be remapped to
>>>> user.virtiofsd.securit.selinux on the host.
>>> As I have stated before, this introduces a breach in security.
>>> It allows an unprivileged process on the host to manipulate the
>>> security state of the guest. This is horribly wrong. It is not
>>> sufficient to claim that the breach requires misconfiguration
>>> to exploit. Don't do this.
>> So couple of things.
>>
>> - Right now whole virtiofs model is relying on the fact that host
>>   unpriviliged users don't have access to shared directory. Otherwise
>>   guest process can simply drop a setuid root binary in shared directory
>>   and unpriviliged process can execute it and take over host system.
>>
>>   So if virtiofs makes use of this mechanism, we are well with-in
>>   the existing constraints. If users don't follow the constraints,
>>   bad things can happen.
>>
>> - I think Smalley provided a solution for your concern in other thread
>>   we discussed this issue.
>>
>>   https://lore.kernel.org/selinux/CAEjxPJ4411vL3+Ab-J0yrRTmXoEf8pVR3x3CSRgPjfzwiUcDtw@mail.gmail.com/T/#mddea4cec7a68c3ee5e8826d650020361030209d6
>>
>>
>>   "So for example if the host policy says that only virtiofsd can set
>> attributes on those files, then the guest MAC labels along with all
>> the other attributes are protected against tampering by any other
>> process on the host."

You can't count on SELinux policy to address the issue on a
system running Smack. Or any other user of system.* xattrs,
be they in the kernel or user space. You can't even count on
SELinux policy to be correct. virtiofs has to present a "safe"
situation regardless of how security.* xattrs are used and
regardless of which, if any, LSMs are configured. You can't
do that with user.* attributes.


>>
>>  Apart from hiding the shared directory from unpriviliged processes,
>>  we could design selinux policy in such a way that only virtiofsd
>>  is allowed "setattr". That should make sure even in case of
>>  misconfiguration, unprivileged process is not able to change
>>  guest security xattrs stored in "user.virtiofs.security.selinux".
>>
>>  I think that sounds like a very reasonable proposition.
>>
>>>> This remapping is useful when SELinux is enabled in guest and virtiofs
>>>> as being used as rootfs. Guest and host SELinux policy might not match
>>>> and host policy might deny security.selinux xattr setting by guest
>>>> onto host. Or host might have SELinux disabled and in that case to
>>>> be able to set security.selinux xattr, virtiofsd will need to have
>>>> CAP_SYS_ADMIN (which we are trying to avoid).
>>> Adding this mapping to virtiofs provides the breach for any
>>> LSM using xattrs.
>> I think both the points above answer this as well.
>>
>>>>  Being able to remap
>>>> guest security.selinux (or other xattrs) on host to something else
>>>> is also better from security point of view.
>>>>
>>>> But when we try this, we noticed that SELinux relabeling in guest
>>>> is failing on some symlinks. When I debugged a little more, I
>>>> came to know that "user.*" xattrs are not allowed on symlinks
>>>> or special files.
>>>>
>>>> So if we allow owner (or CAP_FOWNER) to set user.* xattr, it will
>>>> allow virtiofs to arbitrarily remap guests's xattrs to something
>>>> else on host and that solves this SELinux issue nicely and provides
>>>> two SELinux policies (host and guest) to co-exist nicely without
>>>> interfering with each other.
>>> virtiofs could use security.* or system.* xattrs instead of user.*
>>> xattrs. Don't use user.* xattrs.
>> So requirement is that every layer (host, guest and nested guest), will
>> have a separate security.selinux label and virtiofsd should be able
>> to retrieve/set any of the labels depending on access.
>>
>> How do we achieve that with single security.selinux label per inode on host.
> I guess we could think of using trusted.* but that requires CAP_SYS_ADMIN
> in init_user_ns. And we wanted to retain capability to run virtiofsd
> inside user namespace too. Also we wanted to give minimum required
> capabilities to virtiofsd to reduce the risk what if virtiofsd gets
> compromised. So amount of damage it can do to system is minimum.
>
> So guest security.selinux xattr could potentially be mapped to.
>
> trusted.virtiofs.security.selinux
>
> nested guest selinux xattrs could be mapped to.
>
> trusted.virtiofs.trusted.virtiofs.security.selinux
>
> And given reading/setting trusted.* requires CAP_SYS_ADMIN, that means
> unpriviliged processes can't change these security attributes of a
> file.
>
> And trade-off is that virtiofsd process needs to be given CAP_SYS_ADMIN.
>
> Frankly speaking, we are more concerned about the security of host
> system (as opposed to something changing in file for guest). So while
> using "trusted.*" is still an option, I would think that not running
> virtiofsd with CAP_SYS_ADMIN probably has its advantages too. On host
> if we can just hide the shared dir from unpriviliged processes then
> we get best of both the worlds. Unpriviliged processes can't change
> anything on the shared file at the same time, possible damage by
> virtiofsd is less if it gets compromised.
>
> Thanks
> Vivek
>


