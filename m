Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
In-Reply-To: <2fb6efb4-9155-99ad-3acd-c274783436ed@yandex-team.ru> (Anton
 Kuchin's message of "Thu, 19 Jan 2023 18:58:12 +0200")
References: <20230115170903.3416105-1-antonkuchin@yandex-team.ru>
 <CAJSP0QVKUKgkBMw1PiN8-L8Ykhq=gfvNTTs4sf1tuzoqHu+GXw@mail.gmail.com>
 <0d57cc40-693b-b36c-a135-fdac60dd00ec@yandex-team.ru>
 <CAJSP0QUXB0kgsCSsmi8dpnJFYho2cR_2Liep=pGmp6WzDZ_7pw@mail.gmail.com>
 <d6bf0b9a-a167-817d-2c17-c2e472961155@yandex-team.ru>
 <CAJSP0QXXe6KgLN2PJvi-5GqcELhUKJPB2pUARL2ktO9TQYAq=g@mail.gmail.com>
 <2fb6efb4-9155-99ad-3acd-c274783436ed@yandex-team.ru>
Reply-To: quintela@redhat.com
Date: Wed, 01 Feb 2023 15:26:45 +0100
Message-ID: <87h6w5ea1m.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [Virtio-fs] [PATCH] vhost-user-fs: add capability to allow
 migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Anton Kuchin <antonkuchin@yandex-team.ru>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Markus Armbruster <armbru@redhat.com>, Eric Blake <eblake@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, yc-core@yandex-team.ru, "Michael
 S. Tsirkin" <mst@redhat.com>

Anton Kuchin <antonkuchin@yandex-team.ru> wrote:
> On 19/01/2023 18:02, Stefan Hajnoczi wrote:
>> On Thu, 19 Jan 2023 at 10:29, Anton Kuchin <antonkuchin@yandex-team.ru> wrote:
>>> On 19/01/2023 16:30, Stefan Hajnoczi wrote:
>>>> On Thu, 19 Jan 2023 at 07:43, Anton Kuchin <antonkuchin@yandex-team.ru> wrote:
>>>>> On 18/01/2023 17:52, Stefan Hajnoczi wrote:
>>>>>> On Sun, 15 Jan 2023 at 12:21, Anton Kuchin <antonkuchin@yandex-team.ru> wrote:

Hi

Sorry to come so late into the discussion.


>>>>>>> +static int vhost_user_fs_pre_save(void *opaque)
>>>>>>> +{
>>>>>>> +    MigrationState *s = migrate_get_current();
>>>>>>> +
>>>>>>> +    if (!s->enabled_capabilities[MIGRATION_CAPABILITY_VHOST_USER_FS]) {
>>>>>>> +        error_report("Migration of vhost-user-fs devices requires internal FUSE "
>>>>>>> +                     "state of backend to be preserved. If orchestrator can "
>>>>>>> +                     "guarantee this (e.g. dst connects to the same backend "
>>>>>>> +                     "instance or backend state is migrated) set 'vhost-user-fs' "
>>>>>>> +                     "migration capability to true to enable migration.");
>>>>>>> +        return -1;
>>>>>>> +    }
>>>>>>> +
>>>>>>> +    return 0;
>>>>>>> +}
>>>>>>> +
>>>>>>>     static const VMStateDescription vuf_vmstate = {
>>>>>>>         .name = "vhost-user-fs",
>>>>>>> -    .unmigratable = 1,
>>>>>>> +    .minimum_version_id = 0,
>>>>>>> +    .version_id = 0,
>>>>>>> +    .fields = (VMStateField[]) {
>>>>>>> +        VMSTATE_VIRTIO_DEVICE,
>>>>>>> +        VMSTATE_END_OF_LIST()
>>>>>>> +    },
>>>>>>> +   .pre_save = vhost_user_fs_pre_save,
>>>>>>>     };

I don't object to extend the vmstate this way.

But I object to the migration capability for several reasons:
- This feature has _nothing_ to do with migration, the problem, what it
  describes, etc is related to vhost_user_fs.
- The number of migration capabilities is limited
  And we add checks to see if they are valid, consistent, etc
  see qemu/migration/migration.c:migrate_caps_check()
- As Stefan says, we can have several vhost_user_fs devices, and each
  one should know if it can migrate or not.
- We have to options for the orchestator:
  * it knows that all the vhost_user_fs devices can be migration
    Then it can add a property to each vhost_user_fs device
  * it don't know it
    Then it is a good idea that we are not migrating this VM.

> I think we'd be better without a new marker because migration code
> has standard generic way of solving such puzzles that I described
> above. So adding new marker would go against existing practice.
> But if you could show me where I missed something I'll be grateful
> and will fix it to avoid potential problems.
> I'd also be happy to know the opinion of Dr. David Alan Gilbert.

If everybody agrees that any vhost_user_fs device is going to have a
virtio device, then I agree with you that the marker is not needed at
this point.

Once told that, I think that you are making your live harder in the
future when you add the other migratable devices.

I am assuming here that your "underlying device" is:

enum VhostUserFSType {
    VHOST_USER_NO_MIGRATABLE = 0,
    // The one we are doing here
    VHOST_USER_EXTERNAL_MIGRATABLE,
    // The one you describe for the future
    VHOST_USER_INTERNAL_MIGRATABLE,
};

struct VHostUserFS {
    /*< private >*/
    VirtIODevice parent;
    VHostUserFSConf conf;
    struct vhost_virtqueue *vhost_vqs;
    struct vhost_dev vhost_dev;
    VhostUserState vhost_user;
    VirtQueue **req_vqs;
    VirtQueue *hiprio_vq;
    int32_t bootindex;
    enum migration_type;
    /*< public >*/
};


static int vhost_user_fs_pre_save(void *opaque)
{
    VHostUserFS *s = opaque;

    if (s->migration_type == VHOST_USER_NO_MIGRATABLE)) {
        error_report("Migration of vhost-user-fs devices requires internal FUSE "
                     "state of backend to be preserved. If orchestrator can "
                     "guarantee this (e.g. dst connects to the same backend "
                     "instance or backend state is migrated) set 'vhost-user-fs' "
                     "migration capability to true to enable migration.");
        return -1;
    }
    if (s->migration_type == VHOST_USER_EXTERNAL_MIGRATABLE) {
        return 0;
    }
    if (s->migration_type == VHOST_USER_INTERNAL_MIGRATABLE) {
        error_report("still not implemented");
        return -1;
    }
    assert("we don't reach here");
}

