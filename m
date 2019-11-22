References: <20191122113130.481113-1-stefanha@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <0bda9aff-2912-4107-6d9f-c385068ca646@redhat.com>
Date: Fri, 22 Nov 2019 13:59:44 +0100
MIME-Version: 1.0
In-Reply-To: <20191122113130.481113-1-stefanha@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: fix libfuse information leaks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com

On 11/22/19 12:31 PM, Stefan Hajnoczi wrote:
> Some FUSE message replies contain padding fields that are not
> initialized by libfuse.  This is fine in traditional FUSE applications
> because the kernel is trusted.  virtiofsd does not trust the guest and
> must not expose uninitialized memory.
>=20
> Use C struct initializers to automatically zero out memory.  Not all of
> these code changes are strictly necessary but they will prevent future
> information leaks if the structs are extended.
>=20
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

Nice cleanup.
Reviewed-by: Philippe Mathieu-Daud=E9 <philmd@redhat.com>


