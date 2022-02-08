Date: Tue, 8 Feb 2022 10:48:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=UH8TS/EzPGw/GBzDJWtcvbqn0HsrZSZIjurqR+DaLL8=; b=R
	V1CyncCZ+3w0WMRHSQvd3LzmmzIrDyhdzJ6/PSwgMklfucr/nkn50GXOC2qLnWbx
	8dkq5oveGdMlbnAjcks1L+s+s6LznKuKgcgEu7eHilw9BqI2lGelTWi0dBtP9boC
	ILysE/ScDYoWJNa0E7DH3UHwPeG9n0KurMGDpYOf3tRCo2rE8Oo5//ATGuM/l7CY
	JfLM6GJ16yZ4V/wB0MCba/68v5owBjrctebBexbdzlaTTDc5/bKgiW5OesudQu+h
	+Zq0PH76DnmYiv9yS3T5g9iSib4IkmNK2Nv3brkqsiGlwLD3OECVVwO73WrtMZge
	kS9jCjYUBTZUEOM8t7zXQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=UH8TS/EzPGw/GBzDJWtcvbqn0HsrZ
	SZIjurqR+DaLL8=; b=koFot0sdaQ1q8X4mabQ4tNTYafb+BrrSOVmXGycj5cQxn
	8OVteL6QQ27+bgOu80BEcEycALRFwmwV+4oKMxBA3IxRMmHL9k8Vlouw4ugrMuGO
	mvSWkEULBNSzdWdAuWoy/+EcrlYu2F7B/R5NV7RspQzgbuFaK/4FCy7ahBZrycVs
	XyOfvpeWu4UOJ3RjP+cauqLCSnkWZCySPtptpJHqYwlsHe62LbjM6EESjX4y1kHa
	rQ1tK3SZ5z49S5ttahfsLmUICF+EIsn+SfS+Y6cFNwhNjaQ4V0oaY3KjragJjQYy
	SBLFvZG1d2XOrfMw+CvAgcu900djmWzCGZ11M/wzw==
From: virtiofs-bot@sinrega.org
Message-Id: <52443.122020810482100643@us-mta-542.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR merged: Clean up the command line usage
	message
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

In the usage message, we show legacy and deprecated options whose use we discourage without any warning or deprecated mark.

We can adopt a deprecation policy, for instance, where a deprecated option will be removed in the next major revision.
In this MR the legacy options are marked as "deprecated" and a warning message is shown if are used.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/69

