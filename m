Return-Path: <erik.schilling@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1694585919; x=1695190719; darn=redhat.com;
 h=in-reply-to:references:message-id:from:to:cc:subject:date
 :content-transfer-encoding:mime-version:from:to:cc:subject:date
 :message-id:reply-to;
 bh=iAf/16hy8GPnKFTGuy3hCSRkInFeqAXMGniiY3Op/qM=;
 b=A7M3BTXEAitzHeelDJ2Gc6l+BhLMFC3S2+tk5S1hOqENcv1DAyLMGd9FMymEfLii11
 x35q/l6/ZRtiKJDTrL1G9G02/Mkz2uNCGpUm6+06td63P667JOeeeBiVLyIyucGQOovd
 Rmf4nqzjV1UBSyLmrgpTV4eUbkNXVf7DS5RwnWUlYWC/Aa1n59T+0xa0E/1PVcJgR/M4
 dalkFnmW0iNQBEO7Ap3yJixy4boL0G6fI+Uol2+e2D5ujX0WWGGChjCdT+JK1SM59Gsi
 zHG/iqGOZv7SDrAMU/r5dURYrnbbi/wuiVFjIwAenPHdpG2o20hqNGn3Gqe0b0nVd64C
 txcw==
Mime-Version: 1.0
Date: Wed, 13 Sep 2023 08:18:38 +0200
From: "Erik Schilling" <erik.schilling@linaro.org>
Message-Id: <CVHKGP2HRKVG.TEIWT3U6ZVTX@ablu-work>
References: <CV5Q388ZKSI3.2N5DT3BRV3RIM@fedora>
 <CV7IJY36ZXDZ.250Z3B8VKN4Y5@ablu-work>
In-Reply-To: <CV7IJY36ZXDZ.250Z3B8VKN4Y5@ablu-work>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Subject: Re: [Virtio-fs] [BUG] virtio-fs: Corruption when running binaries
 from virtiofsd-backed fs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Erik Schilling <erik.schilling@linaro.org>, virtualization@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com
Cc: Vivek Goyal <vgoyal@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, =?utf-8?q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>, Manos
 Pitsidianakis <manos.pitsidianakis@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org

On Fri Sep 1, 2023 at 12:37 PM CEST, Erik Schilling wrote:
> On Wed Aug 30, 2023 at 10:20 AM CEST, Erik Schilling wrote:
> > Hi all!
> >
> > Some days ago I posted to #virtiofs:matrix.org, describing that I am
> > observing what looks like a corruption when executing programs from a
> > virtiofs-based filesystem.
> >
> > Over the last few days I spent more time drilling into the problem.
> > This is an attempt at summarizing my findings in order to see what othe=
r
> > people think about this.
> >
> > When running binaries mounted from virtiofs they may either: fail with =
a
> > segfault, fail with badaddr, get stuck or - sometimes - succeed.
> >
> > Environment:
> >   Host: Fedora 38 running 6.4.11-200.fc38.x86_64
> >   Guest: Yocto-based image: 6.4.9-yocto-standard, aarch64
> >   virtiofsd: latest main + some debug prints [1]
> >   QEMU: built from recent git [2]
> >
> > virtiofsd invocation:
> >   RUST_LOG=3D"debug" ./virtiofsd --seccomp=3Dnone --sandbox=3Dnone \
> >     --socket-path "fs.sock0" --shared-dir $PWD/share-dir/ --cache=3Dnev=
er
> >
> > QEMU invocation:
> >   ~/projects/qemu/build/qemu-system-aarch64 -kernel Image -machine virt=
 \
