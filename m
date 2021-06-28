DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
	t=1624902069; bh=qmoxYEMA7LrB3a7Ujqu2HpPAZip17EtNOkikOqYyUXM=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To;
	b=puC017rPoaQSKQncK74VMjTF/nd9njh2rVHZHyYh/1lCEp5iJU8FpYhM7FGMGHQoE2rXqtiy/Ka9UnCk85cw+MdihmiUWhCM3zNBHi9d1j88cbn0setwLnif2fRo5FB+FLDu3110Bygw0jeHA5iTrFfypbVkZvXco0unBltI21iZckkF9xKKqqzPg+WBtOQD28WU6Q4OxOSSxO9CIVUBuDjO98gMZ8FD9H/OvG4Ir6rs5hztkjCGelk2FY3SMZiMPd63UUH6MGvF22bS9ehsLhsz4pMN28LpBeo7sOwKsyaPubgPbqe9eXya8iU8Ecss6ocfTOZ9nW4U9TDnwIYJyg==
References: <20210625191229.1752531-1-vgoyal@redhat.com>
	<BN0PR11MB57275823CE05DED7BC755460FD069@BN0PR11MB5727.namprd11.prod.outlook.com>
	<20210628131708.GA1803896@redhat.com>
	<1b446468-dcf8-9e21-58d3-c032686eeee5@redhat.com>
	<5d8f033c-eba2-7a8b-f19a-1005bbb615ea@schaufler-ca.com>
	<YNn4p+Zn444Sc4V+@work-vm>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <a13f2861-7786-09f4-99a8-f0a5216d0fb1@schaufler-ca.com>
Date: Mon, 28 Jun 2021 10:41:04 -0700
MIME-Version: 1.0
In-Reply-To: <YNn4p+Zn444Sc4V+@work-vm>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [RFC PATCH 0/1] xattr: Allow user.* xattr on
 symlink/special files if caller has CAP_SYS_RESOURCE
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: "berrange@redhat.com" <berrange@redhat.com>, "selinux@vger.kernel.org" <selinux@vger.kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "Schaufler,
	Casey" <casey.schaufler@intel.com>, Vivek Goyal <vgoyal@redhat.com>

