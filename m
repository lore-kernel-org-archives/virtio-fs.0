Return-Path: <thuth@redhat.com>
Message-ID: <27da4d93-38e6-1c40-4a60-92f3343f380f@redhat.com>
Date: Thu, 29 Dec 2022 10:34:55 +0100
MIME-Version: 1.0
References: <20221219130205.687815-1-berrange@redhat.com>
 <20221219130205.687815-6-berrange@redhat.com>
From: Thomas Huth <thuth@redhat.com>
In-Reply-To: <20221219130205.687815-6-berrange@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 5/6] tests: add G_GNUC_PRINTF for various
 functions
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
>   tests/qtest/ahci-test.c           |  3 +++
>   tests/qtest/arm-cpu-features.c    |  1 +
>   tests/qtest/erst-test.c           |  2 +-
>   tests/qtest/ide-test.c            |  3 ++-
>   tests/qtest/ivshmem-test.c        |  4 ++--
>   tests/qtest/libqmp.c              |  2 +-
>   tests/qtest/libqos/libqos-pc.h    |  6 ++++--
>   tests/qtest/libqos/libqos-spapr.h |  6 ++++--
>   tests/qtest/libqos/libqos.h       |  6 ++++--
>   tests/qtest/libqos/virtio-9p.c    |  1 +
>   tests/qtest/migration-helpers.h   |  1 +
>   tests/qtest/rtas-test.c           |  2 +-
>   tests/qtest/usb-hcd-uhci-test.c   |  4 ++--
>   tests/unit/test-qmp-cmds.c        | 13 +++++++++----
>   14 files changed, 36 insertions(+), 18 deletions(-)
...
> diff --git a/tests/unit/test-qmp-cmds.c b/tests/unit/test-qmp-cmds.c
> index 2373cd64cb..6d52b4e5d8 100644
> --- a/tests/unit/test-qmp-cmds.c
> +++ b/tests/unit/test-qmp-cmds.c
> @@ -138,6 +138,7 @@ void qmp___org_qemu_x_command(__org_qemu_x_EnumList *a,
>   }
>   
>   
> +G_GNUC_PRINTF(2, 3)
>   static QObject *do_qmp_dispatch(bool allow_oob, const char *template, ...)
>   {
>       va_list ap;
> @@ -160,6 +161,7 @@ static QObject *do_qmp_dispatch(bool allow_oob, const char *template, ...)
>       return ret;
>   }
>   
> +G_GNUC_PRINTF(3, 4)
>   static void do_qmp_dispatch_error(bool allow_oob, ErrorClass cls,
>                                     const char *template, ...)
>   {
> @@ -269,7 +271,7 @@ static void test_dispatch_cmd_io(void)
>   
>   static void test_dispatch_cmd_deprecated(void)
>   {
> -    const char *cmd = "{ 'execute': 'test-command-features1' }";
> +    #define cmd "{ 'execute': 'test-command-features1' }"
>       QDict *ret;

That looks weird, why is this required?

  Thomas

