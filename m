Return-Path: <berrange@redhat.com>
Date: Wed, 20 Apr 2022 17:13:25 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <YmAxJdh6mupPRxh+@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220420132624.2439741-1-marcandre.lureau@redhat.com>
 <20220420132624.2439741-7-marcandre.lureau@redhat.com>
 <YmAg+9GExN7wn6Yb@redhat.com>
 <CAFEAcA-n89moZJX5t72ek0iB0MEMQCAyq9jhVymcwyHEK_NNMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFEAcA-n89moZJX5t72ek0iB0MEMQCAyq9jhVymcwyHEK_NNMw@mail.gmail.com>
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
To: Peter Maydell <peter.maydell@linaro.org>
Cc: marcandre.lureau@redhat.com, qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>, Fam Zheng <fam@euphon.net>, Vladimir Sementsov-Ogievskiy <v.sementsov-og@mail.ru>, Akihiko Odaki <akihiko.odaki@gmail.com>, "open list:Block layer core" <qemu-block@nongnu.org>, Kyle Evans <kevans@freebsd.org>, Laurent Vivier <laurent@vivier.eu>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "open list:virtiofs" <virtio-fs@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Michael Roth <michael.roth@amd.com>, Eric Blake <eblake@redhat.com>, Warner Losh <imp@bsdimp.com>, Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>

On Wed, Apr 20, 2022 at 05:10:51PM +0100, Peter Maydell wrote:
> On Wed, 20 Apr 2022 at 16:04, Daniel P. Berrangé <berrange@redhat.com> wrote:
> >
> > On Wed, Apr 20, 2022 at 05:25:49PM +0400, marcandre.lureau@redhat.com wrote:
> > > From: Marc-André Lureau <marcandre.lureau@redhat.com>
> >
> > Could use a commit message explaining why this is a good
> > idea.
> >
> > I see it contains QEMU_COPYRIGHT macro, but it also then
> > contains QEMU_HELP_BOTTOM which is about bug reporting
> > not copyright.
> >
> > IMHO something like 'qemu-cli.h' could be a better match
> 
> "-cli" is both too broad and also inaccurate, because we use
> these macros in the GUI UI frontends too. It's "macros defining
> strings for use in version/usage/help dialogs and output".
> Maybe qemu/help-texts.h ?

I guess I tend to still view qemu-system-XXX as cli, despite the
possibility of a GUI, since you're passing 10's/100's of CLI
parameters regardless.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|
