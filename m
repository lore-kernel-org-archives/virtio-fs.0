Date: Wed, 26 May 2021 11:16:05 -0400
From: virtiofs-bot@sinrega.org
Message-Id: <83124.121052611160004043@us-mta-542.us.mimecast.lan>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=PmUzP8GmchLKVELVi
	AMDrb77DBTWkxpBWf/zg/LRoJE=; b=O637PcjBtdCyKVdCjGGQsD5f81nKzREY6
	LbskQhO9n/4xh3gimiFVH13in87JqjkQIjazzoL/Lz2rQEo6j0wqNWRAaMTY58cK
	Q9BydmfE9ymUE8YGtL8gDC5Thg178dNV8VgqtRcGxacfSNlfw+arKF1glIySeU9A
	45E94aqKIPmXCXQb5JF1jorLcBzRtN8SOyNTc0Vqu9FD6Or/SYtPHUyD8q2snOEB
	BwDpbtWLI5t9WEqxz9AYOllq33Yfim1COdVjJZYFxajUdWDPSwNru0lT+0eHbN+f
	T+q0K57EG4sBtO102/ud3aUuM9I/njULRF7agHSCFEhDhgEbQlH1A==
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] Issue closed: Build fails on aarch64
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

