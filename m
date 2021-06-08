DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1623188520; bh=BzT3wyhqpB6185zh00HzeGjst0xNZzNRNRcMkS0h4Ek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TPCVJJPheMdSOTumApcB7X+1E/NcOwTUaPkWOc0lpWofraySQuqK/Fcz1QR6mNJu/
	JbIBKs/drSoZzxeIaf8DU0tcv9YgrMNiR9LgzEx5Jp9SRNagHzDD3i7zi+FOEo/XNJ
	PbSCFfPCoCcvdEbuB9SHmSId3kCsa3A9i6hzSXy45RUsscxetLrLqsMCTUaNMm49UN
	bwYG+NWjh/K8BEQOhSdGCCVa17ZOAdaJ6qeDg+T+pKZf2Yhee13uQc7YW8WObvi3GL
	70AEi/UPGVfR2Jv2x6K94NNblVioAzUPYNkVqPqAoBESmnu/nAN5SlJ3uRurgWzvvm
	BCngHHHE4/VLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1623188519; bh=BzT3wyhqpB6185zh00HzeGjst0xNZzNRNRcMkS0h4Ek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hZs7zDSzWVrirXlYRkb+jr8ZfGHEWgLxIP6E4ym/fYo38OHCnrgAXLk03GvlJ80wc
	x4mK1vQ5pH8UOHFvd8L4zqag2eWJnnMdHYfznLUafJ+oP8csmM21fusFJhPGd2IHMP
	x2A+h/66ugFwS/ecXQDBFnfvvyZGsFSNO6ofK0bLXiyzQARFG4DcbZyQFti3B4i1my
	A1JVbDm/2VNinrbZODsGhJfERVUeNRvAsCBcacT/cJA9HGmH/LIBAiFl42Et7hhdXk
	NDJ/fB7kpmf30DKYvH2PI4iaXRNGopmekboUxPqkpuDH/pgxlmDD+K+kI4L1avIiaK
	H/hT4xQFNqKGw==
Date: Wed, 9 Jun 2021 06:41:38 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
Message-ID: <YL/kEpcaYE/Jr0J7@codewreck.org>
References: <20210608153524.GB504497@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210608153524.GB504497@redhat.com>
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
To: Vivek Goyal <vgoyal@redhat.com>, Changbin Du <changbin.du@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Richard Weinberger <richard.weinberger@gmail.com>, linux kernel mailing list <linux-kernel@vger.kernel.org>, virtio-fs@redhat.com, Enrico Weigelt <lkml@metux.net>, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net

... And that's why I told Changbin Du a few times his patches needed
more Ccs :/

FWIW: we just got last month a couple of patches that would allow
initrd-less 9p root mount (using the nfs/cifs method described below
with root=/dev/v9fs)

Vivek Goyal wrote on Tue, Jun 08, 2021 at 11:35:24AM -0400:
> NFS and CIFS use "root=/dev/nfs" and CIFS passes "root=/dev/cifs" and
> actual root device details come from filesystem specific kernel
> command line options.
> 
> virtiofs does not seem to fit in any of the above categories. In fact
> we have 9pfs which can be used to boot from but it also does not
> have a proper syntax to specify rootfs and does not fit into any of
> the existing syntax. They both expect a device "tag" to be passed
> in a device to be mounted. And filesystem knows how to parse and
> use "tag".
> 
> So this patch proposes that we add a new prefix "fstag:" which specifies
> that identifier which follows is filesystem specific tag and its not
> a block device. Just pass this tag to filesystem and filesystem will
> figure out how to mount it.


...However I agree something more generic would be welcome in my
opinion, so I like this approach.

I'll give it a try for 9p over the weekend and report back.

-- 
Dominique

