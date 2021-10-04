DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
	t=1633368978; bh=niPxADPRikeK5rxApUPmsD8xoirqtAp+hVaMB3iQuNM=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To;
	b=t7sbeDKtiDnLJJjTe4nQLwaWm3ggQOUp3uIKp8fsXn8yyJjSj58zfHOf1MN12cwJclIZGyHVRsJajnSUU9HCiYoo1iVZ6ddxmKb2QisX+IdZtbeMiaqW7Ts3WK5l0sXSECb2LNLwY0nOT9sMPR2NTBbF17mhv3STqz+F9s6RggKY1dtpwuHvp/Qt42bIvqQmSmLsTLa8fxxEMkGbVV8pgTFtDf2IkrdvIrmbtBKxnrbbSDikSF4n3GeagqD/Kf7Gefq/1dQR74wJsSu1GqDe1cEzPw2f6dC2WufYb5el3WzqD6E1yQkC+OuT6Bb6V1xE6yjShb7z3lAepbvvfLuzZA==
References: <YVYI/p1ipDFiQ5OR@redhat.com>
	<1583ffb057e8442fa7af40dabcb38960982211ba.camel@kernel.org>
	<06a82de9-1c3e-1102-7738-f40905ea9ee4@schaufler-ca.com>
	<7404892c92592507506038ef9bdcfc1780311000.camel@kernel.org>
	<a7ab4daf-e577-abcc-f4a0-09d7eb9c4cb7@schaufler-ca.com>
	<YVs2P1AcWkQ0Q0wq@redhat.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <ae32818f-95b1-6dce-1738-aac6f184c1c6@schaufler-ca.com>
Date: Mon, 4 Oct 2021 10:36:15 -0700
MIME-Version: 1.0
In-Reply-To: <YVs2P1AcWkQ0Q0wq@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] security: Return xattr name from
 security_dentry_init_security()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: bfields@fieldses.org, linux-nfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, selinux@vger.kernel.org, stephen.smalley.work@gmail.com, Jeff Layton <jlayton@kernel.org>, virtio-fs@redhat.com, Casey Schaufler <casey@schaufler-ca.com>, linux-security-module@vger.kernel.org, chuck.lever@oracle.com, linux-fsdevel@vger.kernel.org, idryomov@gmail.com, ceph-devel@vger.kernel.org

