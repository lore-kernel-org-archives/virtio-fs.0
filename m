Date: Wed, 16 Feb 2022 12:37:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=ZlN7mrAJBZa3ZTkh9yJAXYpS261X1kzfHI1wPKBRifU=; b=N
	gyxIS67u7Z2OgY/jb/d5tBpIFgReQOZd5oj7zvWQXzL0QsrXU+OO6LA2zMh+wZ12
	d68lH1EYTnPe+jK/CTm+UneAnM1nowu47JFUnk+Zh1t1m0eSUilGqQ2D9rwIn1Yk
	gqmKw8ACTi4r2WE88jQpFpioK4YbNthdZEA3gb08lzBYEobDVg94Oae646n6kEQq
	iKFTwtANqfWGUk4z5HvItylzgypCMRbatEY7GQiBMSg/9nbv0fH9QTyk0I0JA6Yy
	adZNixSk3m5pWS3HZ5Q6+OT27NeloL8ALCs5cP1xkdoJumDvsRAqoh7dFg+hz/SK
	vDrJLkLy08zldlKHTtPEg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=ZlN7mrAJBZa3ZTkh9yJAXYpS261X1
	kzfHI1wPKBRifU=; b=Uefr68hQKPkV6mSTGcNH0z/DA0kb8q/Fs2fVijeHmJcxI
	vnUw8uvNnDPuptn1HDxedK3AK42VpIuj0Rllto0oy64KSgDGwI5q8qA2QTB56kA5
	JIWuoxnEn1PNLHpre2/bGa8e12aPuZNWe/ZhA5jLM+FF52Ys8dMfNtenz0Q0RDDH
	jbGBT4CZm6T8Ww8YOVAbrbFm2qzi0Mu5YyXIZfoQFivMFWDyKvvaDzFeObL9Osvc
	t/wCrURkN1y0vSn5Uh6XR9ki4Fej6OaRG2UdOYNlhgtMr7MHMhfJjYqnBbOU6FBR
	jDmlDmR/s6evq8HjF7pZARd7rRwHZXnjPI0tU0QAw==
From: virtiofs-bot@sinrega.org
Message-Id: <05886.122021612374704092@us-mta-629.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: Parent exits with signal
	received by child
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Make the parent process return the child's exit code or the signal
received by the child. Closes #21.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/80

