References: <599fd4bd-2f62-1ce5-2b9c-0512ee7ead6e@redhat.com>
	<0208dde6-df57-c27a-418f-57cb3c0173f2@redhat.com>
From: Laszlo Ersek <lersek@redhat.com>
Message-ID: <c0f7c512-d796-db16-e5fb-a2e346c37e48@redhat.com>
Date: Mon, 21 Dec 2020 13:45:09 +0100
MIME-Version: 1.0
In-Reply-To: <0208dde6-df57-c27a-418f-57cb3c0173f2@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] virtiofsd: sshfs as submount?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>, Miklos Szeredi <mszeredi@redhat.com>
Cc: "=?UTF-8?Q?Daniel_P._Berrang=c3=a9?=" <berrange@redhat.com>, qemu devel list <qemu-devel@nongnu.org>, virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>

On 12/21/20 13:06, Max Reitz wrote:

> I can share sshfs through sshfs, so it must be something virtiofs-specific.

Your insight proved crucial to solving the riddle.

Chaining sshfs with sshfs made me think that you must have used a normal
(non-root) user account on the first remote computer (where you ran the
2nd sshfs command).

And that reminded me of the "allow_root" option which I seemed to have
read somewhere around the FUSE manuals.

So indeed I set up another sshfs mount on my laptop, with my normal UID,
and tried to access the mount point from a plain root shell (with
virtiofsd completely out of the picture) -- it failed with "Permission
denied". :) It's apparently intentional on sshfs's / FUSE's part, to
protect the local root user from "remote nastiness injection".

Then I re-did the sshfs mount, but with "-o allow_root" this time. The
plain root shell can now access the mount point.

... So can virtiofsd :) It's *amazing* to see remote files in the UEFI
shell. I never thought "filesystem as a service" could feel this empowering.

Thanks, Max!
Laszlo

