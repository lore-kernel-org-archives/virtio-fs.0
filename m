Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1650282621; x=1650369021; bh=7j3GU+tpEUCt3Uhl+C8vH
 IThAL9reYlSZrNEIKG9Ebg=; b=iPurQTWqrXGo0A0fRL6JjHStyhwKMOfP4Px/S
 lnw9SppxAHUEsMo3uNAZ0lZw2s8KTRTxii26m8r/tHZs/3pAuusgAprs94YDdw86
 buD9BQpMdWXO2gg3Iw4rBXrGwxJT1BTXZENlP6gkdujQ/k0ZzkO5c8MJO13ZJMpZ
 ujAlSB8CQ/ehPrqSdopoLVv22gRPJwPLNPhRNPXDMD19xNmIidYx0hEZpEkihG8s
 IHLLs6MxO9tqlQruymQbgovEVzG5fND4PwZDHmbC0U/kUCTR1AaBI2TFDKGGelBd
 U5O5lw8W+mVV20Uhm//aziEmK33lonbg3L2X9VZtTEcpxwypQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm1; t=1650282621; x=1650369021; bh=7
 j3GU+tpEUCt3Uhl+C8vHIThAL9reYlSZrNEIKG9Ebg=; b=JLkVvIPratR5xTV5E
 M82wjiP8TXe8kkqjulAXpu06w/ntsdNWVvYNB5uHsyAoV7v8ZYbL2rxJ5uNjqTb3
 CiZTpO6WXc9u6/7P1nmu2yUAEwcQa1f35Gn12FTPf4KbjxmJsJMTehor0jaUZDBY
 lzDLpQjPiIMtlLWZ9WxV0P4AtKMpU34G1SBMUfLYkuJfUr1g/tc6ZOlBW8uo+G7U
 S8kSm1P8JkAy2cCnmi75pt6q0JZvEM9wmOHiNUDJpDWNia/AuOR9txdoT03jaZrg
 PkZRUuoq3ga4QkFXCwMLC9skIu4UJbdJWqI8vBw0aUP7T2cMwycFRGEANIwmp+aq
 i3RaQ==
From: virtiofs-bot@sinrega.org
Message-Id: <53048.122041807502300396@us-mta-668.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon, 18 Apr 2022 11:50:26 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Fix st_mode of . and ..
 directories in readdirplus
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Generally, `st_mode` (as a field of `struct stat`) is made of `S_IFDIR`,
`S_IFREG`, etc., but `d_type` (as a field of `struct dirent`) is made of
`DT_DIR`, `DT_REG`, etc. But these definitions are differ up to a 12 bit
shift.
It leads to incorrect attributes of `.` and `..` in Windows guest, so fix it.

Fixes https://bugzilla.redhat.com/show_bug.cgi?id=2074311
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/111

