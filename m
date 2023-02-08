Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to;
 bh=0LLYngw8A+tTzU0eFFBQCDBl93nWuzAZ3a6Se7a+EcY=;
 b=ooPZlFVOdsGihFmB9TgJIYzcUnk8SrS3ehy3U4N+p2+pR3KmZUW6xlfjGltJXMiJnL
 TLYcI+HE/mBRbIGlYtU8ZuSudc7X1nredkFF8tE8xWUgdbV/M6ALfZrNlkFkZ4AF21F0
 PkPP2RrE4M17BUd8CelXkFKJ1PfJUpZ7qeeiKeOmfclfph9m+GvBixwmbtPvuwJ/rTpv
 iIecI43FHAT82Oh9Ukno39I+yXTV644BZFthzBGotmcteVXJTjtYTKvBzBdHSkMSdZAU
 EhUBOpRsIOQ9wREtUHEysRCwGw2HQAmgIHTsB0DA6gqcpP07PN7vc/RYUsoxTJY+RJtS
 8c1A==
MIME-Version: 1.0
References: <fb523956-7a8c-608b-6db1-961686b73e9c@redhat.com>
 <CAJSP0QWnq6av7j6x_n-C2mLSPMYBhMeEthr6ayPN-cmsEB3UnA@mail.gmail.com>
 <f26dd5ed-fa02-faeb-fadb-0dbfbe7792d3@redhat.com>
 <CAJSP0QWA5j8J_nsUWwh5a18XsoJxjtRutLQzXT6JT1LwLbxCCA@mail.gmail.com>
In-Reply-To: <CAJSP0QWA5j8J_nsUWwh5a18XsoJxjtRutLQzXT6JT1LwLbxCCA@mail.gmail.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Wed, 8 Feb 2023 09:32:05 -0500
Message-ID: <CAJSP0QWh-4cYfKK3ea4qwcaGrmXpS0npxvhzr0JG7rNUjfrB=A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] vhost-user (virtio-fs) migration: back end state
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Dave Gilbert <dgilbert@redhat.com>, Juan Quintela <quintela@redhat.com>

On Tue, 7 Feb 2023 at 07:29, Stefan Hajnoczi <stefanha@gmail.com> wrote:
> On Tue, 7 Feb 2023 at 04:08, Hanna Czenczek <hreitz@redhat.com> wrote:
> > On 06.02.23 17:27, Stefan Hajnoczi wrote:
> > > On Mon, 6 Feb 2023 at 07:36, Hanna Czenczek <hreitz@redhat.com> wrote=
:
> > > Should we schedule a call with Jason, Michael, Juan, David, etc to
> > > discuss further? That way there's less chance of spending weeks
> > > working on something only to be asked to change the approach later.
> >
> > Sure, sounds good!  I=E2=80=99ve taken a look into what state we=E2=80=
=99ll need to
> > migrate already, but I=E2=80=99ll take a more detailed look now so that=
 it=E2=80=99s
> > clear what our requirements are.

Hi Hanna,
The next step is getting agreement on how the vhost-user device state
interface will work. Do you want to draft the new vhost-user protocol
messages and put together slides for discussion with Michael, Jason,
Juan, and David in the next KVM call? That might be the best way to
get agreement. Doing it via email is possible too but I guess it will
take longer.

If you don't want to design the vhost-user protocol changes yourself
then someone on this email thread can help with that.

Stefan

