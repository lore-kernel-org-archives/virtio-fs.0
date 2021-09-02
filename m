DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
	t=1630610403; bh=5g1XEZzAWFktTaX29oZVU313MlCGCdyLEEo/HSTsE48=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To;
	b=qW949QlTlna5+NG2mn2w6JJdRr++EbWB3Kk++WWPtBbKAueU3SEgoJ1BPpQZUYiFsXI86t55rrgnpx//DQ9fUtifxzNtl0fknUAsdsE2fA3PmLFvBisBiakeU4DHccpu0HTiIazoVZqBVmFXDSZDK0LIUwupeGVk0P26hibC5Y9adszDLSgbNNnUtRucKcTZdsMWnLCoAE186Cke0zPKX0Ba3VMaiZE2Xr/ww+nVRU2KKDKTxgceSnkWJhqWSYvOvo4J3E4rqUIfEHhex6wryqi22cfqq/piv1hfhy65041MQR1UUP6gHt6BoWS6YI11k1zBuV2EpavezaM/W7h52w==
References: <20210902152228.665959-1-vgoyal@redhat.com>
	<CAHc6FU4foW+9ZwTRis3DXSJSMAvdb4jXcq7EFFArYgX7FQ1QYg@mail.gmail.com>
	<YTEcYkAA2F1FhOvF@redhat.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <12b37acc-401a-4d44-085f-8f51077a0d10@schaufler-ca.com>
Date: Thu, 2 Sep 2021 12:19:54 -0700
MIME-Version: 1.0
In-Reply-To: <YTEcYkAA2F1FhOvF@redhat.com>
Content-Type: text/plain; charset="utf-8"
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
To: Vivek Goyal <vgoyal@redhat.com>, Andreas Gruenbacher <agruenba@redhat.com>
Cc: gscrivan@redhat.com, Theodore Ts'o <tytso@mit.edu>, Miklos Szeredi <miklos@szeredi.hu>, selinux@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>, stephen.smalley.work@gmail.com, Dave Chinner <david@fromorbit.com>, LKML <linux-kernel@vger.kernel.org>, virtio-fs@redhat.com, casey.schaufler@intel.com, LSM <linux-security-module@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Fields,
	Bruce" <bfields@redhat.com>, christian.brauner@ubuntu.com

