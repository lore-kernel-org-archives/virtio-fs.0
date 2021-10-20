Date: Wed, 20 Oct 2021 04:01:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=Sc+3hD9PUHVnU7eHcYkeRmCn+aSOfXPx3/0Ww
	zPnQhA=; b=WXINGpoPPYFgNXCf5ePOzcUJ3pFWUCEvV4LXb0OVn3YPbmLomGHaa
	CtRTBZoMHx3TMeejNO4FKqIIULqVDyhNw0zcUClBDC5KMSRxQFijj3ipPzujd3Zy
	M4/TdbbBhqtDMS4D8TBxeV5b4xuWW3AxFFG7O2zKtlR+711d+aUhICh+5xJBgc7O
	AqS+zyHNyg7nLAYVb4ZH3EhzRjBONcjG0ivsytmFOcI79laGg0zClAgxOyFvelZG
	dhzdtihG1q2mhHIdE9LVu0TGQInH9eaQNu+RpPWxPf+7/wiX7hN4e4vSAv/HqJQt
	YESrVbt8zepkqqQDsHlYEKVrWuIk/fh2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Sc+3hD9PUHVnU7eHc
	YkeRmCn+aSOfXPx3/0WwzPnQhA=; b=E68orFrg+5/4GXlsdybfuz0zDOh1giz9H
	za/ep5EhcjrONgwSB0n/BSXm0YPTl1mIXXT2zpVlL0IBUkc3JEvA0UiZEVshLew1
	9/VvcGdAmx2zucyXzi45Nkys8Uu++dKSq5o96glu8WvEUYDrfHoP/vsIeZ8K6M01
	neERYquLm8wG3RaqIzDEsr+f9pRAtGLoKC4XilU0rz4Fzmdye6yscFbKltpXE0Lv
	xd/fMMfpZPZtBC6njSkinM+EEr5VpwQTMSIcRzTi5Doh/taPOahEjtwXq+7KZQNm
	sExkmF+6jXGgQUXs2hrwYHh7rr0pydH7d2w3dFTa7wpRpwwJEcScg==
From: virtiofs-bot@sinrega.org
Message-Id: <74319.121102004012800803@us-mta-448.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] Issue opened: Follow-up from "File
	handle follow-up patches"
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The following discussion from !41 should be addressed:

- [ ] @marcandre.lureau started a [discussion](https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/41#note_703625402):  (+2 comments)

    > I like it even better with .rustfmt.toml:
    > `imports_granularity="Crate"`
    > 
    > ok
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/issues/16

