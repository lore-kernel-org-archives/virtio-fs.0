Return-Path: <walters@verbum.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verbum.org; h=cc
 :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
 :message-id:mime-version:references:reply-to:sender:subject
 :subject:to:to; s=fm2; t=1664301123; x=1664387523; bh=fotpJBo8Vu
 Gxhlza7+sKnJD9vRGz9MqSig111e2TlUA=; b=RxItZakgRM/FQS7vD2Hf2FXG4i
 6zyfXgq+sVGg1lU31k/lsJ51RgHpTqXnOex0Ibrf4IgtTEAFXxE7t84zyDQvea4D
 YCF55W+JZ86QCQf1UXO9u/Y/AETCdoe6Ukhs8Kn1BOhxipN27i34uxXKnHuMdsFM
 nzC1/GlbkmMbozyPPOClqqPGYWJYmuPYnfnCvg6CEuJ88yK5Idp0/ROJSc9dF9bo
 c3yfk2ynchOoa8YPcyW9Dj0wJ2w7doALjklbaQUBuyt6GREfv2EMdgIJDUoTA/dI
 lvZizVZwZhsVk+njWg9zhKIbAAfs28qYX69HovXKRIcwWuhbMf/oo/e5XNFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
 :feedback-id:from:from:in-reply-to:in-reply-to:message-id
 :mime-version:references:reply-to:sender:subject:subject:to:to
 :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
 fm2; t=1664301123; x=1664387523; bh=fotpJBo8VuGxhlza7+sKnJD9vRGz
 9MqSig111e2TlUA=; b=yYVJMafqL9YUXica6doKLkX6M8ja97RhWt8MvYXnLE0I
 qjtd6HxzTO9GG5e8UVgHG5Xi/Sc/pdx+YYWd9UNGt15dh+G3nejyzkVPsW2bscwE
 Zg8j7Os3Jlx6UQqq14HN1yos2RORxv81r5Z/ftiOdH0TA83NOzqV4NljFn5+rkKJ
 hAw4tHDC8tqGeUSB2tA9z5IiVX8bT9ErWpKNcxr0U0oE2RcCRp9IILKJ4ZW8Uwst
 YrdozvKQEMHIulBuNRoT/rlWC/h7ms9anIrw2spi+3gDKfeC3pNeXOXYwk3P7C1s
 mERl7puogPEJ2zipaOBZS64voKoHA5VelBKvrpOdog==
Mime-Version: 1.0
Message-Id: <798fe353-9537-44fe-a76a-819e8c93abb5@www.fastmail.com>
In-Reply-To: <CAJh=p+5rQDBJJC8VNGL10KYgDeq-Hg5WK7avONCti03eJGH+ow@mail.gmail.com>
References: <4362261a-c762-4666-84e2-03c9daa6c4d9@www.fastmail.com>
 <YzMmu3xfOtQwuFUx@redhat.com> <YzMrYAJQeSP2hDSs@redhat.com>
 <CAJh=p+5rQDBJJC8VNGL10KYgDeq-Hg5WK7avONCti03eJGH+ow@mail.gmail.com>
Date: Tue, 27 Sep 2022 13:51:41 -0400
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
To: German Maglione <gmaglione@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs-list <virtio-fs@redhat.com>, Sergio Lopez <slp@redhat.com>



On Tue, Sep 27, 2022, at 1:27 PM, German Maglione wrote:
>
>> > Now all the development has moved to rust virtiofsd.

Oh, awesome!!  The code there looks great.

> I could work on this for the next major version and see if anything breaks.
> But I prefer to add this as a compilation feature, instead of a command line
> option that we will then have to maintain for a while.

Hmm, what would be the issue with having the code there by default?  I think rather than any new command line option, we automatically use `openat2+RESOLVE_IN_ROOT` if the process is run as a nonzero uid.

> Also, I don't see it as a sandbox feature, as Stefan mentioned, a compromised
> process can call openat2() without RESOLVE_IN_ROOT. 

I'm a bit skeptical honestly about how secure the existing namespace code is against a compromised virtiofsd process.  The primary worry is guest filesystem traversals, right?  openat2+RESOLVE_IN_ROOT addresses that.  Plus being in Rust makes this dramatically safer.

> I did some test with
> Landlock to lock virtiofsd inside the shared directory, but IIRC it requires a
> kernel 5.13

But yes, landlock and other things make sense, I just don't see these things as strongly linked.  IOW we shouldn't in my opinion block unprivileged virtiofsd on more sandboxing than openat2 already gives us.

