Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=m1aaK3L/+fA1S5eKN82KltOBbvGbfJ4TlIvoza+IPyw=;
 b=l3gTf7TUoc9iL/SgTiy+GEYudBjSTyVdGKME8sYqwLAFIObRvhzPW0QzYeRmjV89Qt
 NkrQ8MB2KMMGRqhxOI9to9n4zdrr0iffAlz9IO7TT/TIwNhJHSg12YVmT2T0Rx+KIDe+
 1se3ZT8O3VTdlCSOW2fMx/b3hEVxhlyz4uio1sock78pasPqdmJBP5eHXd8i3zwzXkU1
 Psx9tyhHdYpAd7zPHNEYkuEv2aNBipJMeL/XA3qCU95Ygk1Ha5wBNWt1uVz6kWuyEJTZ
 YAJdTu3aCzEYkq0e6tvsgzu2o1fc0j72imSwtdy43wi8JzSBEHCHi862XgiGzWV96uni
 S7aw==
MIME-Version: 1.0
References: <20221125143946.27717-1-mhartmay@linux.ibm.com>
In-Reply-To: <20221125143946.27717-1-mhartmay@linux.ibm.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Fri, 25 Nov 2022 15:50:39 -0500
Message-ID: <CAJSP0QVJJYAaY_9a-DTmKqFJ+yRKAoASBMXuqNuZHghk3KN9aQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Add `sigreturn` to the seccomp
 whitelist
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Marc Hartmayer <mhartmay@linux.ibm.com>
Cc: qemu-devel@nongnu.org, qemu-s390x <qemu-s390x@nongnu.org>, virtio-fs@redhat.com, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Stefan Liebler <stli@linux.ibm.com>

Thanks, applied to qemu.git/master.

Stefan