On 6/28/2021 9:28 AM, Dr. David Alan Gilbert wrote:
> * Casey Schaufler (casey@schaufler-ca.com) wrote:
>> On 6/28/2021 6:36 AM, Daniel Walsh wrote:
>>> On 6/28/21 09:17, Vivek Goyal wrote:
>>>> On Fri, Jun 25, 2021 at 09:49:51PM +0000, Schaufler, Casey wrote:
>>>>>> -----Original Message-----
>>>>>> From: Vivek Goyal <vgoyal@redhat.com>
>>>>>> Sent: Friday, June 25, 2021 12:12 PM
>>>>>> To: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
>>>>>> viro@zeniv.linux.org.uk
>>>>>> Cc: virtio-fs@redhat.com; dwalsh@redhat.com; dgilbert@redhat.com;
>>>>>> berrange@redhat.com; vgoyal@redhat.com
>>>>> Please include Linux Security Module list <linux-security-module@vger.kernel.org>
>>>>> and selinux@vger.kernel.org on this topic.
>>>>>
>>>>>> Subject: [RFC PATCH 0/1] xattr: Allow user.* xattr on symlink/special files if
>>>>>> caller has CAP_SYS_RESOURCE
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> In virtiofs, actual file server is virtiosd daemon running on host.
>>>>>> There we have a mode where xattrs can be remapped to something else.
>>>>>> For example security.selinux can be remapped to
>>>>>> user.virtiofsd.securit.selinux on the host.
>>>>> This would seem to provide mechanism whereby a user can violate
>>>>> SELinux policy quite easily.
>>>> Hi Casey,
>>>>
>>>> As david already replied, we are not bypassing host's SELinux policy (if
>>>> there is one). We are just trying to provide a mode where host and
>>>> guest's SELinux policies could co-exist without interefering
>>>> with each other.
>>>>
>>>> By remappming guests SELinux xattrs (and not host's SELinux xattrs),
>>>> a file probably will have two xattrs
>>>>
>>>> "security.selinux" and "user.virtiofsd.security.selinux". Host will
>>>> enforce SELinux policy based on security.selinux xattr and guest
>>>> will see the SELinux info stored in "user.virtiofsd.security.selinux"
>>>> and guest SELinux policy will enforce rules based on that.
>>>> (user.virtiofsd.security.selinux will be remapped to "security.selinux"
>>>> when guest does getxattr()).
>>>>
>>>> IOW, this mode is allowing both host and guest SELinux policies to
>>>> co-exist and not interefere with each other. (Remapping guests's
>>>> SELinux xattr is not changing hosts's SELinux label and is not
>>>> bypassing host's SELinux policy).
>>>>
>>>> virtiofsd also provides for the mode where if guest process sets
>>>> SELinux xattr it shows up as security.selinux on host. But now we
>>>> have multiple issues. There are two SELinux policies (host and guest)
>>>> which are operating on same lable. And there is a very good chance
>>>> that two have not been written in such a way that they work with
>>>> each other. In fact there does not seem to exist a notion where
>>>> two different SELinux policies are operating on same label.
>>>>
>>>> At high level, this is in a way similar to files created on
>>>> virtio-blk devices. Say this device is backed by a foo.img file
>>>> on host. Now host selinux policy will set its own label on
>>>> foo.img and provide access control while labels created by guest
>>>> are not seen or controlled by host's SELinux policy. Only guest
>>>> SELinux policy works with those labels.
>>>>
>>>> So this is similar kind of attempt. Provide isolation between
>>>> host and guests's SELinux labels so that two policies can
>>>> co-exist and not interfere with each other.
>>>>
>>>>>> This remapping is useful when SELinux is enabled in guest and virtiofs
>>>>>> as being used as rootfs. Guest and host SELinux policy might not match
>>>>>> and host policy might deny security.selinux xattr setting by guest
>>>>>> onto host. Or host might have SELinux disabled and in that case to
>>>>>> be able to set security.selinux xattr, virtiofsd will need to have
>>>>>> CAP_SYS_ADMIN (which we are trying to avoid). Being able to remap
>>>>>> guest security.selinux (or other xattrs) on host to something else
>>>>>> is also better from security point of view.
>>>>> Can you please provide some rationale for this assertion?
>>>>> I have been working with security xattrs longer than anyone
>>>>> and have trouble accepting the statement.
>>>> If guest is not able to interfere or change host's SELinux labels
>>>> directly, it sounded better.
>>>>
>>>> Irrespective of this, my primary concern is that to allow guest
>>>> VM to be able to use SELinux seamlessly in diverse host OS
>>>> environments (typical of cloud deployments). And being able to
>>>> provide a mode where host and guest's security labels can
>>>> co-exist and policies can work independently, should be able
>>>> to achieve that goal.
>>>>
>>>>>> But when we try this, we noticed that SELinux relabeling in guest
>>>>>> is failing on some symlinks. When I debugged a little more, I
>>>>>> came to know that "user.*" xattrs are not allowed on symlinks
>>>>>> or special files.
>>>>>>
>>>>>> "man xattr" seems to suggest that primary reason to disallow is
>>>>>> that arbitrary users can set unlimited amount of "user.*" xattrs
>>>>>> on these files and bypass quota check.
>>>>>>
>>>>>> If that's the primary reason, I am wondering is it possible to relax
>>>>>> the restrictions if caller has CAP_SYS_RESOURCE. This capability
>>>>>> allows caller to bypass quota checks. So it should not be
>>>>>> a problem atleast from quota perpective.
>>>>>>
>>>>>> That will allow me to give CAP_SYS_RESOURCE to virtiofs deamon
>>>>>> and remap xattrs arbitrarily.
>>>>> On a Smack system you should require CAP_MAC_ADMIN to remap
>>>>> security. xattrs. I sounds like you're in serious danger of running afoul
>>>>> of LSM attribute policy on a reasonable general level.
>>>> I think I did not explain xattr remapping properly and that's why this
>>>> confusion is there. Only guests's xattrs will be remapped and not
>>>> hosts's xattr. So one can not bypass any access control implemented
>>>> by any of the LSM on host.
>>>>
>>>> Thanks
>>>> Vivek
>>>>
>>> I want to point out that this solves a  couple of other problems also. 
>> I am not (usually) adverse to solving problems. My concern is with
>> regard to creating new ones.
>>
>>> Currently virtiofsd attempts to write security attributes on the host, which is denied by default on systems without SELinux and no CAP_SYS_ADMIN.
>> Right. Which is as it should be.
>> Also, s/SELinux/a LSM that uses security xattrs/
>>
>>>   This means if you want to run a container or VM
>> A container uses the kernel from the host. A VM uses the kernel
>> from the guest. Unless you're calling a VM a container for
>> marketing purposes. If this scheme works for non-VM based containers
>> there's a problem.
> And 'kata' is it's own kernel, but more like a container runtime - would
> you like to call this a VM or a container?

I would call it a VM.

On the other hand, there has been a concerted effort to ensure that there
is no technical definition of a container. I hope to exploit this for
personal wealth and glory before too long myself. If kata wants to identify
as a container, who am I to say otherwise?

> There's whole bunch of variations people are playing around with; I don't
> think there's a single answer, or a single way people are trying to use
> it.

Just so.

>>> on a host without SELinux support but the VM has SELinux enabled, then virtiofsd needs CAP_SYS_ADMIN.  It would be much more secure if it only needed CAP_SYS_RESOURCE.
>> I don't know, so I'm asking. Does virtiofsd really get run with limited capabilities,
>> or does it get run as root like most system daemons? If it runs as root the argument
>> has no legs.
> It's typically run without CAP_SYS_ADMIN; (although we have other
> problems, like wanting to use file handles that make caps tricky).
> Some people are trying to run it in user namespaces.
> Given that it's pretty complex and playing with lots of file syscalls
> under partial control of the guest, giving it as few capabilities
> as possible is my preference.

It would be mine as well. I expect/fear that many developers find
capabilities too complicated to work with and drop back to good old
fashioned root. The whole rationale for user namespaces seems to be
that it makes running as root in the namespace "safe".

>>>   If the host has SELinux enabled then it can run without CAP_SYS_ADMIN or CAP_SYS_RESOURCE, but it will only be allowed to write labels that the host system understands, any label not understood will be blocked. Not only this, but the label that is running virtiofsd pretty much has to run as unconfined, since it could be writing any SELinux label.
>> You could fix that easily enough by teaching SELinux about the proper
>> use of CAP_MAC_ADMIN. Alas, I understand that there's no way that's
>> going to happen, and why it would be considered philosophically repugnant
>> in the SELinux community. 
>>
>>> If virtiofsd is writing Userxattrs with CAP_SYS_RESOURCE, then we can run with a confined SELinux label only allowing it to sexattr on the content in the designated directory, make the container/vm much more secure.
>>>
>> User xattrs are less protected than security xattrs. You are exposing the
>> security xattrs on the guest to the possible whims of a malicious, unprivileged
>> actor on the host. All it needs is the right UID.
> Yep, we realise that; but when you're mainly interested in making sure
> the guest can't attack the host, that's less worrying.

That's uncomfortable.

> It would be lovely if there was something more granular, (e.g. allowing
> user.NUMBER. or trusted.NUMBER. to be used by this particular guest).

We can't do that without breaking the "kernels aren't container aware"
mandate. I suppose that if someone wanted to implement xattr namespaces
(like user namespaces, not just the prefix) you could get away with that.
Namespaces for everything. :)

>> We have unused xattr namespaces. Would using the "trusted" namespace
>> work for your purposes?
> For those with CAP_SYS_ADMIN I guess.
>
> Note the virtiofsd takes an option allowing you to set the mapping
> however you like, so there's no hard coded user. or trusted. in the
> daemon itself.
>
> Dave
>
>>


