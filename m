DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
	h=references:user-agent:from:to:cc:subject:date:in-reply-to
	:message-id:mime-version:content-transfer-encoding;
	bh=YvHq1wtiylmBZ/fLtqU0SAhkEqotrOTWBp6a4PlVVEI=;
	b=ObVEs6d9T0josJav3mJPdMJ8B/u+UFLMv+McnTsDYXEEnPKpCu2mzmbGHqz6FQv0Ta
	HN9p05N6lzqAyPpqANse1zfO6/S4PomjdEzZqDJUP6Ym4xNaWmh+d38dGBsZeuqOyBiL
	E0yTBhPJac9ckwReMj1AEAf9pODs/SAwwI1C6DM3lS3x2KvhY62IDYK8AT2eQj8aU5I2
	jitd76cz554Gi9aoEUftINa1gy72jT5SK9XR+qbUoVVN9gRCoAxYWoPN4Uc9Bgk4/jcd
	iiFGaMomyJoXeC1a1Rxm9F3SHK9KY8ohuq9M8XFYcpdjzbdD5cgo7iGltz8XwjelILOC
	MFcw==
References: <20210409100627.451573-1-groug@kaod.org>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Fri, 09 Apr 2021 15:56:36 +0100
In-reply-to: <20210409100627.451573-1-groug@kaod.org>
Message-ID: <87im4vsdzn.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Fix side-effect in assert()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


Greg Kurz <groug@kaod.org> writes:

> It is bad practice to put an expression with a side-effect in
> assert() because the side-effect won't happen if the code is
> compiled with -DNDEBUG.
>
> Use an intermediate variable. Consolidate this in an macro to
> have proper line numbers when the assertion is hit.
>
> virtiofsd: ../../tools/virtiofsd/passthrough_ll.c:2797: lo_getxattr:
>  Assertion `fchdir_res == 0' failed.
> Aborted
>
>   2796          /* fchdir should not fail here */
> =>2797          FCHDIR_NOFAIL(lo->proc_self_fd);
>   2798          ret = getxattr(procname, name, value, size);
>   2799          FCHDIR_NOFAIL(lo->root.fd);
>
> Fixes: bdfd66788349 ("virtiofsd: Fix xattr operations")
> Cc: misono.tomohiro@jp.fujitsu.com
> Signed-off-by: Greg Kurz <groug@kaod.org>

Reviewed-by: Alex Bennée <alex.bennee@linaro.org>

-- 
Alex Bennée