On 10/4/2021 10:13 AM, Vivek Goyal wrote:
> On Mon, Oct 04, 2021 at 09:39:44AM -0700, Casey Schaufler wrote:
>> On 10/4/2021 9:01 AM, Jeff Layton wrote:
>>> On Mon, 2021-10-04 at 08:54 -0700, Casey Schaufler wrote:
>>>> On 10/4/2021 8:20 AM, Jeff Layton wrote:
>>>>> On Thu, 2021-09-30 at 14:59 -0400, Vivek Goyal wrote:
>>>>>> Right now security_dentry_init_security() only supports single security
>>>>>> label and is used by SELinux only. There are two users of of this hook,
>>>>>> namely ceph and nfs.
>>>>>>
>>>>>> NFS does not care about xattr name. Ceph hardcodes the xattr name to
>>>>>> security.selinux (XATTR_NAME_SELINUX).
>>>>>>
>>>>>> I am making changes to fuse/virtiofs to send security label to virtiofsd
>>>>>> and I need to send xattr name as well. I also hardcoded the name of
>>>>>> xattr to security.selinux.
>>>>>>
>>>>>> Stephen Smalley suggested that it probably is a good idea to modify
>>>>>> security_dentry_init_security() to also return name of xattr so that
>>>>>> we can avoid this hardcoding in the callers.
>>>>>>
>>>>>> This patch adds a new parameter "const char **xattr_name" to
>>>>>> security_dentry_init_security() and LSM puts the name of xattr
>>>>>> too if caller asked for it (xattr_name != NULL).
>>>>>>
>>>>>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>>>>>> ---
>>>>>>
>>>>>> I have compile tested this patch. Don't know how to setup ceph and
>>>>>> test it. Its a very simple change. Hopefully ceph developers can
>>>>>> have a quick look at it.
>>>>>>
>>>>>> A similar attempt was made three years back.
>>>>>>
>>>>>> https://lore.kernel.org/linux-security-module/20180626080429.27304-1-zyan@redhat.com/T/
>>>>>> ---
>>>>>>  fs/ceph/xattr.c               |    3 +--
>>>>>>  fs/nfs/nfs4proc.c             |    3 ++-
>>>>>>  include/linux/lsm_hook_defs.h |    3 ++-
>>>>>>  include/linux/lsm_hooks.h     |    1 +
>>>>>>  include/linux/security.h      |    6 ++++--
>>>>>>  security/security.c           |    7 ++++---
>>>>>>  security/selinux/hooks.c      |    6 +++++-
>>>>>>  7 files changed, 19 insertions(+), 10 deletions(-)
>>>>>>
>>>>>> Index: redhat-linux/security/selinux/hooks.c
>>>>>> ===================================================================
>>>>>> --- redhat-linux.orig/security/selinux/hooks.c	2021-09-28 11:36:03.559785943 -0400
>>>>>> +++ redhat-linux/security/selinux/hooks.c	2021-09-30 14:01:05.869195347 -0400
>>>>>> @@ -2948,7 +2948,8 @@ static void selinux_inode_free_security(
>>>>>>  }
>>>>>>  
>>>>> I agree with Al that it would be cleaner to just return the string, but
>>>>> the call_*_hook stuff makes that a bit more tricky. I suppose this is a
>>>>> reasonable compromise.
>>>> call_int_hook() and call_void_hook() were introduced to reduce the monotonous
>>>> repetition in the source. They are cosmetic and add no real value. They shouldn't
>>>> be a consideration in the discussion.
>>>>
>>>> There is a problem with Al's suggestion. The interface as used today has two real
>>>> problems. It returns an attribute value without identifying the attribute. Al's
>>>> interface would address this issue. The other problem is that the interface can't
>>>> provide multiple attribute+value pairs. The interface is going to need changed to
>>>> support that for full module stacking. I don't see a rational way to extend the
>>>> interface if it returns a string when there are multiple attributes to choose from.
>>>>
>>> Is that also a problem for the ctx parameter? In the case of full module
>>> stacking do you get back multiple contexts as well?
>> That's a bigger discussion than is probably appropriate on this thread.
>> In the module stacking case the caller needs to identify which security
>> module's context it wants. If the caller is capable of dealing with
>> multiple attributes (none currently are, but they all assume that you're
>> using SELinux and only support what SELinux needs) it will need to
>> do something different. We have chickens and eggs involved. The LSM
>> infrastructure doesn't need to handle it because none of its callers
>> are capable of dealing with it. None of the callers try, in part because
>> they have no way to get the information they would need, and in part
>> because they don't care about anything beyond SELinux. Ceph, for example,
>> is hard coded to expect "security.selinux".
>>
>> On further reflection, Al's suggestion could be made to work if the
>> caller identified which attribute its looking for.
> Or I could just add a parameter "const char *xattr_name" which identifies
> which xattr caller is looking for.  (So no returning the name of xattr).
> And this will simply return "int".
>
> Anyway, all the callers right now only expect "security.selinux". Those
> who can deal with other xattrs, can pass it explicitly.

Labeled NFS was supposed to support Smack as well as SELinux.
To the best of my knowledge no one ever actually got that working.
But is was promised, and there's no obvious reason it shouldn't work.

> I feel current patch is better because caller can check anyway, what
> xattr name it got in return and reject it if it does not want to deal
> with it. No hardcoding of xattr names required.

There are a bunch of LSM hooks that I'd love to rip out and replace
with more rational interfaces. This is one. I doubt I'll have the
opportunity to do that in this lifetime. Any change that works is
OK with me. There's probably some amount of change that will be
necessary in the future, and neither of the proposals on the table
are unworkable.



