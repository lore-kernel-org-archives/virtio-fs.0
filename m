Mime-Version: 1.0
From: "Connor Kuehl" <ckuehl@redhat.com>
Date: Wed, 14 Apr 2021 16:47:55 -0500
Message-Id: <CANRZOP7US2Z.118EXV1M0KTZO@redhat>
In-Reply-To: <20210414201207.3612432-1-jose.carlos.venegas.munoz@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: Enable xattr if xattrmap is
	used
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Carlos Venegas <jose.carlos.venegas.munoz@intel.com>, virtio-fs@redhat.com
Cc: qemu-devel@nongnu.org, vgoyal@redhat.com

On Wed Apr 14, 2021 at 3:12 PM CDT, Carlos Venegas wrote:
>
> Using xattrmap for Kata Containers we found that xattr is should be used
> or xattrmap wont work. These patches enable xattr when -o xattrmap is
> used. Also, they add help for the xattrmap option on `virtiofsd --help`
> output.
>
> Carlos Venegas (2):
> virtiofsd: Allow use "-o xattrmap" without "-o xattr"
> virtiofsd: Add help for -o xattr-mapping

Good usability improvement.

For the series:

Reviewed-by: Connor Kuehl <ckuehl@redhat.com>