Your initial vmstateDescription

static const VMStateDescription vuf_vmstate = {
    .name = "vhost-user-fs",
    .unmigratable = 1,
    .minimum_version_id = 0,
    .version_id = 0,
    .fields = (VMStateField[]) {
        VMSTATE_INT8(migration_type, struct VHostUserFS),
        VMSTATE_VIRTIO_DEVICE,
        VMSTATE_END_OF_LIST()
    },
    .pre_save = vhost_user_fs_pre_save,
};

And later you change it to something like:

static bool vhost_fs_user_internal_state_needed(void *opaque)
{
    VHostUserFS *s = opaque;

    return s->migration_type == VMOST_USER_INTERNAL_MIGRATABLE;
}

static const VMStateDescription vmstate_vhost_user_fs_internal_sub = {
    .name = "vhost-user-fs/internal",
    .version_id = 1,
    .minimum_version_id = 1,
    .needed = &vhost_fs_user_internal_state_needed,
    .fields = (VMStateField[]) {
        .... // Whatever
        VMSTATE_END_OF_LIST()
    }
};

static const VMStateDescription vuf_vmstate = {
    .name = "vhost-user-fs",
    .minimum_version_id = 0,
    .version_id = 0,
    .fields = (VMStateField[]) {
        VMSTATE_INT8(migration_type, struct VHostUserFS),
        VMSTATE_VIRTIO_DEVICE,
        VMSTATE_END_OF_LIST()
    },
    .pre_save = vhost_user_fs_pre_save,
    .subsections = (const VMStateDescription*[]) {
        &vmstate_vhost_user_fs_internal_sub,
        NULL
    }
};

And you are done.

I will propose to use a property to set migration_type, but I didn't
want to write the code right now.

I think that this proposal will make Stephan happy, and it is just
adding and extra uint8_t that is helpul to implement everything.

Later, Juan.

PD.  One of the few things that Pascal got right and C got completely
     wrong were pascal variant registers vs C union's.  If you have a
     union, if should be "required" that there is a field in the
     enclosing struct that specifies what element of the union we have.
     This is exactly that case.

