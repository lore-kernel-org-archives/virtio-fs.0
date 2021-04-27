DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:from:subject:message-id:date:user-agent:mime-version
	:content-transfer-encoding:content-language;
	bh=LnfIFwYkWzBxXYg91fpRdN9bajaXQ8OyvqYM4xB/nW4=;
	b=UtSBd/roj5OSNWv1OqEicW1k8nQ8FHrh1i9MUF8st7NeanEhLAzPHenkuGEpNhBKKX
	mvg4VZf3LosFS9j8xqN6o05SexJr5v6zco9RiNJMqkdaD9OUxWXPPt4O8FPs20/8lgB0
	/xmGr84xNtbxsHm1Pf7Uw5/wUeCaSRaMQWfPBc4RGPntJtBiI/hfNiCse3Xk77u3KBas
	HF3IYNVa1KY7es7cMhedZOpJnWwOWM0l9Hszhj72r88yziE2dGIVQHEbpXbIoDKwS2/0
	58ZStxnV3zzuEm9irdjZv5atXGpgdYDRogYiN8QQuz3HcfBsLF4aDemq6NDTVUJElQ7V
	0Sjg==
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <6b2e27a4-8bee-3649-95a4-a2cea45a18e4@gmail.com>
Date: Tue, 27 Apr 2021 16:59:59 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] Min host / vm kernel rev for basic DAX ops?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Kindly answer a couple 'basic' virtiofs questions:

1) Which mainline kernel version is necessary for the host, and for the
vm to enable reliable DAX operations -- supposing no shared host
activity on the underlying fs.

2) Which host file system(s) have the best DAX performance while
offering xattr and related abilities?

Thanks




