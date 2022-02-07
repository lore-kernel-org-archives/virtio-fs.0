Date: Mon, 7 Feb 2022 08:52:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=MvW6qUDnkURX+NzsFut84zpxHXtoINcbfb7rYg4pc9M=; b=n
	tRPKzZCa0NHsf3hYQ+2/YFX86v4WP44ZvTUmVu7yHreT9S0CpO9BMDQTcAxULa65
	zWGSAQKfnA1NQ3QgnwTrwZ0PN97DfhnxuOsfXefg5tRJ6Y68X5M3kzrhLZr+za+F
	rgciu1vkqf3aZ7Q39Qu1MIO929Keg3x/f+v3jTHYFML5bI4iEglDVXkkbuesl+1W
	X5Z3WLOdxwiRVXgQCegAn1391qp4nme7tjGqBzlWxdZObWeyLnd1J4x5kJCQgqH2
	rsvifHikmJDZIEO+jGlMc+1aamqdN+IN2vpOZqt58NVGFXmPMmeK5EpJyws/llDI
	/4+rUMynuXuirNrM2ef1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=MvW6qUDnkURX+NzsFut84zpxHXtoI
	Ncbfb7rYg4pc9M=; b=G2Yu/k5CvRRfdZDSmgyZM7OvlxKou56pEoUeI1GbcxvCn
	xycBxMWMtY5IPpp5KWOEb7PcAsC0lFRpkQqxne45ggW7NxkNFa4ZRSX5qhv1mBFQ
	nFyT5uwKido2zWt/Z8Fsw7JfsKQ2Lm/m0FfDkV+UF8nhWwFKoWDBD/CNBBUTLJd9
	0NKmSwNjyJE7CzRm9GMGe18885GF/0Q/Mk1eWqP5QraU6jcBl6vLcKZDOxMnXc8z
	Dv6Fc53r22ATFPS5ECMI0yLu3D0QyL4gBnppXbrZDwDHaz9bzmIrnbTVzsEf8lpd
	sH6VA/uT8YFOdIZGydtMi7BGEw+h5QHOaP0KjRQCw==
From: virtiofs-bot@sinrega.org
Message-Id: <52614.122020708524101454@us-mta-549.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: passthrough: Reset config on
	FUSE_DESTROY
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

`PassthroughFs::{writeback, announce_submounts}` are set (as the
circumstances require) in `init()`.  Therefore, we also reset them
in `destroy()`.  Without this commit, those variables would always
be set after they're set once.  This might be undesired when the
caller calls `destroy()` and then `init()` with deviating
`FsOptions`.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/84

