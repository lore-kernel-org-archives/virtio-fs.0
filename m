Date: Mon, 17 Jan 2022 07:53:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm3; bh=/WeDeqWb8vGhDA/ScTvKBpzrgSLnmXlQZycmr
	V4q7L4=; b=jHzAO7XqAxEY7ZlhGUfoWav+OHKmuSdcKCYX6iX7F40B7g/+uZUyp
	LS9oqL0cE2RQShnomQoBiDutMh9Q1/QVWWMRKljrGLXyHyrWdzgaakFmsfnPhyMj
	1ulwdBButP1VR0CVo6ZDXZB4SFQoIDh2UoF9hJVf5FU+T8PIn/NdM+GdrNxcm25X
	0iVuC3Vn5/MzljKV4F4z5Rp2RYMNFhTECJKwrzkmv44L01hOyZtA1li364Yr9S8K
	fc9gp5hBAyLH1O+jiYQGRUE2dbiKWH6bdZegGodqa0XRVd1NR7kbliQZYYzgxs/t
	jL8IIVsM3m83ESOWLpduySWzC8hyZL+Ug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=/WeDeqWb8vGhDA/Sc
	TvKBpzrgSLnmXlQZycmrV4q7L4=; b=gCoPc1s9cF1VbSERAt7gfZ0ktQLwS0Plc
	bPUb7hhawOuRvoPGhAgN1rk7DRJi/RhJB3ZxDH2zXLnnQ8X86Sd4AXZL33a8wV5A
	ciQA3OGrI/Q5wsNWycY9ugsxy7l8WVtNxenXw1yOsJOqxw6AcvARNQ/IVIXVkgKu
	k7t/B2ybJrBw3eg6L/ml7jo5SR0AJ7nvg0TaPFO+zqdd4PwIKY3Rlx7Cl+mSWUgI
	nPH6nlkeoolbhp0TENrUMN883Zs4IuKjkQlbnPTJN8m7UefULkk+kcsBDT9vuH3E
	T5wipx2bRR8f67CtS2tk33ui1h6EC7FcuF3cPiARP+nSlkCOYqnGg==
From: virtiofs-bot@sinrega.org
Message-Id: <97181.122011707530600693@us-mta-383.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] Issue opened: Indicate an error if child
	gets killed by SIGSYS
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Currently, if the child gets killed by SIGSYS, the parent indicates no error.

Q: Should this be a logged error, or non-zero exit code, or both? Currently none of that happens.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/21

