Date: Thu, 17 Dec 2020 11:49:50 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201217114950.GC4117@work-vm>
References: <20201216211125.19496-1-lersek@redhat.com>
	<20201216211125.19496-7-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201216211125.19496-7-lersek@redhat.com>
Subject: Re: [Virtio-fs] [edk2 PATCH 06/48] OvmfPkg/VirtioFsDxe: introduce
 the basic FUSE request/response headers
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Laszlo Ersek <lersek@redhat.com>
Cc: virtio-fs@redhat.com, Jordan Justen <jordan.l.justen@intel.com>, devel@edk2.groups.io, Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>, Ard Biesheuvel <ard.biesheuvel@arm.com>

* Laszlo Ersek (lersek@redhat.com) wrote:
> Introduce the VIRTIO_FS_FUSE_REQUEST and VIRTIO_FS_FUSE_RESPONSE
> structures, which are the common headers for the various FUSE
> request/response structures.
>=20
> Introduce the VirtioFsFuseNewRequest() helper function for populating
> VIRTIO_FS_FUSE_REQUEST, from parameters and from a VIRTIO_FS-level request
> counter.
>=20
> Introduce the VirtioFsFuseCheckResponse() helper function for verifying
> most FUSE response types that begin with the VIRTIO_FS_FUSE_RESPONSE
> header.
>=20
> Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
> Cc: Jordan Justen <jordan.l.justen@intel.com>
> Cc: Philippe Mathieu-Daud=E9 <philmd@redhat.com>
> Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3D3097
> Signed-off-by: Laszlo Ersek <lersek@redhat.com>
> ---
>  OvmfPkg/Include/IndustryStandard/VirtioFs.h |  49 +++++
>  OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |  17 ++
>  OvmfPkg/VirtioFsDxe/DriverBinding.c         |   5 +
>  OvmfPkg/VirtioFsDxe/Helpers.c               | 216 ++++++++++++++++++++
>  4 files changed, 287 insertions(+)
>=20
> diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Includ=
e/IndustryStandard/VirtioFs.h
> index ea7d80d15d0b..521288b03f1c 100644
> --- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
> +++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
> @@ -44,9 +44,58 @@ typedef struct {
>    //
>    // The total number of request virtqueues exposed by the device (i.e.,
>    // excluding the "hiprio" queue).
>    //
>    UINT32 NumReqQueues;
>  } VIRTIO_FS_CONFIG;
>  #pragma pack ()
> =20
> +//
> +// FUSE-related definitions follow.
> +//
> +// From virtio-v1.1-cs01-87fa6b5d8155, 5.11 File System Device: "[...] T=
he
> +// driver acts as the FUSE client mounting the file system. The virtio f=
ile
> +// system device provides the mechanism for transporting FUSE requests [=
...]"
> +//
> +// Unfortunately, the documentation of the FUSE wire protocol is lacking=
. The
> +// Virtio spec (as of this writing) simply defers to
> +// "include/uapi/linux/fuse.h" in the Linux kernel source -- see the ref=
erence
> +// in virtio spec file "introduction.tex", at commit 87fa6b5d8155.
> +//
> +// Of course, "include/uapi/linux/fuse.h" is a moving target (the virtio=
 spec
> +// does not specify a particular FUSE interface version). The OvmfPkg co=
de
> +// targets version 7.31, because that's the lowest version that the QEMU
> +// virtio-fs daemon supports at this time -- see QEMU commit 72c42e2d6551
> +// ("virtiofsd: Trim out compatibility code", 2020-01-23).

Fuse has it's own in built protocol versioning and negotiation, and as I
remember it's the version of the header in the Linux kernel that's the
definitive version.  I think it would have also been safe just to take
the latest released kernel version

Dave

