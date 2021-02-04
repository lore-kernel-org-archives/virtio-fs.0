Date: Thu, 4 Feb 2021 19:39:47 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20210204193947.GP3039@work-vm>
References: <20210204183439.546918-1-dgilbert@redhat.com>
	<161246668791.30579.7760426288477164722@c667a6b167f6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161246668791.30579.7760426288477164722@c667a6b167f6>
Subject: Re: [Virtio-fs] [PULL 0/5] virtiofs queue: Security fix
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, qemu-stable@nongnu.org

* no-reply@patchew.org (no-reply@patchew.org) wrote:
> Patchew URL: https://patchew.org/QEMU/20210204183439.546918-1-dgilbert@redhat.com/
> 
> 
> 
> Hi,
> 
> This series seems to have some coding style problems. See output below for
> more information:
> 
> Type: series
> Message-id: 20210204183439.546918-1-dgilbert@redhat.com
> Subject: [PULL 0/5] virtiofs queue: Security fix
> 
> === TEST SCRIPT BEGIN ===
> #!/bin/bash
> git rev-parse base > /dev/null || exit 0
> git config --local diff.renamelimit 0
> git config --local diff.renames True
> git config --local diff.algorithm histogram
> ./scripts/checkpatch.pl --mailback base..
> === TEST SCRIPT END ===
> 
> Updating 3c8cf5a9c21ff8782164d1def7f44bd888713384
> From https://github.com/patchew-project/qemu
>  * [new tag]         patchew/20210204183439.546918-1-dgilbert@redhat.com -> patchew/20210204183439.546918-1-dgilbert@redhat.com
> Switched to a new branch 'test'
> cc58a0c virtiofsd: Add restart_syscall to the seccomp whitelist
> bc881ed virtiofsd: Add _llseek to the seccomp whitelist
> 449b30f virtiofsd: prevent opening of special files (CVE-2020-35517)
> 5da12fe virtiofsd: optionally return inode pointer from lo_do_lookup()
> 3690387 virtiofsd: extract lo_do_open() from lo_open()
> 
> === OUTPUT BEGIN ===
> 1/5 Checking commit 3690387a3bc2 (virtiofsd: extract lo_do_open() from lo_open())
> ERROR: return of an errno should typically be -ve (return -ENOMEM)
> #72: FILE: tools/virtiofsd/passthrough_ll.c:1674:
> +        return ENOMEM;

That's expected and OK.

> total: 1 errors, 0 warnings, 114 lines checked
> 
> Patch 1/5 has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
> 
> 2/5 Checking commit 5da12fe61f50 (virtiofsd: optionally return inode pointer from lo_do_lookup())
> 3/5 Checking commit 449b30fcc7be (virtiofsd: prevent opening of special files (CVE-2020-35517))
> 4/5 Checking commit bc881ed54ee8 (virtiofsd: Add _llseek to the seccomp whitelist)
> 5/5 Checking commit cc58a0c7f1a0 (virtiofsd: Add restart_syscall to the seccomp whitelist)
> === OUTPUT END ===
> 
> Test command exited with code: 1
> 
> 
> The full log is available at
> http://patchew.org/logs/20210204183439.546918-1-dgilbert@redhat.com/testing.checkpatch/?type=message.
> ---
> Email generated automatically by Patchew [https://patchew.org/].
> Please send your feedback to patchew-devel@redhat.com
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

