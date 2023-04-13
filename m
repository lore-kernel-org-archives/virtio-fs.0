Return-Path: <mst@redhat.com>
Date: Thu, 13 Apr 2023 12:11:42 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20230413120554-mutt-send-email-mst@kernel.org>
References: <20230411150515.14020-1-hreitz@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20230411150515.14020-1-hreitz@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 0/4] vhost-user-fs: Internal migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>

On Tue, Apr 11, 2023 at 05:05:11PM +0200, Hanna Czenczek wrote:
> RFC:
> https://lists.nongnu.org/archive/html/qemu-devel/2023-03/msg04263.html
> 
> Hi,
> 
> Patch 2 of this series adds new vhost methods (only for vhost-user at
> this point) for transferring the back-end’s internal state to/from qemu
> during migration, so that this state can be stored in the migration
> stream.  (This is what we call “internal migration”, because the state
> is internally available to qemu; this is in contrast to “external
> migration”, which Anton is working on, where the back-end’s state is
> handled by the back-end itself without involving qemu.)
> 
> For this, the state is handled as a binary blob by qemu, and it is
> transferred over a pipe that is established via a new vhost method.
> 
> Patch 3 adds two high-level helper functions to (A) fetch any vhost
> back-end’s internal state and store it in a migration stream (a
> `QEMUFile`), and (B) load such state from a migrations stream and send
> it to a vhost back-end.  These build on the low-level interface
> introduced in patch 2.
> 
> Patch 4 then uses these functions to implement internal migration for
> vhost-user-fs.  Note that this of course depends on support in the
> back-end (virtiofsd), which is not yet ready.
> 
> Finally, patch 1 fixes a bug around migrating vhost-user devices: To
> enable/disable logging[1], the VHOST_F_LOG_ALL feature must be
> set/cleared, via the SET_FEATURES call.  Another, technically unrelated,
> feature exists, VHOST_USER_F_PROTOCOL_FEATURES, which indicates support
> for vhost-user protocol features.  Naturally, qemu wants to keep that
> other feature enabled, so it will set it (when possible) in every
> SET_FEATURES call.  However, a side effect of setting
> VHOST_USER_F_PROTOCOL_FEATURES is that all vrings are disabled.


I didn't get this part.
Two questions:
	Rings can be enabled or disabled by ``VHOST_USER_SET_VRING_ENABLE``.

	If ``VHOST_USER_F_PROTOCOL_FEATURES`` has not been negotiated, the
	ring starts directly in the enabled state.

	If ``VHOST_USER_F_PROTOCOL_FEATURES`` has been negotiated, the ring is
	initialized in a disabled state and is enabled by
	``VHOST_USER_SET_VRING_ENABLE`` with parameter 1.

so VHOST_USER_F_PROTOCOL_FEATURES only controls initial state of rings,
it does not disable rings.



>  This
> causes any enabling (done at the start of migration) or disabling (done
> on the source after a cancelled/failed migration) of logging to make the
> back-end hang.  Without patch 1, therefore, starting a migration will
> have any vhost-user back-end that supports both VHOST_F_LOG_ALL and
> VHOST_USER_F_PROTOCOL_FEATURES immediately hang completely, and unless
> execution is transferred to the destination, it will continue to hang.
> 
> 
> [1] Logging here means logging writes to guest memory pages in a dirty
> bitmap so that these dirty pages are flushed to the destination.  qemu
> cannot monitor the back-end’s writes to guest memory, so the back-end
> has to do so itself, and log its writes in a dirty bitmap shared with
> qemu.
> 
> 
> Changes in v1 compared to the RFC:
> - Patch 1 added
> 
> - Patch 2: Interface is different, now uses a pipe instead of shared
>   memory (as suggested by Stefan); also, this is now a generic
>   vhost-user interface, and not just for vhost-user-fs
> 
> - Patches 3 and 4: Because this is now supposed to be a generic
>   migration method for vhost-user back-ends, most of the migration code
>   has been moved from vhost-user-fs.c to vhost.c so it can be shared
>   between different back-ends.  The vhost-user-fs code is now a rather
>   thin wrapper around the common code.
>   - Note also (as suggested by Anton) that the back-end’s migration
>     state is now in a subsection, and that it is technically optional.
>     “Technically” means that with this series, it is always used (unless
>     the back-end doesn’t support migration, in which case migration is
>     just blocked), but Anton’s series for external migration would make
>     it optional.  (I.e., the subsection would be skipped for external
>     migration, and mandatorily included for internal migration.)
> 
> 
> Hanna Czenczek (4):
>   vhost: Re-enable vrings after setting features
>   vhost-user: Interface for migration state transfer
>   vhost: Add high-level state save/load functions
>   vhost-user-fs: Implement internal migration
> 
>  include/hw/virtio/vhost-backend.h |  24 +++
>  include/hw/virtio/vhost.h         | 124 +++++++++++++++
>  hw/virtio/vhost-user-fs.c         | 101 +++++++++++-
>  hw/virtio/vhost-user.c            | 147 ++++++++++++++++++
>  hw/virtio/vhost.c                 | 246 ++++++++++++++++++++++++++++++
>  5 files changed, 641 insertions(+), 1 deletion(-)
> 
> -- 
> 2.39.1

