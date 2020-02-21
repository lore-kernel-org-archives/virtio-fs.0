References: <20200221065515.4476-1-yangx.jy@cn.fujitsu.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <96dca240-e221-a4ab-4f8f-198891c1b16a@redhat.com>
Date: Fri, 21 Feb 2020 10:47:38 +0100
MIME-Version: 1.0
In-Reply-To: <20200221065515.4476-1-yangx.jy@cn.fujitsu.com>
Content-Language: en-US
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Remove fuse.h and struct
	fuse_module
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Xiao Yang <yangx.jy@cn.fujitsu.com>, virtio-fs@redhat.com
Cc: qemu-devel@nongnu.org

On 2/21/20 7:55 AM, Xiao Yang wrote:
> All code in fuse.h and struct fuse_module are not used by virtiofsd
> so removing them is safe.
>=20
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
> ---
>   tools/virtiofsd/fuse.h   | 1229 --------------------------------------
>   tools/virtiofsd/fuse_i.h |   16 -
>   2 files changed, 1245 deletions(-)
>   delete mode 100644 tools/virtiofsd/fuse.h

Reviewed-by: Philippe Mathieu-Daud=E9 <philmd@redhat.com>


