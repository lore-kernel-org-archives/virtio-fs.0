DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=0QsMHMToALTgigyVVitR0QGzkqjZRHN3wRK9R0WkFcg=;
	b=Auk/J/am7PnSkti7DnDeBTBkoI7EdkOeiXxOafA83iFtNlXEfJCh8HA0llJSykN0lU
	F3K3PX0+eGlrLpw9xVldfbGWlBeibwiL4+JP4oW3J6fT8IYoEUYX6QU+hSAzqc2x9YAS
	wcqf5w4LictNkY4z6rP056PjahcGRfLxvhsqs=
MIME-Version: 1.0
References: <20200304165845.3081-1-vgoyal@redhat.com>
	<20200304165845.3081-12-vgoyal@redhat.com>
In-Reply-To: <20200304165845.3081-12-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 10 Mar 2020 20:31:44 +0100
Message-ID: <CAJfpegu5HMg2BnBsfSEWOv7K_0KjchntZ9q4oOvxzYLjOEBF3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 11/20] fuse: implement FUSE_INIT
	map_alignment field
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-nvdimm@lists.01.org, "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org

On Wed, Mar 4, 2020 at 5:59 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> The device communicates FUSE_SETUPMAPPING/FUSE_REMOVMAPPING alignment
> constraints via the FUST_INIT map_alignment field.  Parse this field and
> ensure our DAX mappings meet the alignment constraints.
>
> We don't actually align anything differently since our mappings are
> already 2MB aligned.  Just check the value when the connection is
> established.  If it becomes necessary to honor arbitrary alignments in
> the future we'll have to adjust how mappings are sized.
>
> The upshot of this commit is that we can be confident that mappings will
> work even when emulating x86 on Power and similar combinations where the
> host page sizes are different.
>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Miklos Szeredi <mszeredi@redhat.com>


