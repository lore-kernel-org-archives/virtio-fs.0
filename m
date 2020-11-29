DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:cc:references:from:subject:message-id:date:user-agent
	:mime-version:in-reply-to:content-transfer-encoding:content-language;
	bh=w0VeM8a+sGPcWJNI6a5Lqp/fB+GnVDpZaRHawCLADhc=;
	b=OBOxNcNm+9mPztYVz8mqJ934N/keaKzESgbgTbLo7JUEgY1uPQifZLVX/oyufmiy9J
	7kuRlajlgHexeCC0hJ0Ty8PvbDbSsgTMdfijc5OHt8682iSCTrsDariWKG/329sPwj7C
	yWYmAa9A/IgaQHLFE9GJQTMM/z6GhHaErKmqIi40fgtKS8Wg41Q3WHZYHcPOp3V+g/Zs
	Xe2Q3TmEDHZVMh8TGp8brNriGBDsM7+lJ8+JpIsKFNrt3Eq9RvI1TYTqfGe8vtudBI7y
	1TcDs3+KRCoYFvJM/LVeqrCpfFjt7tTZGLzSA/zq1QMUVz52kvVaYKlFNWr4b7L0ydAP
	ZPFA==
References: <0503b244-b426-0779-7b9e-ff63dfa1165c@gmail.com>
	<20201119181635.GA3300@redhat.com>
	<04959049-62bf-c7dc-70b5-aacbc649c474@gmail.com>
	<20201119183841.GB3300@redhat.com> <20201119184436.GC3300@redhat.com>
	<20201119194424.GD3300@redhat.com>
	<d6a20a5e-3da3-b73b-03b6-24eb044c05a6@redhat.com>
	<eecb8c4e-9fd9-39ba-024b-c35953e769ef@gmail.com>
	<20201120185557.GC3105@redhat.com>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <34ee3c42-8948-13a7-9c3f-8417bb4e948e@gmail.com>
Date: Sun, 29 Nov 2020 15:41:00 -0600
MIME-Version: 1.0
In-Reply-To: <20201120185557.GC3105@redhat.com>
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


On 11/20/20 12:55 PM, Vivek Goyal wrote:
> On Fri, Nov 20, 2020 at 11:11:28AM -0600, Harry G. Coin wrote:
>> On 11/20/20 9:01 AM, Daniel Walsh wrote:
>>> On 11/19/20 14:44, Vivek Goyal wrote:
>>>> On Thu, Nov 19, 2020 at 01:44:36PM -0500, Vivek Goyal wrote:
>>>>> On Thu, Nov 19, 2020 at 01:38:41PM -0500, Vivek Goyal wrote:
>>>>>> On Thu, Nov 19, 2020 at 12:27:20PM -0600, Harry G. Coin wrote:
>>>>>>> On 11/19/20 12:16 PM, Vivek Goyal wrote:
>>>>>>>> On Thu, Nov 19, 2020 at 10:52:51AM -0600, Harry G. Coin wrote:
>>>>>>>>> Hello virtiofs team.Ã‚Â  I need clarification about a 'restorecon'
>>>>>>>>> selinux
>>>>>>>>> guest giving an 'operation not supported' response.
>>>>>>>>>
>>>>>>>>> If the host fs is btrfs (with xattr enabled in virtiofsd) but not
>>>>>>>>> running SELinux,
>>>>>>>> I suspect that on host setxattr(security.selinux) is failing with
>>>>>>>> "operation not supported".
>>>>>>>>
>>>>>>>> What do you mean by host "not running SELinux". SElinux is not
>>>>>>>> compiled
>>>>>>>> in? Or it is disabled or in passive mode?
>>>>>>>>
>>>>>>>> Is it working with filesystems other than btrfs, say ext4 or xfs.
>>>>>>>>
>>>>>>>> Now qemu supports xattr remapping. You might want to run virtiofsd
>>>>>>>> to remap security.selinux. I think that might get you going till
>>>>>>>> the root cause of the issue is found.
>>>>>>>>
>>>>>>>> Vivek
>>>>>>> Thank you for the focus.Â Â  The host os in this instance is not
>>>>>>> from the
>>>>>>> fedora/rhel/centos world with selinux running.Â  My case is a debian
>>>>>>> sourced distro (ubuntu).Â  That world uses 'apparmor' by default, not
>>>>>>> selinux.Â Â  I think it's reasonable to suppose there are a lot of
>>>>>>> servers
>>>>>>> out there not running selinux that have lots of vms running on
>>>>>>> them, not
>>>>>>> all using virtiofs.Â  There should be a documented way to allow the
>>>>>>> 'restorcon' command on one of many guests on such hosts to work.Â  I
>>>>>>> suppose to wrap this up:
>>>>>>>
>>>>>>> For the future readers who got here by searching,Â  could you give the
>>>>>>> first kernel version that supports a non-selinux host supporting an
>>>>>>> selinux enabled guest and the virtiofsd command line necessary to get
>>>>>>> the restorecon command to work normally?
>>>>>> I don't know yet. Because I don't know what's the root cause of the
>>>>>> issue.
>>>>>>
>>>>>> The way you are explaining it, looks like host kernel somehow is
>>>>>> blocking setxattr(security.selinux). And I have no idea why. Is it
>>>>>> apparmor or something else.
>>>>>>
>>>>>> If no selinux module is loaded on host, then as long as virtiofsd
>>>>>> process has CAP_SYS_ADMIN, it should be able to set security.selinux.
>>>>>>
>>>>>> "Operation not supported" means error "EOPNOTSUP". I am assuming
>>>>>> you are running virtiofsd with "-o xattr" to make sure virtiofsd
>>>>>> supports xattr. If that's the case somehow kernel is returning
>>>>>> "EOPNOTSUP".
>>>>>>
>>>>>> Can you run virtiofsd with debug option -d and try to install that
>>>>>> package in guest and capture outout of virtiofsd and post here. It
>>>>>> might confirm that host kernel is returning error.
>>>>> I tried doing "chcon unconfined_u:object_r:admin_home_t:s0 bar.txt"
>>>>> on a file in virtiofs and got "Operation not supported". I think
>>>>> guest kernel failed this. Will need to debug further.
>>>> Ok, Dan Walsh says that it probably is due to the fact that selinux
>>>> policy in guest is not aware of virtiofs. He has opened a PR to
>>>> add that.
>>>>
>>>> https://github.com/fedora-selinux/selinux-policy/pull/478
>>>>
>>>> I am not sure what distribution you are running as guest but it
>>>> probably will require similar changes. Once this package is built
>>>> I will give it a try.
>>>>
>>>> Thanks
>>>> Vivek
>>> Correct. The Guest OS Has to have SELinux enabled and the virtiofs
>>> file system within the VM
>>>
>>> needs to have SELinux policy that says it support labeling on Xattrs.Â 
>>> Otherwise when you attempt
>>>
>>> to set labels on the file system.Â  SELinux in side of the kernel will
>>> say that virtiofs does not support
>>>
>>> SELinux labels, which is what you are seeing.
>>>
>> It is the advertising and presumption of those using 'virtual machines'
>> that they are 'runnable' on any host.Â  If I read the above correctly,
>> because there's no telling which of the hundreds of packages in the
>> fedora/centos/rhel world will fail on built-in restorecon calls,
>> virtiofs is now excluded for general use except on SELinux enabled hosts
>> .
> Hi,
>
> This is SELinux policy change required in guest (and not host). So after
> this change in selinux policy in guest it should work in your setup
> (where you are not running SELinux on host). Can you please give it
> a try. selinux developers provided simple instructions to test it.
>
> https://github.com/fedora-selinux/selinux-policy/pull/478#issuecomment-731290656
>
> *********************
> FWIW, you can apply the fix locally without rebuilding the selinux-policy RPM as follows:
>
> # echo '(fsuse xattr virtiofs (system_u object_r fs_t ((s0) (s0))))' >virtiofs.cil
> # semodule -i virtiofs.cil
> And to check that the change is applied:
>
> # seinfo --fs_use | grep virtiofs
>     fs_use_xattr virtiofs system_u:object_r:fs_t:s0;
> To revert the local workaround:
>
> # semodule -r virtiofs
> ***********************************
>
> So please load above policy module in guest (and not host) and then try
> installing the package which was failing for you. Please let us know
> if this fixes the issue you are seeing or not. 
>
> I tested it and it fixed the chcon issue I was seeing.
>
>> Â There are, (cough) a fair few hosts out there which are not running
>> SElinux, whose operators hope/need to provide vm guest services to the
>> fedora/rhel/centos package users.Â  So, I ask the virtiofs folks to
>> consider creating or defining an option allowing fedora/rhel/centos
>> guests a way to succeed.Â  Or, in the alternative, a clear warning that
>> virtiofs is not a good choice forÂ  rhel/centos/fedora guests on other
>> than rhel/centos/fedora bare-metal requiring selinux enabled.
> To enable selinux in guest, we don't need selinux to be enabled 
> on host.
>
> In fact selinux policy on on host can potentially interfere with guest
> policy. So I think we should run virtiofsd with remapped
> "security.capability" xattr in qemu. That way both guest and host can
> have their own selinux policy.
>
> Thanks
> Vivek
>
Testing results follow.  Short version:  Commands above applied without
error,  failure remains until vm is rebooted, then success.  Good enough
for today!

