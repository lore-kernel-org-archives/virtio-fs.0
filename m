Return-Path: <mst@redhat.com>
Date: Wed, 18 Oct 2023 08:14:12 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20231018081336-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20231004125904.110781-8-hreitz@redhat.com>
 <20231004125904.110781-9-hreitz@redhat.com>
 <20231004125904.110781-7-hreitz@redhat.com>
 <20231004125904.110781-6-hreitz@redhat.com>
 <20231004125904.110781-5-hreitz@redhat.com>
 <20231004125904.110781-4-hreitz@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v4 3/8] vhost-user.rst: Clarify
 enabling/disabling vrings
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, German Maglione <gmaglione@redhat.com>, Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>

On Wed, Oct 04, 2023 at 02:58:59PM +0200, Hanna Czenczek wrote:
> Currently, the vhost-user documentation says that rings are to be
> initialized in a disabled state when VHOST_USER_F_PROTOCOL_FEATURES is
> negotiated.  However, by the time of feature negotiation, all rings have
> already been initialized, so it is not entirely clear what this means.
> 
> At least the vhost-user-backend Rust crate's implementation interpreted
> it to mean that whenever this feature is negotiated, all rings are to
> put into a disabled state, which means that every SET_FEATURES call
> would disable all rings, effectively halting the device.  This is
> problematic because the VHOST_F_LOG_ALL feature is also set or cleared
> this way, which happens during migration.  Doing so should not halt the
> device.
> 
> Other implementations have interpreted this to mean that the device is
> to be initialized with all rings disabled, and a subsequent SET_FEATURES
> call that does not set VHOST_USER_F_PROTOCOL_FEATURES will enable all of
> them.  Here, SET_FEATURES will never disable any ring.
> 
> This interpretation does not suffer the problem of unintentionally
> halting the device whenever features are set or cleared, so it seems
> better and more reasonable.
> 
> We can clarify this in the documentation by making it explicit that the
> enabled/disabled state is tracked even while the vring is stopped.
> Every vring is initialized in a disabled state, and SET_FEATURES without
> VHOST_USER_F_PROTOCOL_FEATURES simply becomes one way to enable all
> vrings.
> 
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>


OK so I am expecting v5. My advice is to move patch 1 to end of patchset
so we can defer it if we want to.

> ---
>  docs/interop/vhost-user.rst | 32 +++++++++++++++++---------------
>  1 file changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
> index 50f5acebe5..9f4940a036 100644
> --- a/docs/interop/vhost-user.rst
> +++ b/docs/interop/vhost-user.rst
> @@ -395,31 +395,33 @@ negotiation.
>  Ring states
>  -----------
>  
> -Rings can be in one of three states:
> +Rings have two independent states: started/stopped, and enabled/disabled.
>  
> -* stopped: the back-end must not process the ring at all.
> +* While a ring is stopped, the back-end must not process the ring at
> +  all, regardless of whether it is enabled or disabled.  The
> +  enabled/disabled state should still be tracked, though, so it can come
> +  into effect once the ring is started.
>  
> -* started but disabled: the back-end must process the ring without
> +* started and disabled: The back-end must process the ring without
>    causing any side effects.  For example, for a networking device,
>    in the disabled state the back-end must not supply any new RX packets,
>    but must process and discard any TX packets.
>  
> -* started and enabled.
> +* started and enabled: The back-end must process the ring normally, i.e.
> +  process all requests and execute them.
>  
> -Each ring is initialized in a stopped state.  The back-end must start
> -ring upon receiving a kick (that is, detecting that file descriptor is
> -readable) on the descriptor specified by ``VHOST_USER_SET_VRING_KICK``
> -or receiving the in-band message ``VHOST_USER_VRING_KICK`` if negotiated,
> -and stop ring upon receiving ``VHOST_USER_GET_VRING_BASE``.
> +Each ring is initialized in a stopped and disabled state.  The back-end
> +must start a ring upon receiving a kick (that is, detecting that file
> +descriptor is readable) on the descriptor specified by
> +``VHOST_USER_SET_VRING_KICK`` or receiving the in-band message
> +``VHOST_USER_VRING_KICK`` if negotiated, and stop a ring upon receiving
> +``VHOST_USER_GET_VRING_BASE``.
>  
>  Rings can be enabled or disabled by ``VHOST_USER_SET_VRING_ENABLE``.
>  
> -If ``VHOST_USER_F_PROTOCOL_FEATURES`` has not been negotiated, the
> -ring starts directly in the enabled state.
> -
> -If ``VHOST_USER_F_PROTOCOL_FEATURES`` has been negotiated, the ring is
> -initialized in a disabled state and is enabled by
> -``VHOST_USER_SET_VRING_ENABLE`` with parameter 1.
> +In addition, upon receiving a ``VHOST_USER_SET_FEATURES`` message from
> +the front-end without ``VHOST_USER_F_PROTOCOL_FEATURES`` set, the
> +back-end must enable all rings immediately.
>  
>  While processing the rings (whether they are enabled or not), the back-end
>  must support changing some configuration aspects on the fly.
> -- 
> 2.41.0

