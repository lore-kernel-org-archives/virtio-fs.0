Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=7m7QPGiCP4S20D0BtAIqmAJC7Tsy8GJCqBiUeHUzM1c=;
 b=bNIbRwdqyFoWXlx9VdQMqsXJi4ZwRoXHFhbo8L3yuEmlB7W1vE4ntlbzJ8jRU78zVt
 oiTsD15qESfexMTv+VYcs3I6WMsHKxcQpRi3kgwhlG1Nu8/l/hxzFMkCqQCABJxdDgkP
 CMdZZQEl3uEj8i+agfO94xmyAmPz893p8WfWc3uSQYozvqhaqCZzrAWGGE87AG/SAmU+
 GwIqyWtj55q2B+ePALyhQPN3+e3bhC1y7eydBeIRFfOA3SqZ0fJv4rjr/4MirwTCM5Jq
 kT7el38wvzOslqxb66TLVFCB+nnb0JVEFVgKyheFkKH9l5U9ziRZUNHzoif1xDx/tB1Y
 B6lg==
MIME-Version: 1.0
References: <20221029172515.217264-1-sw@weilnetz.de>
In-Reply-To: <20221029172515.217264-1-sw@weilnetz.de>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Sun, 30 Oct 2022 14:12:44 -0400
Message-ID: <CAJSP0QVGbW2d0vJzikE4c56hro=GqeT4Zx5+d8P7PTzG9c_1hA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] Fix some typos in documentation and comments
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Weil <sw@weilnetz.de>
Cc: qemu-devel@nongnu.org, Markus Armbruster <armbru@redhat.com>, Michael Roth <michael.roth@amd.com>, Peter Maydell <peter.maydell@linaro.org>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, Eric Blake <eblake@redhat.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Konstantin Kostiuk <kkostiuk@redhat.com>, Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-arm@nongnu.org, virtio-fs@redhat.com

On Sat, 29 Oct 2022 at 13:27, Stefan Weil via <qemu-devel@nongnu.org> wrote:
>
> Most of them were found and fixed using codespell.
>
> Signed-off-by: Stefan Weil <sw@weilnetz.de>
> ---

Aside from Peter's comments:

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

