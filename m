Date: Wed, 27 Oct 2021 09:22:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=d/klWL9Dw6fusDFGIAZdC7Wcw3nrLWFI2BmIG
	746gxQ=; b=X8Gp1gukWaY/5qOFs2VRdIGfRNW9gVZr5fMZiSFNWVQXbH6FcIsWV
	k1iJhuH7Oja0HI1VvhsJ1kaXw73wI+i+k/P0RMnANNPTQDIk+BVlTlQ35HrPBX4N
	PwIJXzzlkuKtWwArZ715zCgaO9jyvZlhIxJIx4ER/8uhXYAC9G3AiOjF1vrWj530
	PRhZqWfASmcJ5GLXG6VF85b2+gBWi4yjAW7rc6qBJiHK3lEVFnGppwsiOY1endV9
	jegb/xTRG/5gHCxerV8Ca/tCDsyxPBr+JIExFr9zULSYvKyL4AteZACmuvm2wB6A
	8U8T+ADyH6Voy1OCNGJ2qhGeCVOQi1CxA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=d/klWL9Dw6fusDFGI
	AZdC7Wcw3nrLWFI2BmIG746gxQ=; b=iKGbvquMvlZCxPpk3NNnIpk9OEUn3ARcN
	233wcSypelvMi0pr8geOJU/zUDAXzFfzsaY0Ep3Yj27J/kkQqbO2aXFpWEBK1rHz
	JRty9Lp7CiKdd33Tja/aki3QeaqN6sbVdMxFe2yu/1GKWS+ncR/WO3FlhDkXLzuq
	DmoNb7qj3hZ48uhOEbNTsbxP19mw5W0AHl3jWqyVy26IzCnBn1PfvZjiBDaKwIrK
	4WoMorcqktYxRC+CDqg0SpD1Fp+IrlLP1vgc8pqCZTQNtSJ0Y2QfUROPx/Bfm9j3
	x457TQc2Sz8e3cjw552adBI5G44cTqlHy1cc/2R9o/xIBXmArHZ9w==
From: virtiofs-bot@sinrega.org
Message-Id: <70122.121102709220702424@us-mta-593.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Drop mutability from
	FileReadWriteAtVolatile
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Internally, the FileReadWriteAtVolatile methods are going to use
pread/pwrite family of syscalls, which implies the file descriptor
offset is not altered. With this in mind, drop the mutability
requirement on the File argument.

This change allows us to drop the "try_clone()" on
PassthroughFs::[read()|write()], saving a "dup()" syscall on both of
those critical paths.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/42

