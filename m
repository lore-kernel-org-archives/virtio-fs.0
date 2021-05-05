Date: Wed, 5 May 2021 15:08:41 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
Message-ID: <20210505130841.ertqcjbmrgxhhddp@sirius.home.kraxel.org>
References: <20210505103702.521457-1-berrange@redhat.com>
	<20210505103702.521457-5-berrange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210505103702.521457-5-berrange@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 4/7] usb/dev-mtp: use GDateTime for
 formatting timestamp for objects
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Jiri Pirko <jiri@resnulli.us>, qemu-block@nongnu.org, Juan Quintela <quintela@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org, Laurent Vivier <laurent@vivier.eu>, virtio-fs@redhat.com, Max Reitz <mreitz@redhat.com>, Brad Smith <brad@comstyle.com>

On Wed, May 05, 2021 at 11:36:59AM +0100, Daniel P. Berrang=E9 wrote:
> The GDateTime APIs provided by GLib avoid portability pitfalls, such
> as some platforms where 'struct timeval.tv_sec' field is still 'long'
> instead of 'time_t'. When combined with automatic cleanup, GDateTime
> often results in simpler code too.
>=20
> Signed-off-by: Daniel P. Berrang=E9 <berrange@redhat.com>

Reviewed-by: Gerd Hoffmann <kraxel@redhat.com>

