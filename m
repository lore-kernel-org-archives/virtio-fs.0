DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.com; s=mail;
	t=1595231686; bh=4lmdzV6+/uw9yONIHVIizQCCPQUJeiHCzwSBdfLQkeU=;
	h=Message-Id:Date:Subject:To:From;
	b=RL0AUETXhXNWKNhKmxqo7qUqi+FFmgDlkjAbg/AilyloMY+NHVESAtwI/7T0O9z88
	cwbt/wRqUYF3vUVWHsErCMe0CRyOtm36Vs1EN/BzDDbhIep0hoWjr4BE8Lftu55LT3
	Rzq0hNuzzI5uTLqVEgJR/1ia3ZG6FbKBBMDyJ2OY=
From: Aa Aa <jimbothom@yandex.com>
MIME-Version: 1.0
Date: Mon, 20 Jul 2020 17:54:46 +1000
Message-Id: <612101595231414@mail.yandex.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] F_SETLKW not supported
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hi

I am trying to run some java apps via virtfs and some of the file locking (java) doesn't work. Here an exception (java) is thrown something about file locking:

Here is the strace output:

 3541 [pid 12461] openat(AT_FDCWD, "/mnt/<redacted> O_WRONLY|O_CREAT|O_APPEND, 0666 <unfinished ...>
 3542 [pid 12461] <... openat resumed>)       = 180
 3543 [pid 12461] fstat(180, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
 3544 [pid 12461] fcntl(180, F_SETLKW, {l_type=F_WRLCK, l_whence=SEEK_SET, l_start=0, l_len=0} <unfinished ...>
 3545 [pid 12461] <... fcntl resumed>)        = -1 EOPNOTSUPP (Operation not supported)

If I run this on the native file system, there is no issue. Should this functl be supported?

Cheers

JT

