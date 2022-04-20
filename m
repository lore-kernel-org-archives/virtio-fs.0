Return-Path: <peter.maydell@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc:content-transfer-encoding;
 bh=OwHUEDY2EXzaY0pEwGqTeB6dkRDc3iu9YRLJY5iV6xw=;
 b=CAvpzHmxBceOdz1vEToatSSJmct5B2tkYgEsZ73GRy6p4aDFiuy4JAgY0kMlw0gDH7
 HwPGpQHlFBMksWPRwriKncGI5hn9fQzkeBmvCR5gYwG0jdJ8jFpmxMXGEYR6xhwiLdNT
 v+vr0u/GG6p3XtqcEYpVJUQiFFdLzFAV8vanO/Kxeg5YI3IexbceF7gixtYZRoJQCk1T
 +vD3+3i6zPOQnD29UL8uZOj0ySyhmlbMzwNUxUXZ49eVHJa6sCh7ncPBFsnYYdKpnQ+4
 YLifpM8YX9Pza5Z4kRfLxc6zJ0+gdC9cEZP/V2Km6GvfMJSPCW+kmvpNmjmt3DyQzwK8
 q+1w==
MIME-Version: 1.0
References: <20220420132624.2439741-1-marcandre.lureau@redhat.com>
 <20220420132624.2439741-7-marcandre.lureau@redhat.com>
 <YmAg+9GExN7wn6Yb@redhat.com>
In-Reply-To: <YmAg+9GExN7wn6Yb@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 20 Apr 2022 17:10:51 +0100
Message-ID: <CAFEAcA-n89moZJX5t72ek0iB0MEMQCAyq9jhVymcwyHEK_NNMw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH 06/41] include: rename qemu-common.h
 qemu/copyright.h
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: marcandre.lureau@redhat.com, qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>, Fam Zheng <fam@euphon.net>, Vladimir Sementsov-Ogievskiy <v.sementsov-og@mail.ru>, Akihiko Odaki <akihiko.odaki@gmail.com>, "open list:Block layer core" <qemu-block@nongnu.org>, Kyle Evans <kevans@freebsd.org>, Laurent Vivier <laurent@vivier.eu>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "open list:virtiofs" <virtio-fs@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Michael Roth <michael.roth@amd.com>, Eric Blake <eblake@redhat.com>, Warner Losh <imp@bsdimp.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>

On Wed, 20 Apr 2022 at 16:04, Daniel P. Berrang=C3=A9 <berrange@redhat.com>=
 wrote:
>
> On Wed, Apr 20, 2022 at 05:25:49PM +0400, marcandre.lureau@redhat.com wro=
te:
> > From: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>
>
> Could use a commit message explaining why this is a good
> idea.
>
> I see it contains QEMU_COPYRIGHT macro, but it also then
> contains QEMU_HELP_BOTTOM which is about bug reporting
> not copyright.
>
> IMHO something like 'qemu-cli.h' could be a better match

"-cli" is both too broad and also inaccurate, because we use
these macros in the GUI UI frontends too. It's "macros defining
strings for use in version/usage/help dialogs and output".
Maybe qemu/help-texts.h ?

-- PMM

