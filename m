Date: Fri, 12 Nov 2021 04:49:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=uWhUYrYa0lWQS7xISBWwoCLzaqOpoLcA5gkGh
	52QrOE=; b=D3pwg7c2VwkkyCjDIjx0tDnVmsbAmqgAiyxNvkeIU8TD4dM1RZ7JC
	0tUvbIjmIP1CiYzGh1r41p+6G4hLwlcujvSI0HEx2a4evPXI0L/aa0PF7lIsUP5L
	MwuuNC9AMidmnkpr6thcs2va/HiIBhOPp9m1IslyiNcvZNL2591SwVjP/k7VKLw2
	BT7cQEF6VKuvtBjIOOg/HFu4zkax45rFq40TZ+wGCFDkoPjUgEfpvxM3JCERdqtA
	Ak/3w5n3KRo+NdNziTlD9ckkieA+crCt7W+4q/zZkr1bB5ngWZnyJZZvHbM/NpbS
	/AvA2SrHzPge0+73t0YnjJDHCYcoWDvJw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=uWhUYrYa0lWQS7xIS
	BWwoCLzaqOpoLcA5gkGh52QrOE=; b=Q7KJtZIEBG/WzKY9FhoCQ20hMXOyBnWJS
	1I/nNZopiR90PSZPmxULl6cUQNmMa5BS9J7SfI+h/fmLm3VYjYEz17JyWoI6nq7k
	1wRifJ2wM6NU96XLUADuv36CGu9wn0OfTXT6Jvs2+KEm4lGrCd9SUo6c6tmakefb
	CL9rESprkADL/+suIs5oTKvE5hjWFJWFgrFubTw14h+X2iWmegm+WLAfl4prb0p2
	nDUSRzzYUOwJps9rfZG12EonzupfKU/Qlqfqa88K3zuZJYAgOWwZSp3I49wYdHOD
	d21AJ8EX3iFBLlhKZDWvjDHHSCYvNXThapRlGUI0gKSxNY+ksyJlw==
From: virtiofs-bot@sinrega.org
Message-Id: <89275.121111204490700277@us-mta-299.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Allow clone3 syscall in
	seccomp filter
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Some versions of glibc make use of the clone3 syscall when spawning
new threads, so allow it in our seccomp filter.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/46

