DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:from:subject:message-id:date:user-agent:mime-version
	:content-transfer-encoding:content-language;
	bh=KJ7RT2ikzr2tDrPh2Y9bhPYGspcF4mBv8FORXIe3Hjg=;
	b=F772xMm7eiQRGfGXvyospY+Z5X4fqochJOnUK2i7rsVV2fifpMWQ4ntt6l1ReBNj/1
	I8fGMcd+pfcnPmlexjp/bqesIMiQzbFg4RV50NtPOHR9dZ+U5ki2duaXssx442PhlCZA
	f5URPJBWeVWJSg/Ca8j+jz2CTxd4Le6cYDzQc1bmDwc6X3HxDFKV1Kv/U2UoOWJ4wxXQ
	nb6lBbHc+KzgVtx5xMja9/h1lCKhl38zC4LvaizvknWP4qCdyvZYhmJj0bODpAOBSr6A
	xUlUoanH01IFxULO8S3ig+Whv/36mPsFAaCK+7QgY8qJEQzjeQWFMkCZWqB5PG5iAzuo
	2s/g==
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <49924235-5ce7-9d5d-cf98-ace0743505fd@gmail.com>
Date: Sun, 15 Nov 2020 01:30:40 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] restorecon "operation not supported" root virtiofs?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>

When the host's fs is btrfs, and on the host we have:

/usr/lib/qemu/virtiofsd --fd=46 -o
source=/vmsystems/fedora_generic,xattr,flock,no_posix_lock -o writeback

On generic fedora 33, kernel 5.9.8-200.fc33.x86_64

[administrator@fedora Downloads]$ touch foo;restorecon foo
restorecon: Could not set context for
/home/administrator/Downloads/foo:  Operation not supported

What, if anything, am I missing to enable proper restorecon / SELinux
operations?

Thanks!

Harry Coin




