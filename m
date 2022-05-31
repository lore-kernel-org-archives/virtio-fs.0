Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1653995623; x=1654082023; bh=D7YUHBa6+KyhoQcScapzs
 qGNYKAJaOLLu+8ztpsXNi0=; b=GnknBq275mogR5WFzPeLks8ZIwEbW9y4EjUOR
 VHhAyty/Pgtn7n5B6kjV/9e3ypZRINIPmsKKyKgrkrLx2AQp21TPKoB4VT0G2g+2
 i6G3D1hmrNmwU6bi1KLa4nc9IE/4a/eeSryvO361BTqeaLDLoSMWC70/r70rUfvd
 2TrD4MvjHpcyb7RhOk28N6+2qWff5+oJk1kX1IohXi7oNu8JNjVGa5NEeL0UZbn1
 wToI8NmbI3f/iQaeq0IBWDSIk3AAuCuHAndnkgAt5KBPbYo0lvtNUXE4PhgsCr/M
 1PHR55JSusbtYNRQCTkOElsHEZ0rYkYxGamf37RQL0oiIdkyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1653995623; x=1654082023; bh=D7YUHBa6+KyhoQcScapzsqGNYKAJaOLLu+8
 ztpsXNi0=; b=ewdynhS4Wk4/0AtsE+lIwHtaoGXpOqzMwAMEufFHVT3H01OwMPA
 FeqOupC2fNmceVcnIpEohNbGGr95BXMKDeKwB+zfQpDCC6JG0JMmmDNXQEw75FFz
 Gczg23ksKYTa/RWUmqIxkuIS58CQ+Qpb6/BC9f9eik1pK+NAsGXqFlM2J5U+tvSo
 0T9Qyb98UPrEy4gOt1OIon1macyywygnXgZKDFrqqZpzexPxIRsPG+2MhuW8+wFF
 Cc3vXnCzyyPuhYq+V7+BrD5j0HZXtcpAwH/c7peii80HU77WgN8w/Ax0GjHv2WEW
 9+XrMz+igteSxcQisndxQ+p8MstmUf8J55Q==
From: virtiofs-bot@sinrega.org
Message-Id: <31738.122053107134501218@us-mta-557.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue, 31 May 2022 11:13:51 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: implement std::error::Error trait
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The seccomp and sandbox modules declare a custom error enum, they should implement the std:error:Error trait.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/121

