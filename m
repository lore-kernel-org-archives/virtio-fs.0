From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:44 +0100
Message-Id: <20201216211125.19496-8-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 07/48] OvmfPkg/VirtioFsDxe: map "errno"
	values to EFI_STATUS
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: devel@edk2.groups.io, virtio-fs@redhat.com, lersek@redhat.com
Cc: Jordan Justen <jordan.l.justen@intel.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>, Ard Biesheuvel <ard.biesheuvel@arm.com>

The VirtioFsFuseCheckResponse() function dedicates the EFI_DEVICE_ERROR
status code to the case when the Virtio Filesystem device explicitly
returns an error via the "VIRTIO_FS_FUSE_RESPONSE.Error" field.

Said field effectively carries a Linux "errno" value. Introduce a helper
function for mapping "errno" values to (hopefully) reasonable EFI_STATUS
codes. This way we'll be able to propagate "errno" values as EFI_STATUS
return codes along the UEFI call stack -- in some detail anyway.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h |   5 +
 OvmfPkg/VirtioFsDxe/Helpers.c     | 200 ++++++++++++++++++++
 2 files changed, 205 insertions(+)

diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index f7eae9a4b71a..772ab743cc8e 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -144,16 +144,21 @@ VirtioFsFuseNewRequest (
 
 EFI_STATUS
 VirtioFsFuseCheckResponse (
   IN  VIRTIO_FS_SCATTER_GATHER_LIST *ResponseSgList,
   IN  UINT64                        RequestId,
   OUT UINTN                         *TailBufferFill
   );
 
+EFI_STATUS
+VirtioFsErrnoToEfiStatus (
+  IN INT32 Errno
+  );
+
 //
 // EFI_SIMPLE_FILE_SYSTEM_PROTOCOL member functions for the Virtio Filesystem
 // driver.
 //
 
 EFI_STATUS
 EFIAPI
 VirtioFsOpenVolume (
diff --git a/OvmfPkg/VirtioFsDxe/Helpers.c b/OvmfPkg/VirtioFsDxe/Helpers.c
index 5bd2dc641f6d..334fa6c7dd26 100644
--- a/OvmfPkg/VirtioFsDxe/Helpers.c
+++ b/OvmfPkg/VirtioFsDxe/Helpers.c
@@ -909,8 +909,208 @@ VirtioFsFuseCheckResponse (
   // If the last buffer is considered variable size, report its filled size.
   //
   if (TailBufferFill != NULL) {
     *TailBufferFill = ResponseSgList->IoVec[NumFixedSizeVec].Transferred;
   }
 
   return EFI_SUCCESS;
 }
+
+/**
+  An ad-hoc function for mapping FUSE (well, Linux) "errno" values to
+  EFI_STATUS.
+
+  @param[in] Errno  The "VIRTIO_FS_FUSE_RESPONSE.Error" value, returned by the
+                    Virtio Filesystem device. The value is expected to be
+                    negative.
+
+  @return                   An EFI_STATUS error code that's deemed a passable
+                            mapping for the Errno value.
+
+  @retval EFI_DEVICE_ERROR  Fallback EFI_STATUS code for unrecognized Errno
+                            values.
+**/
+EFI_STATUS
+VirtioFsErrnoToEfiStatus (
+  IN INT32 Errno
+  )
+{
+  switch (Errno) {
+  case   -1: // EPERM               Operation not permitted
+    return EFI_SECURITY_VIOLATION;
+
+  case   -2: // ENOENT              No such file or directory
+  case   -3: // ESRCH               No such process
+  case   -6: // ENXIO               No such device or address
+  case  -10: // ECHILD              No child processes
+  case  -19: // ENODEV              No such device
+  case  -49: // EUNATCH             Protocol driver not attached
+  case  -65: // ENOPKG              Package not installed
+  case  -79: // ELIBACC             Can not access a needed shared library
+  case -126: // ENOKEY              Required key not available
+    return EFI_NOT_FOUND;
+
+  case   -4: // EINTR               Interrupted system call
+  case  -11: // EAGAIN, EWOULDBLOCK Resource temporarily unavailable
+  case  -16: // EBUSY               Device or resource busy
+  case  -26: // ETXTBSY             Text file busy
+  case  -35: // EDEADLK, EDEADLOCK  Resource deadlock avoided
+  case  -39: // ENOTEMPTY           Directory not empty
+  case  -42: // ENOMSG              No message of desired type
+  case  -61: // ENODATA             No data available
+  case  -85: // ERESTART            Interrupted system call should be restarted
+    return EFI_NOT_READY;
+
+  case   -5: // EIO                 Input/output error
+  case  -45: // EL2NSYNC            Level 2 not synchronized
+  case  -46: // EL3HLT              Level 3 halted
+  case  -47: // EL3RST              Level 3 reset
+  case  -51: // EL2HLT              Level 2 halted
+  case -121: // EREMOTEIO           Remote I/O error
+  case -133: // EHWPOISON           Memory page has hardware error
+    return EFI_DEVICE_ERROR;
+
+  case   -7: // E2BIG               Argument list too long
+  case  -36: // ENAMETOOLONG        File name too long
+  case  -90: // EMSGSIZE            Message too long
+    return EFI_BAD_BUFFER_SIZE;
+
+  case   -8: // ENOEXEC             Exec format error
+  case  -15: // ENOTBLK             Block device required
+  case  -18: // EXDEV               Invalid cross-device link
+  case  -20: // ENOTDIR             Not a directory
+  case  -21: // EISDIR              Is a directory
+  case  -25: // ENOTTY              Inappropriate ioctl for device
+  case  -27: // EFBIG               File too large
+  case  -29: // ESPIPE              Illegal seek
+  case  -38: // ENOSYS              Function not implemented
+  case  -59: // EBFONT              Bad font file format
+  case  -60: // ENOSTR              Device not a stream
+  case  -83: // ELIBEXEC            Cannot exec a shared library directly
+  case  -88: // ENOTSOCK            Socket operation on non-socket
+  case  -91: // EPROTOTYPE          Protocol wrong type for socket
+  case  -92: // ENOPROTOOPT         Protocol not available
+  case  -93: // EPROTONOSUPPORT     Protocol not supported
+  case  -94: // ESOCKTNOSUPPORT     Socket type not supported
+  case  -95: // ENOTSUP, EOPNOTSUPP Operation not supported
+  case  -96: // EPFNOSUPPORT        Protocol family not supported
+  case  -97: // EAFNOSUPPORT        Address family not supported by protocol
+  case  -99: // EADDRNOTAVAIL       Cannot assign requested address
+  case -118: // ENOTNAM             Not a XENIX named type file
+  case -120: // EISNAM              Is a named type file
+  case -124: // EMEDIUMTYPE         Wrong medium type
+    return EFI_UNSUPPORTED;
+
+  case   -9: // EBADF               Bad file descriptor
+  case  -14: // EFAULT              Bad address
+  case  -44: // ECHRNG              Channel number out of range
+  case  -48: // ELNRNG              Link number out of range
+  case  -53: // EBADR               Invalid request descriptor
+  case  -56: // EBADRQC             Invalid request code
+  case  -57: // EBADSLT             Invalid slot
+  case  -76: // ENOTUNIQ            Name not unique on network
+  case  -84: // EILSEQ        Invalid or incomplete multibyte or wide character
+    return EFI_NO_MAPPING;
+
+  case  -12: // ENOMEM              Cannot allocate memory
+  case  -23: // ENFILE              Too many open files in system
+  case  -24: // EMFILE              Too many open files
+  case  -31: // EMLINK              Too many links
+  case  -37: // ENOLCK              No locks available
+  case  -40: // ELOOP               Too many levels of symbolic links
+  case  -50: // ENOCSI              No CSI structure available
+  case  -55: // ENOANO              No anode
+  case  -63: // ENOSR               Out of streams resources
+  case  -82: // ELIBMAX         Attempting to link in too many shared libraries
+  case  -87: // EUSERS              Too many users
+  case -105: // ENOBUFS             No buffer space available
+  case -109: // ETOOMANYREFS        Too many references: cannot splice
+  case -119: // ENAVAIL             No XENIX semaphores available
+  case -122: // EDQUOT              Disk quota exceeded
+    return EFI_OUT_OF_RESOURCES;
+
+  case  -13: // EACCES              Permission denied
+    return EFI_ACCESS_DENIED;
+
+  case  -17: // EEXIST              File exists
+  case  -98: // EADDRINUSE          Address already in use
+  case -106: // EISCONN             Transport endpoint is already connected
+  case -114: // EALREADY            Operation already in progress
+  case -115: // EINPROGRESS         Operation now in progress
+    return EFI_ALREADY_STARTED;
+
+  case  -22: // EINVAL              Invalid argument
+  case  -33: // EDOM                Numerical argument out of domain
+    return EFI_INVALID_PARAMETER;
+
+  case  -28: // ENOSPC              No space left on device
+  case  -54: // EXFULL              Exchange full
+    return EFI_VOLUME_FULL;
+
+  case  -30: // EROFS               Read-only file system
+    return EFI_WRITE_PROTECTED;
+
+  case  -32: // EPIPE               Broken pipe
+  case  -43: // EIDRM               Identifier removed
+  case  -67: // ENOLINK             Link has been severed
+  case  -68: // EADV                Advertise error
+  case  -69: // ESRMNT              Srmount error
+  case  -70: // ECOMM               Communication error on send
+  case  -73: // EDOTDOT             RFS specific error
+  case  -78: // EREMCHG             Remote address changed
+  case  -86: // ESTRPIPE            Streams pipe error
+  case -102: // ENETRESET           Network dropped connection on reset
+  case -103: // ECONNABORTED        Software caused connection abort
+  case -104: // ECONNRESET          Connection reset by peer
+  case -116: // ESTALE              Stale file handle
+  case -125: // ECANCELED           Operation canceled
+  case -128: // EKEYREVOKED         Key has been revoked
+  case -129: // EKEYREJECTED        Key was rejected by service
+  case -130: // EOWNERDEAD          Owner died
+  case -131: // ENOTRECOVERABLE     State not recoverable
+    return EFI_ABORTED;
+
+  case  -34: // ERANGE              Numerical result out of range
+  case  -75: // EOVERFLOW           Value too large for defined data type
+    return EFI_BUFFER_TOO_SMALL;
+
+  case  -52: // EBADE               Invalid exchange
+  case -108: // ESHUTDOWN         Cannot send after transport endpoint shutdown
+  case -111: // ECONNREFUSED        Connection refused
+    return EFI_END_OF_FILE;
+
+  case  -62: // ETIME               Timer expired
+  case -110: // ETIMEDOUT           Connection timed out
+  case -127: // EKEYEXPIRED         Key has expired
+    return EFI_TIMEOUT;
+
+  case  -64: // ENONET              Machine is not on the network
+  case  -66: // EREMOTE             Object is remote
+  case  -72: // EMULTIHOP           Multihop attempted
+  case -100: // ENETDOWN            Network is down
+  case -101: // ENETUNREACH         Network is unreachable
+  case -112: // EHOSTDOWN           Host is down
+  case -113: // EHOSTUNREACH        No route to host
+  case -123: // ENOMEDIUM           No medium found
+  case -132: // ERFKILL             Operation not possible due to RF-kill
+    return EFI_NO_MEDIA;
+
+  case  -71: // EPROTO              Protocol error
+    return EFI_PROTOCOL_ERROR;
+
+  case  -74: // EBADMSG             Bad message
+  case  -77: // EBADFD              File descriptor in bad state
+  case  -80: // ELIBBAD             Accessing a corrupted shared library
+  case  -81: // ELIBSCN             .lib section in a.out corrupted
+  case -117: // EUCLEAN             Structure needs cleaning
+    return EFI_VOLUME_CORRUPTED;
+
+  case  -89: // EDESTADDRREQ        Destination address required
+  case -107: // ENOTCONN            Transport endpoint is not connected
+    return EFI_NOT_STARTED;
+
+  default:
+    break;
+  }
+
+  return EFI_DEVICE_ERROR;
+}
-- 
2.19.1.3.g30247aa5d201



