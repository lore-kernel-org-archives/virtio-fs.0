Date: Fri, 17 Dec 2021 05:13:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=2gDz3DoJ8vd7cBtlHaq+vMboZ+g3EiPsJxmLm
	hhAaKU=; b=alI8IMaa0jR0FHeAyzboH46WAF//Hog/b+Y0S+S08vqzdKc4E7RKb
	aj3CZvuvJBV3YjA65xMj/0TOhMc3nA3YK2Uy9/3rTuRL3AOiyROx04kC+TcFaiQt
	GFjzSRG/vh1O79XSzbzPuTtJ2jlnuNjfuenwzBEmdKRo/FbN+3CaDD/csBiR+sPv
	zEyDJzNss992eJ7OzqI/jqtEHNJtQf2EOug5/5o4Aben3u3YA3MIQwF1IHkx/a5B
	Rwm2mXIbDs/JgrJftDENhDgIUDodKmwio1mVWyGINml2UrwnT17vizGmCQbsDgof
	xrhku6pUKjq8DLn7kuHsRcOy/IBo6zS1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=2gDz3DoJ8vd7cBtlH
	aq+vMboZ+g3EiPsJxmLmhhAaKU=; b=b+wjuottF5ICLtWH+CTKB3liQglnM0oNY
	ttiZx5AAc6l1J+poUoLFNcVYVy9c6FceuPCB/Ak/CocjUA8/JyWmmqpSsIovl3xj
	vT6SEefB8AQiFGSHtQiuXF+rbjyLG5DZjogReOH1RtbMk7upeAUCQgzhfYTz4QoL
	nXRGhuf3zyJC7xnekACgfNoOZuH4PLkwwGv3ZNZomzVTEMNFNjSnSwucRNP8tW9/
	Aj9hRJdnSj3WDCYTWAHQqds/8kwUinsdj7Cx62Rte2mSJJjGexg5hUIj+EZIrjlV
	TliCEHiqzErWfAo1gCV9IVTt29nl/QPz2urfmHvxvEJsJy8lDoGDQ==
From: virtiofs-bot@sinrega.org
Message-Id: <64827.121121705132700346@us-mta-381.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR closed: Set up uid/gid mappings in
	user_namespace sandbox
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

When using the namespace sandbox mode with a non-privileged user, set
up 1-to-1 mappings for the current process uid and gid. This allows
both root and a user with the same uid/gid in the VM to access the
files served by us. This scenario fits nicely with the "shared folder"
use case.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/16

