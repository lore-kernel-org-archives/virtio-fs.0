DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alxu.ca; s=default;
	t=1611240617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	content-transfer-encoding:content-transfer-encoding:
	in-reply-to:in-reply-to:references:references;
	bh=XXvN/2ywSjw/5QngZ1tZzibD8n/j9vdFtF06JkcFtWg=;
	b=WaMwm5GST1tEjJMlVvF4ZFn/mYph472/n0YuHRGpGd7q6SvV5wswfuAHcJ0xuSA5NPoN6G
	43FxgszeydOekOqJRuq1LmukpobnDMDBVqncIhhlX6n+mGENJ+02eUV61Ipn22biLD93HC
	8hILk1fG/6WhZtx0xVv8T/B4f8PdCrGDsQz362NE9MSpgfpNX0uv8Bex9omAAXnzsW4Fj2
	X983JP71Vds4h9UPHe6YoVrRZoyKp+JDbtBmnsAnFM9cJDrU5FrBIJlHGeL33805wSwby7
	ZWH4x3pyO2sOCjG+57vwq3V1zBJx5nJn8rVyskk+yZCwQ2S1HrcfUnbOC+ktog==
Date: Thu, 21 Jan 2021 09:50:15 -0500
From: Alex Xu <alex@alxu.ca>
References: <20210121144429.58885-1-stefanha@redhat.com>
In-Reply-To: <20210121144429.58885-1-stefanha@redhat.com>
MIME-Version: 1.0
Message-Id: <1611240546.prykd5to6n.none@localhost>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: prevent opening of special files
 (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>
Cc: P J P <ppandit@redhat.com>, virtio-fs@redhat.com, vgoyal@redhat.com

Excerpts from Stefan Hajnoczi's message of January 21, 2021 9:44 am:
> A well-behaved FUSE client does not attempt to open special files with
> FUSE_OPEN because they are handled on the client side (e.g. device nodes
> are handled by client-side device drivers).
> 
> The check to prevent virtiofsd from opening special files is missing in
> a few cases, most notably FUSE_OPEN. A malicious client can cause
> virtiofsd to open a device node, potentially allowing the guest to
> escape. This can be exploited by a modified guest device driver. It is
> not exploitable from guest userspace since the guest kernel will handle
> special files inside the guest instead of sending FUSE requests.
> 
> This patch adds the missing checks to virtiofsd. This is a short-term
> solution because it does not prevent a compromised virtiofsd process
> from opening device nodes on the host.
> 
> Reported-by: Alex Xu <alex@alxu.ca>
> Fixes: CVE-2020-35517
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
> This issue was diagnosed on public IRC and is therefore already known
> and not embargoed.
> 
> A stronger fix, and the long-term solution, is for users to mount the
> shared directory and any sub-mounts with nodev, as well as nosuid and
> noexec. Unfortunately virtiofsd cannot do this automatically because
> bind mounts added by the user after virtiofsd has launched would not be
> detected. I suggest the following:
> 
> 1. Modify libvirt and Kata Containers to explicitly set these mount
>    options.
> 2. Then modify virtiofsd to check that the shared directory has the
>    necessary options at startup. Refuse to start if the options are
>    missing so that the user is aware of the security requirements.
> 
> As a bonus this also increases the likelihood that other host processes
> besides virtiofsd will be protected by nosuid/noexec/nodev so that a
> malicious guest cannot drop these files in place and then arrange for a
> host process to come across them.
> 
> Additionally, user namespaces have been discussed. They seem like a
> worthwhile addition as an unprivileged or privilege-separated mode
> although there are limitations with respect to security xattrs and the
> actual uid/gid stored on the host file system not corresponding to the
> guest uid/gid.

I haven't looked too closely at the code, but the commit message seems 
reasonable to me.

Thanks,
Alex.


