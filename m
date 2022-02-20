Date: Sun, 20 Feb 2022 11:56:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=8jFQn7jzTNwosIKxFsLz0NRapjHlOeOpEVSyhBnsUM8=; b=R
	KoDBXF+EcH+ui22QrzcwPTWwh/J8Bq6l6LgWN7qjfcuJY2En1b2cPl/DomKVFn2R
	tNgrOG1IZnVvDCyo4e2YkER5rMWxOlnPeL5aQZuuWdynzk7rWu2/ReIKyZS0NCA/
	D0i8Fw0p+xk5O7+LqxwcHzm6dFX7/9+OHZO4FHRgaO2tf/Q3QQIit1/K1JDKhUw7
	iHDdfOS2G8FkrzYAmrBzoJocMa0S9VU0wnMFxGuX/oRnQ1mOK4nh44l4YpZsCVB+
	VILVlVcVem3tYrmtLaQ+yOuWOF3/dFJx0iIWZwq1sfd5qVvCapcZyE63SrDvosyN
	93BVQvSYIKbEsLOvwQaqA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=8jFQn7jzTNwosIKxFsLz0NRapjHlO
	eOpEVSyhBnsUM8=; b=joLSQwBywklk91peXekMmvllycX0NwzaTZNW3OdfJxC/A
	kYKdtgTfWaKv7qR7ilS8PuCBQrjVjjd1ZHo5UgXXiaa3+OdIX6lLEnGZ4IWtaZL0
	PzrJY6sgQfM/pV24qP1xYg7mhgGop7D/Fc9yUce8YmqKTdURVtB7Ma7KaFkXMPed
	1OhXwRt45BIeAjD2tWECR7c9qfYxtLBvQUbDN1k40zBPwvzfMc18sTyEsJPn3UD3
	ahNbccptmXqr58FoxqCzjzKVA+I+VpGKInBzENFszL/tnWc2wZBfCAwWeKEK4p1L
	Gpi/IrcRTlnumImHpLWTcCpBaUqJN+sgsH4dmkYMA==
From: virtiofs-bot@sinrega.org
Message-Id: <52924.122022011562400131@us-mta-213.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] Issue opened: WinError 1005 on realpath()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Steps to reproduce:

1. Have a Windows guest
2. Mount virtio-fs on Z:
3. Create directory `Z:\foobar`
4. Run python interpreter
5. Call `os.path.realpath('Z:\\foobar')`

What happens:

```
OSError: [WinError 1005] The volume does not contain a recognized file system.
```

That's the line where the error is raised: https://github.com/python/cpython/blob/b77158b4da449ec5b8f682816a79d004fd65ed07/Lib/ntpath.py#L674
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/32

