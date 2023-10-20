Return-Path: <manos.pitsidianakis@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1697792652; x=1698397452; darn=redhat.com;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to
 :references:user-agent:subject:cc:to:from:date:from:to:cc:subject
 :date:message-id:reply-to;
 bh=LV+TTpoR2W5z/eLtMV7w5gTIRRPNVNLtDhd8ldgJh+U=;
 b=MsmZ/evljEWBJrN6YjIxnrplcJNIQK9B8QLoJ3dpkI4ueumdZRBj1Ay+5DYeLVqpb0
 7zZs0ym3Z5Nx65kGESxCaXN6JVGuJbrpGz+7ONdbPs78uECFnd8ayPExnQrA4GeBtLN6
 uxrdbfN2BGKjFPoN1oN5IlTMM83CmGCQ4k7r8LcNkl2SqYDeuXQe4bC/Eht7Jg+kvE5i
 ee0hQ2mOKCL6ixJbNAygWDRjGTzBoB7X7bcloYzGn7/mSe2ubQJ+pRztXPThhGrb9HYi
 apuH3ArZAl3u1GqUnETOSPDt1kaUIz2h4mtMCk4CLgdIl649Cvz2jNfmQtuZcTTHET1+
 4uQg==
Date: Fri, 20 Oct 2023 12:03:50 +0300
From: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
References: <20231019095610.2818087-1-alex.bennee@linaro.org>
 <20231019095610.2818087-6-alex.bennee@linaro.org>
 <20231020031407.xd4ykc4msfdmoav5@vireshk-i7> <878r7x90a0.fsf@linaro.org>
 <20231020050210-mutt-send-email-mst@kernel.org>
In-Reply-To: <20231020050210-mutt-send-email-mst@kernel.org>
Message-ID: <2tl6x.csk4mc5p2sx@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"; format="flowed"
Subject: Re: [Virtio-fs] [PATCH v5 5/6] hw/virtio: add vhost-user-snd and
 virtio-snd-pci devices
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Michael S. Tsirkin" <mst@redhat.com>, Alex Benn=?UTF-8?B?w6k=?= e <alex.bennee@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, qemu-devel@nongnu.org, "Daniel P. Berrang=?UTF-8?B?w6k=?= " <berrange@redhat.com>, virtio-fs@redhat.com, Eduardo Habkost <eduardo@habkost.net>, Fam Zheng <fam@euphon.net>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, Hanna Reitz <hreitz@redhat.com>, Eric Blake <eblake@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Jason Wang <jasowang@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, Marc-Andr=?UTF-8?B?w6kg?=Lureau <marcandre.lureau@redhat.com>, Markus Armbruster <armbru@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Manos Pitsidianakis <manos.pitsidianakis@linaro.org>

On Fri, 20 Oct 2023 12:02, "Michael S. Tsirkin" <mst@redhat.com> wrote:
>On Fri, Oct 20, 2023 at 09:16:03AM +0100, Alex Bennée wrote:
>> 
>> Viresh Kumar <viresh.kumar@linaro.org> writes:
>> 
>> > On 19-10-23, 10:56, Alex Bennée wrote:
>> >> From: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
>> >> 
>> >> Tested with rust-vmm vhost-user-sound daemon:
>> >> 
>> >>     RUST_LOG=trace cargo run --bin vhost-user-sound -- --socket /tmp/snd.sock --backend null
>> >> 
>> >> Invocation:
>> >> 
>> >>     qemu-system-x86_64  \
>> >>             -qmp unix:./qmp-sock,server,wait=off  \
>> >>             -m 4096 \
>> >>             -numa node,memdev=mem \
>> >>             -object memory-backend-file,id=mem,size=4G,mem-path=/dev/shm,share=on \
>> >>             -D qemu.log \
>> >>             -d guest_errors,trace:\*snd\*,trace:\*sound\*,trace:\*vhost\* \
>> >>             -chardev socket,id=vsnd,path=/tmp/snd.sock \
>> >>             -device vhost-user-snd-pci,chardev=vsnd,id=snd \
>> >>             /path/to/disk
>> >> 
>> >> [AJB: imported from https://github.com/epilys/qemu-virtio-snd/commit/54ae1cdd15fef2d88e9e387a175f099a38c636f4.patch]
>> >> 
>> >> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
>> >
>> > Missing SOB from Manos ?
>> 
>> oops, guess I need a respin then ;-)
>
>Just ask Manos to send his S.O.B in a reply.

Signed-off-by: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>