On Wed, Oct 04, 2023 at 02:59:00PM +0200, Hanna Czenczek wrote:
> In vDPA, GET_VRING_BASE does not stop the queried vring, which is why
> SUSPEND was introduced so that the returned index would be stable.  In
> vhost-user, it does stop the vring, so under the same reasoning, it can
> get away without SUSPEND.
> 
> Still, we do want to clarify that if the device is completely stopped,
> i.e. all vrings are stopped, the back-end should cease to modify any
> state relating to the guest.  Do this by calling it "suspended".
> 
> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>  docs/interop/vhost-user.rst | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
> index 9f4940a036..d282155562 100644
> --- a/docs/interop/vhost-user.rst
> +++ b/docs/interop/vhost-user.rst
> @@ -426,6 +426,19 @@ back-end must enable all rings immediately.
>  While processing the rings (whether they are enabled or not), the back-end
>  must support changing some configuration aspects on the fly.
>  
> +.. _suspended_device_state:
> +
> +Suspended device state
> +^^^^^^^^^^^^^^^^^^^^^^
> +
> +While all vrings are stopped, the device is *suspended*.  In addition to
> +not processing any vring (because they are stopped), the device must:
> +
> +* not write to any guest memory regions,
> +* not send any notifications to the guest,
> +* not send any messages to the front-end,
> +* still process and reply to messages from the front-end.
> +
>  Multiple queue support
>  ----------------------
>  
> @@ -513,7 +526,8 @@ ancillary data, it may be used to inform the front-end that the log has
>  been modified.
>  
>  Once the source has finished migration, rings will be stopped by the
> -source. No further update must be done before rings are restarted.
> +source (:ref:`Suspended device state <suspended_device_state>`). No
> +further update must be done before rings are restarted.
>  
>  In postcopy migration the back-end is started before all the memory has
>  been received from the source host, and care must be taken to avoid
> @@ -1101,6 +1115,10 @@ Front-end message types
>    (*a vring descriptor index for split virtqueues* vs. *vring descriptor
>    indices for packed virtqueues*).
>  
> +  When and as long as all of a device’s vrings are stopped, it is
> +  *suspended*, see :ref:`Suspended device state
> +  <suspended_device_state>`.
> +
>    The request payload’s *num* field is currently reserved and must be
>    set to 0.
>  
> -- 
> 2.41.0

