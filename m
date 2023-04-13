Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1681384073; x=1683976073;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to;
 bh=73UYQ+UOpa+vWsmo5S3WE7zaLxbDHpDjBT6uMvtzgCQ=;
 b=gt8nd+5enA1YjrS7mIRnGqBVonitlcfs5O64gAYyYuj5pJQgw6KrOo5XUsVT59oZRy
 FHsfV5g9x7xnx9dsQsJ9ZQeEKIOr5L9KhJ0wRaSVD9h4ndodpElMvkFJ7IRa7SUsa6oX
 Z86zeg1JEeKo+r2/GGDF8zLe/9GXZn1PvcNm4UX+W63kpDqbed+mbuhatNiIXPhs2FRq
 3ht1UY2ayRejTPodZKLEqB1rINWrUgdhjr5kPyEy6X6uiePznspDjPj76xQKhTOxzgHY
 kvawpgpF6eZ8+hxkq2/SVW8cv20v/lz+dLcPpBctfPOiz0Fcck96/AOFMzF0/sMhwXe3
 AAFg==
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-3-hreitz@redhat.com>
 <20230412210641.GC2813183@fedora>
 <CAJaqyWfm=g_hr9=WpsnwJ4hdpVb7K7p5rirWjvx=PxKYUp8trA@mail.gmail.com>
In-Reply-To: <CAJaqyWfm=g_hr9=WpsnwJ4hdpVb7K7p5rirWjvx=PxKYUp8trA@mail.gmail.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Thu, 13 Apr 2023 07:07:41 -0400
Message-ID: <CAJSP0QW8fEJKnHMGFk+UFU=-f=5nEvY_zoOM=9f2M5UO4FC=Xw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH 2/4] vhost-user: Interface for migration
 state transfer
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: Hanna Czenczek <hreitz@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>

On Thu, 13 Apr 2023 at 06:15, Eugenio Perez Martin <eperezma@redhat.com> wr=
ote:
> On Wed, Apr 12, 2023 at 11:06=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat=
.com> wrote:
> > On Tue, Apr 11, 2023 at 05:05:13PM +0200, Hanna Czenczek wrote:
> > (And I hope vDPA will import the device state vhost-user messages
> > introduced in this series.)
> >
>
> I guess they will be needed for vdpa-fs devices? Is there any emulated
> virtio-fs in qemu?

Maybe also virtio-gpu or virtio-crypto, if someone decides to create
hardware or in-kernel implementations.

virtiofs is not built into QEMU, there are only vhost-user implementations.

Stefan

