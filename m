Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=QG13wto3iMHroDD8BZ6bjMdwyCMa8mGjxQBbHVCJM+o=;
 b=gwS3xJ8h6RRVPeQ3pFQ/aSKbZ9OJDxhNaAHSDD0gZKxFjyc7zmjQgZMLCdV+bvD+Fq
 KirNVXvbKZQ62iJ6pV/s0UmyIy3EOnSxM1Q9Ze1o2O27lnWp5CWPE1SVOdxR8h30Ebp3
 YGhgmxUng9wywcwT8Hez+as4MQZAqu+hInl7bRWoEkVbalvyUZqVVT2N2QzKBym69hFH
 opM4xo2W0qgFS2elHTdxLey5c1Uxl55YBC7jX+haQLlMB/Wzuj0mvr+80JC6ybFyWlK7
 rFXVfDTftPPuWeFy2450xlN7uASRuHGZCZG9ZdvRJbNl0TvM61mE6lqJs7ZIkNSl+uP0
 sPZA==
MIME-Version: 1.0
References: <4f2c71a4-609e-6880-04d0-2eb127c55023@linux.dev>
In-Reply-To: <4f2c71a4-609e-6880-04d0-2eb127c55023@linux.dev>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 26 Jul 2022 08:55:38 -0400
Message-ID: <CAJSP0QUzd7GXK0XN7YBBfEqO6abQSZMdJzW8pEHnz-ZnGetUWA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] Question about performance comparison between
 virtio-fs and virtio-blk
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hao Xu <hao.xu@linux.dev>
Cc: qemu-devel <qemu-devel@nongnu.org>, virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>

On Tue, 26 Jul 2022 at 08:24, Hao Xu <hao.xu@linux.dev> wrote:
> I watched your presentation about virtiofs in 2020,
>
> https://www.youtube.com/watch?v=EIVOzTsGMMI&t=232s
>
> which is really helpful to me, but I have a question about the graph at
> 3:53, could you give
>
> me more info about the test, like what tool you use for the test, if
> it's fio, what is the parameters.
>
> I used fio to do randread test in a qemu box, but turns out the iops of
> virtio-blk and virtio-fs are similar.

I have CCed Vivek Goyal, who has done more virtiofs benchmarking and
might have ideas to share.

The benchmarking tool was fio with the stated blocksize and I/O
pattern. The benchmark was probably run with direct=1. Based on the
virtio-blk numbers I think iodepth was greater than 1 but I don't have
the exact fio job parameters.

Stefan

