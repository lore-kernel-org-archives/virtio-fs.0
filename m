DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=JBA3kWcV1EmEL7fNmuvvfUm9MgrKtq0ZwPzgOB7jxY0=;
	b=HWYJKgbn6Yzr2UMYpS/j+sOBW/wz7i6JHJhql1zCyxplMmvrDqqtazn85w9QlQuog8
	pFS4cnMQM4Rz8eCEIJ32ylWpAzojc+G8FnlfjB92YMFgM2sGqGPJriIrUPqYIcbu6jqU
	N4jO0T+MGT4F4gXwWiQwczONmyi0W1rscLr+Y=
MIME-Version: 1.0
References: <CAJFHJroyC8SAFJZuQxcwHqph5EQRg=MqFdvfnwbK35Cv-A-neA@mail.gmail.com>
In-Reply-To: <CAJFHJroyC8SAFJZuQxcwHqph5EQRg=MqFdvfnwbK35Cv-A-neA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 1 May 2020 09:53:19 +0200
Message-ID: <CAJfpegtWEMd_bCeULG13PACqPq5G5HbwKjMOnCoXyFQViXE0yQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] fuse doesn't use security_inode_init_security?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: linux-fsdevel@vger.kernel.org, fuse-devel <fuse-devel@lists.sourceforge.net>, LSM <linux-security-module@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Fri, May 1, 2020 at 8:55 AM Chirantan Ekbote <chirantan@chromium.org> wrote:
>
> Hello,
>
> I noticed that the fuse module doesn't currently call
> security_inode_init_security and I was wondering if there is a
> specific reason for that.  I found a patch from 2013[1] that would
> change fuse so that it would call that function but it doesn't appear
> that the patch was merged.
>
> For background: I currently have a virtio-fs server with a guest VM
> that wants to use selinux.  I was able to enable selinux support
> without much issue by adding
>
>     fs_use_xattr virtiofs u:object_r:labeledfs:s0;
>
> to the selinux policy in the guest.  This works for the most part
> except that `setfscreatecon` doesn't appear to work.  From what I can
> tell, this ends up writing to `/proc/[pid]/attr/fscreate` and the
> attributes actually get set via the `inode_init_security` lsm hook in
> selinux.  However, since fuse doesn't call
> `security_inode_init_security` the hook never runs so the
> file/directory doesn't have the right attributes.
>
> Is it safe to just call `security_inode_init_security` whenever fuse
> creates a new inode?  How does this affect non-virtiofs fuse servers?

Not sure,  Adding more Cc's.

I know there's a deadlock scenario with getxattr called on root inode
before mount returns, which causes a deadlock unless mount is run in
the background.  Current libfuse doesn't handle this, but I think some
fuse fs work around this by not using libfuse, or at least have some
special setup code (glusterfs? ceph-fuse? not sure...).  I also don't
know whether the ->inode_init_security hook is related to this or not.


Thanks,
Miklos


