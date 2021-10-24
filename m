DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
	t=1635056674; bh=YUeCIIcdToRsBiCBKhkFQ7oIA2Rmo0QR/W3LRlpMR+o=;
	h=Date:From:To:Subject:From;
	b=rBIt74SCf/T85zLPDpEC34X0ai1aJiGLzhQ9HcLhA3WwmTMIi8nLfOwAghPayG21r
	vnvv/XvZMrhTHQ82Emh58QMF55h7JMgsziJUEtC+9t5fKLb+JQI8Ne/CoxVoCVe8H0
	oDWzgoj/dsJADDhVsqfp7x/J7enIbcBSwMRsPVCyu23HgGy42v49SMdczJFLIuSwIR
	sT/HgbRQWh580AYy9vRTzgnRoTzUMHlVCRYgk3SWOW/LdZ7pYziRvsKu3k/kxu7+wt
	iFjhvGNjxA0+hD9suXaWahzMBgl8ni/aen74HVRmxT6ryCYDZOLLX7r3skZ+x0kSF5
	3ZC20lxOQ2eCA==
MIME-Version: 1.0
Date: Sun, 24 Oct 2021 06:24:33 +0000
From: birnenkram@posteo.de
Message-ID: <5e79ba8579b33e60e9670f2fd99b1c1b@posteo.de>
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] write permissions for Windows host on Linux guest
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hello list,

thanks for a great project which will simplify my workflow a lot once I 
get everything working.

I am trying to share a folder from an Ubuntu 20.04.3 host with a Windows 
10 build 19042 (20H2) guest, using QEMU 5.2 / libvirt 7.0.0 on the host 
and virtio-win 0.1.208 (driver 100.85.104.20800 and associated virtiofs 
service) on the guest. I got the Windows drivers from 
https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md 
(stable virtio-win ISO).

So far I am able to read files in this host folder without problems from 
the guest. However I can only create/write/delete files on the host if

     I use a shell (Windows CMD or Cygwin bash) with *Administrator* 
rights on the guest
OR
     I change the folder permissions on the host, giving write 
permissions to "other". Neither of these options is acceptable as a 
permanent solution.

I already toyed with various settings for "user" in 
/etc/libvirt/qemu.conf, including root and the user owning the shared 
folder (myself), without success. I struggle to understand what 
ultimately determines the write permissions on the host folder. I had 
assumed this to be related to the UID of one of the hypervisor 
processes, so I do not see why running as Administrator or not on the 
guest should make a difference. Also, virtiofsd seems to be running as 
root anyway, so should have the necessary permissions. There's no 
SELinux on my system.

My Windows and Linux user names are different. I don't know if that 
matters, and whether the software attempts to map the two (as Cygwin 
does).

Do you have any ideas what the problem could be? I have seen various 
users reporting issues with write permissions from Windows guests in the 
recent past, but no solution which would solve the issue for me.

Best regards, Michael

