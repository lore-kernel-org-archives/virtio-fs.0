References: <20200727190223.422280-1-stefanha@redhat.com>
	<20200727190223.422280-4-stefanha@redhat.com>
	<OSBPR01MB45826073E5A54CF869E56721E5730@OSBPR01MB4582.jpnprd01.prod.outlook.com>
	<CALDPj7syG0KPhtZEma5n403=YFZ2ptcD4MtP=GdrY9n1eUs5Eg@mail.gmail.com>
	<20200728131250.GB78409@redhat.com>
From: Daniel Walsh <dwalsh@redhat.com>
Message-ID: <e982e87a-d5a8-264d-f591-0f1523464c97@redhat.com>
Date: Tue, 28 Jul 2020 15:12:54 -0400
MIME-Version: 1.0
In-Reply-To: <20200728131250.GB78409@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH v2 3/3] virtiofsd: probe unshare(CLONE_FS)
 and print an error
Reply-To: dwalsh@redhat.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, Roman Mohr <rmohr@redhat.com>
Cc: "vromanso@redhat.com" <vromanso@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "mpatel@redhat.com" <mpatel@redhat.com>

On 7/28/20 09:12, Vivek Goyal wrote:
> On Tue, Jul 28, 2020 at 12:00:20PM +0200, Roman Mohr wrote:
>> On Tue, Jul 28, 2020 at 3:07 AM misono.tomohiro@fujitsu.com <
>> misono.tomohiro@fujitsu.com> wrote:
>>
>>>> Subject: [PATCH v2 3/3] virtiofsd: probe unshare(CLONE_FS) and print an
>>> error
>>>> An assertion failure is raised during request processing if
>>>> unshare(CLONE_FS) fails. Implement a probe at startup so the problem can
>>>> be detected right away.
>>>>
>>>> Unfortunately Docker/Moby does not include unshare in the seccomp.json
>>>> list unless CAP_SYS_ADMIN is given. Other seccomp.json lists always
>>>> include unshare (e.g. podman is unaffected):
>>>>
>>> https://raw.githubusercontent.com/seccomp/containers-golang/master/seccomp.json
>>>> Use "docker run --security-opt seccomp=path/to/seccomp.json ..." if the
>>>> default seccomp.json is missing unshare.
>>> Hi, sorry for a bit late.
>>>
>>> unshare() was added to fix xattr problem:
>>>
>>> https://github.com/qemu/qemu/commit/bdfd66788349acc43cd3f1298718ad491663cfcc#
>>> In theory we don't need to call unshare if xattr is disabled, but it is
>>> hard to get to know
>>> if xattr is enabled or disabled in fv_queue_worker(), right?
>>>
>>>
>> In kubevirt we want to run virtiofsd in containers. We would already not
>> have xattr support for e.g. overlayfs in the VM after this patch series (an
>> acceptable con at least for us right now).
>> If we can get rid of the unshare (and potentially of needing root) that
>> would be great. We always assume that everything which we run in containers
>> should work for cri-o and docker.
> But cri-o and docker containers run as root, isn't it? (or atleast have
> the capability to run as root). Havind said that, it will be nice to be able
> to run virtiofsd without root. 
>
> There are few hurdles though.
>
> - For file creation, we switch uid/gid (seteuid/setegid) and that seems
>   to require root. If we were to run unpriviliged, probably all files
>   on host will have to be owned by unpriviliged user and guest visible
>   uid/gid will have to be stored in xattrs. I think virtfs supports
>   something similar.
>
> I am sure there are other restrictions but this probably is the biggest
> one to overcome.
>
>  > 
You should be able to run it within a user namespace with Namespaces
capabilities.
>> "Just" pointing docker to a different seccomp.json file is something which
>> k8s users/admin in many cases can't do.
> Or may be issue is that standard seccomp.json does not allow unshare()
> and hence you are forced to use a non-standar seccomp.json.
>
> Vivek
>
>> Best Regards,
>> Roman
>>
>>
>>> So, it looks good to me.
>>> Reviewed-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>>>
>>> Regards,
>>> Misono
>>>
>>>> Cc: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>>>> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
>>>> ---
>>>>  tools/virtiofsd/fuse_virtio.c | 16 ++++++++++++++++
>>>>  1 file changed, 16 insertions(+)
>>>>
>>>> diff --git a/tools/virtiofsd/fuse_virtio.c
>>> b/tools/virtiofsd/fuse_virtio.c
>>>> index 3b6d16a041..9e5537506c 100644
>>>> --- a/tools/virtiofsd/fuse_virtio.c
>>>> +++ b/tools/virtiofsd/fuse_virtio.c
>>>> @@ -949,6 +949,22 @@ int virtio_session_mount(struct fuse_session *se)
>>>>  {
>>>>      int ret;
>>>>
>>>> +    /*
>>>> +     * Test that unshare(CLONE_FS) works. fv_queue_worker() will need
>>> it. It's
>>>> +     * an unprivileged system call but some Docker/Moby versions are
>>> known to
>>>> +     * reject it via seccomp when CAP_SYS_ADMIN is not given.
>>>> +     *
>>>> +     * Note that the program is single-threaded here so this syscall
>>> has no
>>>> +     * visible effect and is safe to make.
>>>> +     */
>>>> +    ret = unshare(CLONE_FS);
>>>> +    if (ret == -1 && errno == EPERM) {
>>>> +        fuse_log(FUSE_LOG_ERR, "unshare(CLONE_FS) failed with EPERM. If
>>> "
>>>> +                "running in a container please check that the container
>>> "
>>>> +                "runtime seccomp policy allows unshare.\n");
>>>> +        return -1;
>>>> +    }
>>>> +
>>>>      ret = fv_create_listen_socket(se);
>>>>      if (ret < 0) {
>>>>          return ret;
>>>> --
>>>> 2.26.2
>>>

