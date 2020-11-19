DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:from:subject:message-id:date:user-agent:mime-version
	:content-transfer-encoding:content-language;
	bh=zhxTd/eQ9TKgyygskgCoiKDYtusFAbjE9V7bb6iZVzY=;
	b=uH/HsJVnxMD6h53rYGwXZ13QzRNg9vuSpmUS+wAw8/ol/K735rJk2AgUwKY4U4MLeg
	cZd7ZbOXcUVpblaDyh6dUyVAz9k1aZegWJlIP0HNreZ3l6lCmkKGiFSalmGPhXaOD+lc
	YE9LLpGorUgNMP/gHFZjmG5EPp1+l54gt/0uism4c/3rm8UniXlJd53+Rpsq/kr5ofcv
	CSAl3prEGOvU/+r3AAbI0EetzY+R6ARUc0EtIWOxHMlNyUNHGahm3Y3bWFm7gzXrfNxU
	8Wlb8oha26fyGq8qHBR/rQA1kQgDF18r4DPJ1n15kAeVWQstXxEuSb7CvTy+DlyHSsGG
	IGRw==
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <0503b244-b426-0779-7b9e-ff63dfa1165c@gmail.com>
Date: Thu, 19 Nov 2020 10:52:51 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] restorcon/SELinux virtiofs question
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hello virtiofs team.  I need clarification about a 'restorecon' selinux
guest giving an 'operation not supported' response.

If the host fs is btrfs (with xattr enabled in virtiofsd) but not
running SELinux, and the guest has virtiofs root with selinux active,
what version [if any] for virtiofs is necessary before I can expect the
restorecon command to operate properly?  (Or, maybe I've missed a config
setting somewhere?) 

Packages such as freeipa fail to install because they issue dozens of
'restorecon' calls which fail using virtiofs.

Thanks,

Harry Coin




