Return-Path: <berrange@redhat.com>
Date: Mon, 9 Jan 2023 11:55:00 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <Y7wAlHEIafbNzsdf@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20221219130205.687815-1-berrange@redhat.com>
 <20221219130205.687815-6-berrange@redhat.com>
 <27da4d93-38e6-1c40-4a60-92f3343f380f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <27da4d93-38e6-1c40-4a60-92f3343f380f@redhat.com>
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
To: Thomas Huth <thuth@redhat.com>
Cc: qemu-devel@nongnu.org, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-ppc@nongnu.org, xen-devel@lists.xenproject.org, Laurent Vivier <lvivier@redhat.com>, Markus Armbruster <armbru@redhat.com>, Daniel Henrique Barboza <danielhb413@gmail.com>, virtio-fs@redhat.com, Michael Roth <michael.roth@amd.com>, Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, qemu-block@nongnu.org, Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org, Paul Durrant <paul@xen.org>, Anthony Perard <anthony.perard@citrix.com>, David Gibson <david@gibson.dropbear.id.au>, =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>, John Snow <jsnow@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Stefano Stabellini <sstabellini@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>, Greg Kurz <groug@kaod.org>

On Thu, Dec 29, 2022 at 10:34:55AM +0100, Thomas Huth wrote:
> On 19/12/2022 14.02, Daniel P. Berrangé wrote:
> > Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
> > ---
> >   tests/qtest/ahci-test.c           |  3 +++
> >   tests/qtest/arm-cpu-features.c    |  1 +
> >   tests/qtest/erst-test.c           |  2 +-
> >   tests/qtest/ide-test.c            |  3 ++-
> >   tests/qtest/ivshmem-test.c        |  4 ++--
> >   tests/qtest/libqmp.c              |  2 +-
> >   tests/qtest/libqos/libqos-pc.h    |  6 ++++--
> >   tests/qtest/libqos/libqos-spapr.h |  6 ++++--
> >   tests/qtest/libqos/libqos.h       |  6 ++++--
> >   tests/qtest/libqos/virtio-9p.c    |  1 +
> >   tests/qtest/migration-helpers.h   |  1 +
> >   tests/qtest/rtas-test.c           |  2 +-
> >   tests/qtest/usb-hcd-uhci-test.c   |  4 ++--
> >   tests/unit/test-qmp-cmds.c        | 13 +++++++++----
> >   14 files changed, 36 insertions(+), 18 deletions(-)
> ...
> > diff --git a/tests/unit/test-qmp-cmds.c b/tests/unit/test-qmp-cmds.c
> > index 2373cd64cb..6d52b4e5d8 100644
> > --- a/tests/unit/test-qmp-cmds.c
> > +++ b/tests/unit/test-qmp-cmds.c
> > @@ -138,6 +138,7 @@ void qmp___org_qemu_x_command(__org_qemu_x_EnumList *a,
> >   }
> > +G_GNUC_PRINTF(2, 3)
> >   static QObject *do_qmp_dispatch(bool allow_oob, const char *template, ...)
> >   {
> >       va_list ap;
> > @@ -160,6 +161,7 @@ static QObject *do_qmp_dispatch(bool allow_oob, const char *template, ...)
> >       return ret;
> >   }
> > +G_GNUC_PRINTF(3, 4)
> >   static void do_qmp_dispatch_error(bool allow_oob, ErrorClass cls,
> >                                     const char *template, ...)
> >   {
> > @@ -269,7 +271,7 @@ static void test_dispatch_cmd_io(void)
> >   static void test_dispatch_cmd_deprecated(void)
> >   {
> > -    const char *cmd = "{ 'execute': 'test-command-features1' }";
> > +    #define cmd "{ 'execute': 'test-command-features1' }"
> >       QDict *ret;
> 
> That looks weird, why is this required?

This means that the compiler can see we're passing a constant string
into the API call a few lines lower. Without it, the compiler can't
see that 'cmd' doesn't contain any printf format specifiers, and thus
it would force us to use  func('%s', cmd)... except that's not actually
possible since our crazy json printf formatter doesn't allow arbitrary
'%s', the '%s' can only occur at well defined points in the JSON doc.

Using a constant string via #define was the easiest way to give the
compiler visibility of the safety.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|
