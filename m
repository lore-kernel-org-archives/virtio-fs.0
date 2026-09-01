Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C4E331EDD
	for <virtio-fs@lists.linux.dev>; Tue,  1 Sep 2026 21:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788298456; cv=none; b=IZxrQrEhlxI9sCqzOyOSvUQ1NhOKpQaO0aLKAbNDAD1B+Cy9JS3f+OVOXgQcYA4QQKfa0FKyiqZ1aVSbfmb0XdIYDsGaWV5T2W3pNax4SBfDN1syfYVnARXCJ0Hm80TY5Z7A1h4m41TH/DB/nMJN6zpW3AYSml+ciMtcUBsiAoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788298456; c=relaxed/simple;
	bh=Ose34srI3hrAxlZZz+7jEVM8bnJ/tOc2D7m3K6ahiJ0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=AwfwLCvSrhkrBNzzCmiatB7JAZhWotB2F/hnhps9MPtrTQU0n65T7mL1Q/GCUObEfW7mMN8Mpgn7BT5PK0IOMPOHo0i1PQybWz1FoDG2oXm+UCKJLiQlNAcrZVYQemHzVkj/Zerz5CTRtKChSz3DXcSbRlxCp/UmE/7PgwcF/P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--changyuanl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CZ6J5ajH; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--changyuanl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CZ6J5ajH"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d6c166bafcso3283545ad.2
        for <virtio-fs@lists.linux.dev>; Tue, 01 Sep 2026 14:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788298454; x=1788903254; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=snVEO/sl2HX+PIDOygdJc1iuoXl2isJC1BgiDdwU6RM=;
        b=CZ6J5ajHHw+ZjtAuF+OMFXV1pzJvf7GzS4RyI/dBPjJstxD1rQma+CIX3gIg1P9OVD
         WSeFPzoWA5QoTW42LtJybDF+FF15KaveSB8lc8TVlJJMwA1azE1l/uTicHv/ctLXvbN8
         G2kCuPuRBZ51JhxEf0Kfr9lHE1agB4Yua/LqT3QkUSSJLb+s72Exa/w18IbAU1GhOlEs
         dyuc+wSUQ1yqk+tfjP/VbuXz4k8q2KPk/kIYevwF1E3BhzWGQI777z17pX+91OM7d1XL
         w6IO9Gk+YjI73LGsng7Hgp4n3o+HyV0xdJYdLnIqQ/tKZpk+2rzQuUxPqrDD87tnmzGs
         7yeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788298454; x=1788903254;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=snVEO/sl2HX+PIDOygdJc1iuoXl2isJC1BgiDdwU6RM=;
        b=YqApb45uvIdzu96YXL73yokpLcq4jIlqZTSbQWyYVGhtJQREihNssRPtqJZetxrJmm
         kyUPtcWsIvPlgc97JT9YTikc83C6kLWZ/sark9K6NPTuGCAT9TrQpXn/X+Ei5BFCWre2
         85/+xtK5WOiWPaCfMwo3pLBZEwHyWs5bUvYHjJzU0bkw1q9obvhKeJhW3txAihJ5CqPi
         iSGjEfvBlRhRNDj3CAzClPOLDUAAFa7WFwt8Eg/RjULAmggN82/QbMgldMVeNTjUuZf0
         vb+kYvgGhP7Te+PBl+nfgcgl+TETqxC6WrSSCyIFNyEqrWxfpErQVz9fgL7fQXSv/dX3
         Sq3A==
X-Forwarded-Encrypted: i=1; AKwUvBxHmqd6QJrTPpzbTvGrCgESrrDbKUVFqjXE61iYljwg/++jFxBYtc9qO17RlGfFjqClT5+Q8KTf6HQ=@lists.linux.dev
X-Gm-Message-State: AFuF++l0Oc6VzBs1QRyyPX6gc8r0BkCThUpxGfsChN4evAfGGKZ0Vd3/
	rEEv0wse+0NDeoMSo9S6YR69VtSGp8kEDBSNiWLhdn9AATAwCBDsQ2UbDSlRalj1JYESB/ewECx
	0znl5wy6k72ixh4p1MkxM2A==
