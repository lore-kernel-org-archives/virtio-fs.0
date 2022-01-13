Date: Thu, 13 Jan 2022 17:51:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm3; bh=rWkubUZNhMjF2IwGu3Wz2q+r941eYzc59G7cm
	c0jG8Y=; b=VWW1FzMyWTS/UTF5EMM+OEO169RawQW8StaVhczpxU/QdMt0IGp1u
	LvtO/+GOj7ry5XdmbGrH80URrUxNBKJ9x/TrZCOFChJGdApgpIdOLUSPYzd2hVIb
	HtoVSBrczgfnNt7FQKiVSY5GjGVjMufpsNdVumyMGutxehhrAxQeKp7K2MFnXz74
	Rj6gKpGOjBjqqfdX2ImiKf+7rH2M10FpNWilCnHkSkp/NfETwD+06MEuEFlkf0Rm
	tkaToOndKSu7O2K/XEaU8JWp7co+XDWEcsNcX2VUFttrrbHeGNczUZlGbk6FHQ1h
	LhGbb2Rj56iJHgN63Z3yrqvSkG9amoTUA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=rWkubUZNhMjF2IwGu
	3Wz2q+r941eYzc59G7cmc0jG8Y=; b=eDGs51wp/SsG9o0KYuUu9jVoHGgtMMNaF
	2TPbTIVqPKRW1XyTb+VoMt9IAei9breD5u511gTplSZB2Vu+oA82hnCHS30EXprV
	Y2L8xrVA7B4kespLa5MOVb43CPwHkbrF5tgk9bnPp6X+ulBhEppBvWv+GL89hORR
	NLpSEV2Pf0tx5xD+q+xE1KcYR8ZDKUFA4+2fuZbNnCMZP1Swqah4bGvrJr3tN2yg
	FfHr+0blAm3Rx0BD0bYQN0RRsPlIDMDuqjtmDrvuCrdRlNA1pkMLyEYd48pdVo+u
	mj3AZGVqfrq93treTUE8DB1bvgiWbHwnzh6r5AtD/f+7q4q3W664g==
From: virtiofs-bot@sinrega.org
Message-Id: <76818.122011317510801303@us-mta-448.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: sandbox: Support combining
	--rlimit-nofile and --sandbox=chroot
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Related: #15
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/65

