References: <20210505103702.521457-1-berrange@redhat.com>
	<20210505103702.521457-3-berrange@redhat.com>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <0c8f5a52-cfc9-9b09-b254-086a0524646d@redhat.com>
Date: Fri, 7 May 2021 19:05:08 +0200
MIME-Version: 1.0
In-Reply-To: <20210505103702.521457-3-berrange@redhat.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 2/7] block: use GDateTime for formatting
 timestamp when dumping snapshot info
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>, qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Jiri Pirko <jiri@resnulli.us>, qemu-block@nongnu.org, Juan Quintela <quintela@redhat.com>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <laurent@vivier.eu>, Markus Armbruster <armbru@redhat.com>, virtio-fs@redhat.com, Gerd Hoffmann <kraxel@redhat.com>, Brad Smith <brad@comstyle.com>

On 05.05.21 12:36, Daniel P. Berrangé wrote:
> The GDateTime APIs provided by GLib avoid portability pitfalls, such
> as some platforms where 'struct timeval.tv_sec' field is still 'long'
> instead of 'time_t'. When combined with automatic cleanup, GDateTime
> often results in simpler code too.
> 
> Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
> ---
>   block/qapi.c | 11 ++++-------
>   1 file changed, 4 insertions(+), 7 deletions(-)

Reviewed-by: Max Reitz <mreitz@redhat.com>

