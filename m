DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id:in-reply-to:references;
	bh=52unQB593LIYSJKeJILg0hZ6B5EJz0Z5q3DyqC35Io4=;
	b=XrGcuRE96wVWOX9QWN8q6Zsdw3tA8bPZSVotPXMcE/IlBS61yJ3F0kKO6Zq5LXhBB1
	YAW0Ug3dMfcT7ZgvzoqMT2LrgI+BCsEYKnCNwsR7jFaNw+g0ODhbZu4qsLVI6DDwGbTM
	TfjRP6KbIpsfI0iNtBYaFsspyEI2wdG2WvRsMq1hvERoKXdeB3HxU/XWrwL4LxlP+Ly0
	bLZWYE76oaGHr2AvLA00X1wX+BGglHbPM3c3cdHa7h/hnIDpQsLojXqBNfdxhXtPvlfC
	FjgDwgkWluH/IaMANAQsJ3ckrfvIBzhLnEfsD0DvKatGR8tJn9UAk/E6tDrDldv7YgK0
	CQUg==
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Date: Wed, 18 Dec 2019 15:08:32 -0500
Message-Id: <20191218200833.10368-3-msys.mizuma@gmail.com>
In-Reply-To: <20191218200833.10368-1-msys.mizuma@gmail.com>
References: <20191218200833.10368-1-msys.mizuma@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/3] virtiofsd: add some options to the man page
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

Add following options to the man page:
- flock|no_flock
- norace
- posix_lock|no_posix_lock
- readdirplus|no_readdirplus
- timeout
- writeback|no_writeback
- xattr|no_xattr

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 tools/virtiofsd/virtiofsd.texi | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/virtiofsd/virtiofsd.texi b/tools/virtiofsd/virtiofsd.texi
index eec7fbf4e6..76eb219676 100644
--- a/tools/virtiofsd/virtiofsd.texi
+++ b/tools/virtiofsd/virtiofsd.texi
@@ -34,12 +34,34 @@ Print version.
 Enable debug output.
 @item --syslog
 Print log messages to syslog instead of stderr.
+@item -o flock|no_flock
+enable/disable flock.
+The default is @var{no_flock}.
 @item -o log_level=@var{level}
 Print only log messages matching @var{level} or more severe.  @var{level} is
 one of @code{err}, @code{warn}, @code{info}, or @code{debug}.  The default is
 @var{info}.
+@item -o norace
+Disable racy fallback.
+The default is false.
+@item -o posix_lock|no_posix_lock
+Enable/Disable remote posix lock.
+The default is @var{posix_lock}.
+@item -o readdirplus|no_readdirplus
+Enable/Disable readdirplus.
+The default is @var{readdirplus}
 @item -o source=@var{path}
 Share host directory tree located at @var{path}.  This option is required.
+@item -o timeout=<number>
+I/O timeout (second).
+The default depends on cache= option.
+@item -o writeback|no_writeback
+Enable/Disable writeback cache. The cache alows the FUSE client
+to buffer and merge write requests.
+The default is @var{no_writeback}.
+@item -o xattr|no_xattr
+Enable/Disable Extended attributes (xattr) of the files and directories.
+The default is @var{no_xattr}.
 @item --socket-path=@var{path}, -o vhost_user_socket=@var{path}
 Listen on vhost-user UNIX domain socket at @var{path}.
 @item --fd=@var{fdnum}
-- 
2.18.1


