References: <20210312141003.819108-1-groug@kaod.org>
	<20210312141003.819108-4-groug@kaod.org>
From: Connor Kuehl <ckuehl@redhat.com>
Message-ID: <c56bcaab-4a2d-219b-5d83-49dfd6fa1483@redhat.com>
Date: Fri, 12 Mar 2021 09:13:54 -0600
MIME-Version: 1.0
In-Reply-To: <20210312141003.819108-4-groug@kaod.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 3/3] virtiofsd: Don't allow empty filenames
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>, qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com

On 3/12/21 8:10 AM, Greg Kurz wrote:
> POSIX.1-2017 clearly stipulates that empty filenames aren't
> allowed ([1] and [2]). Since virtiofsd is supposed to mirror
> the host file system hierarchy and the host can be assumed to
> be linux, we don't really expect clients to pass requests with
> an empty path in it. If they do so anyway, this would eventually
> cause an error when trying to create/lookup the actual inode
> on the underlying POSIX filesystem. But this could still confuse
> some code that wouldn't be ready to cope with this.
> 
> Filter out empty names coming from the client at the top level,
> so that the rest doesn't have to care about it. This is done
> everywhere we already call is_safe_path_component(), but
> in a separate helper since the usual error for empty path
> names is ENOENT instead of EINVAL.
> 
> [1] https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_170
> [2] https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap04.html#tag_04_13
> 
> Signed-off-by: Greg Kurz <groug@kaod.org>

Reviewed-by: Connor Kuehl <ckuehl@redhat.com>

