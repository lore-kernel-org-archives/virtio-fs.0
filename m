References: <160497112183.32285.8464514877214048442@b92d57cec08d>
From: Haotian Li <lihaotian9@huawei.com>
Message-ID: <faaeb432-fcf8-1083-0db0-98e61e971992@huawei.com>
Date: Tue, 10 Nov 2020 14:01:54 +0800
MIME-Version: 1.0
In-Reply-To: <160497112183.32285.8464514877214048442@b92d57cec08d>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: fix some accessing NULL
	pointer problem
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, linfeilong@huawei.com

Hi,
Thanks for your suggestion. We will fix the coding style
problems and resend new patches.

> Patchew URL: https://patchew.org/QEMU/eeb2fd1d-a53d-eae6-4727-7f1a6b20ac9e@huawei.com/
> 
> 
> 
> Hi,
> 
> This series seems to have some coding style problems. See output below for
> more information:
> 
> Message-id: eeb2fd1d-a53d-eae6-4727-7f1a6b20ac9e@huawei.com
> Subject: [PATCH 0/2] virtiofsd: fix some accessing NULL pointer problem
> Type: series
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
>  - [tag update]      patchew/20201028185722.2783532-1-keithp@keithp.com -> patchew/20201028185722.2783532-1-keithp@keithp.com
>  * [new tag]         patchew/eeb2fd1d-a53d-eae6-4727-7f1a6b20ac9e@huawei.com -> patchew/eeb2fd1d-a53d-eae6-4727-7f1a6b20ac9e@huawei.com
> Switched to a new branch 'test'
> c91e972 virtiofsd: check whether lo_map_reserve returns NULL in main func
> 387bda7 tools/virtiofsd/buffer.c: check whether buf is NULL in fuse_bufvec_advance func
> 
> === OUTPUT BEGIN ===
> 1/2 Checking commit 387bda78be64 (tools/virtiofsd/buffer.c: check whether buf is NULL in fuse_bufvec_advance func)
> ERROR: braces {} are necessary for all arms of this statement
> #23: FILE: tools/virtiofsd/buffer.c:249:
> +    if (!buf)
> [...]
> 
> total: 1 errors, 0 warnings, 9 lines checked
> 
> Patch 1/2 has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
> 
> 2/2 Checking commit c91e9722f323 (virtiofsd: check whether lo_map_reserve returns NULL in main func)
> ERROR: braces {} are necessary for all arms of this statement
> #34: FILE: tools/virtiofsd/passthrough_ll.c:3457:
> +    if (!reserve_elem)
> [...]
> 
> ERROR: braces {} are necessary for all arms of this statement
> #38: FILE: tools/virtiofsd/passthrough_ll.c:3461:
> +    if (!root_elem)
> [...]
> 
> total: 2 errors, 0 warnings, 21 lines checked
> 
> Patch 2/2 has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
> 
> === OUTPUT END ===
> 
> Test command exited with code: 1
> 
> 
> The full log is available at
> http://patchew.org/logs/eeb2fd1d-a53d-eae6-4727-7f1a6b20ac9e@huawei.com/testing.checkpatch/?type=message.
> ---
> Email generated automatically by Patchew [https://patchew.org/].
> Please send your feedback to patchew-devel@redhat.com
> 

