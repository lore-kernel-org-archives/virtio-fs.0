DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=Yr1qOumuS8TXWEOrqim0XuS33cj0E8thnCAJCT0r9GY=;
	b=ZhRS1Ok6vhL7zeDZkgmGxaMYhwI3zcCvbfNUajVPoWdIK7sa0Qg3QadGgEpwbgZPwI
	WYG5/mB6f3ljby+rTF1atb4Fzjq7V2Bh9gxg8DPAC83591G7R1A7ABhYpVpBv88FjR6G
	jlGtz+N88vdwfHPiocq9EWVTpEgpzPl6hyFUQ=
MIME-Version: 1.0
References: <20210226183357.28467-1-lhenriques@suse.de>
	<20210301163324.GC186178@redhat.com>
	<YD0wbmulcBVZ7VZy@suse.de> <20210302160033.GD220334@redhat.com>
	<20210302162554.GE220334@redhat.com>
In-Reply-To: <20210302162554.GE220334@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 3 Mar 2021 16:36:24 +0100
Message-ID: <CAJfpegt7U_-gv0QKFF8D9P6DmsHbQ=fNUOBrC17X6Z+O7WzrzQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [RFC PATCH] fuse: Clear SGID bit when setting mode
	in setacl
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, linux-kernel@vger.kernel.org

On Tue, Mar 2, 2021 at 5:26 PM Vivek Goyal <vgoyal@redhat.com> wrote:

> > I still feel that it should probably be fixed in virtiofsd, given fuse client
> > is expecting file server to take care of any change of mode (file
> > permission bits).
>
> Havid said that, there is one disadvantage of relying on server to
> do this. Now idmapped mount patches have been merged. If virtiofs
> were to ever support idmapped mounts, this will become an issue.
> Server does not know about idmapped mounts, and it does not have
> information on how to shift inode gid to determine if SGID should
> be cleared or not.
>
> So if we were to keep possible future support of idmapped mounts in mind,
> then solving it in client makes more sense.  (/me is afraid that there
> might be other dependencies like this elsewhere).
>
> Miklos, WDYT.

Hmm sounds like two different modes of operation.

1) shared, non-idmapped: need to take care of races, so do the sgid
clearing in the server
2) non-shared, idmapped: can only do it in client

The same applies to all the other FUSE_*_KILL* stuff, so I guess the
decision about the mode just needs to be tied to a flag in some way.
Not sure if an existing one could be used.

Thanks,
Miklos

