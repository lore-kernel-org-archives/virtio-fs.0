References: <20190905082947.6633-1-stefanha@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <6e9ff4f7-2906-3c11-8191-05cff3e60f53@redhat.com>
Date: Thu, 5 Sep 2019 11:17:38 +0200
MIME-Version: 1.0
In-Reply-To: <20190905082947.6633-1-stefanha@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [Qemu-devel] [PATCH RESEND 0/2] virtiofsd: use
 "fuse_log.h" APIs instead of <err.h>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com

Hi Stefan,

On 9/5/19 10:29 AM, Stefan Hajnoczi wrote:
> warn(3), warnx(3), err(3), and errx(3) print to stderr even when the --syslog
> option was given.  In this case messages to stderr are likely to be lost and
> this makes troubleshooting hard.  Use "fuse_log.h" APIs instead of <err.h>.
> 
> Stefan Hajnoczi (2):
>   virtiofsd: replace warn(3) and warnx(3) with fuse_warning()
>   virtiofsd: replace err(3) and errx(3) with fuse_err()

Is this a straight RESEND or are there any changes in this series?

I'm asking because IIRC your first series had:
- Reviewed-by: Jun Piao <piaojun@huawei.com>
- Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

If this isn't a RESEND then I'll review it again.

Thanks,

Phil.

