Return-Path: <philmd@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=Nl4BGj1PyLBerZrWWS1NwXWllkrPCT7tq7b1VOTopDg=;
 b=Qoq1oc3WR/h+dr5nNxVF0P7U/ZkhFAEPkpf+fYnizATJ+5xL7j35kQRZlFPbDPYY6c
 xJ87qjQrF4tMPIewqjhAqQrO83nQpxuUaIk8jNhy/p3QqhwSRIlWhzki+GNhGPPoG5C0
 CNYt5ZkwEwcQIgYOHRqOtrZ+AXFqI9J/6J5r+RJ4DODPoxNNmlTVzRYWOtbR3RO7h6dH
 arAMC6XqWrhiNElK5I5Y8veR6sltuaZK3dnQXQHLIaG+vT7nPYnivs1S3YALat+eBHQf
 ZANg1H+/TYJ3rRMn24mhTyfWr76k9AvneEMnhGGVK7lIH9aqaGPda+t73IjSWL2d4qQa
 eNqg==
Message-ID: <542d86b6-3ca7-a1c4-51b1-af73d5434f57@linaro.org>
Date: Mon, 19 Dec 2022 15:13:51 +0100
MIME-Version: 1.0
References: <20221219130205.687815-1-berrange@redhat.com>
 <20221219130205.687815-5-berrange@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221219130205.687815-5-berrange@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 4/6] util/error: add G_GNUC_PRINTF for
 various functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>, qemu-devel@nongnu.org
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-ppc@nongnu.org, xen-devel@lists.xenproject.org, Laurent Vivier <lvivier@redhat.com>, Markus Armbruster <armbru@redhat.com>, Daniel Henrique Barboza <danielhb413@gmail.com>, virtio-fs@redhat.com, Michael Roth <michael.roth@amd.com>, =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, qemu-block@nongnu.org, Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org, Paul Durrant <paul@xen.org>, Anthony Perard <anthony.perard@citrix.com>, David Gibson <david@gibson.dropbear.id.au>, =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>, John Snow <jsnow@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Stefano Stabellini <sstabellini@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>, Greg Kurz <groug@kaod.org>, Thomas Huth <thuth@redhat.com>

On 19/12/22 14:02, Daniel P. Berrangé wrote:
> Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
> ---
>   util/error-report.c | 1 +
>   util/error.c        | 1 +
>   2 files changed, 2 insertions(+)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


