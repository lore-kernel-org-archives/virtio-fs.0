Date: Thu, 11 Nov 2021 13:31:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=7ZDhHUzXquI1a3gfscHAhzwHZKvVyPRJiqy82
	/SovZ0=; b=Bw5HTTiHt7oTJsGqQV3fzMyet//cgwAV41G5kqJJJvtzJhdSsWe4N
	Tj8Znd+4F6otoDF+Ls28wlHhi7XkOlzfuBl4FGSSJqFpyiY+8BEJvFpy5IyIDPEz
	uGow32ytpOAV4nY82dxezScnlzd2bGrOVWuWdg1dCNTmr15o5kLwo03n5iKKHWBH
	AX+hRLOSAwNkkGJueRpmvVqsrrtTTFASzHJWi25RuE3uClW/K8fMA8bZyVSITUsc
	CS1gEgcyTzuhrq9cRzO3trBEhz68c53AsHE3zRxfdnMd8czCUxxI95xgS2eVbJmh
	JThkkQX1u0uFtakQ4s97f38++RW30R2KQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=7ZDhHUzXquI1a3gfs
	cHAhzwHZKvVyPRJiqy82/SovZ0=; b=DNXDHrK/dxX8n2wIoScin7DpERPXK87X9
	aFqCjO+biX6UBo0VoG868GZm887BMEiaIOE36NQwsnbdUwFb0EKKDxxwcbmGJOSW
	D1ynek5vk9svgHSvNNA/asC8cwkAJhTdkaXdsdvF8DLn5ukyIrbT3hbjoBre2fOU
	ziBEoJMe5RT6EIh1pzmtmDUac1QLAMKDVDayyszDR2rLhPYeLFCoI+q0901fmhfI
	yuG9Bf10lNK7OVYlQPulZ94zHTtb5dAwJ5rETUJxkTXt8B/UYSBneCrNRVk5TswZ
	aG3Z8QN4iNZgAGNK8sTzFQIHJgUrSI6s8Q+UDO3RKB6l6hdrBRsNw==
From: virtiofs-bot@sinrega.org
Message-Id: <18680.121111113313900331@us-mta-105.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Replace Firecraker's seccomp
	with seccomp-sys
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Some distributions require all crate dependencies to be packaged
individually. This implies that depending on the whole Firecracker
repository would make things very hard for us to get virtiofsd-rs
packaged.

This change replaces the dependency on Firecracker's seccomp with
seccomp-sys, which is a crate providing raw bindings for
libseccomp. This means we add the latter as a both a build time and
run time dependency, but that should be fine as the C implementation
also depends on it.

I've also considered adding syscallz, which provides safe wrappers on
top of syscomp-sys, but that one also depends on strut, which we need
to drop from our dependencies due to its problematic versioning
policy.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/45

