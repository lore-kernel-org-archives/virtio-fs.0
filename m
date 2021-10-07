Date: Thu, 7 Oct 2021 09:18:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=6JRy8VXcc3l8pE+U4+w9kSKx1GS23HS+wD5hO
	c7/VjE=; b=DE5zk5RyplzltBMi7Pj+/yWusawOxcVZ9a126wWhEfIUtwxfRD/o7
	8myIEG+Rqg+PM9W5yDq/cwoNxwnO/hoJrJgnPd0t1988paDM9BzWYb18moPQprGe
	qHYH2cU0MUC9lxaix8Q1AorqLfoVcMpPUW9/kpObW9m10TuzOa0CNNnUotviHnWg
	H4fnw010SrJuYxAS7uh9lYut6ck73oyLjLkdBHRonINjnfwalbYU9tYm8UXG2qGB
	Bm+jmr1HF0963zLQasgh3xCquMX22t0795dtYRWAB57M7UF9AKzc81n2OXsZXDkf
	qBiOO6jH1vUQuivZRc978P2gHzJcH+Wcg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6JRy8VXcc3l8pE+U4
	+w9kSKx1GS23HS+wD5hOc7/VjE=; b=Dj6enzGQtLJsFBv0vPPDdJEzy7VSZo0AD
	dEs7PIWHMMO0OwfsejVSfJ44+Fp6hyZfRUDVt4OVIU4BknPsWns3BDPJSVxyQOxs
	EBFOBvxiC3ovf6KTrVbNf7JXizOSDW6Tlk5cZIcfSCnoTBEY+T2t+aNhUHIWmYaa
	jB8m0KOr8fnj04P/ZVJaZv9pzQRHFHTBTJQ1jfg7OunmhSG8jkwIPaFrstiMs1WP
	JA4Ghc+YuyQNWNbVan0t4dDpGDo8eoDLkd/yt0pKn5cO+zgJYOSgGSC1w0+xg8sO
	iswB9dp9+1AG2kYQivmL2tAVltEg/ALutY2GbMLTXTsL5MaaMEQpw==
From: virtiofs-bot@sinrega.org
Message-Id: <15901.121100709182001043@us-mta-245.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Implement a single thread mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Implement a mode that disables the thread pool and processes the
requests in a single thread.

By processing the requests in a single thread we lose the parallelism,
but in exchange we can apply some optimizations, such as acquiring the
vring mutex lock once and keeping it until all pending requests have
been processed.

The expectations are that the thread pool mode will perform better
when the backing filesystem is on a relatively slow storage and
there's a significant amount of I/O parallelism inside the guest,
while the single thread mode will consume less CPU and perform better
on pretty much every other case.

This mode can be enabled by specifying the value "0" for the
thread-pool-size command line argument. We also make "0" (single
thread mode) the default value, to mimic the behavior of the C
implementation.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/40

