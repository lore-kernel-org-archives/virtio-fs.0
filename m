DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=vpDry/4vppRTdkM/5uTPl5dyLlGXb8npQEXSH8SC3n8=;
	b=o2GB6bGy73ynHmJi3Gg4hEYN2Dm0AvQJTbKeajulhWdOW5eNjC2JDiAycN4FAXuZVu
	QOlxhQTFFF3dwFNUX78Dq+3+GI0T8ycd7lmeW4LD/RLJdg1IG204YBu1stQ0sSE9O9aZ
	slfxNIO+pajQUUZ9zBFJG7CWumjrgZX95S90ugGG52KhNUrFHcQQ3u04lB7OjMz77eNp
	9x/qAM0TbHBx8bT7bMwuDm1gsvioW83tOrqFUzRWjJC3k1fEh44py+hqvv7OcrHUAbQN
	/reiwOMaaXdhdTnSDny8pD9reCSgGZKgAes9sIfzb2yFipwOPvP1YYN29F9+X/95xkYK
	CbLQ==
MIME-Version: 1.0
References: <YWWMO/ZDrvDZ5X4c@redhat.com> <YW1qJKLHYHWia2Nd@redhat.com>
	<3bd86fa3-b3b0-754f-25a5-5e4f723babe4@namei.org>
In-Reply-To: <3bd86fa3-b3b0-754f-25a5-5e4f723babe4@namei.org>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 19 Oct 2021 19:49:06 -0400
Message-ID: <CAHC9VhRZyGYsFziXMfJQ=1OcLO52TGmAGMi5RaA3FXRgREsSeQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v2] security: Return xattr name from
	security_dentry_init_security()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: James Morris <jmorris@namei.org>
Cc: bfields@fieldses.org, linux-nfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, selinux@vger.kernel.org, casey@schaufler-ca.com, Stephen Smalley <stephen.smalley.work@gmail.com>, jlayton@kernel.org, Ondrej Mosnacek <omosnace@redhat.com>, anna.schumaker@netapp.com, virtio-fs@redhat.com, trond.myklebust@hammerspace.com, linux-security-module@vger.kernel.org, chuck.lever@oracle.com, linux-fsdevel@vger.kernel.org, idryomov@gmail.com, ceph-devel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>, Serge Hallyn <serge@hallyn.com>

On Tue, Oct 19, 2021 at 5:02 PM James Morris <jmorris@namei.org> wrote:
>
> On Mon, 18 Oct 2021, Vivek Goyal wrote:
>
> > Hi James,
> >
> > I am assuming this patch will need to be routed through security tree.
> > Can you please consider it for inclusion.
>
> I'm happy for this to go via Paul's tree as it impacts SELinux and is
> fairly minor in scope.

I'll take a look tomorrow, I ended up spending most of my day today
chasing a 32-bit MIPS (!!) bug in libseccomp and now it's dinner time.

-- 
paul moore
www.paul-moore.com

