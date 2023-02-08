Return-Path: <mst@redhat.com>
Date: Wed, 8 Feb 2023 09:34:54 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20230208093358-mutt-send-email-mst@kernel.org>
References: <fb523956-7a8c-608b-6db1-961686b73e9c@redhat.com>
 <CAJSP0QWnq6av7j6x_n-C2mLSPMYBhMeEthr6ayPN-cmsEB3UnA@mail.gmail.com>
 <f26dd5ed-fa02-faeb-fadb-0dbfbe7792d3@redhat.com>
 <CAJSP0QWA5j8J_nsUWwh5a18XsoJxjtRutLQzXT6JT1LwLbxCCA@mail.gmail.com>
 <CAJSP0QWh-4cYfKK3ea4qwcaGrmXpS0npxvhzr0JG7rNUjfrB=A@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJSP0QWh-4cYfKK3ea4qwcaGrmXpS0npxvhzr0JG7rNUjfrB=A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] vhost-user (virtio-fs) migration: back end state
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Hanna Czenczek <hreitz@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, Jason Wang <jasowang@redhat.com>, Dave Gilbert <dgilbert@redhat.com>, Juan Quintela <quintela@redhat.com>

On Wed, Feb 08, 2023 at 09:32:05AM -0500, Stefan Hajnoczi wrote:
> On Tue, 7 Feb 2023 at 07:29, Stefan Hajnoczi <stefanha@gmail.com> wrote:
> > On Tue, 7 Feb 2023 at 04:08, Hanna Czenczek <hreitz@redhat.com> wrote:
> > > On 06.02.23 17:27, Stefan Hajnoczi wrote:
> > > > On Mon, 6 Feb 2023 at 07:36, Hanna Czenczek <hreitz@redhat.com> wrote:
> > > > Should we schedule a call with Jason, Michael, Juan, David, etc to
> > > > discuss further? That way there's less chance of spending weeks
> > > > working on something only to be asked to change the approach later.
> > >
> > > Sure, sounds good!  I’ve taken a look into what state we’ll need to
> > > migrate already, but I’ll take a more detailed look now so that it’s
> > > clear what our requirements are.
> 
> Hi Hanna,
> The next step is getting agreement on how the vhost-user device state
> interface will work. Do you want to draft the new vhost-user protocol
> messages and put together slides for discussion with Michael, Jason,
> Juan, and David in the next KVM call? That might be the best way to
> get agreement. Doing it via email is possible too but I guess it will
> take longer.

Let's get a proposal on list first please. If there's a disagreement
we can do a call too, but give everyone time to review.

> If you don't want to design the vhost-user protocol changes yourself
> then someone on this email thread can help with that.
> 
> Stefan

