DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
	:mime-version:in-reply-to:content-transfer-encoding:content-language;
	bh=kudREQ7t9gHf6DVuShXNl/hbtQgw+8szlFSJQ68ELus=;
	b=pFfVl54A055w5mVBhF0O8sPd2e2yLKJQ6KjeoyhN488okZwdki+KdRhiVEROtHTSMv
	OVzzCGKZuAgKGBqC+/+5DndkJ2+dItGaxf3SO4MUtxVvTcBAICPvx+41RJawla+jyh86
	5h5wGTcpuPK1qZh7ImaW+u+FHVLe6/axMR9m3hg9pDjyWdtZmnXcDoN7NRc05lIQ97WZ
	36cTWMet8/GDnAb0o/02O5fHhItFXMJSR54e2XZU0ccNcbDOB5ljsu6TU+BnyNkHwyaR
	49Cnyf3+AXRfK+6+/JD8AW1jFLb8ehVUKDAQkqUKEeW2pN+8qgDimp1mDM/hyTRY+ClN
	Gm2w==
References: <20200929185015.GG220516@redhat.com>
	<CAOQ4uxgMeWF_vitenBY6_N3Eu-ix92q8AO5ckDAF+SVxHTBXXw@mail.gmail.com>
	<CAJfpegtH0TruLCnG_YJ8aUBHh7k5sqN_wVEegvDPJOoDcmwLSQ@mail.gmail.com>
	<CAOQ4uxiity6zAW__Y+T=o+GHkzxo=fnVj+21Z8cRjdvFWbauRQ@mail.gmail.com>
	<dfa0dbea-7046-0852-60c6-39bc24f24314@gmail.com>
	<20201001135129.GG2807@work-vm>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <3deb375c-e234-f83c-159f-cebdd3a1876e@gmail.com>
Date: Thu, 1 Oct 2020 09:12:17 -0500
MIME-Version: 1.0
In-Reply-To: <20201001135129.GG2807@work-vm>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] Kudos: productivity boost using virtio-fs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com


On 10/1/20 8:51 AM, Dr. David Alan Gilbert wrote:
> * Harry G. Coin (hgcoin@gmail.com) wrote:
>> Though it's likely been written before:
>>
>> Virtio-fs is a wonderful productivity boost in development environments
>> in which unrelated deadlocks, crashes and hard-lockups happen.Â Â  Why?Â 
>> Because the underlying file system is never corrupted (though individual
>> file contents may be, the file system itself is protected).Â Â  For
>> example, using btrfs' snapshot ability in the underlying file system and
>> comparing 'before and after' crashes creates a powerful debugging tool.
> Thanks!
>
> I'm curious, can you describe a bit more about how you're using it with
> btrfs - I don't think we've had anyone describe that before.
> (We mostly use it with overlayfs via the various container tools).
>
> Dave

The 3 host chassis I've set up so far to work with this has a  btrfs
file system in a raid-1 setup.  Btrfs does a good job with xattr support
which virtio-fs can be set to use well.

I have several vm's running on each chassis, each using virtio-fs.  On
the host, there is a sub-volume for each vm.  The vms  use kernel
booting, and huge pages.  So, on the bare-metal host, a simple 'btrfs su
snapshot <vm sub volume> <snap name> generates an 'almost free' (from a
resource perspective) look at the entire vm.  Various risky experimental
things go on in the vm, which could lead to file system corruption owing
to deadlocks and hard freezes and race conditions.  However with
virtio-fs, when that happens, all I need to do on the host is make a
another snapshot of the 'frozen' vm, stop the vm.  Then I can compare
the exact state of the files at the time of the freeze with the 'known
good' versions at the snapshot time.   Delete the 'frozen' state
snapshot, make a new  snapshot of the known good snapshot, reboot the vm
and the dev cycle can continue. 

Even if the cause of the freeze wasn't evident in the file system
deltas, knowing there isn't corruption in the underlying fs is a big
time saver.

I expect when dax makes it out of the development bubble this
configuration will be a very high performance, easy to maintain, high
security arrangement.  Much harder to 'break out' of a vm than the
various container options.





>> I suspect most folks involved in virtio-fs know this, but it's worth
>> putting in the record for new folks.
>>
>> Harry
>>
>>
>>
>>
>> _______________________________________________
>> Virtio-fs mailing list
>> Virtio-fs@redhat.com
>> https://www.redhat.com/mailman/listinfo/virtio-fs


