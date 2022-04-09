Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=j0IPxDPNAUFBCEKXyPIHIkNJCPfyiKCIm15W42dTm9M=; b=n
 iQlpMO/RnMlJzqCE23fb4y39/d6kGsxI2PLTZnNERskYD592SImt08V5DWe+psLb
 9Dw5H5VNKcns7471ECVdnT9aDf8LvYxL9/3ERuCqEI0Yj/6zcR4s+UCCfQEMe6Dp
 NGeVPBVh75J9gpoD//1BFy92hol8hsghFGsuZGOOocz4Q+rL311zdicLxnnFh2EF
 d6pSm+NjHVvKiOEQaqsFzr6VxwDFMNWdzS6iFhOsawrmyejBIcgiBXaxBtHVAZ6y
 sUOPOYL3ZKiO6T21csGRVsGkMBpLzEARVnGnmmEKXW9ak7L1C4HEzOV9yJxaIOXL
 wRq61SDjzFDbkhn6RqRYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; bh=j0IPxDPNAUFBCEKXyPIHIkNJCPfyi
 KCIm15W42dTm9M=; b=UR4FhW/aOTRGWmQbN5bCEo4QondH1kYSEZZT65tVnsR9W
 XLPgTdIjylgbHLi8yEobBTxaeygu/ea+RIWLxNeX5Ih4x0m7qee0+sLm0OyV+StK
 XJ6qrnfM0hKi7j8xyG7T9Pg116FPL1+Qq0oSw9ZTjM1NPTNSBSqzhjnrZ19qXray
 QhwHEfiv0Bp6BFS/McxsBOB577hD0YiijTbimzV9BllU1m9m9kqpq7sq4Tv1RLe8
 feuNSHK2+tch/QM/vbw5D2JuxG8TT48eTSwYbaURMFyjHoKLOO9a3AIrIiMbsv9L
 6KJ5md0eSWum6YU5n2CuN72RuxvPVQthgiQLT5LDA==
From: virtiofs-bot@sinrega.org
Message-Id: <11199.122040908381300151@us-mta-633.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Sat,  9 Apr 2022 12:38:16 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue closed: Support for running with
 sandbox=none without root and without namespaces
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hello,
I have question - before version 1.0 (somewhere around June 2021 eg. commit 513b9eaa0471d28c28a611f3ad447d15dccde446) it was possible to run with sandbox=none as unprivileged user and without namespace support, currently this is not possible.

Are you planning to support running as normal user without namespace support with sandbox=none?

Because currently sanbox=none is kinda not none and I really like old way of none, so want to ask if any plans for new sandbox mode maybe or if I have to stay on older version.

Thanks for answer and this awesome tool
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/42

