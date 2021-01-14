Date: Thu, 14 Jan 2021 10:08:31 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20210114100831.GA2905@work-vm>
References: <rprnspo3-119s-qnoo-2o93-sn40rq40ns@erqung.pbz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rprnspo3-119s-qnoo-2o93-sn40rq40ns@erqung.pbz>
Subject: Re: [Virtio-fs] [RFC] About non-root virtiofsd(1) process
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: P J P <ppandit@redhat.com>
Cc: virtio-fs@redhat.com

* P J P (ppandit@redhat.com) wrote:
>   Hello,
> 
> * Recently I realised that virtiofsd(1) process does not drop its 'root'
>   privileges while sharing host directory tree with a guest VM.

Correct.

>   Libvirtd(8) generally starts a guest VM with non-root system user (ex. qemu)
>   privileges. If virtiofsd(1) has 'root' privileges, that makes it an
>   accomplice in a potential guest-to-host privilege escalation scenario. Which
>   is not good.
> 
> * IMHO, ideally virtiofsd(1) should not run with 'root' privileges at all.
> 
> * But If it has to, then atleast all default configuration settings must be
>   utmost strict and restrictive as possible. Ex. By default offer only read
>   access to guest VM.
> 
> * Another option is for root virtiofsd(1) process to fork a sub-process which
>   will run with non-root (ex. qemu) system user privileges.
> 
>    - All file I/O operations for sharing a host directory with a guest are
>      performed by the sub-process with non-root system user privileges.
> 
>    - Sub-process shall talk to the parent virtiofsd(1) process only when
>      privileged operation/assistance is required.
> 
>   Ex. https://www.nginx.com/blog/inside-nginx-how-we-designed-for-performance-scale/
> 
> ...wdyt?

virtiofsd does a lot to sandbox itself after startup; and it has to be
able to provide access to a filesystem that on the host might want to
have files with root ownership, and xattr's and the like - i.e. to allow
the guest to do rpm installs for example.

The intent is that whoever starts virtiofsd passes it a directory
to be used only by the guest or that has appropriate permissions for the
guest to access.

The default sandboxing gives the virtiofsd it's own mount, pid and net
namespaces; so hopefully it can't escape to any other filetree other
than the one it's explicitly been told to give to the guest.
(That's -o sandbox=namespace which is the default)

It's seccomp'd to disallow as many syscalls as possible.

It also drops a lot of capabilities; although it is left
with a bunch of powerful ones (e.g. CAP_DAC_OVERRIDE) - but
you can also reduce those with the use of the -o modcaps= option.

Dave

> 
> Thank you.
> --
> Prasad J Pandit / Red Hat Product Security Team
> 8685 545E B54C 486B C6EB 271E E285 8B5A F050 DE8D
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

