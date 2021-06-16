DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1623813915; bh=UF41cxCsn59VfZ1zaB/7LANWupA7/gtFYXligXAa+m0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kgK//wCPddGcUk68rah3nbQPD8AoKXsCiq3g8PDRNlaCD9sFsPdxwl1+fHnqJGRwp
	9LrYcqMknektgvv47NzMYkMCUJBVuXAf/XwF+073QqCyqcr10pLZh+b+qdy6gSuZHJ
	MfWyHTAVJXzj3jN9W1v7Jmf4BVUyXEyJaG2imY7ZuvKomjSrMiuik527oEez3vYxYq
	7+/t4iLQt1aWI6LKTL8B4DsiNSVlVMY3wNjhPoza/jR5rn4qoIwkhZ0HMDOQ4JHcV0
	hdoxtvK7rH7kndZ2s/qcsBZOvdxj4zIyOR+vfbBw7xr1FVM87FYXb4YVPoTU3+HjtA
	+n/1Mrx6Ly/HA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1623813913; bh=UF41cxCsn59VfZ1zaB/7LANWupA7/gtFYXligXAa+m0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oki2/2Uw5o8ufmcpkC4jpFdYETCT0KE82Do6WV0y2d+mVCxEMGzNf3o993+v+EcTL
	2+aowAQKdzsIBxZcwaa1VbqsMFqY26QmCQATCNMBMqLS/wGcCKS6PM2Eu/G0wvgD6F
	FUS3QcJCgOJY8LSohYs/gUitLpEj7+ISD/9hfwd9VvvLJyPpC0HddtJRssohu1jLq/
	bBnWXzYziAEb9d2R4BStq2KgrZFbHrHEqYi1ESFqpNl6EG4rxeZWr8pl+xOZQSnbPl
	kOSjweO6xP74XWqSp26piXJ8KuNct9hRajPa7vlfRnW3m1qyrbs0i44XokAP173Irp
	Hp+vDUrjn1r2g==
Date: Wed, 16 Jun 2021 12:24:51 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
Message-ID: <YMlvA2/L/n6XFa2h@codewreck.org>
References: <20210608153524.GB504497@redhat.com>
	<YMCPPCbjbRoPAEcL@stefanha-x1.localdomain>
	<20210609154543.GA579806@redhat.com>
	<YMHKZhfT0CUgeLno@stefanha-x1.localdomain>
	<YMHOXn2cpGh1T9vz@codewreck.org> <YMXyW0KXc3HqdUAj@codewreck.org>
	<20210614142804.GA869400@redhat.com>
	<YMfi3Q50b1wV+lDW@codewreck.org>
	<20210615135057.GB965196@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210615135057.GB965196@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH] init/do_mounts.c: Add root="fstag:<tag>"
 syntax for root device
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Richard Weinberger <richard.weinberger@gmail.com>, linux kernel mailing list <linux-kernel@vger.kernel.org>, virtio-fs@redhat.com, viro@zeniv.linux.org.uk, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net

Vivek Goyal wrote on Tue, Jun 15, 2021 at 09:50:57AM -0400:
>> Ultimately if we go through the explicit whitelist that's not required
>> anyway, and in that case it's probably better to check before as you've
>> said.
> 
> Yes, current whitelist based approach will not allow to have both
> block devices as well as tag/non-block based root devices. Are there
> any examples where we current filesystems support such things. And
> can filesystem deal with it instead?

Hmm I had thought ubi might allow for both through mount options, but
that doesn't seem to be the case.
I guess it is possible to imagine some fuse filesystem allowing both but
I'm not sure fuse is a valid target for rootfs, and looking at the list
of others filesystems which don't have the flag (from a quick grep:
mm/shmem, ipc/mqueue, nfs, sysfs, ramfs, procfs, overlayfs, hostfs,
fuse, ecryptfs, devpts, coda, binderfs, cifs, ceph, afs, 9p, cgroups) I
guess that might not be a problem.

> If this becomes a requirement, then we will have to go back to my
> previous proposal of "root=fstag=<tag>" instead. That way "root=<foo>"
> will be interpreted as block device while "root=fstag=<foo>" explicitly
> says its some kind of tag (and not a block device).

I guess that if it ever becomes an issue we could make rootwait wait for
only driver_probe_done() at that point, but as it is now sounds good to
me for now.


While I'm looking at this code, I feel that the two
 if (!strncmp(root_device_name, "mtd", 3) ||
     !strncmp(root_device_name, "ubi", 3)) {
will eventually cause some problems once we say arbitrary tags are
allowed if one ever starts with it, but I'm not sure that can be changed
without breaking something else so let's leave that aside for now as
well...

>> What I was advocating for is the whole feature being gated by some
>> option - my example with an embdedded device having 9p builtin (because
>> for some reason they have everything builtin) but not wanting to boot on
>> a tcp 9p rootfs still stands even if we're limiting this to a few
>> filesystems.
>> 
>> If you're keeping the idea of tags CONFIG_ROOT_TAGS ?
> 
> I thought about it and CONFIG_ROOT_TAGS made less sense because it will
> disable all filesystem roots. So say you don't want to boot from 9p
> rootfs but are ok booting from virtiofs rootfs, then disablig whole
> feature does not allow that.
> 
> We probably need to have per filesystem option. Something like CONFIG_ROOT_NFS
> and CONFIG_CIFS_ROOT. So may be we need to add CONFIG_ROOT_VIRTIOFS
> and COFIG_ROOT_9P_FS to decide wither to include filesystem in whitelist
> or not and that will enable/disable boot from root functionality.

Hm, I guess that makes sense.
A global kill switch might have made integration easier if it's disabled
by default like others, but you're right that in practice people would
only want to enable a specific filesystem, right.


> I feel that these kind of patches can go in later. Because a user
> can boot from 9p or virtiofs rootfs anyway using mtd prefix hack
> or using /dev/root as tag hack and adding these options does not
> close those paths. So I thought that adding these config
> options should not be a strict requirement for this patch series and
> these options can be added separately in respective filesystems. WDYT?

I wasn't aware of such possibilities, good to know :-D

Sounds good to me, I'll do proper review and retest the v2 patch over the
weekend.

-- 
Dominique

