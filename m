Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1652088956; x=1652175356; bh=KApii7/v/FgU82VXx1pUr
 M3k2RYPflEkwoKPpRTx9QU=; b=Fb13C0MhjuQFlToNyt2EAFq3paiL22g+UkmIK
 JkN3fn6dcLsQsQLYKVUCj4ADsQJ+azYYfXaidpbC897XJvXPt+RatG4MYXl82sb4
 Q0w88XVmRjzOIXIvrEnQw1krmIBwiJauExlPGGsvhzXL08h58XxX9rba+MVgtrcr
 /cfwC/MviTpVWY4zwJuwsa7Acrm23PSMVQLjKAFFhRLlPUtabnvS05u6yF2SxJqo
 HyZTVnbK6KCx17RhDVicS9Wls0c9VEpKGdALkCKPK/wxtHHQI/RySnU7kJOjpDgi
 oaKozhxoJf++gBy+iEJW6K2UrNcat+5VIyFuH7peCKw091bgg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm1; t=1652088956; x=1652175356; bh=K
 Apii7/v/FgU82VXx1pUrM3k2RYPflEkwoKPpRTx9QU=; b=LEUGRbT+6DoePskv1
 vDrjZAIMlKRPA+OlJSCDCptIJ/kRZGnEIGeLwSpYcoYMQMrRn2QqNol+RMQ82TvK
 bdmIfjIJEKgmNC/9bHb6S1sui+1WZgmPwFt6O77MCUhTxnJD/DDP0zYT9D/tp7kl
 maY+ef5MNBSTI85CRhFrX5Op2kfOZjPP1MlBo1pFUn4HxOd2jsnQ2SG4OaNhC+4k
 9yWkrDDRPuLFRIvGxl54qsFodzMbaJughnu+NG33GculxmVBn4Wqd7NHuQkWA6ge
 GWHJ00e2N4eBrErraXmgjoak0qTib9/gq3Lduuafn6XUEdNMBvYGMeTEoCp+Pg6n
 Bc3Fw==
From: virtiofs-bot@sinrega.org
Message-Id: <58955.122050905355800339@us-mta-643.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon,  9 May 2022 09:36:00 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Allow only one daemon to bind
 the socket
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Currently, more than one daemon can start using the same unix socket. Although only the last one will use it. This happens because the socket is deleted before bind to it. So, let's try to acquire a lock file before removing the socket file.

Closes #31
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/110

