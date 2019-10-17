Date: Thu, 17 Oct 2019 10:45:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20191017144553.GA12588@redhat.com>
References: <20191016160157.12414-1-stefanha@redhat.com>
	<20191016160157.12414-3-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016160157.12414-3-stefanha@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 2/2] virtiofsd: move to a new pid namespace
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Wed, Oct 16, 2019 at 05:01:57PM +0100, Stefan Hajnoczi wrote:

[..]
> +	/*
> +	 * If the mounts have shared propagation then we want to opt out so our
> +	 * mount changes don't affect the parent mount namespace.
> +	 */
> +	if (mount(NULL, "/", NULL, MS_REC|MS_SLAVE, NULL) < 0) {
> +		fuse_log(FUSE_LOG_ERR, "mount(/, MS_REC|MS_SLAVE): %m\n");
> +		exit(1);
> +	}

So we will get mount propogation form parent but our mounts will not
propagate back. Sounds reasonable.

Can we take away CAP_SYS_ADMIN from virtiofsd? That way it will not be 
able to do mount at all. 

I am wondering are we dependent on daemon having CAP_SYS_ADMIN. 

Thanks
Vivek

