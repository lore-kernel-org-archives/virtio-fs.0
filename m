Date: Mon, 19 Apr 2021 15:07:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210419190753.GE1472665@redhat.com>
References: <20210414201207.3612432-3-jose.carlos.venegas.munoz@intel.com>
	<CANRX0ORJA43.22ADKWIJW7DI0@redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRX0ORJA43.22ADKWIJW7DI0@redhat>
Subject: Re: [Virtio-fs] [PATCH 2/2] virtiofsd: Add help for -o xattr-mapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Connor Kuehl <ckuehl@redhat.com>
Cc: virtio-fs@redhat.com, Carlos Venegas <jose.carlos.venegas.munoz@intel.com>, qemu-devel@nongnu.org

On Wed, Apr 14, 2021 at 04:44:26PM -0500, Connor Kuehl wrote:
> On Wed Apr 14, 2021 at 3:12 PM CDT, Carlos Venegas wrote:
> > The option is not documented in help.
> >
> > Add small help about the option.
> >
> > Signed-off-by: Carlos Venegas <jose.carlos.venegas.munoz@intel.com>
> > ---
> > tools/virtiofsd/helper.c | 3 +++
> > 1 file changed, 3 insertions(+)
> >
> > diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
> > index 28243b51b2..5e98ed702b 100644
> > --- a/tools/virtiofsd/helper.c
> > +++ b/tools/virtiofsd/helper.c
> > @@ -172,6 +172,9 @@ void fuse_cmdline_help(void)
> > " default: no_writeback\n"
> > " -o xattr|no_xattr enable/disable xattr\n"
> > " default: no_xattr\n"
> > + " -o xattrmap=<mapping> Enable xattr mapping (enables xattr)\n"
> > + " <mapping> is a string consists of a series of rules\n"
> > + " e.g. -o xattrmap=:map::user.virtiofs.:\n"
> 
> This is a helpful note, but it doesn't tell the whole story. I think
> it'd be helpful to add one last note to this option which is to
> recommend reading the virtiofsd(1) man-page for more information on
> xattrmap rules.

Is there a virtiofsd man page as well? All I see is
docs/tools/virtiofsd.rst.

Vivek

