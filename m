Return-Path: <raphael.norwitz@nutanix.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=guvbPAYZCs61kZX2vxLUlVRex5pKBf0j+O8qSGKXQh8=;
 b=x7veiidBrwZBiA+ddFgismY44RAKrnSLumzfNW3hn7MFFtfrKKa441zoy3MZ3B1Ine+0
 opWeQqsE9HvZGlPUVI4g2QNjZA9bmsVG0okeJy78yzY8Sd/Ra+jqbVYlKGEPB+MJnC/0
 L74D+kD91v64RhpWENjZGQEbOj6RkdrcNCY1bFr7vdSxxBO6d15MDgKcwM63ciS48gJY
 dTAI41dgY4TKWl5Z5FJqd0NSJ3X4s28m26t59xI0yv/Y8+Q7E/1o0xhixAttRCkC3CJa
 lK1h63vTMlA/5SgHICmBp4sHtXkgHht4SJeG8lYW4X6PbgS7V8Fd8rac5IPpnqWkxIpO kw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=guvbPAYZCs61kZX2vxLUlVRex5pKBf0j+O8qSGKXQh8=;
 b=D5y4bCz+ejODC6yk0VCGsJp9/WCNRu5DiJCi64CDBv6LiVFkaIVipceLKBNWXS8qnxoDiGCgw3AJ3CY4/uIbFbBIaHf6PPgOtI7D3BycPqSTVICXpQlpDVKGLWAZB3hjjIB3ng5tPDXQfybwWpPUVgD6mDsvHwaHJFPmtvETLBigp0clyo4V4iwzDlld4wpskBK/8FF6/oN7wI5FxAQhYLZ0CV1Tc4FzLIVRxMD3FukGSiuUlwVkptvwLCoz/bN7NHkyuTGNjkEbixD01IaiX+0dt8cVew4yT3uaTBZ3ChOCaoL0lY8gSfTcRd4WNxIsfd9SRxAd5dOmWGaHhsptJg==
From: Raphael Norwitz <raphael.norwitz@nutanix.com>
Date: Thu, 24 Nov 2022 13:50:04 +0000
Message-ID: <2254ACCA-BD15-4091-B5A9-226D55E6A93D@nutanix.com>
References: <20221123131630.52020-1-sgarzare@redhat.com>
 <4A976F8D-AB6F-4BAD-AD5A-ABF69B8A040C@nutanix.com>
 <20221124014951-mutt-send-email-mst@kernel.org>
 <20221124075452.y2slphvuwbjsst36@sgarzare-redhat>
In-Reply-To: <20221124075452.y2slphvuwbjsst36@sgarzare-redhat>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <F2BDD7832E58CC4AB88FD2E058D9AF76@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH for-7.2] vhost: enable vrings in
 vhost_dev_start() for vhost-user devices
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Kevin Wolf <kwolf@redhat.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Fam Zheng <fam@euphon.net>, Viresh Kumar <viresh.kumar@linaro.org>, German Maglione <gmaglione@redhat.com>, =?iso-8859-1?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, Jason Wang <jasowang@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "qemu-block@nongnu.org" <qemu-block@nongnu.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>



> On Nov 24, 2022, at 2:54 AM, Stefano Garzarella <sgarzare@redhat.com> wro=
te:
>=20
> On Thu, Nov 24, 2022 at 01:50:19AM -0500, Michael S. Tsirkin wrote:
>> On Thu, Nov 24, 2022 at 12:19:25AM +0000, Raphael Norwitz wrote:
>>>=20
>>> > On Nov 23, 2022, at 8:16 AM, Stefano Garzarella <sgarzare@redhat.com>=
 wrote:
