Return-Path: <primalgamer@gmail.com>
Message-ID: <b155ad6fe6bb026377a8f75882e26078da10ab70.camel@inf.elte.hu>
From: Ferenc Fejes <fejes@inf.elte.hu>
Date: Fri, 24 Feb 2023 16:17:56 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: [Virtio-fs] question: QEMU guest with Virtiofs but without virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>
Cc: qemu-devel@nongnu.org, stefanha@redhat.com, =?ISO-8859-1?Q?P=E9ter?= Antal <peti.antal99@gmail.com>

Hi!

I'm using a QEMU VM with a debootstrap rootfs, shared over virtiofs for
the guest. My best understanding is that virtiofsd must required even
if just using one guest.

Looking around in the QEMU manpages I got a little bit confused by
virtfs parameter. Is it something entirely connected with 9P or it is
possible to pass folders to the guest through virtiofs without
virtiofsd? Unfortunately none of my trial with the parameters
succeeded.

Could someone can give me a confirmation if virtiofsd is must or its
optional. Thanks in advance!

Best,
Ferenc

