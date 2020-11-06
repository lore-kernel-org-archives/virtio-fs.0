Date: Fri, 6 Nov 2020 11:00:15 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201106160015.GD1436035@redhat.com>
References: <20201009181512.65496-1-vgoyal@redhat.com>
	<20201009181512.65496-6-vgoyal@redhat.com>
	<CAJfpegvhK+5-Zze7qZFrXkUkXbN_4M1CpEqyL9Rq9UNOtb2ckg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvhK+5-Zze7qZFrXkUkXbN_4M1CpEqyL9Rq9UNOtb2ckg@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v3 5/6] fuse: Add a flag FUSE_OPEN_KILL_PRIV
 for open() request
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>

On Fri, Nov 06, 2020 at 02:55:11PM +0100, Miklos Szeredi wrote:
> On Fri, Oct 9, 2020 at 8:16 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > With FUSE_HANDLE_KILLPRIV_V2 support, server will need to kill
> > suid/sgid/security.capability on open(O_TRUNC), if server supports
> > FUSE_ATOMIC_O_TRUNC.
> >
> > But server needs to kill suid/sgid only if caller does not have
> > CAP_FSETID. Given server does not have this information, client
> > needs to send this info to server.
> >
> > So add a flag FUSE_OPEN_KILL_PRIV to fuse_open_in request which tells
> > server to kill suid/sgid(only if group execute is set).
> 
> This is needed for FUSE_CREATE as well (which may act as a normal open
> in case the file exists, and no O_EXCL was specified), right?

Hi Miklos,

IIUC, In current code we seem to use FUSE_CREATE only if file does not exist.
If file exists, then we probably will take FUSE_OPEN path.

Are you concerned about future proofing where somebody decides to use
FUSE_CREATE for create + open on a file which exists. If yes, I agree that
patching FUSE_CREATE makes sense.

> 
> I can edit the patch, if you agree.

Please do.

Thanks
Vivek

