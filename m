DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	to:subject:message-id:date:from; s=fm3; bh=WdYfPNcuhe0LRKPzJ3/08
	eHCdd1XwiOwCUWI+wPuGD8=; b=FTNQTom3ySIAO7N9yVx7b3jBLZlQ9GqC5cHNS
	025RLAnGfz4qWGz6GF4hUXTJoGh6pkfUMRD00meVtbbtiksZbL4Nfnixo04RuCmv
	RTpspONSwFim9pei/yDEY9yeGaO/4YXUzZmuR46OHlIOW0mWZDjBAizy7nqRcveW
	IpQVSDN/C59WC18YoMEY04lbTo5vsDFmNJY/A8sCBDOlYarWDjaf7s3XTXNfJIKK
	j6THpm6ViikXNn3WT8GzkVdh7bzPGKDlnRzxGUkot2If7B+WcjmuoqVp6GTgAUaJ
	/0mnptIyD6XOQJldIk7g5+2EqA/z/wghY47d5wEfZ4EdJbnAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=date:from:message-id:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=WdYfPNcuhe0LRKPzJ3/08eHCdd1XwiOwCUWI+wPuGD8=; b=j5T3hmV4
	jhJQpxYwECmDHtBYZPjlg1H02s6QzSRvEZR3MGWFDs7v+3tfelQp3NEI/aNQwLh6
	5NlzlBFrPEY/bTqkLu1P3EoCkWgTsVYgh1t+xarWyg47CsRsa7ua8Z2tFTPtn+i7
	4FwEwcgi7snMjp49mNiptUY1Eo7s+QQyvkVmpY55hc1Cg2wQdGRxzKrkJihhqgkN
	WbsegPDISa5TiWy8i+UTJ4e5KPO+ICxCPKrgAxstZ26cKKiFQ7io+pDGwuR+YBgV
	YNGUokZYNpDiV/4obNlfsGcPr5bNqHxbYgBFRE8HK0T9xZ1M7sheABN0J00qT/pO
	vDOXcQZCiK620w==
Message-Id: <20210416173745.C70F61080066@mailuser.nyi.internal>
Date: Fri, 16 Apr 2021 13:37:45 -0400 (EDT)
From: virtiofs-bot@sinrega.org
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Add packaging-related content
	to the manifest
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This will be helpful when packaging virtiofsd-rs for crates.io and will
simplify downstream packaging.

Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/20

