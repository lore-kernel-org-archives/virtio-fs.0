Date: Fri, 3 Dec 2021 06:19:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=r31xEKYz8u6/3iV9m/ePJJzcf/qdmqPa6nYXF
	MF+Bs8=; b=EW7UmegUWJDhVZDZsaZD5cjnq9zhDmuyEg7u55Jxa7pMrLM20Aas5
	gjA5HbOqzNPDKOz82JhU7jdhrzBweUvhdD324LzwZTI3goFCjTDcfO1rOPDt5KIS
	M1nrLp+8lGxQfcUt44/4kwJs5JYssjPhCbymkHmf8hlPfLpqm4wD69J4pdbqIp9E
	dZQ/IY5cSfa88U9kbHveLpeYzYldfKTr6S6cfWGYBx+ItnUroned4vVEMI3gOGy1
	2eQdOI9M/Ga7V4a5yoTv1Ay2CJQzv9sBjTaNrn5agOlPMrlFz/LySxi1jwEpIUDN
	eD+VAoVoYxfBilKB3y9QvaFlpY/j24y6A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=r31xEKYz8u6/3iV9m
	/ePJJzcf/qdmqPa6nYXFMF+Bs8=; b=fLhpJscUA2ZdtapxnPf0E12f6dJB2bFO/
	oZP/O+AQj4JbZfvEZjNIL4ANf53zd/P6t9ada7Vu6fI/TzCjATmLYyaA1mFswzNx
	dN/zFp2+Jr/wsE+ytBMR9yFes5JwKrzcyQsYcVpQ1jf5jNRn5Q8U5ZuwBnp+SFi+
	6Pzuy7M25beBLqrHsx8hWSDYNrU63AYb9UBNt7jwPQaz/THpIaPnnHSqMOIWe57e
	b8zJtFLRb3MGvfU8Q/LaTSijgPBvIGRPKeo/Ju2kqkO7Cyvk8wZayEa1gDriqJyH
	ZAMxJuKmdORSs9TtRo483vmRHXU0jfAwU/Z48+8/CJzlNS6pkqsRw==
From: virtiofs-bot@sinrega.org
Message-Id: <34512.121120306191600371@us-mta-584.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Correctly open mountinfo with
	sandbox=none
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

We need to open `/proc/self/mountinfo` with `O_RDONLY`, because we want to read from it.  Instead, we open it with `O_PATH` (when using sandbox=none), though, which is wrong and will later prevent us from creating openable file handles.

Fix it.

(Reported by German)
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/52

