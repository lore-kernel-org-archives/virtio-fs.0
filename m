Date: Wed, 22 Dec 2021 08:25:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=dBaWyPD5bAZgMfFYuuejzalriA9ri8tFa8yUT
	XCldWs=; b=y+vYtr2NZGUdrXHnpYZneHawjrOJ7WCCq3dgJBEbwcuoeZWnSUF/J
	DOaSQAHk1jKuMH+7KCKelKGEe+v67b5aiw6LNX5VyOQVKeHwTIrBWmMz+lQYpL8n
	6Y8xniyASjs/XP2LHs73LBR8F8rVzyNt1b+55eXbptAVH2qQ6IMfduBtnQFZI+6s
	JcODiZjKVrOmligLkR0QEcSQgN6368EhoXIEagJX038KPSTA9a9e11l7KHhKYOiu
	hOETpFkxpIpQjUb8aumFC/GdAD6CNuRT3P3tlb91+owB+FKmNmsgh9YzgqkBWT2V
	exdc7oX4ymEy+9iKz9ra8MfzF7TPslxOg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=dBaWyPD5bAZgMfFYu
	uejzalriA9ri8tFa8yUTXCldWs=; b=SEXNo3HH45lOqGowsB8u3CoHc0d2ywZbN
	Kxd+ZfrSXQle1bYTGlQ1E1POGjHbbOy80J5E3/Fl+3YncoomR+MhVxSw2xx2WTEy
	fV+6DYAcQqD7KqdfbQMpNQ8HH9ZyGlqV+fDJJQNFFWxetq+b2U51/qQ5Oxp1ubic
	ICNvwNOdIzS+YGbSQsXdPkB/mlePoD+bU7A29k9+/fxX7SRefXezeaTcfUF0PaYZ
	LqHUUdC3wJTWXWwXHBhASWFY0VnqJeGmaxUOrAHMKJOPIkdO2QeSAEYxP/v/y9V1
	7oHzrTuS9DZF3t97B7+uvqlAC3eMVcd+8oqHOR1GT290GfNkQOZBw==
From: virtiofs-bot@sinrega.org
Message-Id: <51695.121122208255000419@us-mta-33.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] =?utf-8?q?=5Bvirtiofsd-rs=5D_MR_opened=3A_Strip_share?=
	=?utf-8?q?d_directory_from_mountinfo=E2=80=99s_mount_points_with_s?=
	=?utf-8?q?andbox=3Dchroot?=
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

When using *sandbox=chroot*, `/proc/self/mountinfo` still contains the pre-chroot mount point paths.  To open them, we need to strip the shared directory as a prefix from them.

This series does so by first canonicalizing the shared directory path, and then (when using *sandbox=chroot*) stripping it from every mount point in `/proc/self/mountinfo` that we want to open.

(Reported by German)
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/58

