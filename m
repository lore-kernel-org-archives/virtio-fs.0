References: <20210505103702.521457-1-berrange@redhat.com>
	<20210505103702.521457-7-berrange@redhat.com>
From: Laurent Vivier <laurent@vivier.eu>
Message-ID: <49d2bc96-a365-b79b-755f-ee8b2ad5c97c@vivier.eu>
Date: Wed, 5 May 2021 13:18:43 +0200
MIME-Version: 1.0
In-Reply-To: <20210505103702.521457-7-berrange@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: fr
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 6/7] linux-user: use GDateTime for
 formatting timestamp for core file
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>, qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Jiri Pirko <jiri@resnulli.us>, qemu-block@nongnu.org, Juan Quintela <quintela@redhat.com>, Jason Wang <jasowang@redhat.com>, Markus Armbruster <armbru@redhat.com>, Max Reitz <mreitz@redhat.com>, virtio-fs@redhat.com, Gerd Hoffmann <kraxel@redhat.com>, Brad Smith <brad@comstyle.com>

Le 05/05/2021 à 12:37, Daniel P. Berrangé a écrit :
> The GDateTime APIs provided by GLib avoid portability pitfalls, such
> as some platforms where 'struct timeval.tv_sec' field is still 'long'
> instead of 'time_t'. When combined with automatic cleanup, GDateTime
> often results in simpler code too.
> 
> Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
> ---
>  linux-user/elfload.c | 36 +++++++++---------------------------
>  1 file changed, 9 insertions(+), 27 deletions(-)
> 

Reviewed-by: Laurent Vivier <laurent@vivier.eu>

