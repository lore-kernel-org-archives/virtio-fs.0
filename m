Return-Path: <gmaglion@redhat.com>
MIME-Version: 1.0
References: <BY5PR14MB38930999DE81BFE799016C8C86829@BY5PR14MB3893.namprd14.prod.outlook.com>
In-Reply-To: <BY5PR14MB38930999DE81BFE799016C8C86829@BY5PR14MB3893.namprd14.prod.outlook.com>
From: German Maglione <gmaglione@redhat.com>
Date: Mon, 11 Jul 2022 09:59:11 +0200
Message-ID: <CAJh=p+6ZrMyHGkgWNfA_S7nY135cmOHuqOE34FqWTGXK3fbmXA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] Ownership of a file shared between guest and host
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Pra.. Dew.." <linux_learner@outlook.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

On Fri, Jul 8, 2022 at 10:18 PM Pra.. Dew.. <linux_learner@outlook.com> wro=
te:
>
> We have been able to setup virtiofs between guest and host (QEMU 6.2/Linu=
x 5.15). We run virtiofsd as a non-root user in the host. We did not want t=
o run it as a root user in order to minimize the attack surface. We run it =
as a virtiofs user. When we create a file in the shared folder, the permiss=
ion of the file is virtiofs user and virtiofs group. When we read that file=
 from the guest it shows virtiofs user (only the uid) and nobody group. The=
 goal is to restrict the access of the file to a few services in the guest =
(not give access to all services). We tried to create a group in the guest =
and tried to move the file in the new group. However chown gives "bad descr=
iptor." Is there a better way of doing this? Any input is really appreciate=
d. Thank you so much!


you can try to run virtiofsd inside a user namespace[1], mapping a
range of "host" uid/gid to uid/gid 0 and following in the guest.
see "podman unshare" or "lxc-usernsexec"


[1] https://gitlab.com/virtio-fs/virtiofsd#running-as-non-privileged-user
--=20
German