Thanks

Harry Coin

---

  Detail:

In this case, the VM host is running a debian/ubuntu os, not running
selinux, the underlying filesystem is btrfs. 

root@noc1:~# uname -a
Linux noc1.1.quietfountain.com 5.8.0-29-generic #31-Ubuntu SMP Fri Nov 6
12:37:59 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux

ps axu

...

root       84306  0.0  0.0  80216   992 ?        Sl   14:45   0:00
/usr/lib/qemu/virtiofsd --fd=44 -o
source=/vmsystems/fedora_generic,xattr,flock,no_posix_lock -o writeback

root       84356  4.1  0.0 4165836 30088 ?       Sl   14:45   1:23
/usr/lib/qemu/virtiofsd --fd=44 -o
source=/vmsystems/fedora_generic,xattr,flock,no_posix_lock -o writeback

...

On the otherwise default fedora workstation guest we have:

[root@fedora ~]# uname -a
Linux fedora.1.quietfountain.com 5.9.10-200.fc33.x86_64 #1 SMP Mon Nov
23 18:12:50 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
[root@fedora ~]# mount

...

myfs on / type virtiofs (rw,relatime)

...

[root@fedora ~]# touch foo
[root@fedora ~]# restorecon foo
restorecon: Could not set context for /root/foo:  Operation not supported
[root@fedora ~]# echo '(fsuse xattr virtiofs (system_u object_r fs_t
((s0) (s0))))' >virtiofs.cil
[root@fedora ~]# semodule -i virtiofs.cil
[root@fedora ~]# seinfo --fs_use | grep virtiofs

fs_use_xattr virtiofs system_u:object_r:fs_t:s0;

[root@fedora ~]# restorecon foo
restorecon: Could not set context for /root/foo:  Operation not supported
[root@fedora ~]# touch foo2
[root@fedora ~]# restorecon foo2
restorecon: Could not set context for /root/foo2:  Operation not supported
[root@fedora ~]# reboot

...

[root@fedora ~]# restorecon foo2
[root@fedora ~]# touch foo3
[root@fedora ~]# restorecon foo3
[root@fedora ~]#





