Date: Tue, 1 Feb 2022 17:01:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=nwRVoize8rE9rdF8iLVJU4u5ZVs/nfq5l3Fz2lix83Y=; b=X
	Lzqlzx4BSo8svA1ToxfCe9an28/wvPxSrnGBfLTY083VLoFx8LrUa4q6HZqBqH9Z
	YynFJQFLBdh7Nzuke24HvI+jXuASLFW+4EcnWIr80UO/KmBznYH/kmoKEvR8DtIN
	+V3Wj7STpxFZ31cKYoRxfDafFiKqTjQ54EmNx3Tp7DmbAVw48zx/mc1vXsqx73wa
	czrqdlqnRFmk46QAirwO02QyLNIoDKfPS0uvivNRani49zB5u29YjBHTJzjGY1U9
	neAKkkafBtkhr5Q0cPPfp4IQnUjT+u2uYUbklqCv6FZh01JHLYEaELuwXt5nNDKb
	K7QQ124cBSD7X2EBTJp/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; bh=nwRVoize8rE9rdF8iLVJU4u5ZVs/n
	fq5l3Fz2lix83Y=; b=Ti7WIV3RF5nE3D1mwbnW46wym9us+LmyahgwOx1T7SlTf
	cMyA6HTYVtmbFnwcaneOLenx2Aawv3xpG6gg1VVxsZIWtfki7Whd31JV595D9jfx
	UANCkuN/6RdhzhgOEtT/qV/HXdkwxkrDHoNFalP/dKbflaQ3lMv7lsiN3jQLbxy1
	KoLye5lVIVfndVWyL5H2yHbtWymyTmEm3LQbcKYVjrlZHedWEwRp/eSSXuMDeOpV
	cisPY2+OOr6q/xy3ukIOw3vhTZ2ywB+GKp1QFrAS3tLzEke1q8+sAc3VlfpRNTSy
	bkZp5RsCSd/liuNP+KGHFB9iZiNX1DeDJXzmXWz0Q==
From: virtiofs-bot@sinrega.org
Message-Id: <06332.122020117013300621@us-mta-315.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: Handle FUSE_INIT and
	FUSE_DESTROY non-concurrently
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

- Replace `futures::executor::ThreadPool` by `tokio::runtime::Runtime`.
  This prepares for using tokio's implementation of `RwLock` with
  owning lock guards that are `Send`, i.e., can be moved into other
  threads.

- Handling FUSE_INIT or FUSE_DESTROY requests shouldn't be done
  concurrently with handling some other request.  To enforce this, we
  require an exclusive reference (`&mut self`) when calling `init()`
  or `destroy()` functions.

  Furthermore, those requests (FUSE_INIT, FUSE_DESTROY) shouldn't be
  reordered with other requests.  To enforce this, we lock an `RwLock`
  from the main thread and move the lock guard into the worker thread.
  Locking from the main thread ensures that all previously queued
  requests have already acquired their lock.  This way, those requests
  that require a write-lock (FUSE_INIT, FUSE_DESTROY) cannot be
  reordered with requests that were enqueued earlier.  For similar
  reasons, they also cannot be reordered with requests that will be
  enqueued later.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/85

