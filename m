DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:subject:message-id:date:user-agent:mime-version
	:content-transfer-encoding:content-language;
	bh=39tTKc/uIbQLpVlgFj3OtnE3sgSzhw3SNEKpUGPRdSE=;
	b=Vm2y/gAOSHz2K4Rm1tyrGeJcpDFhYF56jmTb96xwUsQ4IxsV4W8scXHz58l9uoO+AY
	HiLUCqE8OXT6vS+5PYuPOY9/NE4bWxfWyRvk7rffKaB5KjxvM5/7vvSZWpu7nvrTnB9V
	5iKCzVFDv25Oq4RCfxqjRgbq1zrczjF8E/PF7Dd9j9EhNgzvM2q2Ox20ppRY+TNlHmFd
	x+RfdniNMRiVfyINidSFn3s2rsAw4dbfZxaQY61aJmoZj3sjZ92yGt2NhJA6w6wjOlmx
	0tiBH37ZCSj3Gq10eqRNZvqS1TBJx3qi9Q2sVKK9BnBHDb7kkvpE+WxqcG3PUiFm53Qq
	W5kQ==
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <e1437314-4870-a3a3-e866-8be50282ce3c@gmail.com>
Date: Sat, 29 May 2021 13:42:50 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] regression: lsetfilecon fails, breaks rpm, dpkg,
 dnf in virtiofs guests.
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>

Some regression in virtio-fs has led to rpm/dnf/yum failing  in the same
guest it previously worked.

linux 5.11.19-300.fc34.x86_64

Specifically, all attempts to use dnf/yum lead to examples similar to this:

Error unpacking rpm package dnf-4.7.0-1.fc34.noarch
  Upgrading        :
python3-dnf-plugins-core-4.0.21-1.fc34.noarch                                                                                                                                                     
8/20
error: unpacking of archive failed on file /usr/bin/dnf;60b1b277: cpio:
(error 0x2)
error: dnf-4.7.0-1.fc34.noarch: install failed
error: lsetfilecon: (/etc/dnf/plugins/copr.conf,
system_u:object_r:etc_t:s0) Operation not permitted
error: Plugin selinux: hook fsm_file_prepare failed

(

For all packages.  No updates are possible.  Possibly related to:
https://github.com/fedora-selinux/selinux-policy/pull/478/files/21a2df26cd605c55de7edc80e16907fcb76ccf08 
?  What really gets me, is this error exists even though

# getenforce
Permissive

)

The host is running btrfs.  ... virtiofsd --fd=50 -o
source=/vmsystems/fedora_generic,xattr,flock,posix_lock

same effect with  .... virtiofsd --fd=36 -o
source=/vmsystems/dbl1,xattr,flock,no_posix_lock

/etc/fstab:

myfs / virtiofs seclabel 0 0