On Wed, Oct 04, 2023 at 02:59:01PM +0200, Hanna Czenczek wrote:
> For vhost-user devices, qemu can migrate the virtio state, but not the
> back-end's internal state.  To do so, we need to be able to transfer
> this internal state between front-end (qemu) and back-end.
> 
> At this point, this new feature is added for the purpose of virtio-fs
> migration.  Because virtiofsd's internal state will not be too large, we
> believe it is best to transfer it as a single binary blob after the
> streaming phase.
> 
> These are the additions to the protocol:
> - New vhost-user protocol feature VHOST_USER_PROTOCOL_F_DEVICE_STATE
> - SET_DEVICE_STATE_FD function: Front-end and back-end negotiate a file
>   descriptor over which to transfer the state.
> - CHECK_DEVICE_STATE: After the state has been transferred through the
>   file descriptor, the front-end invokes this function to verify
>   success.  There is no in-band way (through the file descriptor) to
>   indicate failure, so we need to check explicitly.
> 
> Once the transfer FD has been established via SET_DEVICE_STATE_FD
> (which includes establishing the direction of transfer and migration
> phase), the sending side writes its data into it, and the reading side
> reads it until it sees an EOF.  Then, the front-end will check for
> success via CHECK_DEVICE_STATE, which on the destination side includes
> checking for integrity (i.e. errors during deserialization).
> 
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>  docs/interop/vhost-user.rst | 172 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 172 insertions(+)
> 
> diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
> index d282155562..aa91e2b34e 100644
> --- a/docs/interop/vhost-user.rst
> +++ b/docs/interop/vhost-user.rst
> @@ -306,6 +306,32 @@ Inflight description
>  
>  :queue size: a 16-bit size of virtqueues
>  
> +Device state transfer parameters
> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +
> ++--------------------+-----------------+
> +| transfer direction | migration phase |
> ++--------------------+-----------------+
> +
> +:transfer direction: a 32-bit enum, describing the direction in which
> +  the state is transferred:
> +
> +  - 0: Save: Transfer the state from the back-end to the front-end,
> +    which happens on the source side of migration
> +  - 1: Load: Transfer the state from the front-end to the back-end,
> +    which happens on the destination side of migration
> +
> +:migration phase: a 32-bit enum, describing the state in which the VM
> +  guest and devices are:
> +
> +  - 0: Stopped (in the period after the transfer of memory-mapped
> +    regions before switch-over to the destination): The VM guest is
> +    stopped, and the vhost-user device is suspended (see
> +    :ref:`Suspended device state <suspended_device_state>`).
> +
> +  In the future, additional phases might be added e.g. to allow
> +  iterative migration while the device is running.
> +
>  C structure
>  -----------
>  
> @@ -365,6 +391,7 @@ in the ancillary data:
>  * ``VHOST_USER_SET_VRING_ERR``
>  * ``VHOST_USER_SET_BACKEND_REQ_FD`` (previous name ``VHOST_USER_SET_SLAVE_REQ_FD``)
>  * ``VHOST_USER_SET_INFLIGHT_FD`` (if ``VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD``)
> +* ``VHOST_USER_SET_DEVICE_STATE_FD``
>  
>  If *front-end* is unable to send the full message or receives a wrong
>  reply it will close the connection. An optional reconnection mechanism
> @@ -539,6 +566,80 @@ it performs WAKE ioctl's on the userfaultfd to wake the stalled
>  back-end.  The front-end indicates support for this via the
>  ``VHOST_USER_PROTOCOL_F_PAGEFAULT`` feature.
>  
> +.. _migrating_backend_state:
> +
> +Migrating back-end state
> +^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +Migrating device state involves transferring the state from one
> +back-end, called the source, to another back-end, called the
> +destination.  After migration, the destination transparently resumes
> +operation without requiring the driver to re-initialize the device at
> +the VIRTIO level.  If the migration fails, then the source can
> +transparently resume operation until another migration attempt is made.
> +
> +Generally, the front-end is connected to a virtual machine guest (which
> +contains the driver), which has its own state to transfer between source
> +and destination, and therefore will have an implementation-specific
> +mechanism to do so.  The ``VHOST_USER_PROTOCOL_F_DEVICE_STATE`` feature
> +provides functionality to have the front-end include the back-end's
> +state in this transfer operation so the back-end does not need to
> +implement its own mechanism, and so the virtual machine may have its
> +complete state, including vhost-user devices' states, contained within a
> +single stream of data.
> +
> +To do this, the back-end state is transferred from back-end to front-end
> +on the source side, and vice versa on the destination side.  This
> +transfer happens over a channel that is negotiated using the
> +``VHOST_USER_SET_DEVICE_STATE_FD`` message.  This message has two
> +parameters:
> +
> +* Direction of transfer: On the source, the data is saved, transferring
> +  it from the back-end to the front-end.  On the destination, the data
> +  is loaded, transferring it from the front-end to the back-end.
> +
> +* Migration phase: Currently, the only supported phase is the period
> +  after the transfer of memory-mapped regions before switch-over to the
> +  destination, when both the source and destination devices are
> +  suspended (:ref:`Suspended device state <suspended_device_state>`).
> +  In the future, additional phases might be supported to allow iterative
> +  migration while the device is running.
> +
> +The nature of the channel is implementation-defined, but it must
> +generally behave like a pipe: The writing end will write all the data it
> +has into it, signalling the end of data by closing its end.  The reading
> +end must read all of this data (until encountering the end of file) and
> +process it.
> +
> +* When saving, the writing end is the source back-end, and the reading
> +  end is the source front-end.  After reading the state data from the
> +  channel, the source front-end must transfer it to the destination
> +  front-end through an implementation-defined mechanism.
> +
> +* When loading, the writing end is the destination front-end, and the
> +  reading end is the destination back-end.  After reading the state data
> +  from the channel, the destination back-end must deserialize its
> +  internal state from that data and set itself up to allow the driver to
> +  seamlessly resume operation on the VIRTIO level.
> +
> +Seamlessly resuming operation means that the migration must be
> +transparent to the guest driver, which operates on the VIRTIO level.
> +This driver will not perform any re-initialization steps, but continue
> +to use the device as if no migration had occurred.  The vhost-user
> +front-end, however, will re-initialize the vhost state on the
> +destination, following the usual protocol for establishing a connection
> +to a vhost-user back-end: This includes, for example, setting up memory
> +mappings and kick and call FDs as necessary, negotiating protocol
> +features, or setting the initial vring base indices (to the same value
> +as on the source side, so that operation can resume).
> +
> +Both on the source and on the destination side, after the respective
> +front-end has seen all data transferred (when the transfer FD has been
> +closed), it sends the ``VHOST_USER_CHECK_DEVICE_STATE`` message to
> +verify that data transfer was successful in the back-end, too.  The
> +back-end responds once it knows whether the transfer and processing was
> +successful or not.
> +
>  Memory access
>  -------------
>  
> @@ -932,6 +1033,7 @@ Protocol features
>    #define VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS  15
>    #define VHOST_USER_PROTOCOL_F_STATUS               16
>    #define VHOST_USER_PROTOCOL_F_XEN_MMAP             17
> +  #define VHOST_USER_PROTOCOL_F_DEVICE_STATE         18
>  
>  Front-end message types
>  -----------------------
> @@ -1532,6 +1634,76 @@ Front-end message types
>    back-end for its device status as defined in the Virtio specification.
>    Deprecated together with VHOST_USER_SET_STATUS.
>  
> +``VHOST_USER_SET_DEVICE_STATE_FD``
> +  :id: 41
> +  :equivalent ioctl: N/A
> +  :request payload: device state transfer parameters
> +  :reply payload: ``u64``
> +
> +  Front-end and back-end negotiate a channel over which to transfer the
> +  back-end’s internal state during migration.  Either side (front-end or
> +  back-end) may create the channel.  The nature of this channel is not
> +  restricted or defined in this document, but whichever side creates it
> +  must create a file descriptor that is provided to the respectively
> +  other side, allowing access to the channel.  This FD must behave as
> +  follows:
> +
> +  * For the writing end, it must allow writing the whole back-end state
> +    sequentially.  Closing the file descriptor signals the end of
> +    transfer.
> +
> +  * For the reading end, it must allow reading the whole back-end state
> +    sequentially.  The end of file signals the end of the transfer.
> +
> +  For example, the channel may be a pipe, in which case the two ends of
> +  the pipe fulfill these requirements respectively.
> +
> +  Initially, the front-end creates a channel along with such an FD.  It
> +  passes the FD to the back-end as ancillary data of a
> +  ``VHOST_USER_SET_DEVICE_STATE_FD`` message.  The back-end may create a
> +  different transfer channel, passing the respective FD back to the
> +  front-end as ancillary data of the reply.  If so, the front-end must
> +  then discard its channel and use the one provided by the back-end.
> +
> +  Whether the back-end should decide to use its own channel is decided
> +  based on efficiency: If the channel is a pipe, both ends will most
> +  likely need to copy data into and out of it.  Any channel that allows
> +  for more efficient processing on at least one end, e.g. through
> +  zero-copy, is considered more efficient and thus preferred.  If the
> +  back-end can provide such a channel, it should decide to use it.
> +
> +  The request payload contains parameters for the subsequent data
> +  transfer, as described in the :ref:`Migrating back-end state
> +  <migrating_backend_state>` section.
> +
> +  The value returned is both an indication for success, and whether a
> +  file descriptor for a back-end-provided channel is returned: Bits 0–7
> +  are 0 on success, and non-zero on error.  Bit 8 is the invalid FD
> +  flag; this flag is set when there is no file descriptor returned.
> +  When this flag is not set, the front-end must use the returned file
> +  descriptor as its end of the transfer channel.  The back-end must not
> +  both indicate an error and return a file descriptor.
> +
> +  Using this function requires prior negotiation of the
> +  ``VHOST_USER_PROTOCOL_F_DEVICE_STATE`` feature.
> +
> +``VHOST_USER_CHECK_DEVICE_STATE``
> +  :id: 42
> +  :equivalent ioctl: N/A
> +  :request payload: N/A
> +  :reply payload: ``u64``
> +
> +  After transferring the back-end’s internal state during migration (see
> +  the :ref:`Migrating back-end state <migrating_backend_state>`
> +  section), check whether the back-end was able to successfully fully
> +  process the state.
> +
> +  The value returned indicates success or error; 0 is success, any
> +  non-zero value is an error.
> +
> +  Using this function requires prior negotiation of the
> +  ``VHOST_USER_PROTOCOL_F_DEVICE_STATE`` feature.
> +
>  
>  Back-end message types
>  ----------------------
> -- 
> 2.41.0

