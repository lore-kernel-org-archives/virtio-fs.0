Return-Path: <walters@verbum.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verbum.org; h=cc
 :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
 :message-id:mime-version:references:reply-to:sender:subject
 :subject:to:to; s=fm2; t=1664460297; x=1664546697; bh=6c9uJDWIOl
 89ZxQkBbMaSnvr+ug9AMGnNuidFr3LmtY=; b=GttC4fgWqCh+1eK3V3dq4sQo7M
 FTiTMtTCuLZG5QAAPljvMpgpfX4qapankAOcQjNxCdJ+YtoUwIYVPZGjmOgMTUl5
 P2zTbtYoJisgmRhvIdnDrCuxWXveS818H7DiDnpegvPi2s73h4YurO3zfzJThIA1
 Mypy0nPtSfviJ02OWhOJa+GxyaY00xtHGLEvP7L2d3FI6akKL9wbKJUyKPvGsrSp
 MVBSYtFDnuoMdniYFGl82tgRJ5GFoWhz3mi5LCdqeU+2QJWIZgZFvk8FtvFrAnxG
 AsUQhQ7HiytyZqNTJYxepWfUPRtV1Ep3U2HG1pLUrG0J4rCDnJe0k/M14L/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
 :feedback-id:from:from:in-reply-to:in-reply-to:message-id
 :mime-version:references:reply-to:sender:subject:subject:to:to
 :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
 fm2; t=1664460297; x=1664546697; bh=6c9uJDWIOl89ZxQkBbMaSnvr+ug9
 AMGnNuidFr3LmtY=; b=tKHVDLaurdyRCkP/OVcyokAfjIRvsaiLsRon2pnKqW3T
 7MVI6uowETV9dusJ95VsIx3h2T6ZjhS/jX3OGTeYknOYN/S+F01d9mkiDHbW5pE6
 DTzwU/3zb2TNFhCGaLY1xFBK+mIA4vwK2GlIVNsruWpQvEz22MlIYyBvbZt1afAg
 v0IJeCfUYvi/CMcICUyYRRMCodmOsJY8CLkNHsewa/Ect7HKQZzPNWS54BKGLsD+
 X+I9LHkWKn41wG7NKBVXTVEX9r1SLSJ4uP3Ujz2e8vmfT2PdmuSQLkpz7MRJQjnF
 9kQ1GFdSUg5LJcujRcdX3MAoCKz8iYSj4KYtMElsHQ==
Mime-Version: 1.0
Message-Id: <b963f623-aa85-4285-9bfa-5fcb4744c354@app.fastmail.com>
In-Reply-To: <YzSgeDdpHOw1hTM0@redhat.com>
References: <4362261a-c762-4666-84e2-03c9daa6c4d9@www.fastmail.com>
 <YzMmu3xfOtQwuFUx@redhat.com> <YzMrYAJQeSP2hDSs@redhat.com>
 <CAJh=p+5rQDBJJC8VNGL10KYgDeq-Hg5WK7avONCti03eJGH+ow@mail.gmail.com>
 <798fe353-9537-44fe-a76a-819e8c93abb5@www.fastmail.com>
 <YzNZnPiUqySu6sGh@fedora> <20220928083340.eyizwu6mm3cc3bxu@mhamilton>
 <YzSgeDdpHOw1hTM0@redhat.com>
Date: Thu, 29 Sep 2022 10:04:36 -0400
From: "Colin Walters" <walters@verbum.org>
Content-Type: text/plain
Subject: Re: [Virtio-fs] virtiofsd: Any reason why there's not an "openat2"
 sandbox mode?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, Sergio Lopez <slp@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

On Wed, Sep 28, 2022, at 3:28 PM, Vivek Goyal wrote:

> Sounds reasonable. In fact, we could probably do someting similar
> for "landlock" as well. 

Thanks for the discussion all!  Can someone (vaguely) commit to look into this in say the next few months?  It's not *urgent*, we can live with the 9p flakes and problems short term, just trying to figure out if this needs to be on our medium-term radar or not.  Thanks!

