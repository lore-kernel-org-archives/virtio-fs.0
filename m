Return-Path: <borntraeger@linux.ibm.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UIVQdBfPaD1o1EXblvXBQsMBcOSOdxtd8qEfUxpHWG0=;
 b=qD6XitCvL+eBnQaTOZJQktDepqBgJzQn08GpHrMS1gzNM/dczhOXFx2RG+7Y5dhlQ8Pb
 Mz3yReWI/NhCGJyKTRLik3Urt6duM/xISWyBHOG+Ndo8KDQRKx8Xgh0cgGlerh0UfRiN
 5hKSEMuaQ4Q0kgiBuEPStRPH/LTbC5BNeCB6UQkULn4YxrxSBxXvCvYkD0l1wX6uTOg6
 lRFSW/E+q+GL2KlKb5AkwZmklu15OdYwqu+9idJV4Urdbg3VONytJZmnjUCCUXJ/m6jm
 G0iprFFlWvKcc2ZRQtlfPQmvMNgm90dwivKv28VCEI5ppRDGlB80PgnUKB7dhxsFFvws uA==
Message-ID: <3a002a6a-9135-ad45-3fed-7dd270450d0b@linux.ibm.com>
Date: Fri, 14 Oct 2022 09:30:24 +0200
MIME-Version: 1.0
References: <20221010172813.204597-1-mst@redhat.com>
 <20221010172813.204597-8-mst@redhat.com>
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20221010172813.204597-8-mst@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Subject: [Virtio-fs] Regression save/restore of vsock: (was [PULL 07/55]
 hw/virtio: move vm_running check to virtio_device_started)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, virtio-fs@redhat.com

Am 10.10.22 um 19:29 schrieb Michael S. Tsirkin:
> From: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>=20
> All the boilerplate virtio code does the same thing (or should at
> least) of checking to see if the VM is running before attempting to
> start VirtIO. Push the logic up to the common function to avoid
> getting a copy and paste wrong.
>=20
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> Message-Id: <20220802095010.3330793-11-alex.bennee@linaro.org>
> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

This results in a regression for our s390x CI when doing save/restore of gu=
ests with vsock:


                 #1  0x000003ff9a248580 raise (libc.so.6 + 0x48580)
                 #2  0x000003ff9a22b5c0 abort (libc.so.6 + 0x2b5c0)
                 #3  0x000003ff9a2409da __assert_fail_base (libc.so.6 + 0x4=
09da)
                 #4  0x000003ff9a240a4e __assert_fail (libc.so.6 + 0x40a4e)
                 #5  0x000002aa2d69a066 vhost_vsock_common_pre_save (qemu-s=
ystem-s390x + 0x39a066)
                 #6  0x000002aa2d55570e vmstate_save_state_v (qemu-system-s=
390x + 0x25570e)
                 #7  0x000002aa2d556218 vmstate_save_state (qemu-system-s39=
0x + 0x256218)
                 #8  0x000002aa2d570ba4 qemu_savevm_state_complete_precopy_=
non_iterable (qemu-system-s390x + 0x270ba4)
                 #9  0x000002aa2d5710b6 qemu_savevm_state_complete_precopy =
(qemu-system-s390x + 0x2710b6)
                 #10 0x000002aa2d564d0e migration_completion (qemu-system-s=
390x + 0x264d0e)
                 #11 0x000002aa2d8db25c qemu_thread_start (qemu-system-s390=
x + 0x5db25c)
                 #12 0x000003ff9a296248 start_thread (libc.so.6 + 0x96248)
                 #13 0x000003ff9a31183e thread_start (libc.so.6 + 0x11183e)

