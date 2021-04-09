DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	to:subject:message-id:date:from; s=fm3; bh=uUEFZi1fbWEKZ8f5YDGs9
	0KErAdKbfrpzgTjNw+EMTo=; b=expgcwAmQuEPDYt/fsRlpynGRnBOxoxjNCev8
	ohPnis7EDBqMKNQj7C+NioBy33AKiVIEo+fyYERWDHZaS+4+4TXtU36p8C1r6ma/
	W/fjtNV2LMSfy302kPpOZ+qqK1e23YI6b1KJjjdx54ofOmsUOZGKuS9yothl4VSb
	w9LMBk+PfpBPFF25cU6Jx2+SPHLfzt0DPZh43DDJV/AkC+bAW7BTxHhjEzUX1A2p
	wydTspy7jExa3B+h/AHZ/m2VvHJe9o/ZhvHzDA4xC994wzWIvVE5PGAcFib45e2A
	nUmF85LSYff9wrNmIL1gEjiVqW+aJVngd5mpf/T9klT85wjSg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=date:from:message-id:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=uUEFZi1fbWEKZ8f5YDGs90KErAdKbfrpzgTjNw+EMTo=; b=Cc1djQIw
	vh2dgazuDqgddKmBWqrTajneCaTNJUJrenOEVvyVT68XtHvoyOeIJT92qvvPLJnm
	juVZ7HNjgE8qHN9ZlgrsbZj28PjH3so7ABsiSIw9wpUUX8nFwjQ0CN9rFeLHYY90
	Gy4+mH0D3L/jTQXTRvqzpe7x3K+o2NXKwnYw/puWp03ALZpe1KL43Ud1pQ9eCHFK
	0OTGcariOd3uSWsEgBO5HK3NlrAOdjA5xvBonrSRznHCGkDNAXKJkXp7vqQHeRyZ
	pdrRYQbHvgVjfNNKsIXCnh+exJjgl9Z+M1Qb8T1KLUMzI2OMFgaoCoz7gsY+/rPD
	PcO5W9zu+gs4jg==
Message-Id: <20210409052933.EA8F9240057@mailuser.nyi.internal>
Date: Fri,  9 Apr 2021 01:29:33 -0400 (EDT)
From: virtiofs-bot@sinrega.org
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Refactor arg parsing code
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This merge request switches the option parser from `clap` to `structopt`.
This reduces a considerable amt. of duplicate code & improves readability.

Internally `structopt` uses `clap` but provides a nice way to define arg parsing in a declarative way. It also re-exports `clap`.
In the next upcoming major version of `clap`, support for the same will be added to the crate itself with the same syntax, except that `#[derive(Structopt)]` will change to `#[derive(Clap)]`. [1] <br>
Also, beta version of clap-v3 is available for testing. [2]

[1] https://github.com/poma/clap#how-does-clap-compare-to-structopt <br>
[2] https://crates.io/crates/clap-v3

Signed-off-by: Mihir Luthra luthramihir708@gmail.com
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/17

