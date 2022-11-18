Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1668793841; x=1668880241; bh=EoS2cYXGbtlribPg4+8AK
 wtIUISSm8XYroMxGFEHbno=; b=Mwc1Z9VHEZSzzlEbVUVOkT7STlrdAU6JsQjdC
 gPE+HuG4rmATB9wxeOMzzlRsWKiroy43LuGITiNLHqJ7Nl4ewUhC/dOhifvIJG5Q
 7lE8co88w2YmNtD++4B3aochen9QvZAYKqnsZKbEkhnED9ihYC74WQCtqtznGEc6
 GyhOuNl+KK5jIB+pfCU1jN5sbA7nud/9tETRxu00AjW53/3FGrKFEfBnvyjuYt2h
 +9d33QYcQK+jb1MHJZTck7LEcm9/pZyOe0N0nMiHBsONk7BXkfdU+pL+qNrqulQS
 7wXqqtL365qViz5FOmGUOp2vzeAMmOhzqljB8VoTcw+UAnrvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1668793841; x=1668880241; bh=EoS2cYXGbtlribPg4+8AKwtIUISSm8XYroM
 xGFEHbno=; b=sdnWlD8e8vant/oEQDtUblko2LP+2APIjxBOKqS+s9jhtQ3o+X3
 DWt3beLssox7/SArqe4shPPrbS3x4yJqSR2rvDQO2NvtGn3+8Z6zMvP+cm1Vm/sx
 8D3H7IVdqWm6VV98GsQrURRPZsg8pAw4XHkOwRJDOthPnZO2Wc7FQjmf2Je8poVz
 rmNEoij4T88Vc6Dflet1Rk/7l7+8jfEqYPaPcySYgD6Q1QDq2650CtJChHMCjwDQ
 Elcu18XRuhsGiC4ES21xr3tSxGBWMwsvL3Y0V+5ZFUDVaVtU18hlirSjBvk7gSCa
 gVfXg3olVD16hSpSrLejnu1pX9btuXQBzUw==
From: virtiofs-bot@sinrega.org
Message-Id: <71221.122111812504101075@us-mta-184.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri, 18 Nov 2022 17:50:45 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: passthrough: Set `RWF_APPEND` on
 non-cached writes on append only files
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Writing to a mem mapped area of a file that was open with `O_APPEND`,
will always write at the end of the file. We can test this with running
virtiofsd with --cache=auto|always:
```python
    import mmap
    import struct
    l = 1024
    f = open("./test.db", "a+b")
    f.truncate(l)
    m = mmap.mmap(f.fileno(), 1024, access=mmap.ACCESS_WRITE)
    m[0:4] = b"0000"
    m.flush()
    print(m.size())
    m[0:4] = b"0000"
    m.flush()
    print(m.size())
```
After each write the size of the file is increased.
This is because, even though the guest kernel sends the correct
offsets, the mem mapped writes in the guest translate into `write()`
operations in the host so that if the file was opened/created with
`O_APPEND` the offset is ignored.

For more details see:
https://gitlab.com/virtio-fs/virtiofsd/-/issues/67
https://github.com/kata-containers/kata-containers/issues/5634

closes #67
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/143