> >     -cpu cortex-a57 \
> >     -serial mon:stdio \
> >     -device virtio-net-pci,netdev=3Dnet0 \
> >     -netdev user,id=3Dnet0,hostfwd=3Dtcp::2223-:22 \
> >     -display none -m 2048 -smp 4 \
> >     -object memory-backend-memfd,id=3Dmem,size=3D2048M,share=3Don \
> >     -numa node,memdev=3Dmem \
> >     -hda trs-overlay-guest.qcow2 \
> >     -chardev socket,id=3Dchar0,path=3D"fs.sock0" \
> >     -device vhost-user-fs-pci,queue-size=3D1024,chardev=3Dchar0,tag=3D/=
dev/root \
> >     -append 'root=3D/dev/vda2 ro log_buf_len=3D8M'
> >
> > I figured that launching virtiofsd with --cache=3Dalways masks the
> > problem. Therefore, I set --cache=3Dnever, but I think I observed no
> > difference compared to the default setting (auto).
> >
> > Adding logging to virtiofsd and kernel _feeled_ like it made the proble=
m
> > harder to reproduce - leaving me with the impression that some race is
> > happening on somewhere.
> >
> > Trying to rule out that virtiofsd is returning corrupted data, I added
> > some logging and hashsum calculation hacks to it [1]. The hashes check
> > out across multiple accesses and the order and kind of queued messages
> > is exactly the same in both the error case and crash case. fio was also
> > unable to find any errors with a naive job description [3].
> >
> > Next, I tried to capture info on the guest side. This became a bit
> > tricky since the crashes became pretty rare once I followed a fixed
> > pattern of starting log capture, running perf and trying to reproduce
> > the problem. Ultimately, I had the most consistent results with
> > immediately running a program twice:
> >
> >   /mnt/ld-linux-aarch64.so.1 /mnt/ls.coreutils /; \
> >     /mnt/ld-linux-aarch64.so.1 /mnt/ls.coreutils /
> >
> >   (/mnt being the virtiofs mount)
> >
> > For collecting logs, I made a hack to the guest kernel in order to dump
> > the page content after receiving the virtiofs responses [4]. Reproducin=
g
> > the problem with this, leaves me with logs that seem to suggest that
> > virtiofsd is returning identical content, but the guest kernel seems to
> > receive differing pages:
> >
> > good-kernel [5]:
> >   kernel: virtio_fs_wake_pending_and_unlock: opcode 3 unique 0x312 node=
id 0x1 in.len 56 out.len 104
> >   kernel: virtiofs virtio1: virtio_fs_vq_done requests.0
> >   kernel: virtio_fs_wake_pending_and_unlock: opcode 1 unique 0x314 node=
id 0x1 in.len 53 out.len 128
> >   kernel: virtiofs virtio1: virtio_fs_vq_done requests.0
> >   kernel: virtio_fs_wake_pending_and_unlock: opcode 3 unique 0x316 node=
id 0x29 in.len 56 out.len 104
> >   kernel: virtiofs virtio1: virtio_fs_vq_done requests.0
> >   kernel: virtio_fs_wake_pending_and_unlock: opcode 14 unique 0x318 nod=
eid 0x29 in.len 48 out.len 16
> >   kernel: virtiofs virtio1: virtio_fs_vq_done requests.0
> >   kernel: virtio_fs_wake_pending_and_unlock: opcode 15 unique 0x31a nod=
eid 0x29 in.len 80 out.len 832
> >   kernel: virtiofs virtio1: virtio_fs_vq_done requests.0
> >   kernel: virtio_fs: page: 000000006996d520
> >   kernel: virtio_fs: to: 00000000de590c14
> >   kernel: virtio_fs rsp:00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
  ................
> >   kernel: virtio_fs rsp:00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
  ................
> >   kernel: virtio_fs rsp:00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
  ................
> >   kernel: virtio_fs rsp:00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
  ................
> >   [...]
> >
> > bad-kernel [6]:
> >   kernel: virtio_fs_wake_pending_and_unlock: opcode 3 unique 0x162 node=
id 0x1 in.len 56 out.len 104
> >   kernel: virtiofs virtio1: virtio_fs_vq_done requests.0
> >   kernel: virtio_fs_wake_pending_and_unlock: opcode 1 unique 0x164 node=
id 0x1 in.len 53 out.len 128
> >   kernel: virtiofs virtio1: virtio_fs_vq_done requests.0
> >   kernel: virtio_fs_wake_pending_and_unlock: opcode 3 unique 0x166 node=
id 0x16 in.len 56 out.len 104
> >   kernel: virtiofs virtio1: virtio_fs_vq_done requests.0
> >   kernel: virtio_fs_wake_pending_and_unlock: opcode 14 unique 0x168 nod=
eid 0x16 in.len 48 out.len 16
> >   kernel: virtiofs virtio1: virtio_fs_vq_done requests.0
> >   kernel: virtio_fs_wake_pending_and_unlock: opcode 15 unique 0x16a nod=
eid 0x16 in.len 80 out.len 832
> >   kernel: virtiofs virtio1: virtio_fs_vq_done requests.0
> >   kernel: virtio_fs: page: 000000006ce9a559
> >   kernel: virtio_fs: to: 000000007ae8b946
> >   kernel: virtio_fs rsp:00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
  ................
> >   kernel: virtio_fs rsp:00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
  ................
> >   kernel: virtio_fs rsp:80 40 de c8 ff ff 00 00 cc 2b 62 ae ff ff 00 00=
  .@.......+b.....
> >   kernel: virtio_fs rsp:02 4e de c8 ff ff 00 00 00 00 00 00 00 00 00 00=
  .N..............
