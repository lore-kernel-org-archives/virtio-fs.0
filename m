DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=7Vv/8P
	v+UZoAhI3w3k5if5V+rn7G4D18VN5pDtkN3Qg=; b=N2UmUo9W40cwEwygwyGGTg
	fP7JZEorFQZAgaz9xxC4qqbSo4UML4Sd3CUm6j5qmGVDn5R61q0cZOQsdYqgl2pU
	6zx7wiDBxvUgXlQpDR2D8triuTCm9DrNmVHerUND4i0MXOs5Hh4w8qjwvZzNj2Vp
	O8H9Enf+MzsytWLmdxhPgXn41owI13tAua5eJSO7MN9Wuu8TBrKmp+/AegLxOcsB
	pBZ5fpYscSjjQsHuJ/F6Wg9OzVd1E6lfooyJcxhJjGTqf2HkLcJAO06gdVYGSc2+
	fTx0VcyK9bTTLHNSLPm1wGlRaxlzjmaeGvfGsnYCiDh5xWe3qvIgOUbfAsD6qVIg
	==
Mime-Version: 1.0
Message-Id: <a02d3e08-3abc-448a-be32-2640d8a991e0@www.fastmail.com>
In-Reply-To: <20210924192442.916927-3-vgoyal@redhat.com>
References: <20210924192442.916927-1-vgoyal@redhat.com>
	<20210924192442.916927-3-vgoyal@redhat.com>
Date: Fri, 24 Sep 2021 18:00:10 -0400
From: "Colin Walters" <walters@verbum.org>
Content-Type: text/plain
Subject: Re: [Virtio-fs] [PATCH 2/2] fuse: Send security context of inode on
	file creation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, selinux@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>
Cc: stephen.smalley.work@gmail.com, Miklos Szeredi <miklos@szeredi.hu>



On Fri, Sep 24, 2021, at 3:24 PM, Vivek Goyal wrote:
> When a new inode is created, send its security context to server along
> with creation request (FUSE_CREAT, FUSE_MKNOD, FUSE_MKDIR and FUSE_SYMLINK).
> This gives server an opportunity to create new file and set security
> context (possibly atomically). In all the configurations it might not
> be possible to set context atomically.
>
> Like nfs and ceph, use security_dentry_init_security() to dermine security
> context of inode and send it with create, mkdir, mknod, and symlink requests.
>
> Following is the information sent to server.
>
> - struct fuse_secctx.
>   This contains total size of security context which follows this structure.
>
> - xattr name string.
>   This string represents name of xattr which should be used while setting
>   security context. As of now it is hardcoded to "security.selinux".

Any reason not to just send all `security.*` xattrs found on the inode? 

(I'm not super familiar with this code, it looks like we're going from the LSM-cached version attached to the inode, but presumably since we're sending bytes we can just ask the filesytem for the raw data instead)

