Date: Fri, 26 Nov 2021 06:32:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=FygHnPd2HD/unaZtFe+qBAvq5yBYp/5EwvFKF
	tIrKQ4=; b=MQan6PdCmGeweEVEOYEyUWbIdB21AKVmsYSBRG0ctj0fO7gHC+HQG
	8/WLrFpDF17MtsZeQkBtZ86BsnjCZxcHRNerucyk9LglGkQWxPPQsxzuNFRO8iVF
	iC8zOCLL/aNFEPgeqvY39caPkS0SBi0qjq/EMair8JeXcjgf7AmnAn3ZGWiP87ve
	/+8Xh87b8jt+xaT4fvVofDKQOPqvU96sO+k+yXGOVw2Pn6yhKSneRp5tE6G/1/7k
	CvR7X6egBV80VITFxAUlBsSx+XXoNw+19Ma4a/7MGKeZItTbSwZkyRNIuyFyUnsu
	z4JKwe7Ngs+628PEb3LTgKZr04nnDeMTQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=FygHnPd2HD/unaZtF
	e+qBAvq5yBYp/5EwvFKFtIrKQ4=; b=OpYSCikH9/pKIvBAveVwsa/xGEdmLe7Gb
	4UW46yoCKScI1vz8CJ88x1UgU4EgrPhQ02XLUSjUWnAl3oPmiTSGXwt0s0bfLm1n
	U18iOAmS/e6tMeahZu0cBVVUMsMWYR+l1gg/0KV5UNpSUscvqSA6xynKxmmp6lPW
	v1ygcdFqqLAjyPvwmjOt8g6eO+jUHSF9Ba180eSYUcpoDbLjLD3Q9k8K8ByiKKYU
	CepsdVhFNlf1CV6RYpU/DvbaJ1li9DqHA0eg21nDqf9ilPk3loSfE5CqnOen6NbC
	y3lmxB9DGDKWKp9O1L/aBm00e2fnCm8WTE+BV/W1e/90FppSk7PrA==
From: virtiofs-bot@sinrega.org
Message-Id: <01749.121112606324100421@us-mta-315.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] Issue closed: Fix unit tests
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Unit tests are broken because ```vm_virtio::queue::DescriptorChain::checked_new```, in the version found in the rust-vmm crate, is not public.

We should either find an alternative, or tweak ```vm-virtio``` to expose an equivalent method for tests.
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/issues/1

