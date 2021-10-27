Date: Wed, 27 Oct 2021 16:29:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YXm2tAMYwFFVR8g/@redhat.com>
References: <20211025204634.2517-1-iangelak@redhat.com>
	<CAOQ4uxieK3KpY7pf0YTKcrNHW7rnTATTDZdK9L4Mqy32cDwV8w@mail.gmail.com>
	<YXgqRb21hvYyI69D@redhat.com>
	<CAOQ4uxhpCKK2MYxSmRJYYMEWaHKy5ezyKgxaM+YAKtpjsZkD-g@mail.gmail.com>
	<YXhIm3mOvPsueWab@redhat.com>
	<CAO17o20sdKAWQN6w7Oe0Ze06qcK+J=6rrmA_aWGnY__MRVDCKw@mail.gmail.com>
	<CAOQ4uxhA+f-GZs-6SwNtSYZvSwfsYz4_=8_tWAUqt9s-49bqLw@mail.gmail.com>
	<20211027132319.GA7873@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027132319.GA7873@quack2.suse.cz>
Subject: Re: [Virtio-fs] [RFC PATCH 0/7] Inotify support in FUSE and virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jan Kara <jack@suse.cz>
Cc: Steve French <sfrench@samba.org>, Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Oct 27, 2021 at 03:23:19PM +0200, Jan Kara wrote:
> On Wed 27-10-21 08:59:15, Amir Goldstein wrote:
> > On Tue, Oct 26, 2021 at 10:14 PM Ioannis Angelakopoulos
> > <iangelak@redhat.com> wrote:
> > > On Tue, Oct 26, 2021 at 2:27 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > The problem here is that the OPEN event might still be travelling towards the guest in the
> > > virtqueues and arrives after the guest has already deleted its local inode.
> > > While the remote event (OPEN) received by the guest is valid, its fsnotify
> > > subsystem will drop it since the local inode is not there.
> > >
> > 
> > I have a feeling that we are mixing issues related to shared server
> > and remote fsnotify.
> 
> I don't think Ioannis was speaking about shared server case here. I think
> he says that in a simple FUSE remote notification setup we can loose OPEN
> events (or basically any other) if the inode for which the event happens
> gets deleted sufficiently early after the event being generated. That seems
> indeed somewhat unexpected and could be confusing if it happens e.g. for
> some directory operations.

Hi Jan,

Agreed. That's what Ioannis is trying to say. That some of the remote events
can be lost if fuse/guest local inode is unlinked. I think problem exists
both for shared and non-shared directory case.

With local filesystems we have a control that we can first queue up
the event in buffer before we remove local watches. With events travelling
from a remote server, there is no such control/synchronization. It can
very well happen that events got delayed in the communication path
somewhere and local watches went away and now there is no way to 
deliver those events to the application.

Thanks
Vivek

