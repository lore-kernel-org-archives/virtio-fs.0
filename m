DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:from:subject:message-id:date:user-agent:mime-version
	:content-transfer-encoding:content-language;
	bh=ZKDagw1NBf9UT1xvBV68IXKIQnx3WknZu/hNz3E9pgI=;
	b=Uclvpoq4t97uBrJoH00Uw9JA98Iwqu5eRHxbQdTodk4CKMqSPc5v4uP3ihRLFX5J2l
	OJj6ui0yEdTeY/3eEKU3Ieztd+18CWD69kvCPiXK8+zBsvMT0u8zCoSQPhUzFp7cvdMq
	wPgKV3xyDwrDOBOGTm2f0CuiuOJ1AUkw4Z5C6EywFvphYdWnPTRGZ2e79E6x7pIvw8pK
	q7M95F5do3jv8iwRRH+PO0hoyiyyoyvNPaVcvI0FJ7wmab21ntlxXQh3zIo7fiIxbh2h
	69dPOko103/ZV1ofniJX0Vn1PAoijSsnGWu6+hH53SMrfodUNpLHFsvAdNlro+8na/gw
	HGsQ==
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <492294b2-b305-86f4-2c91-a2faa766d2ee@gmail.com>
Date: Wed, 30 Jun 2021 14:58:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] multiple virtiofsd's + overlapping shared subtree ->
 enforced compatible xattr maps?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

If two or more instances of virtiofsd have a common full or partially
shared directory tree path -- how will those instances 'enforce' a
'compatible' xattr map lest the host+guest(s) have quite the selinux
attribute salad?   How much does virtiofsd need to feel like nfsd...?







