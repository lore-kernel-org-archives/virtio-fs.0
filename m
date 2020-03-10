DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=a3QS0e8RcKFN7/huSeBCCDwuVM9JqD+PwQz/25LYZ7s=;
	b=OhbAghdNUJbciPVHuH7moOlqqCFrFRE9cU5y6G8bZaazds/cVCLgdwVJGN8cktdJeV
	PcCU4iK+sDFS7sQ0uFJKeBvYtAZY/fdaWTYPriu+UWlAjLMThNuq340tP6KkBerdfuKh
	y3T0QJitw2eIkqR+syI0QC6SM1+A3omTiS8nU=
MIME-Version: 1.0
References: <20200304165845.3081-1-vgoyal@redhat.com>
	<20200304165845.3081-13-vgoyal@redhat.com>
In-Reply-To: <20200304165845.3081-13-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 10 Mar 2020 20:49:49 +0100
Message-ID: <CAJfpeguY8gDYVp_q3-W6JNA24zCry+SfWmEW2zuHLQLhmyUB3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 12/20] fuse: Introduce
	setupmapping/removemapping commands
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
> Introduce two new fuse commands to setup/remove memory mappings. This
> will be used to setup/tear down file mapping in dax window.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
> ---
>  include/uapi/linux/fuse.h | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index 5b85819e045f..62633555d547 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -894,4 +894,41 @@ struct fuse_copy_file_range_in {
>         uint64_t        flags;
>  };
>
> +#define FUSE_SETUPMAPPING_ENTRIES 8
> +#define FUSE_SETUPMAPPING_FLAG_WRITE (1ull << 0)
> +struct fuse_setupmapping_in {
> +       /* An already open handle */
> +       uint64_t        fh;
> +       /* Offset into the file to start the mapping */
> +       uint64_t        foffset;
> +       /* Length of mapping required */
> +       uint64_t        len;
> +       /* Flags, FUSE_SETUPMAPPING_FLAG_* */
> +       uint64_t        flags;
> +       /* Offset in Memory Window */
> +       uint64_t        moffset;
> +};
> +
> +struct fuse_setupmapping_out {
> +       /* Offsets into the cache of mappings */
> +       uint64_t        coffset[FUSE_SETUPMAPPING_ENTRIES];
> +        /* Lengths of each mapping */
> +        uint64_t       len[FUSE_SETUPMAPPING_ENTRIES];
> +};

fuse_setupmapping_out together with FUSE_SETUPMAPPING_ENTRIES seem to be unused.

Thanks,
Miklos


