Return-Path: <antonkuchin@yandex-team.ru>
Message-ID: <99fa1aa1-4316-9fef-80b9-eaf5a1578654@yandex-team.ru>
Date: Mon, 27 Feb 2023 12:19:53 +0200
MIME-Version: 1.0
From: Anton Kuchin <antonkuchin@yandex-team.ru>
References: <20230222074214-mutt-send-email-mst@kernel.org>
 <22fee9b6-1dc0-792c-13cf-54c9303556ab@yandex-team.ru>
 <8372550f-def7-4336-c597-d22155abf145@yandex-team.ru>
 <333c4451-8eef-0603-c3f5-10e38c0eb24e@yandex-team.ru>
 <20230222115106-mutt-send-email-mst@kernel.org>
 <11593688-7ca4-def3-6212-7c26faa4d1c6@yandex-team.ru>
 <20230222121133-mutt-send-email-mst@kernel.org>
 <a477ca70-8aea-6c16-122e-1ded4af11f49@yandex-team.ru>
 <20230222151814-mutt-send-email-mst@kernel.org>
 <20230223023604-mutt-send-email-mst@kernel.org> <Y/fZm12yGIPnwaDX@fedora>
 <f26f38f2-4168-88b3-37e9-09e5a604fad8@yandex-team.ru>
In-Reply-To: <f26f38f2-4168-88b3-37e9-09e5a604fad8@yandex-team.ru>
Content-Language: en-US, ru-RU
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH v3 1/1] vhost-user-fs: add migration type
 property
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, qemu-devel@nongnu.org, yc-core@yandex-team.ru, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Markus Armbruster <armbru@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Juan Quintela <quintela@redhat.com>, =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>


