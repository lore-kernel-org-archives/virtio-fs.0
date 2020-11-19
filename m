DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:cc:references:from:subject:message-id:date:user-agent
	:mime-version:in-reply-to:content-transfer-encoding:content-language;
	bh=wCFBPZCQh+/VX15auEqYM6wjdi8vV+E0fNy/fnxo7do=;
	b=EBVhRnR/ThiR8M1OlxyStwZD/fldy1SaEtnfQg2AnJGffrRHGC9Xp8jxj4s97cpnff
	m68kmoa7DSNgZCkLPSK+r1cAl4Eed9VjIHyFmoqJx5Sm9S1rc+oaVFU6w1TjGv6nRJL5
	ZG03jwMzLH2zuYN1cAGp3WK7KiCbyQcxk385rLJXMOW5akdHYOVqYM7bjsv8nfXIE9ek
	g+ZARj/cskqlSuis+RMFgimGa4fX+MoLbyBufkQcqy0DV6DsxVf/jOxmtVj6xJbuLwVb
	fV8XFodDNWXCRVGuAt64vyI1WJ5q0f3hh9JGXmKjk7dPS2mcAYzlAvNZ9wgMd0JoV2CV
	+j/Q==
References: <0503b244-b426-0779-7b9e-ff63dfa1165c@gmail.com>
	<20201119181635.GA3300@redhat.com>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <04959049-62bf-c7dc-70b5-aacbc649c474@gmail.com>
Date: Thu, 19 Nov 2020 12:27:20 -0600
MIME-Version: 1.0
In-Reply-To: <20201119181635.GA3300@redhat.com>
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com


On 11/19/20 12:16 PM, Vivek Goyal wrote:
> On Thu, Nov 19, 2020 at 10:52:51AM -0600, Harry G. Coin wrote:
>> Hello virtiofs team.Â  I need clarification about a 'restorecon' selinux
>> guest giving an 'operation not supported' response.
>>
>> If the host fs is btrfs (with xattr enabled in virtiofsd) but not
>> running SELinux,
> I suspect that on host setxattr(security.selinux) is failing with 
> "operation not supported". 
>
> What do you mean by host "not running SELinux". SElinux is not compiled
> in? Or it is disabled or in passive mode?
>
> Is it working with filesystems other than btrfs, say ext4 or xfs.
>
> Now qemu supports xattr remapping. You might want to run virtiofsd
> to remap security.selinux. I think that might get you going till
> the root cause of the issue is found.
>
> Vivek

Thank you for the focus.   The host os in this instance is not from the
fedora/rhel/centos world with selinux running.  My case is a debian
sourced distro (ubuntu).  That world uses 'apparmor' by default, not
selinux.   I think it's reasonable to suppose there are a lot of servers
out there not running selinux that have lots of vms running on them, not
all using virtiofs.  There should be a documented way to allow the
'restorcon' command on one of many guests on such hosts to work.  I
suppose to wrap this up:

For the future readers who got here by searching,  could you give the
first kernel version that supports a non-selinux host supporting an
selinux enabled guest and the virtiofsd command line necessary to get
the restorecon command to work normally?

Thanks in advance!!  (And thanks for the work -- can't wait for dax to
make it into standard kernels!!)

Harry Coin




>
>> and the guest has virtiofs root with selinux active,
>> what version [if any] for virtiofs is necessary before I can expect the
>> restorecon command to operate properly?Â  (Or, maybe I've missed a config
>> setting somewhere?)Â 
>>
>> Packages such as freeipa fail to install because they issue dozens of
>> 'restorecon' calls which fail using virtiofs.
>>
>> Thanks,
>>
>> Harry Coin
>>
>>
>>
>>
>> _______________________________________________
>> Virtio-fs mailing list
>> Virtio-fs@redhat.com
>> https://www.redhat.com/mailman/listinfo/virtio-fs


