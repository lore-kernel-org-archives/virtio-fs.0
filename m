Return-Path: <gmaglion@redhat.com>
MIME-Version: 1.0
References: <CAH7xS_XHPenR9STmr7MNaHoGLr-Ks_FiFUYu482ntd1ftVsPfQ@mail.gmail.com>
 <CAJh=p+6JOz2irMLhtSE8zA0wvQKUYEHg53J4jTnqBXe=Q24LWQ@mail.gmail.com>
 <CAJh=p+6R3cSHBkreNbL7-7xCfRyG9LeY8NJwBGZaDOaN=zia=A@mail.gmail.com>
 <CAH7xS_Usm3PK8TX9qFVUs=c+BZuh1tSoAS-17mU3r8T9ad01kQ@mail.gmail.com>
In-Reply-To: <CAH7xS_Usm3PK8TX9qFVUs=c+BZuh1tSoAS-17mU3r8T9ad01kQ@mail.gmail.com>
From: German Maglione <gmaglione@redhat.com>
Date: Wed, 31 Aug 2022 17:42:23 +0200
Message-ID: <CAJh=p+5zdkjRp0rjBvZ9gyfscXKUKv1xakVKRbrKZ+jH_ow3dQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] Map more than one uid/gid when running virtiofsd
 with unprivileged user
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Elaheh Dehghani <dehghani.e@gmail.com>
Cc: virtio-fs@redhat.com

On Fri, Aug 26, 2022 at 7:38 PM Elaheh Dehghani <dehghani.e@gmail.com> wrot=
e:
>
> Thanks German!
>
> We have been able to patch the virtiofsd code to map a range of IDs. We a=
re using systemd service to run virtiofsd as a non-privilege user and its A=
mbientCapabilities set to SETUID and SETGID. We've defined two new paramete=
rs for --uid-map and --gid-map. The patch sets temporary caps for the runni=
ng process (SETUID/SETGID), writes the mapping according to the input param=
eters and at the end it drops those temporary capabilities.
>
> Do you see any value in upstreaming this patch?

Of course, any collaboration is more than welcome.

We didn't implement this functionality because we didn't want to
complicate the sandbox code too much,
but for version 2 we plan to extract the sandboxing code to an
external tool, so we can use your patch in that tool too.

In case I didn't explain myself well, yes please send an MR with your chang=
es :)

Thanks,


>
> Thanks!
>
> On Fri, Aug 26, 2022 at 8:47 AM German Maglione <gmaglione@redhat.com> wr=
ote:
>>
>> On Fri, Aug 26, 2022 at 5:27 PM German Maglione <gmaglione@redhat.com> w=
rote:
>> >
>> > On Thu, Aug 18, 2022 at 1:16 AM Elaheh Dehghani <dehghani.e@gmail.com>=
 wrote:
>> > >
>> > > We are using an unprivileged user to run virtiofsd in its own user n=
amespace. We have a guest VM running on top of QEMU with KVM. We are sharin=
g files from the host to the guest and we need to make sure only certain us=
ers/groups in the guest can read/write those files. Currently there is only=
 one uid/gid that=E2=80=99s mapped correctly (the virtiofsd user on the hos=
t is mapped to guest) and everything else is mapped to nobody.
>> > >
>> > > It seems the reason is that unprivileged virtiofsd only maps current=
 uid/gid when it's running inside its own user namespace.
>> > >
>> > > Due to some resource limitations that we have in our system, we can'=
t use a container-engine such as lxc-usernsexec to map a range of uids/gids=
. So, I'm trying to figure out if there is a way to patch the =E2=80=98setu=
p_id_mappings=E2=80=99 in virtiofsd code to support our specific scenario.
>> > >
>> > >
>> > > The additional mapping that we need is for uid/gid=3D1000. What I've=
 done:
>> > >
>> > > -        Defined 1000:100000:65536 in both /etc/subuid and /etc/subg=
id
>> > >
>> > > -        Changed this line src/sandbox.rs =C2=B7 main =C2=B7 virtio-=
fs / virtiofsd =C2=B7 GitLab to something like:
>> > >
>> > > -         let uid_mapping =3D format!("{} {} 1\n1000 1000 1\n", uid,=
 uid);
>> > >
>> > >
>> > > After running virtiofsd, I=E2=80=99m getting this error:
>> > >
>> > > Error entering sandbox: WriteUidMap(Os { code: 1, kind: PermissionDe=
nied, message: =E2=80=9COperation not permitted=E2=80=9D })
>> > >
>> > >
>> > > What am I missing here?
>> >
>> > As non-privilege user, you are only allowed to map the user UID ->
>> > same NS-UID (as virtiofsd does) or user UID -> NS-UID 0,
>> > by writing directly to '/proc/PID/{uid_map, gid_map}.
>> >
>> > Mapping a range of UIDS/GUIDS is a privileged operation, you need to
>> > set the content of both '/etc/subuid' and '/etc/subgid '
>> > and run newuidmap/newgidmap.
>> >
>> > You could "manually" create the user namespace with "unshare -U", map
>> > the uids/guid using newuidmap/newgidmap, and run virtiofsd
>> > --sandbox=3Dchroot
>> > For instance (as user 1000):
>> >
>> > shell_0_$ unshare -U
>> > shell_0_$ echo $$
>> > 1234
>> >
>> > (in a different terminal)
>> > shell_1_$ newuidmap 1234 0 100000 65536
>> > shell_1_$ newgidmap 1234 0 100000 65536
>> >
>> > (now in the previous terminal)
>> > shell_0_$ virtiofsd --sandbox=3Dchroot ...
>> >
>> > Although lxc-usernsexec is a small tool that only creates user
>> > namespaces and calls newuidmap/newgidmap to do the uid/gid mapping
>> >
>>
>> I forgot to mention, as an alternative you can patch the virtiofsd
>> code removing the 'setup_id_mapping()' call. So you can run
>> virtiofsd --sandbox=3Dnamesapce ...
>>
>> and then just call newuidmap/newgidmap with the virtiofsd PID
>>
>> Cheers,
>>
>>
>> --
>> German
>>


--=20
German