On 24/02/2023 06:14, Anton Kuchin wrote:
> On 23/02/2023 23:24, Stefan Hajnoczi wrote:
>> On Thu, Feb 23, 2023 at 02:36:33AM -0500, Michael S. Tsirkin wrote:
>>> On Wed, Feb 22, 2023 at 03:21:42PM -0500, Michael S. Tsirkin wrote:
>>>> On Wed, Feb 22, 2023 at 08:25:19PM +0200, Anton Kuchin wrote:
>>>>> On 22/02/2023 19:12, Michael S. Tsirkin wrote:
>>>>>> On Wed, Feb 22, 2023 at 07:05:47PM +0200, Anton Kuchin wrote:
>>>>>>> On 22/02/2023 18:51, Michael S. Tsirkin wrote:
>>>>>>>> On Wed, Feb 22, 2023 at 06:49:10PM +0200, Anton Kuchin wrote:
>>>>>>>>> On 22/02/2023 17:14, Vladimir Sementsov-Ogievskiy wrote:
>>>>>>>>>> On 22.02.23 17:25, Anton Kuchin wrote:
>>>>>>>>>>>>>> +static int vhost_user_fs_pre_save(void *opaque)
>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 VHostUserFS *fs =3D opaque;
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 g_autofree char *path =3D=20
>>>>>>>>>>>>>> object_get_canonical_path(OBJECT(fs));
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 switch (fs->migration_type) {
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 case VHOST_USER_MIGRATION_TYPE_NONE:
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error_report("Mi=
gration is blocked by device=20
>>>>>>>>>>>>>> %s", path);
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 case VHOST_USER_MIGRATION_TYPE_EXTERNAL:
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 default:
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error_report("Mi=
gration type '%s' is not
>>>>>>>>>>>>>> supported by device %s",
>>>>>>>>>>>>>> + VhostUserMigrationType_str(fs->migration_type), path);
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +=C2=A0=C2=A0=C2=A0 return -1;
>>>>>>>>>>>>>> +}
>>>>>>>>>>>>> Should we also add this as .pre_load, to force user select
>>>>>>>>>>>>> correct migration_type on target too?
>>>>>>>>>>>> In fact, I would claim we only want pre_load.
>>>>>>>>>>>> When qemu is started on destination we know where it's=20
>>>>>>>>>>>> migrated
>>>>>>>>>>>> from so this flag can be set.
>>>>>>>>>>>> When qemu is started on source we generally do not yet know so
>>>>>>>>>>>> we don't know whether it's safe to set this flag.
>>>>>>>>>> But destination is a "source" for next migration, so there=20
>>>>>>>>>> shouldn't be
>>>>>>>>>> real difference.
>>>>>>>>>> The new property has ".realized_set_allowed =3D true", so, as I=
=20
>>>>>>>>>> understand
>>>>>>>>>> it may be changed at any time, so that's not a problem.
>>>>>>>>> Yes, exactly. So destination's property sets not how it will=20
>>>>>>>>> handle this
>>>>>>>>> incoming
>>>>>>>>> migration but the future outgoing one.
>>>>>>>> How do you know where you are going to migrate though?
>>>>>>>> I think you don't.
>>>>>>>> Setting it on source is better since we know where we
>>>>>>>> are migrating from.
>>>>>>> Yes, I don't know where I'm going to migrate to. This is why=20
>>>>>>> property
>>>>>>> affects only how source saves state on outgoing migration.
>>>>>> Um. I don't get the logic.
>>>>> For this feature to work we need orchestrator to manage the=20
>>>>> migration. And
>>>>> we
>>>>> generally assume that it is responsibility of orchestrator to ensure
>>>>> matching
>>>>> properties on source and destination.
>>>>> As orchestrator manages both sides of migration it can set option=20
>>>>> (and we
>>>>> can
>>>>> check it) on either source or destination. Now it's not important=20
>>>>> which side
>>>>> we
>>>>> select, because now the option is essentially binary allow/deny=20
>>>>> (but IMHO it
>>>>> is much better to refuse source to migrate than find later that=20
>>>>> state can't
>>>>> be
>>>>> loaded by destination, in case of file migration this becomes=20
>>>>> especially
>>>>> painful).
>>>>>
>>>>> But there are plans to add internal migration option (extract FUSE=20
>>>>> state
>>>>> from
>>>>> backend and transfer it in QEMU migration stream), and that's where
>>>>> setting/checking
>>>>> on source becomes important because it will rely on this property=20
>>>>> to decide
>>>>> if
>>>>> extra state form backend needs to be put in the migration stream=20
>>>>> subsection.
>>>>
>>>> If we do internal migration that will be a different property
>>>> which has to match on source *and* destination.
>>>>
>>>>
>>>>> If you are concerned about orchestrator breaking assumption of=20
>>>>> matching
>>>>> properties
>>>>> on source and destination this is not really supported AFAIK but I=20
>>>>> don't
>>>>> think we
>>>>> need to punish it for this, maybe it has its reasons: I can=20
>>>>> imagine scenario
>>>>> where orchestrator could want to migrate from source with
>>>>> 'migration=3Dexternal'
>>>>> to destination with 'migration=3Dnone' to ensure that destination=20
>>>>> can't be
>>>>> migrated further.
>>>> No. I am concerned about a simple practical matter:
>>>> - I decide to restart qemu on the same host - so I need to enable
>>>> =C2=A0=C2=A0 migration
>>>> - Later I decide to migrate qemu to another host - this should be
>>>> =C2=A0=C2=A0 blocked
>>>>
>>>>
>>>> Property on source does not satisfy both at the same time.
>>>> Property on destination does.
>>>
>>> Stefan what's your take on this? Should we move this from
>>> save to load hook?
>> This property can be changed on the source at runtime via qom-set, so
>> you don't need to predict the future. The device can be started from an
>> incoming migration with "external" and then set to "stateful" migration
>> to migrate to another host later on.
>>
>> Anton, can you share the virtiofsd patches so we have a full picture of
>> how "external" migration works? I'd like to understand the workflow and
>> also how it can be extended when "stateful" migration is added.
>
> Unfortunately internal implementation is relying heavily on our=20
> infrastructure,
> and rust virtiofsd still lacks dirty tracking so it is not ready yet.=20
> But I did
> have a PoC for deprecated now C virtiofsd that I didn't bother to prepare
> for upstreaming because C version was declared unsupported. It=20
> essentially adds
> reconnect and this was the only thing required from virtiofsd to support
> migration via file.
>
> If this helps I'll try to find patches or recreate then and will be=20
> happy to share.


Found my stash with PoC. It has some TODOs and needs more work to become=20
submission
quality, but I hope this can be helpful to show the idea.

I checked it with file migration on the same host to update qemu binary=20
like this:
 =C2=A01. Run tools/virtiofsd/virtiofsd with "--reconnect" flag
 =C2=A02. Run src qemu VM with vhost-user-fs device
 =C2=A03. Mount fs in guest and run fio with verification on test file in=
=20
shared directory
 =C2=A04. Command via QMP to migrate VM to file
 =C2=A05. Run dst qemu VM with vhost-user-fs device and "-incoming defer" f=
lag
 =C2=A06. Command via QMP to load migration stream from file and continue V=
M
 =C2=A07. Check that fio keeps running in guest with no errors

[PATCH] tools/virtiofsd: reconnect PoC

Keep daemon listening after disconnect so session can be continued
after VM is restored.

Signed-off-by: Anton Kuchin <antonkuchin@yandex-team.ru>
---
 =C2=A0tools/virtiofsd/fuse_lowlevel.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
|=C2=A0 1 +
 =C2=A0tools/virtiofsd/fuse_virtio.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 | 59 +++++++++++++++++----------
 =C2=A0tools/virtiofsd/helper.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
 =C2=A0tools/virtiofsd/passthrough_ll.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 49 =
++++++++++++++++------
 =C2=A0tools/virtiofsd/passthrough_seccomp.c | 12 +++++-
 =C2=A0tools/virtiofsd/passthrough_seccomp.h |=C2=A0 2 +-
 =C2=A06 files changed, 87 insertions(+), 37 deletions(-)

diff --git a/tools/virtiofsd/fuse_lowlevel.h=20
b/tools/virtiofsd/fuse_lowlevel.h
index b889dae4de..d5f3bf05ba 100644
--- a/tools/virtiofsd/fuse_lowlevel.h
+++ b/tools/virtiofsd/fuse_lowlevel.h
@@ -1795,6 +1795,7 @@ struct fuse_cmdline_opts {
 =C2=A0=C2=A0=C2=A0=C2=A0 int log_level;
 =C2=A0=C2=A0=C2=A0=C2=A0 unsigned int max_idle_threads;
 =C2=A0=C2=A0=C2=A0=C2=A0 unsigned long rlimit_nofile;
+=C2=A0=C2=A0=C2=A0 int reconnect;
 =C2=A0};

 =C2=A0/**
diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 9368e292e4..64782cd78d 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -837,6 +837,7 @@ static const VuDevIface fv_iface =3D {
 =C2=A0int virtio_loop(struct fuse_session *se)
 =C2=A0{
 =C2=A0=C2=A0=C2=A0=C2=A0 fuse_log(FUSE_LOG_INFO, "%s: Entry\n", __func__);
+=C2=A0=C2=A0=C2=A0 int ret =3D 0;

 =C2=A0=C2=A0=C2=A0=C2=A0 while (!fuse_session_exited(se)) {
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct pollfd pf[1];
@@ -858,7 +859,13 @@ int virtio_loop(struct fuse_session *se)
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 b=
reak;
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 assert(poll_res =3D=3D 1)=
;
-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (pf[0].revents & (POLLERR | =
POLLHUP | POLLNVAL)) {
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (pf[0].revents & POLLHUP) {
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fuse_lo=
g(FUSE_LOG_ERR, "%s: Client disconnected: %x\n",=20
__func__,
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pf[0].revents);
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D=
 -1;
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (pf[0].revents & (POLLERR | =
POLLNVAL)) {
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 f=
use_log(FUSE_LOG_ERR, "%s: Unexpected poll revents %x\n",=20
__func__,
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pf[0].revents);
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 b=
reak;
@@ -885,7 +892,7 @@ int virtio_loop(struct fuse_session *se)
 =C2=A0=C2=A0=C2=A0=C2=A0 stop_all_queues(se->virtio_dev);
 =C2=A0=C2=A0=C2=A0=C2=A0 fuse_log(FUSE_LOG_INFO, "%s: Exit\n", __func__);

-=C2=A0=C2=A0=C2=A0 return 0;
+=C2=A0=C2=A0=C2=A0 return ret;
 =C2=A0}

 =C2=A0static void strreplace(char *s, char old, char new)
@@ -1015,25 +1022,31 @@ int virtio_session_mount(struct fuse_session *se)
 =C2=A0{
 =C2=A0=C2=A0=C2=A0=C2=A0 int ret;

-=C2=A0=C2=A0=C2=A0 /*
-=C2=A0=C2=A0=C2=A0=C2=A0 * Test that unshare(CLONE_FS) works. fv_queue_wor=
ker() will need=20
it. It's
-=C2=A0=C2=A0=C2=A0=C2=A0 * an unprivileged system call but some Docker/Mob=
y versions are=20
known to
-=C2=A0=C2=A0=C2=A0=C2=A0 * reject it via seccomp when CAP_SYS_ADMIN is not=
 given.
-=C2=A0=C2=A0=C2=A0=C2=A0 *
-=C2=A0=C2=A0=C2=A0=C2=A0 * Note that the program is single-threaded here s=
o this syscall has no
-=C2=A0=C2=A0=C2=A0=C2=A0 * visible effect and is safe to make.
-=C2=A0=C2=A0=C2=A0=C2=A0 */
-=C2=A0=C2=A0=C2=A0 ret =3D unshare(CLONE_FS);
-=C2=A0=C2=A0=C2=A0 if (ret =3D=3D -1 && errno =3D=3D EPERM) {
-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fuse_log(FUSE_LOG_ERR, "unshare=
(CLONE_FS) failed with EPERM. If "
-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 "running in a container please check that the container =
"
-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 "runtime seccomp policy allows unshare.\n");
-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -1;
-=C2=A0=C2=A0=C2=A0 }

-=C2=A0=C2=A0=C2=A0 ret =3D fv_create_listen_socket(se);
-=C2=A0=C2=A0=C2=A0 if (ret < 0) {
-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
+=C2=A0=C2=A0=C2=A0 if (se->vu_listen_fd =3D=3D -1) {
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fuse_log(FUSE_LOG_INFO, "listen=
fd is closed. set it up\n");
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Test that unshare(CLONE=
_FS) works. fv_queue_worker() will=20
need it. It's
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * an unprivileged system =
call but some Docker/Moby versions=20
are known to
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * reject it via seccomp w=
hen CAP_SYS_ADMIN is not given.
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Note that the program i=
s single-threaded here so this=20
syscall has no
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * visible effect and is s=
afe to make.
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D unshare(CLONE_FS);
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret =3D=3D -1 && errno =3D=
=3D EPERM) {
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fuse_lo=
g(FUSE_LOG_ERR, "unshare(CLONE_FS) failed with=20
EPERM. If "
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "running in a container please c=
heck that the=20
container "
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "runtime seccomp policy allows u=
nshare.\n");
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return =
-1;
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
+
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D fv_create_listen_socket=
(se);
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret < 0) {
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return =
ret;
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
+=C2=A0=C2=A0=C2=A0 } else {
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fuse_log(FUSE_LOG_INFO, "listen=
fd is open. reconnecting\n");
 =C2=A0=C2=A0=C2=A0=C2=A0 }

 =C2=A0=C2=A0=C2=A0=C2=A0 se->fd =3D -1;
@@ -1046,8 +1059,8 @@ int virtio_session_mount(struct fuse_session *se)
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 close(se->vu_listen_fd);
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -1;
 =C2=A0=C2=A0=C2=A0=C2=A0 }
-=C2=A0=C2=A0=C2=A0 close(se->vu_listen_fd);
-=C2=A0=C2=A0=C2=A0 se->vu_listen_fd =3D -1;
+
+=C2=A0=C2=A0=C2=A0 /* TODO: close vu_listen_fd here if not reconnect */
 =C2=A0=C2=A0=C2=A0=C2=A0 fuse_log(FUSE_LOG_INFO, "%s: Received vhost-user =
socket connection\n",
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 __func__);

@@ -1068,6 +1081,8 @@ int virtio_session_mount(struct fuse_session *se)

 =C2=A0void virtio_session_close(struct fuse_session *se)
 =C2=A0{
+=C2=A0=C2=A0=C2=A0 /* TODO: vu_listen_fd can be closed in session_mount */
+=C2=A0=C2=A0=C2=A0 close(se->vu_listen_fd);
 =C2=A0=C2=A0=C2=A0=C2=A0 close(se->vu_socketfd);

 =C2=A0=C2=A0=C2=A0=C2=A0 if (!se->virtio_dev) {
diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
index f5f66f292c..236a58f109 100644
--- a/tools/virtiofsd/helper.c
+++ b/tools/virtiofsd/helper.c
@@ -53,6 +53,7 @@ static const struct fuse_opt fuse_helper_opts[] =3D {
 =C2=A0=C2=A0=C2=A0=C2=A0 FUSE_HELPER_OPT_VALUE("log_level=3Dinfo", log_lev=
el, FUSE_LOG_INFO),
 =C2=A0=C2=A0=C2=A0=C2=A0 FUSE_HELPER_OPT_VALUE("log_level=3Dwarn", log_lev=
el, FUSE_LOG_WARNING),
 =C2=A0=C2=A0=C2=A0=C2=A0 FUSE_HELPER_OPT_VALUE("log_level=3Derr", log_leve=
l, FUSE_LOG_ERR),
+=C2=A0=C2=A0=C2=A0 FUSE_HELPER_OPT_VALUE("--reconnect", reconnect, 0),
 =C2=A0=C2=A0=C2=A0=C2=A0 FUSE_OPT_END
 =C2=A0};

diff --git a/tools/virtiofsd/passthrough_ll.c=20
b/tools/virtiofsd/passthrough_ll.c
index 40ea2ed27f..487d320c70 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3819,7 +3819,7 @@ static void setup_wait_parent_capabilities(void)
 =C2=A0/*
 =C2=A0 * Move to a new mount, net, and pid namespaces to isolate this proc=
ess.
 =C2=A0 */
-static void setup_namespaces(struct lo_data *lo, struct fuse_session *se)
+static void setup_namespaces(struct lo_data *lo, struct fuse_session=20
*se, bool enable_reconnect)
 =C2=A0{
 =C2=A0=C2=A0=C2=A0=C2=A0 pid_t child;

@@ -3829,12 +3829,21 @@ static void setup_namespaces(struct lo_data *lo,=20
struct fuse_session *se)
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * is also needed so that we can remount /pr=
oc for the new pid
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * namespace.
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *
-=C2=A0=C2=A0=C2=A0=C2=A0 * Our UNIX domain sockets have been created.=C2=
=A0 Now we can move to
-=C2=A0=C2=A0=C2=A0=C2=A0 * an empty network namespace to prevent TCP/IP an=
d other network
-=C2=A0=C2=A0=C2=A0=C2=A0 * activity in case this process is compromised.
+=C2=A0=C2=A0=C2=A0=C2=A0 * Our UNIX domain sockets have been created. If w=
e don't need=20
reconnect
+=C2=A0=C2=A0=C2=A0=C2=A0 * now we can move to an empty network namespace t=
o prevent TCP/IP and
+=C2=A0=C2=A0=C2=A0=C2=A0 * other network activity in case this process is =
compromised.
+=C2=A0=C2=A0=C2=A0=C2=A0 *
+=C2=A0=C2=A0=C2=A0=C2=A0 * TODO: Need to double-check if this is necessary=
. Looks like unix=20
sockets
+=C2=A0=C2=A0=C2=A0=C2=A0 * can be shared across network namespaces. Maybe =
it is better if=20
socket can
+=C2=A0=C2=A0=C2=A0=C2=A0 * be created in new namespace (but before we forb=
id listen with=20
seccomp).
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
-=C2=A0=C2=A0=C2=A0 if (unshare(CLONE_NEWPID | CLONE_NEWNS | CLONE_NEWNET) =
!=3D 0) {
-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fuse_log(FUSE_LOG_ERR, "unshare=
(CLONE_NEWPID | CLONE_NEWNS):=20
%m\n");
+=C2=A0=C2=A0=C2=A0 int unshare_flags =3D CLONE_NEWPID | CLONE_NEWNS;
+=C2=A0=C2=A0=C2=A0 if (!enable_reconnect) {
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unshare_flags |=3D CLONE_NEWNET=
;
+=C2=A0=C2=A0=C2=A0 }
+=C2=A0=C2=A0=C2=A0 if (unshare(unshare_flags) !=3D 0) {
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fuse_log(FUSE_LOG_ERR, "unshare=
(CLONE_NEWPID | CLONE_NEWNS%s):=20
%m\n",
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 enable_reconnect ? " | CLONE_NEWNET" : "");
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 exit(1);
 =C2=A0=C2=A0=C2=A0=C2=A0 }

@@ -4146,16 +4155,16 @@ static void setup_chroot(struct lo_data *lo)
 =C2=A0 * source directory.=C2=A0 This reduces the impact of arbitrary code=
=20
execution bugs.
 =C2=A0 */
 =C2=A0static void setup_sandbox(struct lo_data *lo, struct fuse_session *s=
e,
-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 bool enable_syslog)
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 bool enable_syslog, bool enable_reconnect)
 =C2=A0{
 =C2=A0=C2=A0=C2=A0=C2=A0 if (lo->sandbox =3D=3D SANDBOX_NAMESPACE) {
-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 setup_namespaces(lo, se);
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 setup_namespaces(lo, se, enable=
_reconnect);
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 setup_mounts(lo->source);
 =C2=A0=C2=A0=C2=A0=C2=A0 } else {
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 setup_chroot(lo);
 =C2=A0=C2=A0=C2=A0=C2=A0 }

-=C2=A0=C2=A0=C2=A0 setup_seccomp(enable_syslog);
+=C2=A0=C2=A0=C2=A0 setup_seccomp(enable_syslog, enable_reconnect);
 =C2=A0=C2=A0=C2=A0=C2=A0 setup_capabilities(g_strdup(lo->modcaps));
 =C2=A0}

@@ -4500,13 +4509,27 @@ int main(int argc, char *argv[])
 =C2=A0=C2=A0=C2=A0=C2=A0 /* Must be before sandbox since it wants /proc */
 =C2=A0=C2=A0=C2=A0=C2=A0 setup_capng();

-=C2=A0=C2=A0=C2=A0 setup_sandbox(&lo, se, opts.syslog);
+=C2=A0=C2=A0=C2=A0 setup_sandbox(&lo, se, opts.syslog, opts.reconnect);

 =C2=A0=C2=A0=C2=A0=C2=A0 setup_root(&lo, &lo.root);
-=C2=A0=C2=A0=C2=A0 /* Block until ctrl+c or fusermount -u */
-=C2=A0=C2=A0=C2=A0 ret =3D virtio_loop(se);
+=C2=A0=C2=A0=C2=A0 do {
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* TODO: this loop should be li=
ke {mount-loop-unmount} but setup of
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * listen descriptor happe=
ns in mount and will fail after=20
sandboxing.
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Need to extract setup t=
o virtio_session_new where we can create
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * socket before sandboxin=
g and in session_mount only accept=20
client.*/
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Block until ctrl+c, fusermou=
nt -u or client disconnect */
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D virtio_loop(se);
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fuse_log(FUSE_LOG_ERR, "ret is =
%d, %s\n", ret,
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 ret ? "reconnecting" : "terminating");
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fuse_session_unmount(se);
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret) {
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (fus=
e_session_mount(se) !=3D 0) {
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 fuse_log(FUSE_LOG_ERR, "failed to remount\n");
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 goto err_out3;
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
+=C2=A0=C2=A0=C2=A0 } while (opts.reconnect && !ret);

-=C2=A0=C2=A0=C2=A0 fuse_session_unmount(se);
 =C2=A0=C2=A0=C2=A0=C2=A0 cleanup_capng();
 =C2=A0err_out3:
 =C2=A0=C2=A0=C2=A0=C2=A0 fuse_remove_signal_handlers(se);
diff --git a/tools/virtiofsd/passthrough_seccomp.c=20
b/tools/virtiofsd/passthrough_seccomp.c
index 0033dab493..8dd773a062 100644
--- a/tools/virtiofsd/passthrough_seccomp.c
+++ b/tools/virtiofsd/passthrough_seccomp.c
@@ -129,6 +129,11 @@ static const int syscall_allowlist_syslog[] =3D {
 =C2=A0=C2=A0=C2=A0=C2=A0 SCMP_SYS(sendto),
 =C2=A0};

+/* Allow accept to handle client reconnect */
+static const int syscall_allowlist_reconnect[] =3D {
+=C2=A0=C2=A0=C2=A0 SCMP_SYS(accept),
+};
+
 =C2=A0static void add_allowlist(scmp_filter_ctx ctx, const int syscalls[],=
=20
size_t len)
 =C2=A0{
 =C2=A0=C2=A0=C2=A0=C2=A0 size_t i;
@@ -142,7 +147,7 @@ static void add_allowlist(scmp_filter_ctx ctx, const=20
int syscalls[], size_t len)
 =C2=A0=C2=A0=C2=A0=C2=A0 }
 =C2=A0}

-void setup_seccomp(bool enable_syslog)
+void setup_seccomp(bool enable_syslog, bool enable_reconnect)
 =C2=A0{
 =C2=A0=C2=A0=C2=A0=C2=A0 scmp_filter_ctx ctx;

@@ -166,6 +171,11 @@ void setup_seccomp(bool enable_syslog)
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 G_N_ELEMENTS(s=
yscall_allowlist_syslog));
 =C2=A0=C2=A0=C2=A0=C2=A0 }

+=C2=A0=C2=A0=C2=A0 if (enable_reconnect) {
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 add_allowlist(ctx, syscall_allo=
wlist_reconnect,
+ G_N_ELEMENTS(syscall_allowlist_reconnect));
+=C2=A0=C2=A0=C2=A0 }
+
 =C2=A0=C2=A0=C2=A0=C2=A0 /* libvhost-user calls this for post-copy migrati=
on, we don't need=20
it */
 =C2=A0=C2=A0=C2=A0=C2=A0 if (seccomp_rule_add(ctx, SCMP_ACT_ERRNO(ENOSYS),
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 SCMP_SYS(userfaultfd), 0) !=3D 0) {
diff --git a/tools/virtiofsd/passthrough_seccomp.h=20
b/tools/virtiofsd/passthrough_seccomp.h
index 12674fc050..bec47b114c 100644
--- a/tools/virtiofsd/passthrough_seccomp.h
+++ b/tools/virtiofsd/passthrough_seccomp.h
@@ -9,6 +9,6 @@
 =C2=A0#ifndef VIRTIOFSD_PASSTHROUGH_SECCOMP_H
 =C2=A0#define VIRTIOFSD_PASSTHROUGH_SECCOMP_H

-void setup_seccomp(bool enable_syslog);
+void setup_seccomp(bool enable_syslog, bool enable_reconnect);

 =C2=A0#endif /* VIRTIOFSD_PASSTHROUGH_SECCOMP_H */
--=20
2.37.2


>
>>
>>>>
>>>>>>
>>>>>>>>>>> This property selects if VM can migrate and if it can what=20
>>>>>>>>>>> should
>>>>>>>>>>> qemu put
>>>>>>>>>>> to the migration stream. So we select on source what type of
>>>>>>>>>>> migration is
>>>>>>>>>>> allowed for this VM, destination can't check anything at=20
>>>>>>>>>>> load time.
>>>>>>>>>> OK, so the new field "migration" regulates only outgoing=20
>>>>>>>>>> migration and
>>>>>>>>>> do nothing for incoming. On incoming migration the migration=20
>>>>>>>>>> stream
>>>>>>>>>> itself defines the type of device migration.
>>>>>>>>>> Worth mentioning in doc?
>>>>>>>>> Good point. I don't think this deserves a respin but if I have=20
>>>>>>>>> to send v4
>>>>>>>>> I'll include
>>>>>>>>> clarification in it.