On 9/2/2021 11:48 AM, Vivek Goyal wrote:
> On Thu, Sep 02, 2021 at 07:52:41PM +0200, Andreas Gruenbacher wrote:
>> Hi,
>>
>> On Thu, Sep 2, 2021 at 5:22 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>>> This is V3 of the patch. Previous versions were posted here.
>>>
>>> v2: https://lore.kernel.org/linux-fsdevel/20210708175738.360757-1-vgoyal@redhat.com/
>>> v1: https://lore.kernel.org/linux-fsdevel/20210625191229.1752531-1-vgoyal@redhat.com/
>>>
>>> Changes since v2
>>> ----------------
>>> - Do not call inode_permission() for special files as file mode bits
>>>   on these files represent permissions to read/write from/to device
>>>   and not necessarily permission to read/write xattrs. In this case
>>>   now user.* extended xattrs can be read/written on special files
>>>   as long as caller is owner of file or has CAP_FOWNER.
>>>
>>> - Fixed "man xattr". Will post a patch in same thread little later. (J.
>>>   Bruce Fields)
>>>
>>> - Fixed xfstest 062. Changed it to run only on older kernels where
>>>   user extended xattrs are not allowed on symlinks/special files. Added
>>>   a new replacement test 648 which does exactly what 062. Just that
>>>   it is supposed to run on newer kernels where user extended xattrs
>>>   are allowed on symlinks and special files. Will post patch in
>>>   same thread (Ted Ts'o).
>>>
>>> Testing
>>> -------
>>> - Ran xfstest "./check -g auto" with and without patches and did not
>>>   notice any new failures.
>>>
>>> - Tested setting "user.*" xattr with ext4/xfs/btrfs/overlay/nfs
>>>   filesystems and it works.
>>>
>>> Description
>>> ===========
>>>
>>> Right now we don't allow setting user.* xattrs on symlinks and special
>>> files at all. Initially I thought that real reason behind this
>>> restriction is quota limitations but from last conversation it seemed
>>> that real reason is that permission bits on symlink and special files
>>> are special and different from regular files and directories, hence
>>> this restriction is in place. (I tested with xfs user quota enabled and
>>> quota restrictions kicked in on symlink).
>>>
>>> This version of patch allows reading/writing user.* xattr on symlink and
>>> special files if caller is owner or priviliged (has CAP_FOWNER) w.r.t inode.
>> the idea behind user.* xattrs is that they behave similar to file
>> contents as far as permissions go. It follows from that that symlinks
>> and special files cannot have user.* xattrs. This has been the model
>> for many years now and applications may be expecting these semantics,
>> so we cannot simply change the behavior. So NACK from me.
> Directories with sticky bit break this general rule and don't follow
> permission bit model.

The sticky bit is a hack. It was introduced to stave off proposed
implementations of Access Control Lists, which it did successfully
for quite some time.

> man xattr says.
>
> *****************************************************************
> and access to user extended  attributes  is  re‐
>        stricted  to  the  owner and to users with appropriate capabilities for
>        directories with the sticky bit set
> ******************************************************************
>
> So why not allow similar exceptions for symlinks and device files.

Limiting exceptions is usually a good thing. If every system mechanism
devolves into a heap of special cases it becomes very difficult to
describe your system semantics or the system security model. 

> I can understand the concern about behavior change suddenly and
> applications being surprised. If that's the only concern we could
> think of making user opt-in for this new behavior based on a kernel
> CONFIG, kernel command line or something else.

That doesn't work in the world of distros. But you knew that.


>>> Who wants to set user.* xattr on symlink/special files
>>> -----------------------------------------------------
>>> I have primarily two users at this point of time.
>>>
>>> - virtiofs daemon.
>>>
>>> - fuse-overlay. Giuseppe, seems to set user.* xattr attrs on unpriviliged
>>>   fuse-overlay as well and he ran into similar issue. So fuse-overlay
>>>   should benefit from this change as well.
>>>
>>> Why virtiofsd wants to set user.* xattr on symlink/special files
>>> ----------------------------------------------------------------
>>> In virtiofs, actual file server is virtiosd daemon running on host.
>>> There we have a mode where xattrs can be remapped to something else.
>>> For example security.selinux can be remapped to
>>> user.virtiofsd.securit.selinux on the host.
>>>
>>> This remapping is useful when SELinux is enabled in guest and virtiofs
>>> as being used as rootfs. Guest and host SELinux policy might not match
>>> and host policy might deny security.selinux xattr setting by guest
>>> onto host. Or host might have SELinux disabled and in that case to
>>> be able to set security.selinux xattr, virtiofsd will need to have
>>> CAP_SYS_ADMIN (which we are trying to avoid). Being able to remap
>>> guest security.selinux (or other xattrs) on host to something else
>>> is also better from security point of view.
>>>
>>> But when we try this, we noticed that SELinux relabeling in guest
>>> is failing on some symlinks. When I debugged a little more, I
>>> came to know that "user.*" xattrs are not allowed on symlinks
>>> or special files.
>>>
>>> So if we allow owner (or CAP_FOWNER) to set user.* xattr, it will
>>> allow virtiofs to arbitrarily remap guests's xattrs to something
>>> else on host and that solves this SELinux issue nicely and provides
>>> two SELinux policies (host and guest) to co-exist nicely without
>>> interfering with each other.
>> The fact that user.* xattrs don't work in this remapping scenario
>> should have told you that you're doing things wrong; the user.*
>> namespace seriously was never meant to be abused in this way.
> Guest's security label is not be parsed by host kernel. Host kernel
> will have its own security label and will take decisions based on
> that. In that aspect making use of "user.*" xattr seemed to make
> lot of sense

It doesn't make sense. For files, directories or anything. It's
freaking hazardous.

>  and we were wondering why user.* xattr is limited to
> regualr files and directories only and can we change that behavior.
>
>> You may be able to get away with using trusted.* xattrs which support
>> roughly the kind of daemon use I think you're talking about here, but
>> I'm not sure selinux will be happy with labels that aren't fully under
>> its own control. I really wonder why this wasn't obvious enough.
> I guess trusted.* will do same thing. But it requires CAP_SYS_ADMIN
> in init_user_ns.

Right. That's because you're doing dangerous things.

>  And that rules out running virtiofsd unpriviliged

Right. That's because you're doing dangerous things.

> or inside a user namespace. Also it reduces the risk posted by
> virtiofsd on host filesystem due to CAP_SYS_ADMIN. That's why we
> were trying to steer clear of trusted.* xattr space.

Yeah, I get it. What's wrong with admitting that what you're
trying to do is dangerous, and that you have to be careful?

> Also, trusted.* xattr space does not work with NFS.

So, fix that?

>
> $ setfattr -n "trusted.virtiofs" -v "foo" test.txt
> setfattr: test.txt: Operation not supported
>
> We want to be able run virtiofsd over NFS mounted dir too.
>
> So its not that we did not consider trusted.* xattrs. We ran
> into above issues.
>
> Thanks
> Vivek
>


