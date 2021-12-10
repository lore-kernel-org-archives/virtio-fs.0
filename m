Date: Fri, 10 Dec 2021 14:01:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=Fl1+W79WtLLqW+q1VMgQ9M6f7SVQXjRNS+Pmw
	1X96cE=; b=fKMyzVS7VnFt+bUqtsVkomEsqQksJ7aJD9ENd/+aPsNFJbE7QXNlJ
	T6qA3S2aNkZgwyqBMpj6TpP963c39ojxdNbnFig5fp2CiSpHqDcyFgNWv8OYJfQ6
	UdlXTxbTT/Pb8JNmeiGvrA05Jn1hZxevKooz1+lsinZGRAqOVaguPwpILarbOdu+
	ahfKZ6kfgp3cKiLYUurS2RoDJJA3Ke6e7RkEv8jtuQyhRnNziZoBftXhKVGyGcQF
	JTpo5z1VbgsWse+qZZ44J6ZxRBt890IKcbE+vwv3gmHGcsy3I9kgDHz6o1SfXguv
	ye2wUOmV8iLJLSyj4p7qyS179ExeSBLIA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Fl1+W79WtLLqW+q1V
	MgQ9M6f7SVQXjRNS+Pmw1X96cE=; b=Wsab7fs7ZM897ZKYrcx+7k2aSV3/7Cs/M
	YfvJUJjVhhZVrxHE0RCyJIa5HePqNvzbQ/RrJTQPsmFbA67b4fdP1Er9kpXK0tsE
	wAUM6hQYHdYULE33IBFG1HgZ9bjuH7kc0vWXQ68qL9kUxyAa+QGq5t0JUaHYlfA9
	jyC6aaPVxxT8Pid7H49VtEOZBs/yfR/0+rgfSS91Fd1aecFqw1SARxOxZuyKllQL
	dhofEZK2aQVjPKFhdJUpzqjb9TU1QKXsDkwLrAKVfaab40JoRAw826bPalWIvnky
	2Ey0c+W8z/MFf5dTQhR1Nwg1rxXBXFBGFjCMnCw5K0Khd3JUDSs9g==
From: virtiofs-bot@sinrega.org
Message-Id: <64174.121121014014001321@us-mta-260.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] Issue opened: Instructions on building
	and installing from the source code
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hi Team,

It would be great if you can point me in the right direction for building and installing virtiofsd from source, thanks so much!
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/issues/18

