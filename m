DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	to:subject:message-id:date:from; s=fm3; bh=uUEFZi1fbWEKZ8f5YDGs9
	0KErAdKbfrpzgTjNw+EMTo=; b=kWX1tyuaLXR1UgYXee4Qu1K9uiQSpHKgosZ1+
	RpdxmbenGe5geX9YoMaAtUy5UzW1upv9CKJXzuuk2sHP+AZKnpa8gYYD8crX6Pmt
	DVhYJlJPRb6sawJXAOTq7lSDjOr3cc7rAdufSpFzZFkbuvTuLNQ8GZgstX/4gz2J
	EQZAYsLJGqkOlNpgc8ujctN5fHo9wZ9Y2QnbZZTFquR8k48cFYHVnkBMB3lBLt0D
	GJ2ZIqs553Xyhce6jHve6dJFLn4S65e1CJ3G8S3RpC6td5EQxu+MC1h45Tlfqg/B
	OusbFQHvpXcusZUvCNkwZ9B0sp04LOHSPZNTUpMNCDaKfua3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=date:from:message-id:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=uUEFZi1fbWEKZ8f5YDGs90KErAdKbfrpzgTjNw+EMTo=; b=Kv7UQWk6
	02LBJeo2edlw3m4yjQzb+Jo0vPCmSMyzmU1uJ8+8PbMwWAHtRG/WnpEPKkoveDds
	dkIE24KbFyv7aHIwQMn5fX6yMmA8teWf/cdduB+a3NPN6jlMa2fbHO/lYLAZrnA4
	ASpXZPLX0rOu+lUmSnx0Dc8dJ8r8pdX3OnxH0HsZ0sQ+avv3wSCqJARDiPaeTuPF
	UNSXZW0wvhEtDUPaTCJzDdThdpHM89ZTiqi3zbc5RwF1ru6iiGnMFUMwZ7jE3w2O
	bc2UwUAltNb7e7ofWePf3oS0tnppM45snjn3hPACQnXkpCRp5E0cy0dhUGmAbEhw
	L6LKlvZloGNEYw==
Message-Id: <20210422125951.A7BAA108005F@mailuser.nyi.internal>
Date: Thu, 22 Apr 2021 08:59:51 -0400 (EDT)
From: virtiofs-bot@sinrega.org
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Refactor arg parsing code
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

