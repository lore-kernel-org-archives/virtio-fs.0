Date: Fri, 21 May 2021 00:20:27 -0400
From: virtiofs-bot@sinrega.org
Message-Id: <31973.121052100202100849@us-mta-540.us.mimecast.lan>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mBKj/BzMzkjOL51PB
	AwqDguQiRCGY3Io2NfzuT3A3iE=; b=joAcneNq7v2+vnJougwWqzCiGFWNFnEZx
	MKcx2EvEzSdMHsF8slEjPxwyw1oqXQvuvMZtJSB5WErPchHfyji2rzyRtYtoUzgs
	zmk+r0uJZjcf2wfe7GOjhqx/97QpXgHA0EUE+E2zI7IXIPjq9kijFUDqkv5W+uJK
	MKMC3n5d7brl6U3BqP1lbpLsxTYAw/g7TIdb8j0ZPcjpdPMj+c5R0DivJ7RH2fv8
	GbABLNqp++rtKh9EPVmwvFvRf8sdf/mzPtIAdxR3yddwYSkKUupE5RKkUJx84yN9
	ososAnc/PdS8qKXnCfZRY0lAnNwxyVDNN4DrKIWLM0YPKX2M7NH1Q==
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Fix protocol features
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

When virtio-fs uses the DAX option, this means we expect the backend to
send some requests to the VMM, and this is why SLAVE_REQ protocol
feature was exposed. But this is not enough since the requests that are
sent by the backend may contain some file descriptors. That's why we
need the additional protocol feature SLAVE_SEND_FD to be exposed.

Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/27