> +// Correspondingly, Linux's "include/uapi/linux/fuse.h" is consulted as =
checked
> +// out at commit (c6ff213fe5b8^) =3D d78092e4937d ("fuse: fix page deref=
erence
> +// after free", 2020-09-18); that is, right before commit c6ff213fe5b8 (=
"fuse:
> +// add submount support to <uapi/linux/fuse.h>", 2020-09-18) introduces =
FUSE
> +// interface version 7.32.
> +//
> +#define VIRTIO_FS_FUSE_MAJOR  7
> +#define VIRTIO_FS_FUSE_MINOR 31
> +
> +#pragma pack (1)
> +//
> +// Request-response headers common to all request types.
> +//
> +typedef struct {
> +  UINT32 Len;
> +  UINT32 Opcode;
> +  UINT64 Unique;
> +  UINT64 NodeId;
> +  UINT32 Uid;
> +  UINT32 Gid;
> +  UINT32 Pid;
> +  UINT32 Padding;
> +} VIRTIO_FS_FUSE_REQUEST;
> +
> +typedef struct {
> +  UINT32 Len;
> +  INT32  Error;
> +  UINT64 Unique;
> +} VIRTIO_FS_FUSE_RESPONSE;
> +#pragma pack ()
> +
>  #endif // VIRTIO_FS_H_
> diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/Virt=
ioFsDxe.h
> index 12acbd6dc359..f7eae9a4b71a 100644
> --- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
> +++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
> @@ -39,16 +39,17 @@ typedef struct {
>    //                              field         init function       init=
 depth
>    //                              -----------   ------------------  ----=
------
>    UINT64                          Signature; // DriverBindingStart  0
>    VIRTIO_DEVICE_PROTOCOL          *Virtio;   // DriverBindingStart  0
>    VIRTIO_FS_LABEL                 Label;     // VirtioFsInit        1
>    UINT16                          QueueSize; // VirtioFsInit        1
>    VRING                           Ring;      // VirtioRingInit      2
>    VOID                            *RingMap;  // VirtioRingMap       2
> +  UINT64                          RequestId; // DriverBindingStart  0
>    EFI_EVENT                       ExitBoot;  // DriverBindingStart  0
>    EFI_SIMPLE_FILE_SYSTEM_PROTOCOL SimpleFs;  // DriverBindingStart  0
>  } VIRTIO_FS;
> =20
>  #define VIRTIO_FS_FROM_SIMPLE_FS(SimpleFsReference) \
>    CR (SimpleFsReference, VIRTIO_FS, SimpleFs, VIRTIO_FS_SIG);
> =20
>  //
> @@ -127,16 +128,32 @@ VirtioFsSgListsValidate (
> =20
>  EFI_STATUS
>  VirtioFsSgListsSubmit (
>    IN OUT VIRTIO_FS                     *VirtioFs,
>    IN OUT VIRTIO_FS_SCATTER_GATHER_LIST *RequestSgList,
>    IN OUT VIRTIO_FS_SCATTER_GATHER_LIST *ResponseSgList OPTIONAL
>    );
> =20
> +EFI_STATUS
> +VirtioFsFuseNewRequest (
> +  IN OUT VIRTIO_FS              *VirtioFs,
> +     OUT VIRTIO_FS_FUSE_REQUEST *Request,
> +  IN     UINT32                 RequestSize,
> +  IN     UINT32                 Opcode,
> +  IN     UINT64                 NodeId
> +  );
> +
> +EFI_STATUS
> +VirtioFsFuseCheckResponse (
> +  IN  VIRTIO_FS_SCATTER_GATHER_LIST *ResponseSgList,
> +  IN  UINT64                        RequestId,
> +  OUT UINTN                         *TailBufferFill
> +  );
> +
>  //
>  // EFI_SIMPLE_FILE_SYSTEM_PROTOCOL member functions for the Virtio Files=
ystem
>  // driver.
>  //
> =20
>  EFI_STATUS
>  EFIAPI
>  VirtioFsOpenVolume (
> diff --git a/OvmfPkg/VirtioFsDxe/DriverBinding.c b/OvmfPkg/VirtioFsDxe/Dr=
iverBinding.c
> index b888158a805d..4a2787a50a6e 100644
> --- a/OvmfPkg/VirtioFsDxe/DriverBinding.c
> +++ b/OvmfPkg/VirtioFsDxe/DriverBinding.c
> @@ -79,16 +79,21 @@ VirtioFsBindingStart (
>      goto FreeVirtioFs;
>    }
> =20
>    Status =3D VirtioFsInit (VirtioFs);
>    if (EFI_ERROR (Status)) {
>      goto CloseVirtio;
>    }
> =20
> +  //
> +  // Initialize the FUSE request counter.
> +  //
> +  VirtioFs->RequestId =3D 1;
> +
>    Status =3D gBS->CreateEvent (EVT_SIGNAL_EXIT_BOOT_SERVICES, TPL_CALLBA=
CK,
>                    VirtioFsExitBoot, VirtioFs, &VirtioFs->ExitBoot);
>    if (EFI_ERROR (Status)) {
>      goto UninitVirtioFs;
>    }
> =20
>    VirtioFs->SimpleFs.Revision   =3D EFI_SIMPLE_FILE_SYSTEM_PROTOCOL_REVI=
SION;
>    VirtioFs->SimpleFs.OpenVolume =3D VirtioFsOpenVolume;
> diff --git a/OvmfPkg/VirtioFsDxe/Helpers.c b/OvmfPkg/VirtioFsDxe/Helpers.c
> index 88264d4b264c..5bd2dc641f6d 100644
> --- a/OvmfPkg/VirtioFsDxe/Helpers.c
> +++ b/OvmfPkg/VirtioFsDxe/Helpers.c
> @@ -693,8 +693,224 @@ VirtioFsSgListsSubmit (
>        if (!EFI_ERROR (Status) && EFI_ERROR (UnmapStatus)) {
>          Status =3D UnmapStatus;
>        }
>      }
>    }
> =20
>    return Status;
>  }
> +
> +/**
> +  Set up the fields of a new VIRTIO_FS_FUSE_REQUEST object.
> +
> +  The function may only be called after VirtioFsInit() returns successfu=
lly and
> +  before VirtioFsUninit() is called.
> +
> +  @param[in,out] VirtioFs The Virtio Filesystem device that the request =
is
> +                          being prepared for. The "VirtioFs->RequestId" =
field
> +                          will be copied into "Request->Unique". On outp=
ut (on
> +                          successful return), "VirtioFs->RequestId" will=
 be
> +                          incremented.
> +
> +  @param[out] Request     The VIRTIO_FS_FUSE_REQUEST object whose fields=
 are to
> +                          be set.
> +
> +  @param[in] RequestSize  The total size of the request, including
> +                          sizeof(VIRTIO_FS_FUSE_REQUEST).
> +
> +  @param[in] Opcode       The VIRTIO_FS_FUSE_OPCODE that identifies the =
command
> +                          to send.
> +
> +  @param[in] NodeId       The inode number of the file that the request =
refers
> +                          to.
> +
> +  @retval EFI_INVALID_PARAMETER  RequestSize is smaller than
> +                                 sizeof(VIRTIO_FS_FUSE_REQUEST).
> +
> +  @retval EFI_OUT_OF_RESOURCES   "VirtioFs->RequestId" is MAX_UINT64, an=
d can
> +                                 be incremented no more.
> +
> +  @retval EFI_SUCCESS            Request has been populated,
> +                                 "VirtioFs->RequestId" has been incremen=
ted.
> +**/
> +EFI_STATUS
> +VirtioFsFuseNewRequest (
> +  IN OUT VIRTIO_FS              *VirtioFs,
> +     OUT VIRTIO_FS_FUSE_REQUEST *Request,
> +  IN     UINT32                 RequestSize,
> +  IN     UINT32                 Opcode,
> +  IN     UINT64                 NodeId
> +  )
> +{
> +  if (RequestSize < sizeof *Request) {
> +    return EFI_INVALID_PARAMETER;
> +  }
> +
> +  if (VirtioFs->RequestId =3D=3D MAX_UINT64) {
> +    return EFI_OUT_OF_RESOURCES;
> +  }
> +
> +  Request->Len     =3D RequestSize;
> +  Request->Opcode  =3D Opcode;
> +  Request->Unique  =3D VirtioFs->RequestId++;
> +  Request->NodeId  =3D NodeId;
> +  Request->Uid     =3D 0;
> +  Request->Gid     =3D 0;
> +  Request->Pid     =3D 1;
> +  Request->Padding =3D 0;
> +
> +  return EFI_SUCCESS;
> +}
> +
> +/**
> +  Check the common FUSE response format.
> +
> +  The first buffer in the response scatter-gather list is assumed a
> +  VIRTIO_FS_FUSE_RESPONSE structure. Subsequent response buffers, if any=
, up to
> +  and excluding the last one, are assumed fixed size. The last response =
buffer
> +  may or may not be fixed size, as specified by the caller.
> +
> +  This function may only be called after VirtioFsSgListsSubmit() returns
> +  successfully.
> +
> +  @param[in] ResponseSgList   The scatter-gather list that describes the
> +                              response part of the exchange -- the buffe=
rs that
> +                              the Virtio Filesystem device filled in dur=
ing the
> +                              virtio transfer.
> +
> +  @param[in] RequestId        The request identifier to which the respon=
se is
> +                              expected to belong.
> +
> +  @param[out] TailBufferFill  If NULL, then the last buffer in ResponseS=
gList
> +                              is considered fixed size. Otherwise, the l=
ast
> +                              buffer is considered variable size, and on
> +                              successful return, TailBufferFill reports =
the
> +                              number of bytes in the last buffer.
> +
> +  @retval EFI_INVALID_PARAMETER  TailBufferFill is not NULL (i.e., the l=
ast
> +                                 buffer is considered variable size), and
> +                                 ResponseSgList->NumVec is 1.
> +
> +  @retval EFI_INVALID_PARAMETER  The allocated size of the first buffer =
does
> +                                 not match sizeof(VIRTIO_FS_FUSE_RESPONS=
E).
> +
> +  @retval EFI_PROTOCOL_ERROR     The VIRTIO_FS_FUSE_RESPONSE structure i=
n the
> +                                 first buffer has not been fully populat=
ed.
> +
> +  @retval EFI_PROTOCOL_ERROR     "VIRTIO_FS_FUSE_RESPONSE.Len" in the fi=
rst
> +                                 buffer does not equal the sum of the
> +                                 individual buffer sizes (as populated).
> +
> +  @retval EFI_PROTOCOL_ERROR     "VIRTIO_FS_FUSE_RESPONSE.Unique" in the=
 first
> +                                 buffer does not equal RequestId.
> +
> +  @retval EFI_PROTOCOL_ERROR     "VIRTIO_FS_FUSE_RESPONSE.Error" in the =
first
> +                                 buffer is zero, but a subsequent fixed =
size
> +                                 buffer has not been fully populated.
> +
> +  @retval EFI_DEVICE_ERROR       "VIRTIO_FS_FUSE_RESPONSE.Error" in the =
first
> +                                 buffer is nonzero. The caller may inves=
tigate
> +                                 "VIRTIO_FS_FUSE_RESPONSE.Error". Note t=
hat the
> +                                 completeness of the subsequent fixed si=
ze
> +                                 buffers is not verified in this case.
> +
> +  @retval EFI_SUCCESS            Verification successful.
> +**/
> +EFI_STATUS
> +VirtioFsFuseCheckResponse (
> +  IN  VIRTIO_FS_SCATTER_GATHER_LIST *ResponseSgList,
> +  IN  UINT64                        RequestId,
> +  OUT UINTN                         *TailBufferFill
> +  )
> +{
> +  UINTN                   NumFixedSizeVec;
> +  VIRTIO_FS_FUSE_RESPONSE *CommonResp;
> +  UINT32                  TotalTransferred;
> +  UINTN                   Idx;
> +
> +  //
> +  // Ensured by VirtioFsSgListsValidate().
> +  //
> +  ASSERT (ResponseSgList->NumVec > 0);
> +
> +  if (TailBufferFill =3D=3D NULL) {
> +    //
> +    // All buffers are considered fixed size.
> +    //
> +    NumFixedSizeVec =3D ResponseSgList->NumVec;
> +  } else {
> +    //
> +    // If the last buffer is variable size, then we need that buffer to =
be
> +    // different from the first buffer, which is considered a
> +    // VIRTIO_FS_FUSE_RESPONSE (fixed size) structure.
> +    //
> +    if (ResponseSgList->NumVec =3D=3D 1) {
> +      return EFI_INVALID_PARAMETER;
> +    }
> +    NumFixedSizeVec =3D ResponseSgList->NumVec - 1;
> +  }
> +
> +  //
> +  // The first buffer is supposed to carry a (fully populated)
> +  // VIRTIO_FS_FUSE_RESPONSE structure.
> +  //
> +  if (ResponseSgList->IoVec[0].Size !=3D sizeof *CommonResp) {
> +    return EFI_INVALID_PARAMETER;
> +  }
> +  if (ResponseSgList->IoVec[0].Transferred !=3D ResponseSgList->IoVec[0]=
.Size) {
> +    return EFI_PROTOCOL_ERROR;
> +  }
> +
> +  //
> +  // FUSE must report the same number of bytes, written by the Virtio
> +  // Filesystem device, as the virtio transport does.
> +  //
> +  CommonResp =3D ResponseSgList->IoVec[0].Buffer;
> +  TotalTransferred =3D 0;
> +  for (Idx =3D 0; Idx < ResponseSgList->NumVec; Idx++) {
> +    //
> +    // Integer overflow and truncation are not possible, based on
> +    // VirtioFsSgListsValidate() and VirtioFsSgListsSubmit().
> +    //
> +    TotalTransferred +=3D (UINT32)ResponseSgList->IoVec[Idx].Transferred;
> +  }
> +  if (CommonResp->Len !=3D TotalTransferred) {
> +    return EFI_PROTOCOL_ERROR;
> +  }
> +
> +  //
> +  // Enforce that FUSE match our request ID in the response.
> +  //
> +  if (CommonResp->Unique !=3D RequestId) {
> +    return EFI_PROTOCOL_ERROR;
> +  }
> +
> +  //
> +  // If there is an explicit error report, skip checking the transfer
> +  // counts for the rest of the fixed size buffers.
> +  //
> +  if (CommonResp->Error !=3D 0) {
> +    return EFI_DEVICE_ERROR;
> +  }
> +
> +  //
> +  // There was no error reported, so we require that the Virtio Filesyst=
em
> +  // device populate all fixed size buffers. We checked this for the ver=
y first
> +  // buffer above; let's check the rest (if any).
> +  //
> +  ASSERT (NumFixedSizeVec >=3D 1);
> +  for (Idx =3D 1; Idx < NumFixedSizeVec; Idx++) {
> +    if (ResponseSgList->IoVec[Idx].Transferred !=3D
> +        ResponseSgList->IoVec[Idx].Size) {
> +      return EFI_PROTOCOL_ERROR;
> +    }
> +  }
> +
> +  //
> +  // If the last buffer is considered variable size, report its filled s=
ize.
> +  //
> +  if (TailBufferFill !=3D NULL) {
> +    *TailBufferFill =3D ResponseSgList->IoVec[NumFixedSizeVec].Transferr=
ed;
> +  }
> +
> +  return EFI_SUCCESS;
> +}
> --=20
> 2.19.1.3.g30247aa5d201
>=20
>=20
>=20
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--=20
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

