DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=PcFBTJ/FJSIMzco4pkUj7WHkUKvwPRNSLBpa49AXX5A=;
	b=SjEhSkX2uZOq9UjrXLHdsYFVIYYgtuVECg81zGn9VVnu4C2/o5aKLk6NTJ6XGB48kU
	we12fekI3ggjtusdyPy0W8lmpjHgOb1f9+NUxaawhRl0BFq8NIPDHGmKKF9X4Q4Pv2Ht
	hhVBtTL+zqHDrde/WtCyDI/sS9IP5k0MJl7tLsgrBYTt/+XJlbcUTksKPcAz4l3UmK8g
	vGJbXi981Mr6ZJAt5zG4rNvul1gn0hnJgaeKWQeTALH65+oWmicst7cNh+iEZ3tqTZgp
	bkJxuZehzgZvAUXTo/VUf0mBNUdpj2zWWASuYBxMTumSo0t3u0QHCGq13BpKiMmHvFmT
	0S0g==
MIME-Version: 1.0
References: <20220214171545.10242-1-stefanha@redhat.com>
In-Reply-To: <20220214171545.10242-1-stefanha@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 15 Feb 2022 22:40:55 +0000
Message-ID: <CAFEAcA_R1aqTqrD7Pmo-jqkniJNpJGE=UbxBnBUvVFLMb-5Fxw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PULL 0/3] Block patches
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>, qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, libvir-list@redhat.com, qemu-devel@nongnu.org, virtio-fs@redhat.com, Hanna Reitz <hreitz@redhat.com>

On Mon, 14 Feb 2022 at 17:44, Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> The following changes since commit cc5ce8b8b6be83e5fe3b668dbd061ad97c534e3f:
>
>   Merge remote-tracking branch 'remotes/legoater/tags/pull-ppc-20220210' into staging (2022-02-13 20:33:28 +0000)
>
> are available in the Git repository at:
>
>   https://gitlab.com/stefanha/qemu.git tags/block-pull-request
>
> for you to fetch changes up to 4c41c69e05fe28c0f95f8abd2ebf407e95a4f04b:
>
>   util: adjust coroutine pool size to virtio block queue (2022-02-14 17:11:25 +0000)
>
> ----------------------------------------------------------------
> Pull request
>
> This contains coroutine poll size scaling, virtiofsd rseq seccomp for new glibc
> versions, and the QEMU C virtiofsd deprecation notice.
>
> ----------------------------------------------------------------

Reviewed-by: Peter Maydell <peter.maydell@linaro.org>

thanks
-- PMM

