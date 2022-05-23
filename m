Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1653340126; x=1653426526; bh=UompWMxnQuI2FeYmO6Cx4
 +pZ4Bo3JvD9HwCYYY87i6Y=; b=QuwlHcaJiPMiQkdpXOZazQFQV3z8slodkvQvO
 HKKgx1+Dsl/w+jL4RUDVvF32P5ExeOeOYR8Ynn2OLH2dXx5O3Xt5LnLeLg1ALedm
 u6lAWfgxD/1sGikrDcpARfyU6ze7+fHrJP4lnL/rfDrk7N7yd0UeZHbuTZXJ9rmA
 44eOESAo8r0fv+0nl60Pw6SfPBTWDGwmwsjxpDz3gOQzNNqS6QdaM+TJbKRkq+dC
 YHU21cmrCz8GEJH8ntE/EloUt0oKypKbOKyJWm2B38gKMQNJ79JUREGsR/2Pmebe
 ODM0itSlGjGp+DnQMOg9h/wh5OvJP36O+2V+VraYFtSxVpaCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1653340126; x=1653426526; bh=UompWMxnQuI2FeYmO6Cx4+pZ4Bo3JvD9HwC
 YYY87i6Y=; b=cw3k6/4PE9mo1l0szlGYpNsO0dIKU3tJuBhv9jVBUm0Ol8HDubV
 6M3OJaFQO/9ANWjnqsaHqLdQTcd9WYp9BWuBXgoxGO0SRDNVyXRIRFbqMp4PoSja
 TM/f+gBDS2dNo8u9183IKtY5VJxi1DOe5u97CiefQ3n3HnTsT5BThH7t57lM4aEa
 pAZL+4Gz9yGGRV1EtSfN038GOxNQge2vNt7SZyvMV0/X+zJBDGcboxLIp+S/hWuh
 8SxR8CHl9TFYgzEthutQ2vGf9p0euxZUGjUBPMHVDLeOGvOk03OzymNuyHchKOXl
 loKZOAs2COjTIzHriCDcf6JFv1DSFIHRMjQ==
From: virtiofs-bot@sinrega.org
Message-Id: <57688.122052317084800467@us-mta-283.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon, 23 May 2022 21:08:50 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Do not create tmpdir and bind
 mount /proc/self/fd there
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

virtiofsd needs access to /proc/self/fd but we also want to make
sure that if virtiofsd is hacked, it is not able to traverse up the
directory tree and be able to access /proc/ etc.

Currently virtiofsd creates a tmpdir and bind mounts /proc/self/fd/
there and then opens an O_PATH fd for tmpdir. And then it deletes
the tmpdir.

C version of virtiofsd bind mounts /proc/self/fd on /proc/ and then
opens an O_PATH fd on /proc.

Creating a separate dir needs to find a temporary space and SELinux
policy might not allow for writing to some tmp space directly. Instead
runtime needs to setup some space and label it properly so that virtiofsd
can write to it.

So going away from the need of creating tmpdir will be good as long
as one can not traverse into /proc/self or /proc. I think it is
not possible with bind mounting /proc/self/fd on /proc. So proposing
this patch. 

Yet-to-be-signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/119

