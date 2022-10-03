Return-Path: <walters@verbum.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verbum.org; h=cc
 :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
 :message-id:mime-version:references:reply-to:sender:subject
 :subject:to:to; s=fm2; t=1664837522; x=1664923922; bh=jd0wJkpOXv
 i8AWOfiC0AbkK+OJ5peRzxA9rPR6meT4E=; b=h7M4/eQ6OCKWA6StWWUy9sgyr3
 xMdnP6PGzI73MFY0GQLI382h2L1YpKTwZyjqqtV0ltRSafqg6pOVOo3w0L/Rpmjx
 XX74YzcapQO8XH6wem+Gu4XhV/7w/HUqsN8AHmrmTNyXgaFC5XPayfUFWlwOWI30
 cJy4YkwPWOti/mWxyUP1YPV9OyAxb1Xqxj7SHPN6b7ezGusanndknETZy8Am4/Sm
 hL0X4BljaXxjJlSS4bx8V1Uz0gc9GQ9EdUYe5RfY3BR/FmC1uph95brq25WUipfB
 M2pqlqlyBNJJL9kltNqya4sWJIoxw3XTWBAYX1rAAKoC7b7+p4JY1gmlg+Iw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
 :feedback-id:from:from:in-reply-to:in-reply-to:message-id
 :mime-version:references:reply-to:sender:subject:subject:to:to
 :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
 fm2; t=1664837522; x=1664923922; bh=jd0wJkpOXvi8AWOfiC0AbkK+OJ5p
 eRzxA9rPR6meT4E=; b=eyu3gmcyOmUDAFz1lRYj0KRODLE2mthriWxGyo9VLEgx
 RnqgnFMsFFFpA6VVsMt0jJjUXS80sUZnZjtjgiBaVml5eS59KweIO0dPhrNqeYPT
 i4/B7aMYT8YFRii7Vv7OCGCSMvrfEWKgD7lScnANPoapPkEbtlmJh7R3zVHg+6QF
 dcgskY9VoB/9mZR1cJ9gLyD7uHlC+4B7ylZNyE/+8tLRB1e90suRATGDIU8YVTnQ
 fY0RdcgRAjKX9pgAC1wV0yfAliLUK8CNKMBlBcNJAS6lyTXe1Mxmp+HyAYejE0ya
 ZKMKF5kTexLGbqnD4f4swHIDqmgaRsGVDccJIigibA==
Mime-Version: 1.0
Message-Id: <aa26d28d-d352-467c-910c-ab5973a6d759@app.fastmail.com>
In-Reply-To: <YzXP8XhCG5ta2Dvv@redhat.com>
References: <YzMmu3xfOtQwuFUx@redhat.com> <YzMrYAJQeSP2hDSs@redhat.com>
 <CAJh=p+5rQDBJJC8VNGL10KYgDeq-Hg5WK7avONCti03eJGH+ow@mail.gmail.com>
 <798fe353-9537-44fe-a76a-819e8c93abb5@www.fastmail.com>
 <YzNZnPiUqySu6sGh@fedora> <20220928083340.eyizwu6mm3cc3bxu@mhamilton>
 <YzSgeDdpHOw1hTM0@redhat.com>
 <b963f623-aa85-4285-9bfa-5fcb4744c354@app.fastmail.com>
 <YzWnPZ5Y6ivS8e1v@redhat.com>
 <b1cf0d02-cc45-4f5c-bfef-fda3e750bef3@app.fastmail.com>
 <YzXP8XhCG5ta2Dvv@redhat.com>
Date: Mon, 03 Oct 2022 18:51:42 -0400
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
Cc: Sergio Lopez <slp@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org, German Maglione <gmaglione@redhat.com>



On Thu, Sep 29, 2022, at 1:03 PM, Vivek Goyal wrote:
> 
> So rust version of virtiofsd, already supports running unprivileged
> (inside a user namespace).

I know, but as I already said, the use case here is running inside an OpenShift unprivileged pod where *we are already in a container*.

> host$ podman unshare -- virtiofsd --socket-path=/tmp/vfsd.sock 
> --shared-dir /mnt \
>         --announce-submounts --sandbox chroot &

Yes, but in current OCP 4.11 our seccomp policy denies CLONE_NEWUSER:

```
$ unshare -m
unshare: unshare failed: Function not implemented
```

https://docs.openshift.com/container-platform/4.11/security/seccomp-profiles.html

> I think only privileged operation it needs is assigning a range of
> subuid/subgid to the uid you are using on host.

We also turn on NO_NEW_PRIVILEGES by default in OCP pods.  

Now, I *could* in general get elevated permissions where I need to today.  But it's also really important to me to have a long term goal of having operating system builds and tests work well as "just another workload" in our production container platform (now, one *does* want to bind in /dev/kvm, but that's generally safe, and even that strictly speaking is optional if one can stomach the ~10x perf hit).

> Can you give rust virtiofsd (unprivileged) a try.

I admit to not actually trying it in a pod, but I think we all agree it can't work, and the only thing that can today is openat2.

