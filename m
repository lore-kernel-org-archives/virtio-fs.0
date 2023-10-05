Return-Path: <mst@redhat.com>
Date: Thu, 5 Oct 2023 13:15:40 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20231005131352-mutt-send-email-mst@kernel.org>
References: <20231004125904.110781-1-hreitz@redhat.com>
 <20231004125904.110781-2-hreitz@redhat.com>
 <20231005170852.GB1342722@fedora>
MIME-Version: 1.0
In-Reply-To: <20231005170852.GB1342722@fedora>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] (no subject)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
Cc: Hanna Czenczek <hreitz@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>

On Thu, Oct 05, 2023 at 01:08:52PM -0400, Stefan Hajnoczi wrote:
> On Wed, Oct 04, 2023 at 02:58:57PM +0200, Hanna Czenczek wrote:
> > There is no clearly defined purpose for the virtio status byte in
> > vhost-user: For resetting, we already have RESET_DEVICE; and for virtio
> > feature negotiation, we have [GS]ET_FEATURES.  With the REPLY_ACK
> > protocol extension, it is possible for SET_FEATURES to return errors
> > (SET_PROTOCOL_FEATURES may be called before SET_FEATURES).
> > 
> > As for implementations, SET_STATUS is not widely implemented.  dpdk does
> > implement it, but only uses it to signal feature negotiation failure.
> > While it does log reset requests (SET_STATUS 0) as such, it effectively
> > ignores them, in contrast to RESET_OWNER (which is deprecated, and today
> > means the same thing as RESET_DEVICE).
> > 
> > While qemu superficially has support for [GS]ET_STATUS, it does not
> > forward the guest-set status byte, but instead just makes it up
> > internally, and actually completely ignores what the back-end returns,
> > only using it as the template for a subsequent SET_STATUS to add single
> > bits to it.  Notably, after setting FEATURES_OK, it never reads it back
> > to see whether the flag is still set, which is the only way in which
> > dpdk uses the status byte.
> > 
> > As-is, no front-end or back-end can rely on the other side handling this
> > field in a useful manner, and it also provides no practical use over
> > other mechanisms the vhost-user protocol has, which are more clearly
> > defined.  Deprecate it.
> > 
> > Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> > Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> > ---
> >  docs/interop/vhost-user.rst | 28 +++++++++++++++++++++-------
> >  1 file changed, 21 insertions(+), 7 deletions(-)
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>


SET_STATUS is the only way to signal failure to acknowledge FEATURES_OK.
The fact current backends never check errors does not mean they never
will. So no, not applying this.

-- 
MST

