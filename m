Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=T+sraxTsgVW3hLMBsphV2TbCFPqpbnliPIarQ8qX4Pc=; b=d
 KfYl4RYaFhcgeanGmulO9A+e129Hzz8sZ/NumNG/I8rRC8OGREKrKKWHKRh64LuV
 KlRcRc9CMKyu23LAfUCPp+F8XhnY++ZmisUHXBw6ZGh21rW7ZPzaSRaRIQVu6g2N
 l/OBJafhgPqS2grcY9a+k6kUrhtZwm0V5mr5psA2/JFhXLTXNvMrJ65U4F9KcoIN
 J2kGh4q7aYPbflQShhHmJ+h9KLEstDo5PJ7RMEi/sURp1/13GUrdtAq4MtqD4TDg
 Rh7izx5LAdvSHtNhFq10WxFCx2c/6ZXZzT3jfQiZheWuplCRoq/zDHJ2/gGTUbna
 OKO3OZsGPrM0xCHMrMA2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm3; bh=T+sraxTsgVW3hLMBsphV2TbCFPqpb
 nliPIarQ8qX4Pc=; b=YIaK2IyXk4gsi+hKu67qRkagsllWYJrgTzVCTtC3IKjKa
 vk2dYiAfj3wqS9xOBK4B18lCwt0FxPZ9xS0fzeFmNKy3UW3tmIyFcrEtxRyJoZes
 j+NXD12DlNsUQIMDBfABv1GWqN+eiQb+Onr3l3/Cu0oQHjvnT3wtgusagSHNA3Ot
 wKkxrsiWW/NwvTE7eE0OdD7U1ka4kj9Tn0fuLVHKVNqx/dYkCsrLfMAwz8G/MNXn
 6TU3W11g8l1SyBLksEcSUUw8Oh4rCFwYL+WFTzwkWI7mLR7TMcW+JngIQMoD60mE
 VWxs4wQ8ie5exwd2rm43cZDlTbBke5hKMNmG+2ZGQ==
From: virtiofs-bot@sinrega.org
Message-Id: <49334.122033103365200198@us-mta-394.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Thu, 31 Mar 2022 07:37:24 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Do not call setgroups() for
 unprivileged user namespace mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Right now --sandbox=Namespace is broken when called by unprivileged user. Reason being that we call setgroups() and that's not allowed for unprivileged user both outside and inside user namespace.

When unprivileged user is launching user namespace (without help from newuidmap/newgidmap), then it can only map its own id. That means there is no arbitrary swithing of uid/gid. And that also means anything not owned by user will show up as "nobody" and user can not write to that file/dir.

So all this means that we should not have to necessary call setgroups() for this particular mode. This patch gets rid of call for setgroups() for "--sandbox=Namespace" mode when called by unprivileged user. When root starts with "--sandbox=Namespace", setgroups() is still called.

I also picked a patch from Sergio which establishes 1:1 mapping of uid/gid in newly created namespace. So uid outside the user namespace is mapped to same uid inside the user namespace. This is good if user wants to export his/her own home directory into a VM. Without this patch, user owned files show up as nobody which is not very useful at all.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/105

