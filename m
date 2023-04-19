Return-Path: <hreitz@redhat.com>
Message-ID: <fb311ad4-ba1e-afc8-801d-0eff00c7fa7f@redhat.com>
Date: Wed, 19 Apr 2023 12:47:32 +0200
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-3-hreitz@redhat.com> <20230412210641.GC2813183@fedora>
 <CAJaqyWfm=g_hr9=WpsnwJ4hdpVb7K7p5rirWjvx=PxKYUp8trA@mail.gmail.com>
 <d9d67f07-3d4c-9bdb-052b-28e21fa27dd6@redhat.com>
 <20230417151250.GC3852722@fedora>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20230417151250.GC3852722@fedora>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Eugenio Perez Martin <eperezma@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>

On 17.04.23 17:12, Stefan Hajnoczi wrote:

[...]

> This brings to mind how iterative migration will work. The interface for
> iterative migration is basically the same as non-iterative migration
> plus a method to query the number of bytes remaining. When the number of
> bytes falls below a threshold, the vCPUs are stopped and the remainder
> of the data is read.
>
> Some details from VFIO migration:
> - The VMM must explicitly change the state when transitioning from
>    iterative and non-iterative migration, but the data transfer fd
>    remains the same.
> - The state of the device (running, stopped, resuming, etc) doesn't
>    change asynchronously, it's always driven by the VMM. However, setting
>    the state can fail and then the new state may be an error state.
>
> Mapping this to SET_DEVICE_STATE_FD:
> - VhostDeviceStatePhase is extended with
>    VHOST_TRANSFER_STATE_PHASE_RUNNING = 1 for iterative migration. The
>    frontend sends SET_DEVICE_STATE_FD again with
>    VHOST_TRANSFER_STATE_PHASE_STOPPED when entering non-iterative
>    migration and the frontend sends the iterative fd from the previous
>    SET_DEVICE_STATE_FD call to the backend. The backend may reply with
>    another fd, if necessary. If the backend changes the fd, then the
>    contents of the previous fd must be fully read and transferred before
>    the contents of the new fd are migrated. (Maybe this is too complex
>    and we should forbid changing the fd when going from RUNNING ->
>    STOPPED.)
> - CHECK_DEVICE_STATE can be extended to report the number of bytes
>    remaining. The semantics change so that CHECK_DEVICE_STATE can be
>    called while the VMM is still reading from the fd. It becomes:
>
>      enum CheckDeviceStateResult {
>          Saving(bytes_remaining : usize),
> 	Failed(error_code : u64),
>      }

Sounds good.  Personally, I’d forbid changing the FD when just changing 
state, which raises the question of whether there should then be a 
separate command for just changing the state (like VFIO_DEVICE_FEATURE 
..._MIG_DEVICE_STATE?), but that would be a question for then.

Changing the CHECK_DEVICE_STATE interface sounds good to me.

Hanna

