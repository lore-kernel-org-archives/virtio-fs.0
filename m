Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=Hr0dgoHtifo6ZQFNT3To4gYl+dOd8XLgJ/IYxFEIioU=;
 b=G9nlST8vtzdyF8ZjuzB+78zKSk4ZgxkGRG4q3AG9TzkSmcqcNtv7oOqG48OxHNgGLB
 R1/0broziPy7RBae5VNid/ygRwspP2CV8xGIMLSOjgPW0P4dcXWgSu47L+6Fg/yTUmYI
 sgzlkCMI8AJQ2RE8Vu4JKyTrjv+mvLCPnoALfuoVzbJ23Cmr6hoMZaKOFFJbsYHHGvDG
 XPFDyGHwQxw3okFfOhGYsHGmNFZ9EgmSBg/J5LBHV+8XtPjLi+FV+cIwg6eZzcZi88He
 j6AGYPielKFHsYRgs61KeK0UGKwxJKag9whhtFosgq9uhRpokfpFqzNX1WpBVab1y38x
 5zyg==
MIME-Version: 1.0
References: <20230118153833.102731-1-dgilbert@redhat.com>
In-Reply-To: <20230118153833.102731-1-dgilbert@redhat.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Wed, 18 Jan 2023 11:00:13 -0500
Message-ID: <CAJSP0QX9TnaWnkhAneFzZsj0A+c4j0A9mCPSy1i31a3dOnhWbA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH 0/3] Remove C virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com, hczenczek@redhat.com, gmaglione@redhat.com, virtio-fs@redhat.com, pbonzini@redhat.com, alex.bennee@linaro.org

Acked-by: Stefan Hajnoczi <stefanha@redhat.com>

