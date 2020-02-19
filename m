DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
	s=tycho.nsa.gov; t=1582130627; x=1613666627;
	h=subject:to:cc:references:from:message-id:date:
	mime-version:in-reply-to:content-transfer-encoding;
	bh=BVsVz5P3I55uA075t/OwjNH1oawm+2szP2ADrvzyncc=;
	b=luMTeK6FtLl/9ZPPn7vWsLJAQyDM8YQpHRqRini4obYXGsJPNe4PkijY
	zWLex6gZ83/1oyGdcW/yjHTqBg5P4UowkXrEOrVA7CW4oDcHx7p4oHiTI
	BxTvHgGk8HhASiWLcZzm6ILQIPECN5EcgPhrzTN5C84V21AqOKFTNwGsN
	NjrfZ4oVlllBA0mAwAW+jyV7mpw5gpRcK6QVFIIvp3TfD4kw3hOXvLp1W
	IKR68KDrzpjp8Dk0GKLYMf20qp6PI7JKLbclWEx53avFNV/S+zffrqmfB
	QV3glVPQGtM4lkN2AXp80/9CxUTnxakAUXixrpbwD+mIMLYfzhu3UDMLq A==;
References: <20200210160639.GA411895@stefanha-x1.localdomain>
	<bbcbd9a0-a036-1c1e-ed66-ac2aaca454a5@redhat.com>
	<CAFqZXNsL4nC4N2XKgMmTNJGCayJ1E=ppiKCBhv2yFCt39dLWqg@mail.gmail.com>
From: Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <6df9b58c-fe9b-28f3-c151-f77aa6dd67e7@tycho.nsa.gov>
Date: Wed, 19 Feb 2020 11:44:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAFqZXNsL4nC4N2XKgMmTNJGCayJ1E=ppiKCBhv2yFCt39dLWqg@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] SELinux support in virtio-fs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Ondrej Mosnacek <omosnace@redhat.com>, Daniel Walsh <dwalsh@redhat.com>
Cc: virtio-fs@redhat.com, SElinux list <selinux@vger.kernel.org>

On 2/19/20 11:11 AM, Ondrej Mosnacek wrote:
> On Wed, Feb 12, 2020 at 4:29 PM Daniel Walsh <dwalsh@redhat.com> wrote:
>> On 2/10/20 11:06 AM, Stefan Hajnoczi wrote:
>>> Hi Dan,
>>> I've CCed the public virtio-fs mailing list because SELinux support in
>>> virtio-fs has been asked about recently.
>>>
>>> It's time to figure out what level of SELinux support will be available
>>> in virtio-fs.  The file system client shares most of its code with FUSE
>>> and SELinux labels on files are currently not supported in FUSE.
>>>
>>> It would be possible to pass through extended attributes to the
>>> virtiofsd daemon running on the host.  However, passing through xattrs
>>> allows the client to relabel files on the host file system and this
>>> could pose a security problem.  virtiofsd already allows the client to
>>> set the uid/gid and permissions, but is passing through SELinux xattrs a
>>> bad idea?
>>>
>>> virtiofsd is in a position to mangle extended attribute names
>>> ("security.selinux" -> "virtiofs.security.selinux") in order to separate
>>> guest SELinux labels from host SELinux labels.
>>>
>>> As someone who knows very little about SELinux I'm eager to hear what
>>> you think would be a good approach.  Secure containers (e.g. Kata
>>> Containers) are an important use case but virtio-fs can also be used as
>>> the root file system for a guest (a scenario where full SELinux support
>>> is needed).
>>>
>>> Thanks,
>>> Stefan
>>
>> I am traveling right now.  We should add in the SELinux team, and I will
>> be able to look at this on Friday.
> 
> Cc'ing the upstream SELinux mailing list for more insight. Here is a
> public archive of the full thread:
> 
> https://www.redhat.com/archives/virtio-fs/2020-February/msg00005.html

FWIW, there were previous attempts to add FUSE support for per-file 
SELinux labeling (rather than just a single genfscon-based or context= 
mount option label for all files in the mount) but there were problems:

- deadlock during mount with userspace waiting for mount(2) to complete 
and the kernel blocked on requesting the security.selinux xattr of the 
root directory as part of superblock setup during mount [1] [2].
[1] 
https://lore.kernel.org/selinux/1280234607.4789.6.camel@moss-pluto.epoch.ncsc.mil/
[2] 
https://lore.kernel.org/selinux/20120824195928.22970.16209.stgit@paris.rdu.redhat.com/

- there was an attempt to introduce distinctions based on filesystem 
"subtype" so that whitelisted fuse filesystems could have xattr support 
enabled when it was known that their userspace would handle mount(2) 
safely [3] but this was apparently always broken and later reverted [4].
[3] 
https://lore.kernel.org/selinux/20130416225619.GA30164@sh-el5.eng.rdu2.redhat.com/
[4] 
https://lore.kernel.org/selinux/20131213195520.11231.81980.stgit@localhost/.

- there is the issue of trusting the fuse filesystem for its labeling 
information and for domain/context transitions.  At the least, we'd need 
a permission check to gate which contexts a fuse filesystem could supply 
(e.g. the filesystem associate check), and by default nosuid mounts 
disable domain transitions (although it is possible to selectively allow 
them via nosuid_transition now).  Also, if a non-init user namespace 
mount, even if policy is configured to use xattrs 
(SECURITY_FS_USE_XATTR), we flip to using mountpoint labeling (i.e. 
implicit context= mount with the context derived from the mounter's 
context and matching type_transition rule if any) and we don't permit 
use of context mount options.

