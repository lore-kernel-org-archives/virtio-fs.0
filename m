Return-Path: <berrange@redhat.com>
Date: Wed, 20 Apr 2022 16:51:12 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <YmAr8N0L5zzOCsRL@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220420132624.2439741-1-marcandre.lureau@redhat.com>
 <20220420132624.2439741-39-marcandre.lureau@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220420132624.2439741-39-marcandre.lureau@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 38/41] util: replace
 qemu_get_local_state_pathname()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: marcandre.lureau@redhat.com
Cc: qemu-devel@nongnu.org, Fam Zheng <fam@euphon.net>, "open list:Block SCSI subsystem" <qemu-block@nongnu.org>, Michael Roth <michael.roth@amd.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "open list:virtiofs" <virtio-fs@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Weil <sw@weilnetz.de>

On Wed, Apr 20, 2022 at 05:26:21PM +0400, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> Simplify the function to only return the directory path. Callers are
> adjusted to use the GLib function to build paths, g_build_filename().
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> ---
>  include/qemu/osdep.h          | 9 +++------
>  qga/main.c                    | 8 ++++----
>  scsi/qemu-pr-helper.c         | 6 ++++--
>  tools/virtiofsd/fuse_virtio.c | 4 +++-
>  util/oslib-posix.c            | 7 ++-----
>  util/oslib-win32.c            | 5 ++---
>  6 files changed, 18 insertions(+), 21 deletions(-)

Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|
