Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1653995578; x=1654081978; bh=f0pYcHPmMY5yE1PDxIeWA
 tuk5pgjiZ3rIPuXdHuFjgE=; b=h+EdimIZItAoSyUAARr0tS0XLkqY4g94Y/zrV
 y0CAloooXKdY/5raggylWTTN62sTV4ScQ0QyEJ2dIqCtEECDHoLGLr0BVzf2Th3u
 5n2/WEJuJ/Sff6Fu/vodYMCtkp/Gh3i7TzVhYgEdXb22S/jW+NNoGpJWJC1Cq5uM
 7dmulAIHrwXLWWkw48thRmApCzr+Gp9GIKBdY+hEDnKoktirvI69EaeQXedF+Efg
 Iu2533cphcglu7+QzXBECrc8xikuRr3yWtQ5biw4hHAGGy8hz8nCY0he+v3gdtT6
 IjzS9NmRf6+V83F2ho65Nu3M53oCQ0imENA2Y/LWblLjVgfvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
 1653995578; x=1654081978; bh=f0pYcHPmMY5yE1PDxIeWAtuk5pgjiZ3rIPu
 XdHuFjgE=; b=gAWAEBE08G9jRGYnlmeZzVCow8T9FIlJ5ZKbaezTZ6LOaVLcL0W
 v9+PMyurZx2Ca/drttC7Vw5c4WD1XRTrxnJ6kjM7WjqocjNBPxT+DAzviNOqJWIK
 gfwuN7nAyCjLp7YKmDfXiRm+kjPTr19H7dS7iHLRe4xxHLlRUWKnjc4+wREwFJpm
 KUMgPptzCVdnLRzErkBVOYgi2uBSxSHkpIZrHOig6RY0TT0/33zziDpi3eAmcT+f
 KQxyUx90FvpVXEWu+C04vxuG3sim0Wzf138+LVakFT0oHMSR4M3YWRLMkRqYp/D9
 hgfdyCqjuJ1S2vXZ128nlCfTbGXlJNyiHBg==
From: virtiofs-bot@sinrega.org
Message-Id: <64214.122053107130000627@us-mta-647.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Tue, 31 May 2022 11:13:03 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue closed: virtiofsd fails to start due
 to AVCs when running under the `container_kvm_t` label (aka,
 with Kata Containers)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Here are the AVCs:
```
time->Mon May 23 16:35:07 2022
type=USER_AVC msg=audit(1653323707.241:18235): pid=816 uid=81 auid=4294967295 ses=4294967295 subj=system_u:system_r:system_dbusd_t:s0-s0:c0.c1023 msg='avc:  received setenforce notice (enforcing=0)  exe=2F7573722F62696E2F646275732D6461656D6F6E202864656C6574656429 sauid=81 hostname=? addr=? terminal=?'
----
time->Mon May 23 16:35:09 2022
type=PROCTITLE msg=audit(1653323709.744:18242): proctitle=2F7573722F6C6962657865632F76697274696F667364002D2D7379736C6F67002D6F0063616368653D6175746F002D6F006E6F5F706F7369785F6C6F636B002D6F00736F757263653D2F72756E2F6B6174612D636F6E7461696E6572732F7368617265642F73616E64626F7865732F6565613263363938656633353431626635
type=PATH msg=audit(1653323709.744:18242): item=1 name=(null) inode=15676422 dev=fc:01 mode=040755 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:tmp_t:s0 nametype=CREATE cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0 cap_frootid=0
type=PATH msg=audit(1653323709.744:18242): item=0 name=(null) inode=8644264 dev=fc:01 mode=040755 ouid=1001 ogid=121 rdev=00:00 obj=system_u:object_r:tmp_t:s0 nametype=PARENT cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0 cap_frootid=0
type=CWD msg=audit(1653323709.744:18242): cwd="/run/containers/storage/overlay-containers/eea2c698ef3541bf593c2d33e51e6137c872ac03eef933f9ca27b772cce11603/userdata"
type=SYSCALL msg=audit(1653323709.744:18242): arch=c000003e syscall=83 success=yes exit=0 a0=7f5859355100 a1=1ff a2=1d a3=fefefefefefefeff items=2 ppid=198568 pid=198572 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="virtiofsd" exe="/opt/kata/libexec/virtiofsd" subj=system_u:system_r:container_kvm_t:s0:c717,c1013 key=(null)
type=AVC msg=audit(1653323709.744:18242): avc:  denied  { create } for  pid=198572 comm="virtiofsd" name="virtiofsd-.kxe6OCukLKKw" scontext=system_u:system_r:container_kvm_t:s0:c717,c1013 tcontext=system_u:object_r:tmp_t:s0 tclass=dir permissive=1
type=AVC msg=audit(1653323709.744:18242): avc:  denied  { add_name } for  pid=198572 comm="virtiofsd" name="virtiofsd-.kxe6OCukLKKw" scontext=system_u:system_r:container_kvm_t:s0:c717,c1013 tcontext=system_u:object_r:tmp_t:s0 tclass=dir permissive=1
type=AVC msg=audit(1653323709.744:18242): avc:  denied  { write } for  pid=198572 comm="virtiofsd" name="tmp" dev="vda1" ino=8644264 scontext=system_u:system_r:container_kvm_t:s0:c717,c1013 tcontext=system_u:object_r:tmp_t:s0 tclass=dir permissive=1
----
time->Mon May 23 16:35:09 2022
type=PROCTITLE msg=audit(1653323709.744:18243): proctitle=2F7573722F6C6962657865632F76697274696F667364002D2D7379736C6F67002D6F0063616368653D6175746F002D6F006E6F5F706F7369785F6C6F636B002D6F00736F757263653D2F72756E2F6B6174612D636F6E7461696E6572732F7368617265642F73616E64626F7865732F6565613263363938656633353431626635
type=PATH msg=audit(1653323709.744:18243): item=0 name="/proc/self/fd" inode=7324340 dev=00:a0 mode=040500 ouid=0 ogid=0 rdev=00:00 obj=system_u:system_r:container_kvm_t:s0:c717,c1013 nametype=NORMAL cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0 cap_frootid=0
type=CWD msg=audit(1653323709.744:18243): cwd="/run/containers/storage/overlay-containers/eea2c698ef3541bf593c2d33e51e6137c872ac03eef933f9ca27b772cce11603/userdata"
type=SYSCALL msg=audit(1653323709.744:18243): arch=c000003e syscall=165 success=yes exit=0 a0=7f5859355660 a1=7f5859355130 a2=0 a3=1000 items=1 ppid=198568 pid=198572 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="virtiofsd" exe="/opt/kata/libexec/virtiofsd" subj=system_u:system_r:container_kvm_t:s0:c717,c1013 key=(null)
type=AVC msg=audit(1653323709.744:18243): avc:  denied  { mounton } for  pid=198572 comm="virtiofsd" path="/tmp/virtiofsd-.kxe6OCukLKKw" dev="vda1" ino=15676422 scontext=system_u:system_r:container_kvm_t:s0:c717,c1013 tcontext=system_u:object_r:tmp_t:s0 tclass=dir permissive=1
----
time->Mon May 23 16:35:09 2022
type=PROCTITLE msg=audit(1653323709.752:18244): proctitle=2F7573722F6C6962657865632F76697274696F667364002D2D7379736C6F67002D6F0063616368653D6175746F002D6F006E6F5F706F7369785F6C6F636B002D6F00736F757263653D2F72756E2F6B6174612D636F6E7461696E6572732F7368617265642F73616E64626F7865732F6565613263363938656633353431626635
type=SYSCALL msg=audit(1653323709.752:18244): arch=c000003e syscall=84 success=yes exit=0 a0=7f5859355130 a1=2 a2=6 a3=0 items=0 ppid=198568 pid=198572 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="virtiofsd" exe="/opt/kata/libexec/virtiofsd" subj=system_u:system_r:container_kvm_t:s0:c717,c1013 key=(null)
type=AVC msg=audit(1653323709.752:18244): avc:  denied  { rmdir } for  pid=198572 comm="virtiofsd" name="virtiofsd-.kxe6OCukLKKw" dev="vda1" ino=15676422 scontext=system_u:system_r:container_kvm_t:s0:c717,c1013 tcontext=system_u:object_r:tmp_t:s0 tclass=dir permissive=1
type=AVC msg=audit(1653323709.752:18244): avc:  denied  { remove_name } for  pid=198572 comm="virtiofsd" name="virtiofsd-.kxe6OCukLKKw" dev="vda1" ino=15676422 scontext=system_u:system_r:container_kvm_t:s0:c717,c1013 tcontext=system_u:object_r:tmp_t:s0 tclass=dir permissive=1
type=AVC msg=audit(1653323709.752:18244): avc:  denied  { write } for  pid=198572 comm="virtiofsd" name="tmp" dev="vda1" ino=8644264 scontext=system_u:system_r:container_kvm_t:s0:c717,c1013 tcontext=system_u:object_r:tmp_t:s0 tclass=dir permissive=1
```

This is most likely coming from: https://gitlab.com/virtio-fs/virtiofsd/-/blob/main/src/sandbox.rs#L199-212

A possible alternative for this would be using `/var/run`, instead, as the `container_kvm_t` label is allowed to perform the actions there: https://github.com/containers/container-selinux/blob/15c20d72b183d86955894e693127e5bc06722a1a/container.te#L1198-L1210
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/49

