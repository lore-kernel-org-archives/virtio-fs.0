Return-Path: <hreitz@redhat.com>
Message-ID: <e8cc4521-50a1-2e38-1fb3-8cfa7b0c967e@redhat.com>
Date: Thu, 4 May 2023 18:05:46 +0200
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20230411150515.14020-1-hreitz@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
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
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: Stefan Hajnoczi <stefanha@redhat.com>, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Eugenio Perez Martin <eperezma@redhat.com>

On 11.04.23 17:05, Hanna Czenczek wrote:

[...]

> Hanna Czenczek (4):
>    vhost: Re-enable vrings after setting features
>    vhost-user: Interface for migration state transfer
>    vhost: Add high-level state save/load functions
>    vhost-user-fs: Implement internal migration

I’m trying to write v2, and my intention was to keep the code 
conceptually largely the same, but include in the documentation change 
thoughts and notes on how this interface is to be used in the future, 
when e.g. vDPA “extensions” come over to vhost-user.  My plan was to, 
based on that documentation, discuss further.

But now I’m struggling to even write that documentation because it’s not 
clear to me what exactly the result of the discussion was, so I need to 
stop even before that.

So as far as I understand, we need/want SUSPEND/RESUME for two reasons:
1. As a signal to the back-end when virt queues are no longer to be 
processed, so that it is clear that it will not do that when asked for 
migration state.
2. Stateful devices that support SET_STATUS receive a status of 0 when 
the VM is stopped, which supposedly resets the internal state. While 
suspended, device state is frozen, so as far as I understand, SUSPEND 
before SET_STATUS would have the status change be deferred until RESUME.

I don’t want to hang myself up on 2 because it doesn’t really seem 
important to this series, but: Why does a status of 0 reset the internal 
state?  [Note: This is all virtio_reset() seems to do, set the status to 
0.]  The vhost-user specification only points to the virtio 
specification, which doesn’t say anything to that effect. Instead, an 
explicit device reset is mentioned, which would be 
VHOST_USER_RESET_DEVICE, i.e. something completely different. Because 
RESET_DEVICE directly contradicts SUSPEND’s description, I would like to 
think that invoking RESET_DEVICE on a SUSPEND-ed device is just invalid.

Is it that a status 0 won’t explicitly reset the internal state, but 
because it does mean that the driver is unbound, the state should 
implicitly be reset?

Anyway.  1 seems to be the relevant point for migration.  As far as I 
understand, currently, a vhost-user back-end has no way of knowing when 
to stop processing virt queues.  Basically, rings can only transition 
from stopped to started, but not vice versa.  The vhost-user 
specification has this bit: “Once the source has finished migration, 
rings will be stopped by the source. No further update must be done 
before rings are restarted.”  It just doesn’t say how the front-end lets 
the back-end know that the rings are (to be) stopped.  So this seems 
like a pre-existing problem for stateless migration.  Unless this is 
communicated precisely by setting the device status to 0?

Naturally, what I want to know most of all is whether you believe I can 
get away without SUSPEND/RESUME for now.  To me, it seems like honestly 
not really, only when turning two blind eyes, because otherwise we can’t 
ensure that virtiofsd isn’t still processing pending virt queue requests 
when the state transfer is begun, even when the guest CPUs are already 
stopped.  Of course, virtiofsd could stop queue processing right there 
and then, but…  That feels like a hack that in the grand scheme of 
things just isn’t necessary when we could “just” introduce 
SUSPEND/RESUME into vhost-user for exactly this.

Beyond the SUSPEND/RESUME question, I understand everything can stay 
as-is for now, as the design doesn’t seem to conflict too badly with 
possible future extensions for other migration phases or more finely 
grained migration phase control between front-end and back-end.

Did I at least roughly get the gist?

Hanna

