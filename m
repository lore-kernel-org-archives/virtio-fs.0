DKIM-Filter: OpenDKIM Filter v2.11.0 mail.namei.org 3A5781C2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=namei.org; s=2;
	t=1634676775; bh=eJ38SycwOWDCZsBfSsnUj9RXqKdsL9o4kYObW0CKim0=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=ap83rxBCm0keV5NBaLe8KLpMnIwqcHEq9pgLJI793OJ5Of4PzaUjTwC7Hx5QHGtsH
	MEK3P9I8WrBZfxX4R/jEcUYZTcTsZxIorz4cKYTfWtAr7yDMIoIFMuIcTchwBChlmk
	/Zn8v2W44qp6Lts4z9QzcOjQyFUsW82uuihq8CQI=
Date: Wed, 20 Oct 2021 07:52:55 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
In-Reply-To: <YW1qJKLHYHWia2Nd@redhat.com>
Message-ID: <3bd86fa3-b3b0-754f-25a5-5e4f723babe4@namei.org>
References: <YWWMO/ZDrvDZ5X4c@redhat.com> <YW1qJKLHYHWia2Nd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: bfields@fieldses.org, linux-nfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, selinux@vger.kernel.org, stephen.smalley.work@gmail.com, jlayton@kernel.org, Ondrej Mosnacek <omosnace@redhat.com>, anna.schumaker@netapp.com, virtio-fs@redhat.com, casey@schaufler-ca.com, linux-security-module@vger.kernel.org, chuck.lever@oracle.com, linux-fsdevel@vger.kernel.org, idryomov@gmail.com, ceph-devel@vger.kernel.org, trond.myklebust@hammerspace.com, serge@hallyn.com

On Mon, 18 Oct 2021, Vivek Goyal wrote:

> Hi James,
> 
> I am assuming this patch will need to be routed through security tree.
> Can you please consider it for inclusion.
> 

I'm happy for this to go via Paul's tree as it impacts SELinux and is 
fairly minor in scope.


Acked-by: James Morris <jamorris@linux.microsoft.com>


-- 
James Morris
<jmorris@namei.org>

