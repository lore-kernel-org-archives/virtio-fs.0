Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1649874859; x=1649961259; bh=PpjFMT9SIXY4LoDU+DJBM
 HecofwmZ8z0Dhj63VOPHt0=; b=X86r6/JAy7AVbaZIvdhwxL1a14HVwLQny7DUQ
 9t5jVyEWOdtEZCUbuhNdKl8d04JWT3V9mSkNUkszoiu4b7D8kNR0T7KuvtFCPEzf
 RwU9rAP6q3CtXMPun03d1WJ60OuHDZN+Y3erJQGieRYcFPaMpwtJFB6u1Sl1oFy6
 F4/tv1NgCclpL1NCO6VvIqZKfNQBCjXcYMK5CNlH/D9sJhjrTzJWyueKQbrbEjJB
 SZsBAKWPFsc7BUaML0hdYUjdEOzG5KW2FWx2CauXFRgLZpFhg2B/fbb/RGb/9W2L
 LB0Abkw0Ic2YtHi0hr6F/FfHa/449lo5wxAZLRVenCChfk1Yw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm1; t=1649874859; x=1649961259; bh=P
 pjFMT9SIXY4LoDU+DJBMHecofwmZ8z0Dhj63VOPHt0=; b=PScQ0smyKFrRRGKrw
 Nb93pjZQH11QwN3Ri56385KbsL5Z4gY9EjhvxrTgKHQBGmeqBAvFYoTvkie/fGpr
 Wsnkx1MPcbET919/eLQJt/n8jXjWeKorbKZBxFG/v54QEPgt6YmxAcynmxMEE+NW
 0wc+K0SeFVQ1wMwBJZeUe0k/nNRbKyg5zItc8pHVYV7TduRA6khKxaZeHniPqDDx
 4xyCkyDJplIEvn3Zh/CsCCVcdNaV+/6kVxtECrEmtcHtg9eTtL9Hmr1HS3PusriS
 2dqryV+NLqlpXCXZG9Tu4FsIImgLqWnRZt2exK1cH3gAkKnSImcxoE+EFcJFeMC+
 DiHUQ==
From: virtiofs-bot@sinrega.org
Message-Id: <39842.122041314342000118@us-mta-479.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Wed, 13 Apr 2022 18:34:22 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: virtiofsd process's fd keeps
 increasing, not decreasing
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

1. The directory /mnt/a of the virtual machine container is mounted on /mnt/b of the host. At this time, the process of virtiofsd runs in the background of the host. Assuming that the pid of virtiofsd is 100,
2. Then enter /mnt/a of the virtual machine container, and execute the ls or touch command on the terminal
3. Execute ls -l /proc/100/fd on the host, and you will find that the file fd displayed by the ls or touch command just executed is not closed
hope to answer
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/45

