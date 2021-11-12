Date: Fri, 12 Nov 2021 04:14:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=bTWqcOAaQ7Erd7XYdn/nFIhA5r6pFJWbFdreu
	7V23Ig=; b=v+Ammar8GC05K171XAOcsL/HcRjfOdXThgl1N8niwH9ufFvtNAelW
	pzGP0ZGbRe2skj3HBcjQ0UutYfcFmVim0OTNdALNvpjB1e+fuPjlO90SClGNkYY+
	5s7jpy9jksQD/4C94hEq8T8qz1ilQv2GqoWajxBAIiYwKs6TMN8SAlGKAt0xC1+Y
	LndqZqkKt26/pLofa/ZNxBQSFxTx4YBJg4HYTBH61Wscg2vVFFA202MyI/GF7w7f
	4nWrDcL0vyskpXrYFm4pXej+m/X+0Te//OQMxilvE2RiRRpdyMSYjRJpgEi44M7p
	Lb7H1GID/SOZHUzAWb8EM8ThiM1NYLwtw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=bTWqcOAaQ7Erd7XYd
	n/nFIhA5r6pFJWbFdreu7V23Ig=; b=JakUprcLKaoHeCFlXH1G/r43IqCKLBXXU
	/G59RmXs/2pKVjnjElM6DN1CbXrkmxRW2UfDTPju5CpCQvFWrTwkKwTwZvWZakE0
	+jjGH7k5i9REwe1xBmDU/KhuvdcztviazCOJK5A9UUFR5tx/4j+FMjCrYGUdBrAI
	XxP6bJUz3zAJgS+nhBuGQ1g7s6SmdTe9i9iNPTnNGloS3qsfHzqmcbeGs48U+ai4
	Q8HtERzoIcI1RFbI4X5z/YInSjUXfOH0Y5aiei3UTpJBxZzSZERhJ0kywRrkQJ30
	HO3khkshRjoIporCPBhbc0Gk0Q7bO/a4QfHHU/hGJWFZCZDYfp+7A==
From: virtiofs-bot@sinrega.org
Message-Id: <59490.121111204144200311@us-mta-377.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Drop capabilties,
	don't announce KILLPRIV and implement support for KILLPRIV_V2
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This series introduces the ability to drop the capabilities before starting the service, stops announcing KILLPRIV support (which we never really supported) and implements support for KILLPRIV_V2.
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/44