X-Received: from dycaa14.prod.google.com ([2002:a05:7301:540e:b0:315:877c:f169])
 (user=changyuanl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5110:b0:38e:97f0:aa4b with SMTP id 98e67ed59e1d1-39ae83dc551mr1602194a91.13.1788298453859;
 Tue, 01 Sep 2026 14:34:13 -0700 (PDT)
Date: Tue,  1 Sep 2026 14:34:12 -0700
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260901213412.1763253-1-changyuanl@google.com>
Subject: [RFC] Handling 0-sized pseudo-files (cgroupfs/sysfs/procfs) in
 virtiofs and FUSE
From: Changyuan Lyu <changyuanl@google.com>
To: fuse-devel@lists.linux.dev, virtio-fs@lists.linux.dev
Cc: Miklos Szeredi <miklos@szeredi.hu>, khazhy@google.com, peternewman@google.com, 
	German Maglione <gmaglione@redhat.com>, Hanna Czenczek <hreitz@redhat.com>, posk@google.com
Content-Type: text/plain; charset="UTF-8"

Hi all,

We have been investigating an issue when sharing host pseudo-filesystems
(such as /sys/fs/cgroup, /proc, and /sys) into a guest VM via virtiofs.
For our environment, we would like to provide statistics about the
enclosing host-level container (such as cgroup metrics) to feed into
application decisions in the VM guest, for which we would like to pass
through pseudo-filesystems like /sys/fs/cgroup.

Virtiofs does not support this well today. When guest applications read
dynamic pseudo-files (for example, /sys/fs/cgroup/cgroup.controllers or
cgroup.stat), they frequently receive 0 bytes (EOF), even though the host
file contains live dynamic content.

We would like to discuss our findings and proposed solutions for both
virtiofsd and the guest kernel FUSE client.


1. Problem Analysis
===================

In Linux, kernel pseudo-files (kernfs, cgroupfs, procfs) report
st_mode = S_IFREG and st_size = 0 via stat()/statx() because their
content is generated dynamically on read().

In virtiofsd with the default CachePolicy::Auto mode, open_flags is 0
(FOPEN_DIRECT_IO is not set). Consequently, the guest kernel routes reads
through the page cache:

  fuse_file_read_iter()
    -> fuse_cache_read_iter()
      -> generic_file_read_iter()  (mm/filemap.c)

In generic_file_read_iter(), the kernel checks:
  if (iocb->ki_pos >= i_size_read(inode))
      return 0;

Because inode->i_size is 0, generic_file_read_iter() immediately returns
0 bytes (EOF) from guest RAM without ever issuing a FUSE_READ request to
virtiofsd.


2. Host Daemon (virtiofsd) Solution
===================================

To prevent generic_file_read_iter() from truncating reads at i_size == 0,
the guest must open the file with FOPEN_DIRECT_IO so that reads go through
fuse_direct_read_iter() and dispatch FUSE_READ to virtiofsd.

However, setting FOPEN_DIRECT_IO unconditionally on all 0-sized files is
problematic because regular empty files (e.g. touch empty.txt) grown
while open via ftruncate() may encounter mmap(MAP_SHARED) limitations on
older kernels without FUSE_DIRECT_IO_ALLOW_MMAP.

In virtiofsd [1], we implemented an automatic detection in
do_open() and create():
When a regular file has st_size == 0, virtiofsd inspects the underlying
host filesystem type using fstatfs64(). If the file resides on a known
pseudo-filesystem (e.g. CGROUP2_SUPER_MAGIC, CGROUP_SUPER_MAGIC,
PROC_SUPER_MAGIC, SYSFS_MAGIC, TRACEFS_MAGIC, DEBUGFS_MAGIC,
SECURITYFS_MAGIC, BPF_FS_MAGIC), virtiofsd sets OpenOptions::DIRECT_IO
(FOPEN_DIRECT_IO) in the open reply:

  if flags & (libc::O_DIRECTORY as u32) == 0
      && !opts.contains(OpenOptions::DIRECT_IO)
      && is_zero_sized_pseudo_file(&file)?
  {
      opts |= OpenOptions::DIRECT_IO;
  }

With this change, standard read() syscalls (e.g. via dd, head, or runtimes)
in the guest receive FOPEN_DIRECT_IO and successfully read dynamic host
pseudo-file content.


3. Guest Kernel Issue: fuse_splice_read()
=========================================

Even with FOPEN_DIRECT_IO returned by virtiofsd, utilities that use
splice()/sendfile() (such as BusyBox cat, GNU cat in certain cases, or cp)
still fail and return 0 bytes.

Looking at fs/fuse/file.c:fuse_splice_read():

  static ssize_t fuse_splice_read(struct file *in, loff_t *ppos,
                                  struct pipe_inode_info *pipe, size_t len,
                                  unsigned int flags)
  {
      struct fuse_file *ff = in->private_data;

      /* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
      if (fuse_file_passthrough(ff) && !(ff->open_flags & FOPEN_DIRECT_IO))
          return fuse_passthrough_splice_read(in, ppos, pipe, len, flags);
      else
          return filemap_splice_read(in, ppos, pipe, len, flags);
  }

Notice that when FOPEN_DIRECT_IO is set, fuse_splice_read() falls back to
filemap_splice_read() in mm/filemap.c. filemap_splice_read() also checks
*ppos >= i_size_read() and immediately breaks with 0 bytes spliced.

Other filesystems (such as 9p, ceph, cifs, kernfs) handle direct I/O
splice reads by delegating to copy_splice_read(), which invokes
in->f_op->read_iter() (fuse_direct_read_iter).

We propose the following fix for the guest kernel fs/fuse/file.c:

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1884,6 +1884,8 @@ static ssize_t fuse_splice_read(struct file *in, loff_t *ppos,
 	/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
 	if (fuse_file_passthrough(ff) && !(ff->open_flags & FOPEN_DIRECT_IO))
 		return fuse_passthrough_splice_read(in, ppos, pipe, len, flags);
+	else if (ff->open_flags & FOPEN_DIRECT_IO)
+		return copy_splice_read(in, ppos, pipe, len, flags);
 	else
 		return filemap_splice_read(in, ppos, pipe, len, flags);
 }


Questions for Upstream
======================

1. For virtiofsd: Does the automatic detection of pseudo-filesystems via
   fstatfs magic match upstream expectations, or would upstream prefer an
   explicit configuration option (such as per-path cache policies)?
2. For the kernel: Does the proposed copy_splice_read() fallback for
   FOPEN_DIRECT_IO files in fuse_splice_read() look acceptable?

Any feedback and suggestions would be greatly appreciated.

[1] https://gitlab.com/Lencerf/virtiofsd/-/commit/ee9445c7d2963a60e554f8483bd47b7c1634d569

Thanks,
Changyuan Lyu
