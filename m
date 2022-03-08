Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=BNnE3HpM3Kz2IPMF9+K3CNCl3RrbJeTWsOeOZeyEKy8=; b=M
 pnpqzxLcK6MTWI/Siu9o7R+b6bGGIV/So+8eti1ZRUHJx73NMZDedDXS/wVIhxnp
 BSs9QsL4A8LQtGQVTVZ6oaselrsSrt/f6c/N/5x+poySU5+b5NTUvUfzWoOFACCf
 l0UHvs/Cjhh6vO8RnDFU/qGGnEFLckQlY3HLiazejHXiWz7PTZY5OSKuhXZlBn2I
 fhzfH1uKyq1CvgWldyWsHXjiKLnCtifXLXOX21bZaYb+2MHjy78YxZtZYOHEgjhX
 xLJc+pi51rNUpXL+OjhqeltzyQ6NaE/TyiunrLs3WwCgQuBZi7sSY6Z5QI9uHoy2
 BUnI3an7N6GOfZ15oMX1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm2; bh=BNnE3HpM3Kz2IPMF9+K3CNCl3RrbJ
 eTWsOeOZeyEKy8=; b=cTF4CQl3XIdyMyQ+w8JzgU6kx7XxL1Z+EnxfoRMrnONpY
 7NyJ/yYG3exJuqELjH3dSZoUWhw7+HCQIc4CcIMT0+ZtwgjSFF80Yeelp7r7plCR
 GqiqYfxxTFkrHc4dnCKA3OIL0m3T2fdqzvusrir0H0itOVV24kPigJ/9UB5bEKLa
 A4OrQTn7r/+iwXSY12pyrNO0dM47Onftmm9DYd2YeqfF0wz5yU61TxyS87yuISp1
 UgkXSpCLpgkp41VacFkmEMGgVV07YUAdlZctbW3dzZLb0aJHtmknvevH567d3+BX
 9gjZR2sbGwC68xmR3CXIGLQAZ3vmuLM+NoaflrEpA==
From: virtiofs-bot@sinrega.org
Message-Id: <11997.122030808341200585@us-mta-460.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Date: Tue,  8 Mar 2022 13:34:14 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Set edition to 2018 in
 rustfmt.toml and update some deps
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Set edition to 2018 in rustfmt.toml and update some deps
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/98

