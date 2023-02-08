Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to;
 bh=YoBuITrRrshUoRqfwl7e8i7oDZ4ha+2zqtJ1/7vhf4k=;
 b=IF57b6MQZLHXtYUu4ib0VCFY/pL1oGoMSU+yaCRqErZu9PeScnkc86orUVBdy1o5ob
 55rieGkYEUZRgOkuOpjIkC7Q3aVfV5bkOEXK03H6m1ukca7VZU+ysg/2DJMb7tUau/fS
 8/7UlyemPOAq+0lIT1ywwSOcOJRDgLu79d1SkURakC67JGIBnky3z2K8K5YjpWAKKdCn
 H2LZ30C+jkNvH8N5mqTIoDMLGrdNiGa3hK3Zqn3gwdPqaXTH2osYhHPHoN/funo4gkx8
 2W3ochbkKGynFLL/8DfbOx2A9/kKq1gc/XYolhyg+UPL6tG90W4nH0mL3RNkrTG66pNy
 /QSg==
MIME-Version: 1.0
References: <fb523956-7a8c-608b-6db1-961686b73e9c@redhat.com>
 <CAJSP0QWnq6av7j6x_n-C2mLSPMYBhMeEthr6ayPN-cmsEB3UnA@mail.gmail.com>
 <f26dd5ed-fa02-faeb-fadb-0dbfbe7792d3@redhat.com>
 <CAJSP0QWA5j8J_nsUWwh5a18XsoJxjtRutLQzXT6JT1LwLbxCCA@mail.gmail.com>
 <CAJSP0QWh-4cYfKK3ea4qwcaGrmXpS0npxvhzr0JG7rNUjfrB=A@mail.gmail.com>
 <d33b0bff-f07d-56a9-8648-16310b60f8a5@redhat.com>
In-Reply-To: <d33b0bff-f07d-56a9-8648-16310b60f8a5@redhat.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Wed, 8 Feb 2023 11:32:53 -0500
Message-ID: <CAJSP0QWrw0o6Mym02vc42TLOdY7mFKH1xQvf=n23J4eOhHWwpg@mail.gmail.com>
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

On Wed, 8 Feb 2023 at 10:58, Hanna Czenczek <hreitz@redhat.com> wrote:
>
> On 08.02.23 15:32, Stefan Hajnoczi wrote:
> > On Tue, 7 Feb 2023 at 07:29, Stefan Hajnoczi <stefanha@gmail.com> wrote=
:
> >> On Tue, 7 Feb 2023 at 04:08, Hanna Czenczek <hreitz@redhat.com> wrote:
> >>> On 06.02.23 17:27, Stefan Hajnoczi wrote:
> >>>> On Mon, 6 Feb 2023 at 07:36, Hanna Czenczek <hreitz@redhat.com> wrot=
e:
> >>>> Should we schedule a call with Jason, Michael, Juan, David, etc to
> >>>> discuss further? That way there's less chance of spending weeks
> >>>> working on something only to be asked to change the approach later.
> >>> Sure, sounds good!  I=E2=80=99ve taken a look into what state we=E2=
=80=99ll need to
> >>> migrate already, but I=E2=80=99ll take a more detailed look now so th=
at it=E2=80=99s
> >>> clear what our requirements are.
> > Hi Hanna,
> > The next step is getting agreement on how the vhost-user device state
> > interface will work. Do you want to draft the new vhost-user protocol
> > messages and put together slides for discussion with Michael, Jason,
> > Juan, and David in the next KVM call? That might be the best way to
> > get agreement. Doing it via email is possible too but I guess it will
> > take longer.
> >
> > If you don't want to design the vhost-user protocol changes yourself
> > then someone on this email thread can help with that.
>
> I=E2=80=99ll need to talk about the whole thing to Stefano and German fir=
st
> (we=E2=80=99re collaborating on virtio-fs migration, looking at different
> aspects of it).  Also, I think I=E2=80=99ll want to look into the code a =
bit
> first and fiddle around to get a working prototype so I get an idea of
> what might be feasible at all.  I wouldn=E2=80=99t want to propose someth=
ing
> that actually can=E2=80=99t work when I try to make it work in practice. =
O:)

Okay.

The specifics of the virtiofs device state don't need much discussion
here. Only the vhost-user protocol changes need agreement because they
are generic infrastructure that will affect other vhost-user device
types, vDPA, and probably core VIRTIO. So don't worry about defining
what each piece of virtiofs state needs to be at this point, I guess
you only need a rough idea in order to come up with the vhost-user
protocol changes.

Stefan

