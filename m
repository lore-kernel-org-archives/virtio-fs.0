Return-Path: <walters@verbum.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verbum.org; h=cc
 :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
 :message-id:mime-version:references:reply-to:sender:subject
 :subject:to:to; s=fm2; t=1664466472; x=1664552872; bh=U7nwSGKpL7
 kzmsrtzXcN1vDbSjhTDOzHr0ve0+b3wqo=; b=Rt9jihANFNVqeqXl/6jZcgFkJl
 TXrXf2rlWCYldEjenoea9M+iXsbN10HbGJOD2uRLGO5ubzm9r/ruBgAN5Rwvhx5R
 xAndsuJqD8FnnCiy0iApbcpNtOsh4DALZyex2yPXCFfKt1F6s9F04u1Nfy6aA9CG
 mAwxNMtxc6xlPFahH06C9V2NbIfwwYm2CHgHJEdIm9038qSK0deZBfVv1nFCs2CG
 kYwB0nH0wTQp+z2PNYSYfxVq4hXJzrCYC4navPXLfRg9rdfgnVN/S2fbzzPL2Nqy
 64N/Oj53jhMheNe2G/Ch9qQklYTf4NDWok9AdZ42QI1pjTvSL7FCwdy2wK7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
 :feedback-id:from:from:in-reply-to:in-reply-to:message-id
 :mime-version:references:reply-to:sender:subject:subject:to:to
 :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
 fm2; t=1664466472; x=1664552872; bh=U7nwSGKpL7kzmsrtzXcN1vDbSjhT
 DOzHr0ve0+b3wqo=; b=dxLV/mjI73QJL5fs9aBRIly7heSoPQcURioDSbQerzdB
 vkHuwS11dqb3HU4YRRo+oQ63PCiG0EXY4m3wUz1iRUaezHBwXShVEDEb2az6xKSk
 UL6b25iEcC1yxaHm8Q5zqGBuMusXYruD7R08PXU38ZDldGnxl8rLezNzGmPRuZcJ
 rsyQrOpg7md4NiC+NQ6Qm5dAvjM4KnCl5MF9JUPGX5FOhtd1xUovT9h6RuZLxMsv
 90kJj+busn+8OpK2clmhkgey/Kp4nejqnGpQcsANfoK312mq0TF4xwIrzU2bbOLa
 ejD4quKhFwZaEeVk2tSM7uvc2UyglOkgjC2Nte5ALA==
Mime-Version: 1.0
Message-Id: <b1cf0d02-cc45-4f5c-bfef-fda3e750bef3@app.fastmail.com>
In-Reply-To: <YzWnPZ5Y6ivS8e1v@redhat.com>
References: <4362261a-c762-4666-84e2-03c9daa6c4d9@www.fastmail.com>
 <YzMmu3xfOtQwuFUx@redhat.com> <YzMrYAJQeSP2hDSs@redhat.com>
 <CAJh=p+5rQDBJJC8VNGL10KYgDeq-Hg5WK7avONCti03eJGH+ow@mail.gmail.com>
 <798fe353-9537-44fe-a76a-819e8c93abb5@www.fastmail.com>
 <YzNZnPiUqySu6sGh@fedora> <20220928083340.eyizwu6mm3cc3bxu@mhamilton>
 <YzSgeDdpHOw1hTM0@redhat.com>
 <b963f623-aa85-4285-9bfa-5fcb4744c354@app.fastmail.com>
 <YzWnPZ5Y6ivS8e1v@redhat.com>
Date: Thu, 29 Sep 2022 11:47:32 -0400
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Sergio Lopez <slp@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org



On Thu, Sep 29, 2022, at 10:10 AM, Vivek Goyal wrote:

> What's your use case. How do you plan to use virtiofs.

At the current time, the Kubernetes that we run does not support user namespaces.  We want to do the production builds of our operating system (Fedora CoreOS and RHEL CoreOS) today inside an *unprivileged* Kubernetes pod (actually in OpenShift using anyuid, i.e. random unprivileged uid too), just with /dev/kvm exposed from the host (which is safe).  Operating system builds *and* tests in qemu are just another workload that can be shared with other tenants.

qemu works fine in this model, as does 9p.  It's just the virtiofs isolation requires privileges to be used today.


