Return-Path: <mst@redhat.com>
Date: Thu, 13 Apr 2023 11:48:24 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20230413105448-mutt-send-email-mst@kernel.org>
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-2-hreitz@redhat.com>
 <20230412205138.GA2813183@fedora>
 <0ca69a92-49ab-223e-b737-9d8655883f38@redhat.com>
 <CAJSP0QWOu5vW_fWc+UKfemrfhgGvJjNJmifVGCyRaP895AXocg@mail.gmail.com>
 <da5c06fe-3422-709a-9782-66e338cc7c85@yandex-team.ru>
MIME-Version: 1.0
In-Reply-To: <da5c06fe-3422-709a-9782-66e338cc7c85@yandex-team.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH 1/4] vhost: Re-enable vrings after setting
 features
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Anton Kuchin <antonkuchin@yandex-team.ru>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, Hanna Czenczek <hreitz@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Juan Quintela <quintela@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Roman Kagan <rvkagan@yandex-team.ru>, Maxime Coquelin <maxime.coquelin@redhat.com>, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>

On Thu, Apr 13, 2023 at 05:24:36PM +0300, Anton Kuchin wrote:
> But is there a valid use-case for logging some dirty memory but not all?
> I can't understand if this is a feature or a just flaw in specification.

IRC the use-case originally conceived was for shadow VQs.  If you use
shadow VQs the VQ access by backend does not change memory since shadow
VQ is not in memory. Not a practical concern right now but there you
have it.

-- 
MST