>>> >
>>> > Commit 02b61f38d3 ("hw/virtio: incorporate backend features in featur=
es")
>>> > properly negotiates VHOST_USER_F_PROTOCOL_FEATURES with the vhost-use=
r
>>> > backend, but we forgot to enable vrings as specified in
>>> > docs/interop/vhost-user.rst:
>>> >
>>> >    If ``VHOST_USER_F_PROTOCOL_FEATURES`` has not been negotiated, the
>>> >    ring starts directly in the enabled state.
>>> >
>>> >    If ``VHOST_USER_F_PROTOCOL_FEATURES`` has been negotiated, the rin=
g is
>>> >    initialized in a disabled state and is enabled by
>>> >    ``VHOST_USER_SET_VRING_ENABLE`` with parameter 1.
>>> >
>>> > Some vhost-user front-ends already did this by calling
>>> > vhost_ops.vhost_set_vring_enable() directly:
>>> > - backends/cryptodev-vhost.c
>>> > - hw/net/virtio-net.c
>>> > - hw/virtio/vhost-user-gpio.c
>>>=20
>>> To simplify why not rather change these devices to use the new semantic=
s?
>=20
> Maybe the only one I wouldn't be scared of is vhost-user-gpio, but for ex=
ample vhost-net would require a lot of changes, maybe better after the rele=
ase.
>=20
> For example, we could do like vhost-vdpa and call SET_VRING_ENABLE in the=
 VhostOps.vhost_dev_start callback of vhost-user.c, but I think it's too ri=
sky to do that now.
>=20
>>=20
>> Granted this is already scary enough for this release.
>=20
> Yeah, I tried to touch as little as possible but I'm scared too, I just h=
aven't found a better solution for now :-(
>=20

Sure - no need to force a more disruptive change in right before the releas=
e. If anything can be simplified later.

>>=20
>>> >
>>> > But most didn't do that, so we would leave the vrings disabled and so=
me
>>> > backends would not work. We observed this issue with the rust version=
 of
>>> > virtiofsd [1], which uses the event loop [2] provided by the
>>> > vhost-user-backend crate where requests are not processed if vring is
>>> > not enabled.
>>> >
>>> > Let's fix this issue by enabling the vrings in vhost_dev_start() for
>>> > vhost-user front-ends that don't already do this directly. Same thing
>>> > also in vhost_dev_stop() where we disable vrings.
>>> >
>>> > [1] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__gitlab.com=
_virtio-2Dfs_virtiofsd&d=3DDwIBAg&c=3Ds883GpUCOChKOHiocYtGcg&r=3DIn4gmR1pGz=
KB8G5p6LUrWqkSMec2L5EtXZow_FZNJZk&m=3DPcC4TEq5C80Knek-ScCNI26rQ13h0n3QEMNNh=
c-ENd7Txd8wHYqwC1TYfXW_hYor&s=3D5pdxt8m4-ks8VB2tRSXQV05kdfdP50iy-aAxuGe-Ffc=
&e=3D > [2] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__github.c=
om_rust-2Dvmm_vhost_blob_240fc2966_crates_vhost-2Duser-2Dbackend_src_event-=
5Floop.rs-23L217&d=3DDwIBAg&c=3Ds883GpUCOChKOHiocYtGcg&r=3DIn4gmR1pGzKB8G5p=
6LUrWqkSMec2L5EtXZow_FZNJZk&m=3DPcC4TEq5C80Knek-ScCNI26rQ13h0n3QEMNNhc-ENd7=
Txd8wHYqwC1TYfXW_hYor&s=3D-3NUG1pPKN-FwUeDkuu52roXoPoeLR1y4gjrddHUz2U&e=3D =
> Fixes: 02b61f38d3 ("hw/virtio: incorporate backend features in features")
>>> > Reported-by: German Maglione <gmaglione@redhat.com>
>>> > Tested-by: German Maglione <gmaglione@redhat.com>
>>> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>>=20
>>> Looks good for vhost-user-blk/vhost-user-scsi.
>>>=20
>>> Acked-by: Raphael Norwitz <raphael.norwitz@nutanix.com>
>=20
> Thanks for the review!
> Stefano

