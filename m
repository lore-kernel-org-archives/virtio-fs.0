Return-Path: <thuth@redhat.com>
Message-ID: <20f8ff01-8240-5c53-99ad-c75d37f6639c@redhat.com>
Date: Thu, 29 Dec 2022 10:29:02 +0100
MIME-Version: 1.0
References: <20221219130205.687815-1-berrange@redhat.com>
 <20221219130205.687815-5-berrange@redhat.com>
From: Thomas Huth <thuth@redhat.com>
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
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-ppc@nongnu.org, xen-devel@lists.xenproject.org, Laurent Vivier <lvivier@redhat.com>, Markus Armbruster <armbru@redhat.com>, Daniel Henrique Barboza <danielhb413@gmail.com>, virtio-fs@redhat.com, Michael Roth <michael.roth@amd.com>, =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, qemu-block@nongnu.org, Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org, Paul Durrant <paul@xen.org>, Anthony Perard <anthony.perard@citrix.com>, David Gibson <david@gibson.dropbear.id.au>, =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>, John Snow <jsnow@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Stefano Stabellini <sstabellini@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>, Greg Kurz <groug@kaod.org>

On 19/12/2022 14.02, Daniel P. Berrangé wrote:
> Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
> ---
>   util/error-report.c | 1 +
>   util/error.c        | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/util/error-report.c b/util/error-report.c
> index 5edb2e6040..6e44a55732 100644
> --- a/util/error-report.c
> +++ b/util/error-report.c
> @@ -193,6 +193,7 @@ real_time_iso8601(void)
>    * a single phrase, with no newline or trailing punctuation.
>    * Prepend the current location and append a newline.
>    */
> +G_GNUC_PRINTF(2, 0)
>   static void vreport(report_type type, const char *fmt, va_list ap)
>   {
>       gchar *timestr;
> diff --git a/util/error.c b/util/error.c
> index b6c89d1412..1e7af665b8 100644
> --- a/util/error.c
> +++ b/util/error.c
> @@ -45,6 +45,7 @@ static void error_handle_fatal(Error **errp, Error *err)
>       }
>   }
>   
> +G_GNUC_PRINTF(6, 0)
>   static void error_setv(Error **errp,
>                          const char *src, int line, const char *func,
>                          ErrorClass err_class, const char *fmt, va_list ap,

Reviewed-by: Thomas Huth <thuth@redhat.com>

