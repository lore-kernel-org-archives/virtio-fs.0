Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1649806309; x=1649892709; bh=7j3GU+tpEUCt3Uhl+C8vH
 IThAL9reYlSZrNEIKG9Ebg=; b=dfdO5MzcSJ/pK/XdP0UMAIue+Oh7KWcW1E5ue
 Phr53iIrHciKb775/PmFYpXA3W4VOVtOkslCFa/zLrOMi47XUHCeuKboSi5cLE6r
 8GYXONqDgztuZixaWPG5A1TUzUrqenQuUAtdw5DHySn9oAHwMFREmCI4X5WUTxV9
 9vOrtF9k+pQCHQ7xopeprypWvTCygbm/CBQPYx/sKO5FQ8jOIgl+bRkXoGtxuDJH
 swz6GWQdw/xYttKUnXMWqSRxsQWrygAMhaABWUyZF0KiiG1K6dpT0oiBwSvkgoUE
 CkGFl4UZNxR2KRJceDproDrgKlEMDUuGCBetOc5rADNt52dCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; t=1649806309; x=1649892709; bh=7
 j3GU+tpEUCt3Uhl+C8vHIThAL9reYlSZrNEIKG9Ebg=; b=ZAo87agaJsdhYMj6Z
 6+Z37ZxLI+ZZ8+ldxmQc5NwPlq1syXM9F+gk+s/nEfNi7vDe8zThBX/P1kO20nF1
 n4CYUyAMa9hLHQ3gsBzv7YYvejpqHU5VxxlBSA9vu/K+Mqkp/MWrsxtw0ee1HX3Q
 +wfgv9eIStsxdVyIwLfNLmXvp65jmcoukmEbanux59jq5Pl4EBUSqLRTQJ/EjlZD
 zHMjvZyxvR+Pz6tmz5UKsHYRAF1lYcWIIfgXXqcrGRa78zFFIF7WxvqHyzKIATu7
 zdRRP8H1O+CWDxmQCEZI8Mfi9+ULAN6hQhW1BKsjtfxzGZCKegkV3Ep8d8X8WjrJ
 EiQ3g==
From: virtiofs-bot@sinrega.org
Message-Id: <76194.122041219315000525@us-mta-546.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue, 12 Apr 2022 23:31:55 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Fix st_mode of . and ..
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