On Wed, Oct 04, 2023 at 02:59:02PM +0200, Hanna Czenczek wrote:
> Add the interface for transferring the back-end's state during migration
> as defined previously in vhost-user.rst.
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>  include/hw/virtio/vhost-backend.h |  24 +++++
>  include/hw/virtio/vhost.h         |  78 ++++++++++++++++
>  hw/virtio/vhost-user.c            | 148 ++++++++++++++++++++++++++++++
>  hw/virtio/vhost.c                 |  37 ++++++++
>  4 files changed, 287 insertions(+)
> 
> diff --git a/include/hw/virtio/vhost-backend.h b/include/hw/virtio/vhost-backend.h
> index 31a251a9f5..b6eee7e9fd 100644
> --- a/include/hw/virtio/vhost-backend.h
> +++ b/include/hw/virtio/vhost-backend.h
> @@ -26,6 +26,18 @@ typedef enum VhostSetConfigType {
>      VHOST_SET_CONFIG_TYPE_MIGRATION = 1,
>  } VhostSetConfigType;
>  
> +typedef enum VhostDeviceStateDirection {
> +    /* Transfer state from back-end (device) to front-end */
> +    VHOST_TRANSFER_STATE_DIRECTION_SAVE = 0,
> +    /* Transfer state from front-end to back-end (device) */
> +    VHOST_TRANSFER_STATE_DIRECTION_LOAD = 1,
> +} VhostDeviceStateDirection;
> +
> +typedef enum VhostDeviceStatePhase {
> +    /* The device (and all its vrings) is stopped */
> +    VHOST_TRANSFER_STATE_PHASE_STOPPED = 0,
> +} VhostDeviceStatePhase;
> +
>  struct vhost_inflight;
>  struct vhost_dev;
>  struct vhost_log;
> @@ -133,6 +145,15 @@ typedef int (*vhost_set_config_call_op)(struct vhost_dev *dev,
>  
>  typedef void (*vhost_reset_status_op)(struct vhost_dev *dev);
>  
> +typedef bool (*vhost_supports_device_state_op)(struct vhost_dev *dev);
> +typedef int (*vhost_set_device_state_fd_op)(struct vhost_dev *dev,
> +                                            VhostDeviceStateDirection direction,
> +                                            VhostDeviceStatePhase phase,
> +                                            int fd,
> +                                            int *reply_fd,
> +                                            Error **errp);
> +typedef int (*vhost_check_device_state_op)(struct vhost_dev *dev, Error **errp);
> +
>  typedef struct VhostOps {
>      VhostBackendType backend_type;
>      vhost_backend_init vhost_backend_init;
> @@ -181,6 +202,9 @@ typedef struct VhostOps {
>      vhost_force_iommu_op vhost_force_iommu;
>      vhost_set_config_call_op vhost_set_config_call;
>      vhost_reset_status_op vhost_reset_status;
> +    vhost_supports_device_state_op vhost_supports_device_state;
> +    vhost_set_device_state_fd_op vhost_set_device_state_fd;
> +    vhost_check_device_state_op vhost_check_device_state;
>  } VhostOps;
>  
>  int vhost_backend_update_device_iotlb(struct vhost_dev *dev,
> diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
> index 14621f9e79..a0d03c9fdf 100644
> --- a/include/hw/virtio/vhost.h
> +++ b/include/hw/virtio/vhost.h
> @@ -348,4 +348,82 @@ static inline int vhost_reset_device(struct vhost_dev *hdev)
>  }
>  #endif /* CONFIG_VHOST */
>  
> +/**
> + * vhost_supports_device_state(): Checks whether the back-end supports
> + * transferring internal device state for the purpose of migration.
> + * Support for this feature is required for vhost_set_device_state_fd()
> + * and vhost_check_device_state().
> + *
> + * @dev: The vhost device
> + *
> + * Returns true if the device supports these commands, and false if it
> + * does not.
> + */
> +bool vhost_supports_device_state(struct vhost_dev *dev);
> +
> +/**
> + * vhost_set_device_state_fd(): Begin transfer of internal state from/to
> + * the back-end for the purpose of migration.  Data is to be transferred
> + * over a pipe according to @direction and @phase.  The sending end must
> + * only write to the pipe, and the receiving end must only read from it.
> + * Once the sending end is done, it closes its FD.  The receiving end
> + * must take this as the end-of-transfer signal and close its FD, too.
> + *
> + * @fd is the back-end's end of the pipe: The write FD for SAVE, and the
> + * read FD for LOAD.  This function transfers ownership of @fd to the
> + * back-end, i.e. closes it in the front-end.
> + *
> + * The back-end may optionally reply with an FD of its own, if this
> + * improves efficiency on its end.  In this case, the returned FD is
> + * stored in *reply_fd.  The back-end will discard the FD sent to it,
> + * and the front-end must use *reply_fd for transferring state to/from
> + * the back-end.
> + *
> + * @dev: The vhost device
> + * @direction: The direction in which the state is to be transferred.
> + *             For outgoing migrations, this is SAVE, and data is read
> + *             from the back-end and stored by the front-end in the
> + *             migration stream.
> + *             For incoming migrations, this is LOAD, and data is read
> + *             by the front-end from the migration stream and sent to
> + *             the back-end to restore the saved state.
> + * @phase: Which migration phase we are in.  Currently, there is only
> + *         STOPPED (device and all vrings are stopped), in the future,
> + *         more phases such as PRE_COPY or POST_COPY may be added.
> + * @fd: Back-end's end of the pipe through which to transfer state; note
> + *      that ownership is transferred to the back-end, so this function
> + *      closes @fd in the front-end.
> + * @reply_fd: If the back-end wishes to use a different pipe for state
> + *            transfer, this will contain an FD for the front-end to
> + *            use.  Otherwise, -1 is stored here.
> + * @errp: Potential error description
> + *
> + * Returns 0 on success, and -errno on failure.
> + */
> +int vhost_set_device_state_fd(struct vhost_dev *dev,
> +                              VhostDeviceStateDirection direction,
> +                              VhostDeviceStatePhase phase,
> +                              int fd,
> +                              int *reply_fd,
> +                              Error **errp);
> +
> +/**
> + * vhost_set_device_state_fd(): After transferring state from/to the
> + * back-end via vhost_set_device_state_fd(), i.e. once the sending end
> + * has closed the pipe, inquire the back-end to report any potential
> + * errors that have occurred on its side.  This allows to sense errors
> + * like:
> + * - During outgoing migration, when the source side had already started
> + *   to produce its state, something went wrong and it failed to finish
> + * - During incoming migration, when the received state is somehow
> + *   invalid and cannot be processed by the back-end
> + *
> + * @dev: The vhost device
> + * @errp: Potential error description
> + *
> + * Returns 0 when the back-end reports successful state transfer and
> + * processing, and -errno when an error occurred somewhere.
> + */
> +int vhost_check_device_state(struct vhost_dev *dev, Error **errp);
> +
>  #endif
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index 7bed9ad7d5..7096b148a9 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -74,6 +74,8 @@ enum VhostUserProtocolFeature {
>      /* Feature 14 reserved for VHOST_USER_PROTOCOL_F_INBAND_NOTIFICATIONS. */
>      VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS = 15,
>      VHOST_USER_PROTOCOL_F_STATUS = 16,
> +    /* Feature 17 reserved for VHOST_USER_PROTOCOL_F_XEN_MMAP. */
> +    VHOST_USER_PROTOCOL_F_DEVICE_STATE = 18,
>      VHOST_USER_PROTOCOL_F_MAX
>  };
>  
> @@ -121,6 +123,8 @@ typedef enum VhostUserRequest {
>      VHOST_USER_REM_MEM_REG = 38,
>      VHOST_USER_SET_STATUS = 39,
>      VHOST_USER_GET_STATUS = 40,
> +    VHOST_USER_SET_DEVICE_STATE_FD = 41,
> +    VHOST_USER_CHECK_DEVICE_STATE = 42,
>      VHOST_USER_MAX
>  } VhostUserRequest;
>  
> @@ -212,6 +216,12 @@ typedef struct {
>      uint32_t size; /* the following payload size */
>  } QEMU_PACKED VhostUserHeader;
>  
> +/* Request payload of VHOST_USER_SET_DEVICE_STATE_FD */
> +typedef struct VhostUserTransferDeviceState {
> +    uint32_t direction;
> +    uint32_t phase;
> +} VhostUserTransferDeviceState;
> +
>  typedef union {
>  #define VHOST_USER_VRING_IDX_MASK   (0xff)
>  #define VHOST_USER_VRING_NOFD_MASK  (0x1 << 8)
> @@ -226,6 +236,7 @@ typedef union {
>          VhostUserCryptoSession session;
>          VhostUserVringArea area;
>          VhostUserInflight inflight;
> +        VhostUserTransferDeviceState transfer_state;
>  } VhostUserPayload;
>  
>  typedef struct VhostUserMsg {
> @@ -2746,6 +2757,140 @@ static void vhost_user_reset_status(struct vhost_dev *dev)
>      }
>  }
>  
> +static bool vhost_user_supports_device_state(struct vhost_dev *dev)
> +{
> +    return virtio_has_feature(dev->protocol_features,
> +                              VHOST_USER_PROTOCOL_F_DEVICE_STATE);
> +}
> +
> +static int vhost_user_set_device_state_fd(struct vhost_dev *dev,
> +                                          VhostDeviceStateDirection direction,
> +                                          VhostDeviceStatePhase phase,
> +                                          int fd,
> +                                          int *reply_fd,
> +                                          Error **errp)
> +{
> +    int ret;
> +    struct vhost_user *vu = dev->opaque;
> +    VhostUserMsg msg = {
> +        .hdr = {
> +            .request = VHOST_USER_SET_DEVICE_STATE_FD,
> +            .flags = VHOST_USER_VERSION,
> +            .size = sizeof(msg.payload.transfer_state),
> +        },
> +        .payload.transfer_state = {
> +            .direction = direction,
> +            .phase = phase,
> +        },
> +    };
> +
> +    *reply_fd = -1;
> +
> +    if (!vhost_user_supports_device_state(dev)) {
> +        close(fd);
> +        error_setg(errp, "Back-end does not support migration state transfer");
> +        return -ENOTSUP;
> +    }
> +
> +    ret = vhost_user_write(dev, &msg, &fd, 1);
> +    close(fd);
> +    if (ret < 0) {
> +        error_setg_errno(errp, -ret,
> +                         "Failed to send SET_DEVICE_STATE_FD message");
> +        return ret;
> +    }
> +
> +    ret = vhost_user_read(dev, &msg);
> +    if (ret < 0) {
> +        error_setg_errno(errp, -ret,
> +                         "Failed to receive SET_DEVICE_STATE_FD reply");
> +        return ret;
> +    }
> +
> +    if (msg.hdr.request != VHOST_USER_SET_DEVICE_STATE_FD) {
> +        error_setg(errp,
> +                   "Received unexpected message type, expected %d, received %d",
> +                   VHOST_USER_SET_DEVICE_STATE_FD, msg.hdr.request);
> +        return -EPROTO;
> +    }
> +
> +    if (msg.hdr.size != sizeof(msg.payload.u64)) {
> +        error_setg(errp,
> +                   "Received bad message size, expected %zu, received %" PRIu32,
> +                   sizeof(msg.payload.u64), msg.hdr.size);
> +        return -EPROTO;
> +    }
> +
> +    if ((msg.payload.u64 & 0xff) != 0) {
> +        error_setg(errp, "Back-end did not accept migration state transfer");
> +        return -EIO;
> +    }
> +
> +    if (!(msg.payload.u64 & VHOST_USER_VRING_NOFD_MASK)) {
> +        *reply_fd = qemu_chr_fe_get_msgfd(vu->user->chr);
> +        if (*reply_fd < 0) {
> +            error_setg(errp,
> +                       "Failed to get back-end-provided transfer pipe FD");
> +            *reply_fd = -1;
> +            return -EIO;
> +        }
> +    }
> +
> +    return 0;
> +}
> +
> +static int vhost_user_check_device_state(struct vhost_dev *dev, Error **errp)
> +{
> +    int ret;
> +    VhostUserMsg msg = {
> +        .hdr = {
> +            .request = VHOST_USER_CHECK_DEVICE_STATE,
> +            .flags = VHOST_USER_VERSION,
> +            .size = 0,
> +        },
> +    };
> +
> +    if (!vhost_user_supports_device_state(dev)) {
> +        error_setg(errp, "Back-end does not support migration state transfer");
> +        return -ENOTSUP;
> +    }
> +
> +    ret = vhost_user_write(dev, &msg, NULL, 0);
> +    if (ret < 0) {
> +        error_setg_errno(errp, -ret,
> +                         "Failed to send CHECK_DEVICE_STATE message");
> +        return ret;
> +    }
> +
> +    ret = vhost_user_read(dev, &msg);
> +    if (ret < 0) {
> +        error_setg_errno(errp, -ret,
> +                         "Failed to receive CHECK_DEVICE_STATE reply");
> +        return ret;
> +    }
> +
> +    if (msg.hdr.request != VHOST_USER_CHECK_DEVICE_STATE) {
> +        error_setg(errp,
> +                   "Received unexpected message type, expected %d, received %d",
> +                   VHOST_USER_CHECK_DEVICE_STATE, msg.hdr.request);
> +        return -EPROTO;
> +    }
> +
> +    if (msg.hdr.size != sizeof(msg.payload.u64)) {
> +        error_setg(errp,
> +                   "Received bad message size, expected %zu, received %" PRIu32,
> +                   sizeof(msg.payload.u64), msg.hdr.size);
> +        return -EPROTO;
> +    }
> +
> +    if (msg.payload.u64 != 0) {
> +        error_setg(errp, "Back-end failed to process its internal state");
> +        return -EIO;
> +    }
> +
> +    return 0;
> +}
> +
>  const VhostOps user_ops = {
>          .backend_type = VHOST_BACKEND_TYPE_USER,
>          .vhost_backend_init = vhost_user_backend_init,
> @@ -2782,4 +2927,7 @@ const VhostOps user_ops = {
>          .vhost_set_inflight_fd = vhost_user_set_inflight_fd,
>          .vhost_dev_start = vhost_user_dev_start,
>          .vhost_reset_status = vhost_user_reset_status,
> +        .vhost_supports_device_state = vhost_user_supports_device_state,
> +        .vhost_set_device_state_fd = vhost_user_set_device_state_fd,
> +        .vhost_check_device_state = vhost_user_check_device_state,
>  };
> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> index 6003e50e83..85e199f0aa 100644
> --- a/hw/virtio/vhost.c
> +++ b/hw/virtio/vhost.c
> @@ -2096,3 +2096,40 @@ int vhost_reset_device(struct vhost_dev *hdev)
>  
>      return -ENOSYS;
>  }
> +
> +bool vhost_supports_device_state(struct vhost_dev *dev)
> +{
> +    if (dev->vhost_ops->vhost_supports_device_state) {
> +        return dev->vhost_ops->vhost_supports_device_state(dev);
> +    }
> +
> +    return false;
> +}
> +
> +int vhost_set_device_state_fd(struct vhost_dev *dev,
> +                              VhostDeviceStateDirection direction,
> +                              VhostDeviceStatePhase phase,
> +                              int fd,
> +                              int *reply_fd,
> +                              Error **errp)
> +{
> +    if (dev->vhost_ops->vhost_set_device_state_fd) {
> +        return dev->vhost_ops->vhost_set_device_state_fd(dev, direction, phase,
> +                                                         fd, reply_fd, errp);
> +    }
> +
> +    error_setg(errp,
> +               "vhost transport does not support migration state transfer");
> +    return -ENOSYS;
> +}
> +
> +int vhost_check_device_state(struct vhost_dev *dev, Error **errp)
> +{
> +    if (dev->vhost_ops->vhost_check_device_state) {
> +        return dev->vhost_ops->vhost_check_device_state(dev, errp);
> +    }
> +
> +    error_setg(errp,
> +               "vhost transport does not support migration state transfer");
> +    return -ENOSYS;
> +}
> -- 
> 2.41.0

On Wed, Oct 04, 2023 at 02:59:04PM +0200, Hanna Czenczek wrote:
> A virtio-fs device's VM state consists of:
> - the virtio device (vring) state (VMSTATE_VIRTIO_DEVICE)
> - the back-end's (virtiofsd's) internal state
> 
> We get/set the latter via the new vhost operations to transfer migratory
> state.  It is its own dedicated subsection, so that for external
> migration, it can be disabled.
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>  hw/virtio/vhost-user-fs.c | 101 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 100 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> index 49d699ffc2..eb91723855 100644
> --- a/hw/virtio/vhost-user-fs.c
> +++ b/hw/virtio/vhost-user-fs.c
> @@ -298,9 +298,108 @@ static struct vhost_dev *vuf_get_vhost(VirtIODevice *vdev)
>      return &fs->vhost_dev;
>  }
>  
> +/**
> + * Fetch the internal state from virtiofsd and save it to `f`.
> + */
> +static int vuf_save_state(QEMUFile *f, void *pv, size_t size,
> +                          const VMStateField *field, JSONWriter *vmdesc)
> +{
> +    VirtIODevice *vdev = pv;
> +    VHostUserFS *fs = VHOST_USER_FS(vdev);
> +    Error *local_error = NULL;
> +    int ret;
> +
> +    ret = vhost_save_backend_state(&fs->vhost_dev, f, &local_error);
> +    if (ret < 0) {
> +        error_reportf_err(local_error,
> +                          "Error saving back-end state of %s device %s "
> +                          "(tag: \"%s\"): ",
> +                          vdev->name, vdev->parent_obj.canonical_path,
> +                          fs->conf.tag ?: "<none>");
> +        return ret;
> +    }
> +
> +    return 0;
> +}
> +
> +/**
> + * Load virtiofsd's internal state from `f` and send it over to virtiofsd.
> + */
> +static int vuf_load_state(QEMUFile *f, void *pv, size_t size,
> +                          const VMStateField *field)
> +{
> +    VirtIODevice *vdev = pv;
> +    VHostUserFS *fs = VHOST_USER_FS(vdev);
> +    Error *local_error = NULL;
> +    int ret;
> +
> +    ret = vhost_load_backend_state(&fs->vhost_dev, f, &local_error);
> +    if (ret < 0) {
> +        error_reportf_err(local_error,
> +                          "Error loading back-end state of %s device %s "
> +                          "(tag: \"%s\"): ",
> +                          vdev->name, vdev->parent_obj.canonical_path,
> +                          fs->conf.tag ?: "<none>");
> +        return ret;
> +    }
> +
> +    return 0;
> +}
> +
> +static bool vuf_is_internal_migration(void *opaque)
> +{
> +    /* TODO: Return false when an external migration is requested */
> +    return true;
> +}
> +
> +static int vuf_check_migration_support(void *opaque)
> +{
> +    VirtIODevice *vdev = opaque;
> +    VHostUserFS *fs = VHOST_USER_FS(vdev);
> +
> +    if (!vhost_supports_device_state(&fs->vhost_dev)) {
> +        error_report("Back-end of %s device %s (tag: \"%s\") does not support "
> +                     "migration through qemu",
> +                     vdev->name, vdev->parent_obj.canonical_path,
> +                     fs->conf.tag ?: "<none>");
> +        return -ENOTSUP;
> +    }
> +
> +    return 0;
> +}
> +
> +static const VMStateDescription vuf_backend_vmstate;
> +
>  static const VMStateDescription vuf_vmstate = {
>      .name = "vhost-user-fs",
> -    .unmigratable = 1,
> +    .version_id = 0,
> +    .fields = (VMStateField[]) {
> +        VMSTATE_VIRTIO_DEVICE,
> +        VMSTATE_END_OF_LIST()
> +    },
> +    .subsections = (const VMStateDescription * []) {
> +        &vuf_backend_vmstate,
> +        NULL,
> +    }
> +};
> +
> +static const VMStateDescription vuf_backend_vmstate = {
> +    .name = "vhost-user-fs-backend",
> +    .version_id = 0,
> +    .needed = vuf_is_internal_migration,
> +    .pre_load = vuf_check_migration_support,
> +    .pre_save = vuf_check_migration_support,
> +    .fields = (VMStateField[]) {
> +        {
> +            .name = "back-end",
> +            .info = &(const VMStateInfo) {
> +                .name = "virtio-fs back-end state",
> +                .get = vuf_load_state,
> +                .put = vuf_save_state,
> +            },
> +        },
> +        VMSTATE_END_OF_LIST()
> +    },
>  };
>  
>  static Property vuf_properties[] = {
> -- 
> 2.41.0

On Wed, Oct 04, 2023 at 02:59:03PM +0200, Hanna Czenczek wrote:
> vhost_save_backend_state() and vhost_load_backend_state() can be used by
> vhost front-ends to easily save and load the back-end's state to/from
> the migration stream.
> 
> Because we do not know the full state size ahead of time,
> vhost_save_backend_state() simply reads the data in 1 MB chunks, and
> writes each chunk consecutively into the migration stream, prefixed by
> its length.  EOF is indicated by a 0-length chunk.
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>  include/hw/virtio/vhost.h |  35 +++++++
>  hw/virtio/vhost.c         | 204 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 239 insertions(+)
> 
> diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
> index a0d03c9fdf..100fcc874d 100644
> --- a/include/hw/virtio/vhost.h
> +++ b/include/hw/virtio/vhost.h
> @@ -426,4 +426,39 @@ int vhost_set_device_state_fd(struct vhost_dev *dev,
>   */
>  int vhost_check_device_state(struct vhost_dev *dev, Error **errp);
>  
> +/**
> + * vhost_save_backend_state(): High-level function to receive a vhost
> + * back-end's state, and save it in @f.  Uses
> + * `vhost_set_device_state_fd()` to get the data from the back-end, and
> + * stores it in consecutive chunks that are each prefixed by their
> + * respective length (be32).  The end is marked by a 0-length chunk.
> + *
> + * Must only be called while the device and all its vrings are stopped
> + * (`VHOST_TRANSFER_STATE_PHASE_STOPPED`).
> + *
> + * @dev: The vhost device from which to save the state
> + * @f: Migration stream in which to save the state
> + * @errp: Potential error message
> + *
> + * Returns 0 on success, and -errno otherwise.
> + */
> +int vhost_save_backend_state(struct vhost_dev *dev, QEMUFile *f, Error **errp);
> +
> +/**
> + * vhost_load_backend_state(): High-level function to load a vhost
> + * back-end's state from @f, and send it over to the back-end.  Reads
> + * the data from @f in the format used by `vhost_save_state()`, and uses
> + * `vhost_set_device_state_fd()` to transfer it to the back-end.
> + *
> + * Must only be called while the device and all its vrings are stopped
> + * (`VHOST_TRANSFER_STATE_PHASE_STOPPED`).
> + *
> + * @dev: The vhost device to which to send the sate
> + * @f: Migration stream from which to load the state
> + * @errp: Potential error message
> + *
> + * Returns 0 on success, and -errno otherwise.
> + */
> +int vhost_load_backend_state(struct vhost_dev *dev, QEMUFile *f, Error **errp);
> +
>  #endif
> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> index 85e199f0aa..1465adf13a 100644
> --- a/hw/virtio/vhost.c
> +++ b/hw/virtio/vhost.c
> @@ -2133,3 +2133,207 @@ int vhost_check_device_state(struct vhost_dev *dev, Error **errp)
>                 "vhost transport does not support migration state transfer");
>      return -ENOSYS;
>  }
> +
> +int vhost_save_backend_state(struct vhost_dev *dev, QEMUFile *f, Error **errp)
> +{
> +    /* Maximum chunk size in which to transfer the state */
> +    const size_t chunk_size = 1 * 1024 * 1024;
> +    g_autofree void *transfer_buf = NULL;
> +    g_autoptr(GError) g_err = NULL;
> +    int pipe_fds[2], read_fd = -1, write_fd = -1, reply_fd = -1;
> +    int ret;
> +
> +    /* [0] for reading (our end), [1] for writing (back-end's end) */
> +    if (!g_unix_open_pipe(pipe_fds, FD_CLOEXEC, &g_err)) {
> +        error_setg(errp, "Failed to set up state transfer pipe: %s",
> +                   g_err->message);
> +        ret = -EINVAL;
> +        goto fail;
> +    }
> +
> +    read_fd = pipe_fds[0];
> +    write_fd = pipe_fds[1];
> +
> +    /*
> +     * VHOST_TRANSFER_STATE_PHASE_STOPPED means the device must be stopped.
> +     * Ideally, it is suspended, but SUSPEND/RESUME currently do not exist for
> +     * vhost-user, so just check that it is stopped at all.
> +     */
> +    assert(!dev->started);
> +
> +    /* Transfer ownership of write_fd to the back-end */
> +    ret = vhost_set_device_state_fd(dev,
> +                                    VHOST_TRANSFER_STATE_DIRECTION_SAVE,
> +                                    VHOST_TRANSFER_STATE_PHASE_STOPPED,
> +                                    write_fd,
> +                                    &reply_fd,
> +                                    errp);
> +    if (ret < 0) {
> +        error_prepend(errp, "Failed to initiate state transfer: ");
> +        goto fail;
> +    }
> +
> +    /* If the back-end wishes to use a different pipe, switch over */
> +    if (reply_fd >= 0) {
> +        close(read_fd);
> +        read_fd = reply_fd;
> +    }
> +
> +    transfer_buf = g_malloc(chunk_size);
> +
> +    while (true) {
> +        ssize_t read_ret;
> +
> +        read_ret = RETRY_ON_EINTR(read(read_fd, transfer_buf, chunk_size));
> +        if (read_ret < 0) {
> +            ret = -errno;
> +            error_setg_errno(errp, -ret, "Failed to receive state");
> +            goto fail;
> +        }
> +
> +        assert(read_ret <= chunk_size);
> +        qemu_put_be32(f, read_ret);
> +
> +        if (read_ret == 0) {
> +            /* EOF */
> +            break;
> +        }
> +
> +        qemu_put_buffer(f, transfer_buf, read_ret);
> +    }
> +
> +    /*
> +     * Back-end will not really care, but be clean and close our end of the pipe
> +     * before inquiring the back-end about whether transfer was successful
> +     */
> +    close(read_fd);
> +    read_fd = -1;
> +
> +    /* Also, verify that the device is still stopped */
> +    assert(!dev->started);
> +
> +    ret = vhost_check_device_state(dev, errp);
> +    if (ret < 0) {
> +        goto fail;
> +    }
> +
> +    ret = 0;
> +fail:
> +    if (read_fd >= 0) {
> +        close(read_fd);
> +    }
> +
> +    return ret;
> +}
> +
> +int vhost_load_backend_state(struct vhost_dev *dev, QEMUFile *f, Error **errp)
> +{
> +    size_t transfer_buf_size = 0;
> +    g_autofree void *transfer_buf = NULL;
> +    g_autoptr(GError) g_err = NULL;
> +    int pipe_fds[2], read_fd = -1, write_fd = -1, reply_fd = -1;
> +    int ret;
> +
> +    /* [0] for reading (back-end's end), [1] for writing (our end) */
> +    if (!g_unix_open_pipe(pipe_fds, FD_CLOEXEC, &g_err)) {
> +        error_setg(errp, "Failed to set up state transfer pipe: %s",
> +                   g_err->message);
> +        ret = -EINVAL;
> +        goto fail;
> +    }
> +
> +    read_fd = pipe_fds[0];
> +    write_fd = pipe_fds[1];
> +
> +    /*
> +     * VHOST_TRANSFER_STATE_PHASE_STOPPED means the device must be stopped.
> +     * Ideally, it is suspended, but SUSPEND/RESUME currently do not exist for
> +     * vhost-user, so just check that it is stopped at all.
> +     */
> +    assert(!dev->started);
> +
> +    /* Transfer ownership of read_fd to the back-end */
> +    ret = vhost_set_device_state_fd(dev,
> +                                    VHOST_TRANSFER_STATE_DIRECTION_LOAD,
> +                                    VHOST_TRANSFER_STATE_PHASE_STOPPED,
> +                                    read_fd,
> +                                    &reply_fd,
> +                                    errp);
> +    if (ret < 0) {
> +        error_prepend(errp, "Failed to initiate state transfer: ");
> +        goto fail;
> +    }
> +
> +    /* If the back-end wishes to use a different pipe, switch over */
> +    if (reply_fd >= 0) {
> +        close(write_fd);
> +        write_fd = reply_fd;
> +    }
> +
> +    while (true) {
> +        size_t this_chunk_size = qemu_get_be32(f);
> +        ssize_t write_ret;
> +        const uint8_t *transfer_pointer;
> +
> +        if (this_chunk_size == 0) {
> +            /* End of state */
> +            break;
> +        }
> +
> +        if (transfer_buf_size < this_chunk_size) {
> +            transfer_buf = g_realloc(transfer_buf, this_chunk_size);
> +            transfer_buf_size = this_chunk_size;
> +        }
> +
> +        if (qemu_get_buffer(f, transfer_buf, this_chunk_size) <
> +                this_chunk_size)
> +        {
> +            error_setg(errp, "Failed to read state");
> +            ret = -EINVAL;
> +            goto fail;
> +        }
> +
> +        transfer_pointer = transfer_buf;
> +        while (this_chunk_size > 0) {
> +            write_ret = RETRY_ON_EINTR(
> +                write(write_fd, transfer_pointer, this_chunk_size)
> +            );
> +            if (write_ret < 0) {
> +                ret = -errno;
> +                error_setg_errno(errp, -ret, "Failed to send state");
> +                goto fail;
> +            } else if (write_ret == 0) {
> +                error_setg(errp, "Failed to send state: Connection is closed");
> +                ret = -ECONNRESET;
> +                goto fail;
> +            }
> +
> +            assert(write_ret <= this_chunk_size);
> +            this_chunk_size -= write_ret;
> +            transfer_pointer += write_ret;
> +        }
> +    }
> +
> +    /*
> +     * Close our end, thus ending transfer, before inquiring the back-end about
> +     * whether transfer was successful
> +     */
> +    close(write_fd);
> +    write_fd = -1;
> +
> +    /* Also, verify that the device is still stopped */
> +    assert(!dev->started);
> +
> +    ret = vhost_check_device_state(dev, errp);
> +    if (ret < 0) {
> +        goto fail;
> +    }
> +
> +    ret = 0;
> +fail:
> +    if (write_fd >= 0) {
> +        close(write_fd);
> +    }
> +
> +    return ret;
> +}
> -- 
> 2.41.0

