DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:cc:references:from:subject:message-id:date:user-agent
	:mime-version:in-reply-to:content-transfer-encoding:content-language;
	bh=RdgSvn8KKH8tVJResvMbNG3cZFy/gSzvqilNJM1V0rs=;
	b=D0/lJ4vUQINehqT3fg+EEgtorDXiq3WR6g4uKpuze/NkByiNAQm8AS5iRKVOwflJjW
	ZsRsHIUbrdwhXQ4R942HcYVXu+/oufpYee/B56TVqkNX7dKZ76UZtJiYHsDTs9RTZwrZ
	G/NaFTh9NUIHfKRPM4Es/vm32e89D9hNgIUhKfWwoeh/5Brerbxpx6Nylnf1vNS6aXCw
	HaYQopFrcvNq+VrJcqdhi2x1LL9u4y5YugV0jddGYDGtvLxJTJd0C81C0ORnvBn8BOCZ
	XONADStMxJ+JN4YcUn9CLi54i2GY4FYj6Lu8cp1wWkvEm96YqAh7Vozhgzs6X6ZVe5i/
	K24Q==
References: <0503b244-b426-0779-7b9e-ff63dfa1165c@gmail.com>
	<20201119181635.GA3300@redhat.com>
	<04959049-62bf-c7dc-70b5-aacbc649c474@gmail.com>
	<20201119183841.GB3300@redhat.com> <20201119184436.GC3300@redhat.com>
	<20201119194424.GD3300@redhat.com>
	<d6a20a5e-3da3-b73b-03b6-24eb044c05a6@redhat.com>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <eecb8c4e-9fd9-39ba-024b-c35953e769ef@gmail.com>
Date: Fri, 20 Nov 2020 11:11:28 -0600
MIME-Version: 1.0
In-Reply-To: <d6a20a5e-3da3-b73b-03b6-24eb044c05a6@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] restorcon/SELinux virtiofs question
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: dwalsh@redhat.com, Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com


On 11/20/20 9:01 AM, Daniel Walsh wrote:
> On 11/19/20 14:44, Vivek Goyal wrote:
>> On Thu, Nov 19, 2020 at 01:44:36PM -0500, Vivek Goyal wrote:
>>> On Thu, Nov 19, 2020 at 01:38:41PM -0500, Vivek Goyal wrote:
>>>> On Thu, Nov 19, 2020 at 12:27:20PM -0600, Harry G. Coin wrote:
>>>>> On 11/19/20 12:16 PM, Vivek Goyal wrote:
>>>>>> On Thu, Nov 19, 2020 at 10:52:51AM -0600, Harry G. Coin wrote:
>>>>>>> Hello virtiofs team.Â  I need clarification about a 'restorecon'
>>>>>>> selinux
>>>>>>> guest giving an 'operation not supported' response.
>>>>>>>
>>>>>>> If the host fs is btrfs (with xattr enabled in virtiofsd) but not
>>>>>>> running SELinux,
>>>>>> I suspect that on host setxattr(security.selinux) is failing with
>>>>>> "operation not supported".
>>>>>>
>>>>>> What do you mean by host "not running SELinux". SElinux is not
>>>>>> compiled
>>>>>> in? Or it is disabled or in passive mode?
>>>>>>
>>>>>> Is it working with filesystems other than btrfs, say ext4 or xfs.
>>>>>>
>>>>>> Now qemu supports xattr remapping. You might want to run virtiofsd
>>>>>> to remap security.selinux. I think that might get you going till
>>>>>> the root cause of the issue is found.
>>>>>>
>>>>>> Vivek
>>>>> Thank you for the focus.   The host os in this instance is not
>>>>> from the
>>>>> fedora/rhel/centos world with selinux running.  My case is a debian
>>>>> sourced distro (ubuntu).  That world uses 'apparmor' by default, not
>>>>> selinux.   I think it's reasonable to suppose there are a lot of
>>>>> servers
>>>>> out there not running selinux that have lots of vms running on
>>>>> them, not
>>>>> all using virtiofs.  There should be a documented way to allow the
>>>>> 'restorcon' command on one of many guests on such hosts to work.  I
>>>>> suppose to wrap this up:
>>>>>
>>>>> For the future readers who got here by searching,  could you give the
>>>>> first kernel version that supports a non-selinux host supporting an
>>>>> selinux enabled guest and the virtiofsd command line necessary to get
>>>>> the restorecon command to work normally?
>>>> I don't know yet. Because I don't know what's the root cause of the
>>>> issue.
>>>>
>>>> The way you are explaining it, looks like host kernel somehow is
>>>> blocking setxattr(security.selinux). And I have no idea why. Is it
>>>> apparmor or something else.
>>>>
>>>> If no selinux module is loaded on host, then as long as virtiofsd
>>>> process has CAP_SYS_ADMIN, it should be able to set security.selinux.
>>>>
>>>> "Operation not supported" means error "EOPNOTSUP". I am assuming
>>>> you are running virtiofsd with "-o xattr" to make sure virtiofsd
>>>> supports xattr. If that's the case somehow kernel is returning
>>>> "EOPNOTSUP".
>>>>
>>>> Can you run virtiofsd with debug option -d and try to install that
>>>> package in guest and capture outout of virtiofsd and post here. It
>>>> might confirm that host kernel is returning error.
>>> I tried doing "chcon unconfined_u:object_r:admin_home_t:s0 bar.txt"
>>> on a file in virtiofs and got "Operation not supported". I think
>>> guest kernel failed this. Will need to debug further.
>> Ok, Dan Walsh says that it probably is due to the fact that selinux
>> policy in guest is not aware of virtiofs. He has opened a PR to
>> add that.
>>
>> https://github.com/fedora-selinux/selinux-policy/pull/478
>>
>> I am not sure what distribution you are running as guest but it
>> probably will require similar changes. Once this package is built
>> I will give it a try.
>>
>> Thanks
>> Vivek
>
> Correct. The Guest OS Has to have SELinux enabled and the virtiofs
> file system within the VM
>
> needs to have SELinux policy that says it support labeling on Xattrs. 
> Otherwise when you attempt
>
> to set labels on the file system.  SELinux in side of the kernel will
> say that virtiofs does not support
>
> SELinux labels, which is what you are seeing.
>
It is the advertising and presumption of those using 'virtual machines'
that they are 'runnable' on any host.  If I read the above correctly,
because there's no telling which of the hundreds of packages in the
fedora/centos/rhel world will fail on built-in restorecon calls,
virtiofs is now excluded for general use except on SELinux enabled hosts
.    There are, (cough) a fair few hosts out there which are not running
SElinux, whose operators hope/need to provide vm guest services to the
fedora/rhel/centos package users.  So, I ask the virtiofs folks to
consider creating or defining an option allowing fedora/rhel/centos
guests a way to succeed.  Or, in the alternative, a clear warning that
virtiofs is not a good choice for  rhel/centos/fedora guests on other
than rhel/centos/fedora bare-metal requiring selinux enabled.

HC





