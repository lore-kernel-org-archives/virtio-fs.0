DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=subject:to:references:from:message-id:date:user-agent:mime-version
	:in-reply-to:content-transfer-encoding:content-language;
	bh=a/6jqDcqaaZrDREISZf6hzG/d0uVsnNNCwJ+brMYx5I=;
	b=kZNkJ8ctWJuHgRaX7ZS5wFDSRsE+F2FHbag/OtgcOOYZQoQuyX4l/ZEc5He39NUas+
	DF1kg6iAtEOcAEu6dTN7xmg37l0wxLe/ASBZ23jDojEBrdhg5LQ+Gnl+yvNfGzdx+yjn
	tMEAVZtdAoPG1f+SHa5RTgscPuoycUofe4VWrwNIuBfd5bvBrEOpf5fi8/9VVFIqSOLU
	JORuUJNyEWHNxOMom+TkLGlHsbt4GYgCO63VGB8mE1BezmAOFlZ9NzQLBqxqiihT1fNq
	o0YBdRN8GwhmN4X24itEFRYZLyv5KD2+iN2vqw6vrafFEFDb9+uAiCdrF4O7Sj4Un8iE
	DHKQ==
References: <20210611120427.49736-1-berrange@redhat.com>
	<20210611154222.GA761698@redhat.com> <YMjLZUqZ5nhihJ1X@redhat.com>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <c7e13bcd-9fd9-d416-9899-5914102b3656@gmail.com>
Date: Tue, 15 Jun 2021 23:31:52 -0500
MIME-Version: 1.0
In-Reply-To: <YMjLZUqZ5nhihJ1X@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH] docs: describe the security considerations
 with virtiofsd xattr mapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com


On 6/15/21 10:46 AM, Daniel P. Berrangé wrote:
>  - Store a symlinks' xattr on the target of the symlink
>
>    if the symlink has dev:inode  54:224, and points to
>    a file 'foo', then on 'foo' create an xattr
>    "user.virtiofs.link:54:224.<original xattrpath>"

Atomicity issues here.  If you do this, virtiofsd will need a 'xattr
write intent journal' somewhere....


