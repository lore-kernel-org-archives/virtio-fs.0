DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:cc:references:from:subject:message-id:date:user-agent
	:mime-version:in-reply-to:content-transfer-encoding:content-language;
	bh=1lORAc+gbFR4CxZkOisjqLZ7mkl4N+qv7fkBns3RD2M=;
	b=kl9PioNPX6WenoWDqU3p+R2JOQAQHDtE/npCxHYVogGmlQtzIK80IaGN63QtIjmghj
	a3/UHAPYyWHSOi/IJQzstE2Aiwhau4RGWEdSMwluKSEmcb924hhZSU2ixwPViyg/qZ03
	LmiMYnV5WfEoox++INGlMv5kUn0FuAny23CwTyNEfwsqQhVo4b50xuKEiYMVWw/0kisG
	oq7JxQjU/Rh5oG/A/AAk3K1eDXmtqc1lL4m2Nssy/SBgT9nmtpgIHmn1+T5zeARjnZlT
	XbNAszh5pYSIezs4lw66WxxtmeniWFUw4DCXIUCwlagHsNSK1o12FWjOcZl05+SwSEPo
	aKHw==
References: <20201014180209.49299-1-dgilbert@redhat.com>
	<20201014180209.49299-4-dgilbert@redhat.com>
	<bd3c072f-dc6c-23a8-cd48-543bafa46363@gmail.com>
	<20201020095401.GD140014@stefanha-x1.localdomain>
	<CAOssrKfbOF7UgkWDZ6t8mmPLt8Vr+4aPpMFpZvV_bYznThZPZg@mail.gmail.com>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <273c2f8c-e607-ca37-3042-f2a5a2586dca@gmail.com>
Date: Tue, 20 Oct 2020 09:55:29 -0500
MIME-Version: 1.0
In-Reply-To: <CAOssrKfbOF7UgkWDZ6t8mmPLt8Vr+4aPpMFpZvV_bYznThZPZg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] Puzzle about rootflags,
 restorecon "operation not supported"
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>


On 10/20/20 7:57 AM, Miklos Szeredi wrote:
> On Tue, Oct 20, 2020 at 11:54 AM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>> On Thu, Oct 15, 2020 at 06:57:09PM -0500, Harry G. Coin wrote:
>>> The 'mainline generic' version of the latest kernel fails to parse
>>> 'fuse' virtiofs options on root kernel boots.  Not only dax, but all the
>>> 'fuse' usual ones as well.  (None of
>>> default_permissions,allow_other,user_id=0 etc are accepted).
>>>
>>> Is that what you expected of the mainline kernel?  I learned of this
>>> when trying to understand this further problem:
>>>
>>> SELinux's 'restorecon' and other attempts to change security attributes
>>> then fails with "operation not supported".
>>>
>>> I could only get sshd able to accept connections by changing SELinux to
>>> permissive.  The commands necessary to change the security attributes
>>> failed with the 'operation not supported' issue.
>>>
>>> Ideas?
>> Hi Harry,
>> FUSE mount options were removed from virtiofs at one point. I think this
>> is expected. The reason is because the options you listed are the
>> default for virtiofs and don't need to be specified explicitly.
>>
>> I have CCed Miklos in case things have changed or I missed something.
> Removing the fuse mount options is expected.  Removing the selinux
> option is probably a bug.
>
> With the DAX patches the option parsing was restored.  Was the selinux
> option parsing also restored?

I suggest a small effort at these user-facing doc updates would help
adoption.  A lot.

What would help the most on the gitlab web page is: a roster of all
guest side mount options, with notes as to deprecated and no longer
implemented options, and notes if an option requires a particular
host-side xml or qemu or virtiofsd setting, and notes if guest kernel
option is not available at kernel boot time.  If there's an 'selinux
option' somewhere to be found I at least missed it on the official
virtiofs doc page.

The kernel.org 'filesystems latest' virtiofs doc is dated 2019. It
contains "virtiofs supports general VFS mount options, for example,
remount, ro, rw, context, etc. It also supports FUSE mount options." 
Which appears to be out of date (file systems using those options fail
to mount/boot).

The libvirt page discusses host setup xml, but doesn't include much of 
the option suite virtiofsd's manpage offers.

Both kernel.org and libvirt reference the gitlab page, nowhere in which
do I find references to fedora past v 29 (now up to 33...). 

I suggest the 'standalone virtio-fs' page include a link to two
different known-good kernel '.config' files.  One  that when compiled
will deliver the virtio-fs features built into the kernel that supports
booting without an initrd, and another that enables as modules the
necessary for initrd or non-virtiofsd-as-root use.  Earlier I offered
the updates to dracut necessary to create an initrd using the kernel
command grammar other packages use, but those should by default support
SELinux , so the default flags need updating.

Thanks for the focus and your work on this!

Harry Coin









>
> Thanks,
> Miklos
>
>
>> Stefan


