Return-Path: <hreitz@redhat.com>
Message-ID: <fc005d50-03ba-0b8f-d9af-64a5297395a3@redhat.com>
Date: Tue, 26 Sep 2023 15:32:14 +0200
MIME-Version: 1.0
References: <20230915102531.55894-1-hreitz@redhat.com>
 <20230925204852.GG323580@fedora>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20230925204852.GG323580@fedora>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v3 0/5] vhost-user: Back-end state migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>, qemu-devel@nongnu.org, "Michael S . Tsirkin" <mst@redhat.com>

On 25.09.23 22:48, Stefan Hajnoczi wrote:
> On Fri, Sep 15, 2023 at 12:25:25PM +0200, Hanna Czenczek wrote:
>> RFC:
>> https://lists.nongnu.org/archive/html/qemu-devel/2023-03/msg04263.html
>>
>> v1:
>> https://lists.nongnu.org/archive/html/qemu-devel/2023-04/msg01575.html
>>
>> v2:
>> https://lists.nongnu.org/archive/html/qemu-devel/2023-07/msg02604.html
>>
>> Hi,
>>
>> I’ve decided not to work on vhost-user SUSPEND/RESUME for now – it is
>> not technically required for virtio-fs migration, which is the actual
>> priority for me now.  While we do want to have SUSPEND/RESUME at some
>> point, the only practically existing reason for it is to be able to
>> implement vhost-level resetting in virtiofsd, but that is not related to
>> migration.
> QEMU sends VHOST_USER_SET_STATUS 0 in vhost_dev_stop(). Are you assuming
> that virtiofs back-ends do not reset the device upon receiving this
> message?

Absolutely.  vhost_dev_stop() is not in the migration-specific path, but 
is called whenever the vCPUs are stopped, which indeed happens to be 
part of migration, but is also used in other cases, like QMP stop.  We 
have identified that it is wrong that we reset the back-end just because 
the vCPUs are stopped (e.g. on migration), but it is what we do right 
now when the VM is paused (e.g. through QMP stop).

Therefore, stateful back-ends cannot implement reset lest stop/cont 
breaks the device.  I don’t think anybody really cares whether a 
vhost-user back-end actually resets its internal state (if there is any) 
when the guest driver asks for a reset on the virtio level, as long as 
the guest driver is then able to initialize the device afterwards.  I do 
think people care that stop/cont works, so it follows to me that no 
stateful back-end will reset its internal state when receiving a 
virtio/vhost reset.  If they do, stop/cont breaks, which is a 
user-visible bug that needs to be addressed – either properly by 
implementing SUSPEND/RESUME in both qemu and the affected back-ends, or 
by using a similar work-around to virtiofsd, which is to ignore reset 
commands.

It’s hard for me to imagine that people don’t care that stop/cont breaks 
some vhost-user back-end, but suddenly would start to care that 
migration doesn’t work – especially given that first of all someone will 
need to manually implement any migration support in that back-end even 
with this series, which means that really, the only back-end we are 
talking about here is our virtiofsd.  To this day I’m not even aware of 
any other back-end that has internal state.

Hanna

