Date: Thu, 4 Feb 2021 17:35:36 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20210204173536.GM3039@work-vm>
References: <20210204150208.367837-1-stefanha@redhat.com>
	<161245534386.30579.2853899336444305293@c667a6b167f6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161245534386.30579.2853899336444305293@c667a6b167f6>
Subject: Re: [Virtio-fs] [PATCH v5 0/3] virtiofsd: prevent opening of
 special files (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: berrange@redhat.com, ppandit@redhat.com, virtio-fs@redhat.com, alex@alxu.ca, lersek@redhat.com, vgoyal@redhat.com

* no-reply@patchew.org (no-reply@patchew.org) wrote:
> Patchew URL: https://patchew.org/QEMU/20210204150208.367837-1-stefanha@redhat.com/
> 
> 
> 
> Hi,
> 
> This series seems to have some coding style problems. See output below for
> more information:
> 
> Type: series
> Message-id: 20210204150208.367837-1-stefanha@redhat.com
> Subject: [PATCH v5 0/3] virtiofsd: prevent opening of special files (CVE-2020-35517)
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
>    db754f8..1ba089f  master     -> master
>  - [tag update]      patchew/20210204014509.882821-1-richard.henderson@linaro.org -> patchew/20210204014509.882821-1-richard.henderson@linaro.org
>  - [tag update]      patchew/20210204124834.774401-1-berrange@redhat.com -> patchew/20210204124834.774401-1-berrange@redhat.com
>  * [new tag]         patchew/20210204150208.367837-1-stefanha@redhat.com -> patchew/20210204150208.367837-1-stefanha@redhat.com
>  * [new tag]         patchew/20210204153925.2030606-1-Jason@zx2c4.com -> patchew/20210204153925.2030606-1-Jason@zx2c4.com
> Switched to a new branch 'test'
> b5bb803 virtiofsd: prevent opening of special files (CVE-2020-35517)
> 0d88a79 virtiofsd: optionally return inode pointer from lo_do_lookup()
> be6aa23 virtiofsd: extract lo_do_open() from lo_open()
> 
> === OUTPUT BEGIN ===
> 1/3 Checking commit be6aa2319875 (virtiofsd: extract lo_do_open() from lo_open())
> ERROR: return of an errno should typically be -ve (return -ENOMEM)
> #70: FILE: tools/virtiofsd/passthrough_ll.c:1674:
> +        return ENOMEM;

This is intended

> total: 1 errors, 0 warnings, 114 lines checked
> 
> Patch 1/3 has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
> 
> 2/3 Checking commit 0d88a7925a83 (virtiofsd: optionally return inode pointer from lo_do_lookup())
> 3/3 Checking commit b5bb8039eb3c (virtiofsd: prevent opening of special files (CVE-2020-35517))
> === OUTPUT END ===
> 
> Test command exited with code: 1
> 
> 
> The full log is available at
> http://patchew.org/logs/20210204150208.367837-1-stefanha@redhat.com/testing.checkpatch/?type=message.
> ---
> Email generated automatically by Patchew [https://patchew.org/].
> Please send your feedback to patchew-devel@redhat.com
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

