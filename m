DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
	t=1624985514; bh=CdVaAyKCUH7a5+INbjm8wM+T+DCBoLIHH2QYKaF4BCY=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To;
	b=ST4SpWv5vXqMXmPQtWevZKBoXfK5o21HELWE0k/iFc769czhS3zknNIdeDL0/6X4CUAQDNFwrcd4Rc2x3b9mbcIFG6dB7z+p6Gs1IjxK94TaVGxYehaCjRf0JY0Fex92rCxmCtySasREz8M+da+Oh2vAf4wFQEwpGXeE/CjTrbny89Hj43ywoYnm92qcSr/c5pcAXLOVXK0vZ1te9Bd+roSG0JKzZb0QbN5NK6M9jduZ25jpGOKvAK90I4r/VMd92RIxbpFBzr7X4/pMRxhx660p5KMmW4Q1F9k+WEZTbIUeYc/0Zxk5/z6HTWDWs6/QuWpnQhHAHrwbMPd76sKELQ==
References: <BN0PR11MB57275823CE05DED7BC755460FD069@BN0PR11MB5727.namprd11.prod.outlook.com>
	<20210628131708.GA1803896@redhat.com>
	<1b446468-dcf8-9e21-58d3-c032686eeee5@redhat.com>
	<5d8f033c-eba2-7a8b-f19a-1005bbb615ea@schaufler-ca.com>
	<YNn4p+Zn444Sc4V+@work-vm>
	<a13f2861-7786-09f4-99a8-f0a5216d0fb1@schaufler-ca.com>
	<YNrhQ9XfcHTtM6QA@work-vm>
	<e6f9ed0d-c101-01df-3dff-85c1b38f9714@schaufler-ca.com>
	<20210629152007.GC5231@redhat.com>
	<78663f5c-d2fd-747a-48e3-0c5fd8b40332@schaufler-ca.com>
	<YNtLtkkDMWye485A@work-vm>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <93e87539-29d1-2bed-9a79-ec378f6869b9@schaufler-ca.com>
Date: Tue, 29 Jun 2021 09:51:47 -0700
MIME-Version: 1.0
In-Reply-To: <YNtLtkkDMWye485A@work-vm>
Content-Type: text/plain; charset=utf-8
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

On 6/29/2021 9:35 AM, Dr. David Alan Gilbert wrote:
> * Casey Schaufler (casey@schaufler-ca.com) wrote:
>> On 6/29/2021 8:20 AM, Vivek Goyal wrote:
>>> On Tue, Jun 29, 2021 at 07:38:15AM -0700, Casey Schaufler wrote:
>>>
>>> [..]
>>>>>>>> User xattrs are less protected than security xattrs. You are exposing the
>>>>>>>> security xattrs on the guest to the possible whims of a malicious, unprivileged
>>>>>>>> actor on the host. All it needs is the right UID.
>>>>>>> Yep, we realise that; but when you're mainly interested in making sure
>>>>>>> the guest can't attack the host, that's less worrying.
>>>>>> That's uncomfortable.
>>>>> Why exactly?
>>>> If a mechanism is designed with a known vulnerability you
>>>> fail your validation/evaluation efforts.
>>> We are working with the constraint that shared directory should not be
>>> accessible to unpriviliged users on host. And with that constraint, what
>>> you are referring to is not a vulnerability.
>> Sure, that's quite reasonable for your use case. It doesn't mean
>> that the vulnerability doesn't exist, it means you've mitigated it. 
>>
>>
>>>> Your mechanism is
>>>> less general because other potential use cases may not be
>>>> as cavalier about the vulnerability.
>>> Prefixing xattrs with "user.virtiofsd" is just one of the options.
>>> virtiofsd has the capability to prefix "trusted.virtiofsd" as well.
>>> We have not chosen that because we don't want to give it CAP_SYS_ADMIN.
>>>
>>> So other use cases which don't like prefixing "user.virtiofsd", can
>>> give CAP_SYS_ADMIN and work with it.
>>>
>>>> I think that you can
>>>> approach this differently, get a solution that does everything
>>>> you want, and avoid the known problem.
>>> What's the solution? Are you referring to using "trusted.*" instead? But
>>> that has its own problem of giving CAP_SYS_ADMIN to virtiofsd.
>> I'm coming to the conclusion that xattr namespaces, analogous
>> to user namespaces, are the correct solution. They generalize
>> for multiple filesystem and LSM use cases. The use of namespaces
>> is well understood, especially in the container community. It
>> looks to me as if it would address your use case swimmingly.
> Yeh; although the details of getting the semantics right is tricky;
> in particular, the stuff which clears capabilitiies/setuid/etc on writes
> - should it clear xattrs that represent capabilities?  If the host
>   performs a write, should it clear mapped xattrs capabilities?  If the
> namespace performs a write should it clear just the mapped ones or the
> host ones as well?  Our virtiofsd code performs acrobatics to make
> sure they get cleared on write that are painful.

Dealing with tricky semantics is the difference between a feature
and a hack. Doing so in a way that other people can take advantage
of the feature is the hallmark of a feature well done.

>
> Dave
>
>>> Thanks
>>> Vivek
>>>


