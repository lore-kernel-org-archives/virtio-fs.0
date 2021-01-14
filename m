Date: Thu, 14 Jan 2021 18:40:58 +0530 (IST)
From: P J P <ppandit@redhat.com>
In-Reply-To: <20210114100831.GA2905@work-vm>
Message-ID: <pq252n8n-p83p-1ps4-5q4s-6712992qq21@erqung.pbz>
References: <rprnspo3-119s-qnoo-2o93-sn40rq40ns@erqung.pbz>
	<20210114100831.GA2905@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: Re: [Virtio-fs] [RFC] About non-root virtiofsd(1) process
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com

+-- On Thu, 14 Jan 2021, Dr. David Alan Gilbert wrote --+
| virtiofsd does a lot to sandbox itself after startup; and it has to be able 
| to provide access to a filesystem that on the host might want to have files 
| with root ownership, and xattr's and the like - i.e. to allow the guest to 
| do rpm installs for example.

  ie. For guest to install RPMs under the shared directory?
 
| The intent is that whoever starts virtiofsd passes it a directory to be used 
| only by the guest or that has appropriate permissions for the guest to 
| access.
| 
| The default sandboxing gives the virtiofsd it's own mount, pid and net 
| namespaces; so hopefully it can't escape to any other filetree other than 
| the one it's explicitly been told to give to the guest. (That's -o 
| sandbox=namespace which is the default)
| 
| It's seccomp'd to disallow as many syscalls as possible.
| 
| It also drops a lot of capabilities; although it is left with a bunch of 
| powerful ones (e.g. CAP_DAC_OVERRIDE) - but you can also reduce those with 
| the use of the -o modcaps= option.

* True; But with these numerous options/parameters, it is possible to miss one 
  while starting virtiofsd(1) daemon, which may prove fatal.

  Hence having the most restrictive default values for them is better.

* Maybe having a command line switch similar to 'qemu -runas <user>' would be 
  helpful?

     $ ./virtiofsd -runas test -o source=...

  A user who wants to run virtiofsd(1) with non-root privileges, can do so.
 

Thank you.
--
Prasad J Pandit / Red Hat Product Security Team
8685 545E B54C 486B C6EB 271E E285 8B5A F050 DE8D

