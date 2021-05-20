Date: Thu, 20 May 2021 17:35:37 -0400
From: virtiofs-bot@sinrega.org
Message-Id: <65203.121052017353200281@us-mta-267.us.mimecast.lan>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=PmUzP8GmchLKVELVi
	AMDrb77DBTWkxpBWf/zg/LRoJE=; b=mfn8PobV46uXmqmuDYccrz9pKO4gzhyD+
	WnWseRr4HWAnUDYSy5OZLEGP60LOno2hFCs2aaA8DszsWqHKjUEvLhw0n1D2oUp3
	xMNLHrH+aq3tArLOcuw4nuwE4Z1b7XXxLThidoKYb78b5tZdzorLH54AaJdgQZMe
	mEAGu5OELj+x54tKRtKpXvppef4b4r5yqj/BN2kiUJkFV39+flwDIVVtMuKrRLQJ
	MiY4OrtYCBpRK1CPDHtUHSuuVYzDWOt1cfKgirayBqWsJXg/LKeknvgeHM8b12RG
	Jqm7gygYd97bQi9E4NCQVYRIV0WtPn+82DdhQkW4iWT/z+yVQSexw==
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] Issue opened: Build fails on aarch64
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Building `virtiofsd-rs` fails when on `aarch64` architecture.
Here is the error:
```
error[E0308]: mismatched types

  --> src/passthrough/stat.rs:80:27

   |

80 |             st.st_nlink = self.stx_nlink as u64;

   |                           ^^^^^^^^^^^^^^^^^^^^^ expected `u32`, found `u64`


error[E0308]: mismatched types

  --> src/passthrough/stat.rs:85:29

   |

85 |             st.st_blksize = self.stx_blksize as i64;

   |                             ^^^^^^^^^^^^^^^^^^^^^^^ expected `i32`, found `i64`


error: aborting due to 2 previous errors


For more information about this error, try `rustc --explain E0308`.

error: could not compile `virtiofsd-rs`


To learn more, run the command again with --verbose.

```
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/issues/13

