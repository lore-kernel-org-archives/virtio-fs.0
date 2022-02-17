Date: Thu, 17 Feb 2022 09:30:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=nBbWZygSzvlp2YQhUufUUWa1xPeb+IeFDDxKVMYGF00=; b=D
	hC2Jde8alBoaBiyqXZa4dT2PDup7bWwVJ2TiyV9tXUG1u0ggKFPI/THf0nvGxfxo
	ZWlt4DK/hRk7iDwqygl663vISzskhd9TAY1ANu4Fz0lsNTtlBl1IU0hI6CGlKrjN
	WrPTqd9erOo1Bkb7niQ62kXPB8jKYc89ChoyA7tBMq5QFcv8ybz3YazlbEP/Gm/J
	bVXyuS3IvD5gE1mOz2a7uclL5VBek5uUY8Ky5L0VO8srhIVECNlRR7BxjT0haVzJ
	eEmpbvJqD7BfGnAl/w1hj+TlgP0z3Zqa/ygNDZftEBv9s1LCvFClEyxdOZ/3DzfR
	PYVLqzuQ4dRC2Oevzc/qg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=nBbWZygSzvlp2YQhUufUUWa1xPeb+
	IeFDDxKVMYGF00=; b=JXQNynAgeKxZTVK+lW8G9197N+oxLIQ2HnENAAKR4GO1q
	cq28k02siKjYJWO5Tsk6FywIlhXRHF2FcVK2L9C72i//IcXjr0KnY6d9LnMZxjj6
	ji0oNMK4gZ3Ommo+gfjYngTAnkro6caun8QUpA8mICQv/E/z+YuZqmcdvwZhZT4Z
	3lnbr/ycBbNauQujKrbXSWeAJRRI3i/BBOvz4ZgkGelbrryLAy5/h9udPKV/vZT7
	7ZeB5YHUFHnsHOzS5GqD6wB4Iaqv8ox8GeGMZ1lw9ego+HTBQ3M/piG5fLJ5Uloc
	vXwDeYWqFoxgfvCRXd04ylIGu6sYmkX/AL5uA1qfg==
From: virtiofs-bot@sinrega.org
Message-Id: <48494.122021709301701447@us-mta-588.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR closed: Draft: process_queue_pool:
	Prevent queue starvation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

In `process_queue_pool()`, instead of processing the queue until
it's empty, we collect the entries from the queue once and then
process only those entries.  This prevents queues from starving
other queues. Without this commit, `process_queue_pool()` might
never return, preventing all other queues from making progress:
e.g., the REQ queue might prevent the HIPRIO queue from making
progress.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/90

