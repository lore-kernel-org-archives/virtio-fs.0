DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209;
	h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WwyTS8f7LxDaulW6rkzWRyAKkCW92/fyupXmJhT339M=;
	b=CzQY/lp8TtUNWtubgal/819krU
	FA41ge5VfnD1bhDpucKUyGqOx8w8uUHRrRXrFUzqaNtG3xvd7A2vnRauzlgeHz596GOXDAV9sp1aF
	m960BV4oeTsw2VIvoq+MPU1XLT3kzip8KrH4TOnzCYsgPe4yHF0uhc4I7kUTr7Ty+w1Yez4EsEmEh
	F9q5dwgKNdz25NeJCKY7+oH6BGR8oTEqLflxQ0SM8mugN0Cj0vbXw27ciSBe/ACP0zgviakBvZ64v
	Lr9Z4vYyaaLznN8HSqDOasTaRbPk+iJvYYXTY5vtpNWTSxeREpwGbSDKBmnY0pnehlr/xBR6MVGUj
	wnzgjk/g==
Date: Thu, 6 May 2021 20:35:17 +0100
From: Matthew Wilcox <willy@infradead.org>
Message-ID: <20210506193517.GF388843@casper.infradead.org>
References: <20210506184304.321645-1-vgoyal@redhat.com>
	<20210506184304.321645-2-vgoyal@redhat.com>
	<YJQ+ex2DUPYo1GV5@work-vm>
MIME-Version: 1.0
In-Reply-To: <YJQ+ex2DUPYo1GV5@work-vm>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH 1/2] virtiofs,
 dax: Fix smatch warning about loss of info during shift
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>, linux-fsdevel@vger.kernel.org, dan.carpenter@oracle.com

On Thu, May 06, 2021 at 08:07:39PM +0100, Dr. David Alan Gilbert wrote:
> > @@ -186,7 +186,7 @@ static int fuse_setup_one_mapping(struct inode *inode, unsigned long start_idx,
> >  	struct fuse_conn_dax *fcd = fm->fc->dax;
> >  	struct fuse_inode *fi = get_fuse_inode(inode);
> >  	struct fuse_setupmapping_in inarg;
> > -	loff_t offset = start_idx << FUSE_DAX_SHIFT;
> > +	loff_t offset = (loff_t)start_idx << FUSE_DAX_SHIFT;
> 
> I've not followed the others back, but isn't it easier to change
> the start_idx parameter to be a loff_t, since the places it's called
> from are poth loff_t pos?

But an index isn't a file offset, and shouldn't be typed as such.