> >   [...]
> >
> > When looking at the corresponding output from virtiofsd, it claims to
> > have returned identical data:
> >
> > good-virtiofsd [7]:
> >   [DEBUG virtiofsd::server] Received request: opcode=3DRead (15), inode=
=3D41, unique=3D794, pid=3D481
> >   [src/server.rs:618] r.read_obj().map_err(Error::DecodeMessage)? =3D R=
eadIn {
> >       fh: 31,
> >       offset: 0,
> >       size: 832,
> >       read_flags: 2,
> >       lock_owner: 6838554705639967244,
> >       flags: 131072,
> >       padding: 0,
> >   }
> >   [src/file_traits.rs:161] hash =3D 2308490450751364994
> >   [DEBUG virtiofsd::server] Replying OK, header: OutHeader { len: 848, =
error: 0, unique: 794 }
> >
> > bad-virtiofsd [8]:
> >   [DEBUG virtiofsd::server] Received request: opcode=3DRead (15), inode=
=3D22, unique=3D362, pid=3D406
> >   [src/server.rs:618] r.read_obj().map_err(Error::DecodeMessage)? =3D R=
eadIn {
> >       fh: 12,
> >       offset: 0,
> >       size: 832,
> >       read_flags: 2,
> >       lock_owner: 6181120926258395554,
> >       flags: 131072,
> >       padding: 0,
> >   }
> >   [src/file_traits.rs:161] hash =3D 2308490450751364994
> >   [DEBUG virtiofsd::server] Replying OK, header: OutHeader { len: 848, =
error: 0, unique: 362 }
> >
> > The "corruption" only seems to happen in this one page, all other pages
> > are identical between runs (except that the bad run terminates earlier)=
.
> >
> > What do the experts think here? To me it feels a bit like some kind of
> > corruption is going on. Or am I misinterpreting things here?
> >
> > Which further analysis steps would you suggest?
> >
> >
> > Further notes:
> >
> > After collecting the above results, I realized that running the guest
> > with -smp 1 makes the problems a lot worse. So maybe that is a better
> > choice when trying to reproduce it.
> >
> > Repo with my scripts is available at:
> > https://git.codelinaro.org/erik_schilling/jira-orko-65-bootstrap-k3s-co=
nfig/
> >
> > The scripts are just quick and dirty implementations and are not
> > particulary portable.
>
> Summary of my testing during the last few days:
>
> Testing with KCSAN revealed a few cases that look like missing READ_ONCE
> annotations (will send patches separately). But nothing of that was
> related to the immediate problem. I tested instrument_read() and another
> round of logging with a delay to virtio_fs_request_complete. It looks
> like the buffer get corrupted before entering that function. KCSAN
> or manual sleeps + prints did not show any corruption while in that
> function.
>
> KASAN did not report any issues.
>
> Patching virtiofsd to do an additional copy and going through rust-vmm's
> .copy_to() function did not change the behaviour.
>
> I will mostly be off next week, will continue analysis afterwards. Happy
> to hear about suggestions of other things to try :).

Back from a week of vacation...

Summary of what was discussed on #virtiofs:matrix.org:

The issue only seems to happen in QEMU TCG scenarios (I tested aarch64
and x86_64 on x86_64, wizzard on Matrix tested arm32).

CCing qemu-devel. Maybe someone has some hints on where to focus the
debugging efforts?

I am trying to build a complex monster script of tracing the relevant
addresses in order to figure out whether the guest or host does the
writes. But I am happy to hear about more clever ideas :).

- Erik

>
> Good weekend,
>
> - Erik
>
>
> >
> > - Erik
> >
> > [1] https://gitlab.com/ablu/virtiofsd/-/commit/18fd0c1849e15bc55fbdd6e1=
f169801b2b03da1f
> > [2] https://gitlab.com/qemu-project/qemu/-/commit/50e7a40af372ee5931c99=
ef7390f5d3d6fbf6ec4
> > [3] https://git.codelinaro.org/erik_schilling/jira-orko-65-bootstrap-k3=
s-config/-/blob/397a6310dea35973025e3d61f46090bf0c092762/share-dir/write-an=
d-verify-mmap.fio
> > [4] https://github.com/Ablu/linux/commit/3880b9f8affb01aeabb0a04fe76ad7=
701dc0bb95
> > [5] Line 12923: https://git.codelinaro.org/erik_schilling/jira-orko-65-=
bootstrap-k3s-config/-/blob/main/logs/2023-08-29%2013%3A42%3A35%2B02%3A00/g=
ood-drop-bad-1.txt
> > [6] Line 12923: https://git.codelinaro.org/erik_schilling/jira-orko-65-=
bootstrap-k3s-config/-/blob/main/logs/2023-08-29%2013%3A42%3A35%2B02%3A00/g=
ood-bad-1.txt
> > [7] https://git.codelinaro.org/erik_schilling/jira-orko-65-bootstrap-k3=
s-config/-/blob/main/logs/2023-08-29%2013%3A42%3A35%2B02%3A00/virtiofsd.txt=
#L2538-2549
> > [8] https://git.codelinaro.org/erik_schilling/jira-orko-65-bootstrap-k3=
s-config/-/blob/main/logs/2023-08-29%2013%3A42%3A35%2B02%3A00/virtiofsd.txt=
#L1052-1063

