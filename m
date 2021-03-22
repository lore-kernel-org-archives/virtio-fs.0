Date: Mon, 22 Mar 2021 16:13:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210322201326.GH446288@redhat.com>
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
	<CAJ+F1CLZ4VtgKp5fEdC70m22PgV2VHvRHunR-nPOWDnJPFvqqg@mail.gmail.com>
	<CAFQAk7hCqSMMfRjUO8vtK-B2cKxJZZTJgSDAbRycd1AOSktM_w@mail.gmail.com>
	<YFHUbEdszo4nursr@stefanha-x1.localdomain>
	<CAFQAk7ia5HsX0e4WBrhDtytGKnd5LsPrUSz9DJVFoo+ShDRP7Q@mail.gmail.com>
	<YFh45AUkh1OzbE6H@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFh45AUkh1OzbE6H@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [External] Re: [RFC PATCH 0/9] Support for
 Virtio-fs daemon crash reconnection
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, QEMU <qemu-devel@nongnu.org>, virtio-fs@redhat.com, Xie Yongji <xieyongji@bytedance.com>, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@gmail.com>

On Mon, Mar 22, 2021 at 11:00:52AM +0000, Stefan Hajnoczi wrote:
> On Wed, Mar 17, 2021 at 08:32:31PM +0800, Jiachen Zhang wrote:
> > On Wed, Mar 17, 2021 at 6:05 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> > > On Fri, Dec 18, 2020 at 05:39:34PM +0800, Jiachen Zhang wrote:
> > I agreed with you that a virtiofsd must be launched by a software like
> > systemd. So we are planning to define more generic persist/restore
> > interfaces (callbacks). Then anyone can implement their own persist/restore
> > callbacks to store states to proper places.  And I think in the next
> > version we will implement default callbacks for the interfaces. Instead of
> > vhost-user messages, systemd's sd_notify(3) will be the default method for
> > storing fds, and several tmpfs files can be the default place to store the
> > shm regions.
> 
> Okay, great!
> 
> I was thinking about how to make the crash recovery mechanism reusable
> as a C library or Rust crate. The mechanism is a combination of:
> 1. sd_listen_fds(3) for restoring the fds on restart.
> 2. sd_notify(3) for storing the fds.
> 3. memfd or tmpfs for storing state (could be mmapped).
> 
> I'm not sure if there is enough common behavior to create a reusable API
> or if this is quite application-specific.

I am wondering what will happen for use cases where virtiofsd is running
inside a container (with no systemd inside containers).

Do container managers offer systemd like services to save and restore
state.

Vivek

