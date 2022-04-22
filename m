Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1650615162; x=1650701562; bh=an8X8qcH4Bgp8i6sJbUIB
 CNNbYWD8zbjbO1zjORVPXs=; b=RBcz5mY7ypuF0Z0lP+qIBrrpt2ZpNWPyFQly4
 Nordr1CBNhzCH/NS5kWxLPbSphsXvrQYbVSVezQ3YnawrevNfgOoUtFq0K8R+nm7
 PLpfQ/pShAUq/bOPUEfspd52z/HGza25gG3QZkZAE9L6v0NKjZCgpKUMTk90fhP8
 8g7ICGdpodvfL5MPCu0B/d4gOJ9kSIqq7gKOuzJ6zSNWQ/8fpBwGCzh9jGf/uTio
 G0tMnrmFF1a2aRy8mk2+J86cSVwSc1bkTj1pJSItupBqKxmOYaZv35NNcnIOzzQ+
 /310ToG4RFGNy/cksEFvTAQ2ybPgUQSddiXdHCF7ZXLPIkTkg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm1; t=1650615162; x=1650701562; bh=a
 n8X8qcH4Bgp8i6sJbUIBCNNbYWD8zbjbO1zjORVPXs=; b=UtSGOlxqUe2i6zW2p
 a6PqiZxWwQCohQOL27n7YSMRwIaD7pCLeTXnUEnpADbKPRN/um9ArLyqe+DywaTg
 r4PB9c56xWFqk7BHlPC7A5ej8vZFsbxyNtqYLxhXfA8MsPguWabCQ2C06pnlZiCw
 rUbkLy0JoERUogAJMxmqaIse7WAJ1YcRU5Xsg3jEJR/4X9v2YI5JwR0CmA8cVLB0
 q4vVxLA9A9A/KGLyfJy2QdEBkKeTriYCacUqd2KzkgnUofiPAkjG7n3Gskk8FtJF
 rprhJutalAyiMqIAZc8WM8j5wFXBFw9+lWcMc2rDwPC8XDRek9+kBDa+3CTqdSGN
 a3pFQ==
From: virtiofs-bot@sinrega.org
Message-Id: <64139.122042204124300249@us-mta-103.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Fri, 22 Apr 2022 08:12:46 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: Daemon failure
 (MappingPastEof error)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Seeing `Waiting for daemon failed: HandleRequest(ReqHandlerError(Custom { kind: Other, error: MappingPastEof }))` in my `/var/log/libvirt/qemu/windose-fs0-virtiofsd.log` file.

Here's the relevant libvirt XML for my filesystem device and memory backing:
```xml
<domain xmlns:qemu="http://libvirt.org/schemas/domain/qemu/1.0" type="kvm">
  ...
  <memoryBacking>
    <source type='memfd'/>
    <access mode='shared'/>
  </memoryBacking>
  ...
  <devices>
    ...
    <filesystem type="mount" accessmode="passthrough">
      <driver type="virtiofs"/>
      <binary path="/run/current-system/sw/bin/virtiofsd" xattr="on">
        <cache mode="always"/>
      </binary>
      <source dir="/test"/>
      <target dir="test-1"/>
      <alias name="fs0"/>
      <address type="pci" domain="0x0000" bus="0x04" slot="0x00" function="0x0"/>
    </filesystem>
    ...
  </devices>
</domain>
```

### Host Software Info:

- **OS**: NixOS Unstable (kernel `5.17.1`)
- **QEMU**: `6.2.0`
- **virtiofsd backend**: `1.1.0`

### Guest Software Info:

- **OS**: Microsoft Windows 10 Pro for Workstations `10.0.19044 Build 19044`
- **VirtIO Windows Driver Installer**: `0.1.217`
- **WinFsp**: 2022 `1.10.22006`
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/46

