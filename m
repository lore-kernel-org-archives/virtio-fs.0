Date: Thu, 14 Jan 2021 14:11:28 +0530 (IST)
From: P J P <ppandit@redhat.com>
Message-ID: <rprnspo3-119s-qnoo-2o93-sn40rq40ns@erqung.pbz>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Subject: [Virtio-fs] [RFC] About non-root virtiofsd(1) process
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

   Hello,

* Recently I realised that virtiofsd(1) process does not drop its 'root'
   privileges while sharing host directory tree with a guest VM.

   Libvirtd(8) generally starts a guest VM with non-root system user (ex. qemu)
   privileges. If virtiofsd(1) has 'root' privileges, that makes it an
   accomplice in a potential guest-to-host privilege escalation scenario. Which
   is not good.

* IMHO, ideally virtiofsd(1) should not run with 'root' privileges at all.

* But If it has to, then atleast all default configuration settings must be
   utmost strict and restrictive as possible. Ex. By default offer only read
   access to guest VM.

* Another option is for root virtiofsd(1) process to fork a sub-process which
   will run with non-root (ex. qemu) system user privileges.

    - All file I/O operations for sharing a host directory with a guest are
      performed by the sub-process with non-root system user privileges.

    - Sub-process shall talk to the parent virtiofsd(1) process only when
      privileged operation/assistance is required.

   Ex. https://www.nginx.com/blog/inside-nginx-how-we-designed-for-performance-scale/

...wdyt?

Thank you.
--
Prasad J Pandit / Red Hat Product Security Team
8685 545E B54C 486B C6EB 271E E285 8B5A F050 DE8D

