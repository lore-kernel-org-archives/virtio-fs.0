DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=q0sJ7a6j5xvVSDg6rIXfwSX5x16Wvu3orvAMR4Fx/F4=;
	b=M81mkmVA1gFIsYQ9wjfg8L1KshCZBsYGPZhyDOLmmEL1SuUdzGg7T+sPTI6OluwXkd
	IxCFCfj7IhtcUL/VLJOHjJbiFNxEWoimKYZ2YYVMLEk0yKA1qeBjoIjIm/ssU5me0Qn4
	FKp3eFJ1fqDn6X+ERf/SQ16PERL2SMntrD5qecGnAl20Jn2iZY2rgMm0f8bCQczMe06E
	Xcz7wXLGgJnEjuhqgOfwJxKYwXphpW1l1OiAYTtjSPe/eukYU6XtkXZg8SPV3nlauU1Z
	4GlPyWWJTsl+sbkYgP+iF0w79MmUgPZlr58Vu4bLhEi9eEBMEokH+Fc3a2LaBXbDE5+h
	t29w==
MIME-Version: 1.0
References: <20220126105112.28711-1-dgilbert@redhat.com>
In-Reply-To: <20220126105112.28711-1-dgilbert@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 26 Jan 2022 14:57:08 +0000
Message-ID: <CAFEAcA9ok6VY5fS9stb8bUZ-yDbMLSCLCPokKWBtEc3Qif=Y4w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PULL 0/1] virtiofs queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: mcascell@redhat.com, qemu-devel@nongnu.org, shawtao1125@gmail.com, pj.pandit@yahoo.co.in, virtio-fs@redhat.com, vgoyal@redhat.com

On Wed, 26 Jan 2022 at 10:54, Dr. David Alan Gilbert (git)
<dgilbert@redhat.com> wrote:
>
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>
> The following changes since commit aeb0ae95b7f18c66158792641cb6ba0cde5789ab:
>
>   Merge remote-tracking branch 'remotes/jsnow-gitlab/tags/python-pull-request' into staging (2022-01-22 12:03:22 +0000)
>
> are available in the Git repository at:
>
>   https://gitlab.com/dagrh/qemu.git tags/pull-virtiofs-20220126
>
> for you to fetch changes up to 449e8171f96a6a944d1f3b7d3627ae059eae21ca:
>
>   virtiofsd: Drop membership of all supplementary groups (CVE-2022-0358) (2022-01-26 10:32:05 +0000)
>
> ----------------------------------------------------------------
> virtiofsd: Security fix
>
> Fixes: CVE-2022-0358
>
> ----------------------------------------------------------------
> Vivek Goyal (1):
>       virtiofsd: Drop membership of all supplementary groups (CVE-2022-0358)


Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/7.0
for any user-visible changes.

-- PMM

