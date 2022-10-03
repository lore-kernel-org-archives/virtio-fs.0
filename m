Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm2; t=1664781094; x=1664867494; bh=DUEmeb53j9gBeFtqX0mi8
 OO/VyKCaDgUO+R53hkzIwc=; b=CfvorOFd75Mm6xRbg1u6wnpINnTLhcXMv2xSR
 LNMZIvXXtS5e6xOJT819Ly3/CEh9CPATEMlrext1PpjcvNJHFKXyHG5B9ZpBBknA
 oNnmnYHpkLE+j0vpQHFG69enX6h+633stzxJoHmuTfMhSiRrINlnrfmdgksM+LE4
 xaU1xFFhBAZ2IaFtLkP2abJazufit/JOuHjui7Rl7Pq4FWd5Hs5Um8pGMjh4kxrl
 Ve50ot2nsXT+KMQ4i31Cpi5zV4nbRzqKnO5t0iVTgOIEyTFno48ZYXPJNwWbYRcu
 k2yFOO8Ld7L2mngHxvS1iF5llaQOKnKW3gosZN5t9pc7m4i+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
 1664781094; x=1664867494; bh=DUEmeb53j9gBeFtqX0mi8OO/VyKCaDgUO+R
 53hkzIwc=; b=mrec5A62EyCDqzF3KXvWRM8KR6xYuVW+lTCqbTV7NA91GXGY3xx
 poGLITiUwDhVC7ZYD1kw5Twlx0hSXCu5d1uJeBOt8oo43RzYQp2uWzkuKef+lZN2
 jl/IOqBnTGHi4MzK732ZKUgDvkLuRB2A/rV8MoC8jSS0PZS1eyAIzAS1tgmSsZvl
 zr3s2oAe1i9IYDS4UtpR2glT0tTEkPV91W0+s6ASGomx8gKGWjXL0ZraNOcYUEwC
 bc0hibu1ScqHvw0kXJpzbkS5kDQkZmgrzpm9uGOH4Smnft8ywpKT65FbDwvmXImW
 hoIS77b5+emqWhrCHsAuY28T+6XQ+kkSSGA==
From: virtiofs-bot@sinrega.org
Message-Id: <77080.122100303113601218@us-mta-557.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon,  3 Oct 2022 07:11:45 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: [question] future support for
 file owner or permissions mapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Has any consideration been given so far for the possibility of future support, in the virtiofs system, for mapping file owners or permissions from the host onto the guest view?
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/60

