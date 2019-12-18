DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id;
	bh=H/8f8ewvLT5DiNos1/61ARNfau2OnjKw96m7KybRoY0=;
	b=I93i6kCD4wW7PcgxSuFocfZz5hbfr5BZUm63OoCU1QenqrA7DR8gukntSyb+aKCk6y
	bNXcl8dgi/LXUBcqt62eaUDFkwuqF2NOUn3SwAwBESyM2joXXhGa+FKViN2/faWGZMgm
	fnf4C/BRFjCACR8R81twYDC5ExnV+/zxCq2jUj6WfKTJqKRr+1UUZEi9Ax5/Jw6UCSrr
	rlup2aURRF0hBvt56J05/EAGS1AnHenkIdUAlUtHkrPNgliAsPqD+fZSsWcKHfrl5Vh/
	IGhEz7A0+rqQwvcHRxDd0DtKRWoQxMYnO4fk4aMiNck/22E69OJB/TH8o9T9zwD+ANeD
	YKYg==
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Date: Wed, 18 Dec 2019 15:08:30 -0500
Message-Id: <20191218200833.10368-1-msys.mizuma@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/3] Add some option descriptions to help and
	man page
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

Add some options to the help message and man page so that
users can set them.

Masayoshi Mizuma (3):
  virtiofsd: add some options to the help message
  virtiofsd: add some options to the man page
  virtiofsd: remove --writeback option from the man page

 tools/virtiofsd/helper.c       | 26 +++++++++++++++++++++++---
 tools/virtiofsd/virtiofsd.texi | 24 ++++++++++++++++++++++--
 2 files changed, 45 insertions(+), 5 deletions(-)

-- 
2.18.1


