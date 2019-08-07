Date: Wed, 7 Aug 2019 10:50:30 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190807095030.GA26738@stefanha-x1.localdomain>
References: <20190807093152.10964-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807093152.10964-1-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Fix lo_destroy crash in
 g_hash_table_foreach_remove
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

On Wed, Aug 07, 2019 at 10:31:52AM +0100, Dr. David Alan Gilbert (git) wrote:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> 
> This fixes a crash in lo_destroy since g_hash_table_foreach_remove
> doesn't like the hashtable changing as it iterates, and unref_inode
> will remove entries.
> 
> Avoid the g_hash_table_foreach_remove and use a dummy iterator to find
> one element of the table at a time.
> 
> Fixes: virtiofsd: fix lo_destroy() resource leaks
> 
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  contrib/virtiofsd/passthrough_ll.c | 27 +++++++++++++--------------
>  1 file changed, 13 insertions(+), 14 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

