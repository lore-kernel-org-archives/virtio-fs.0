DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
	t=1635065903; bh=dD8dXDoxhsiv3aVbIMH+KbCkZLBdqBRvk70WTels+jU=;
	h=Date:From:To:Subject:From;
	b=LJy/JHnduO8Dx40N0Bv2ZfmscT3gy2sHQ6wZcHq0WQ/exvmVphshjhsw+nYjRyk9w
	xU1hf6QIw757BNyNjuztO13HfeiYXCZZ0q6LETP5JKQUC/VLrE5DdLzb74XMLEaVzP
	j9qRJc4XoOEAaqJ/wLjWwjUSmaPsC0OsQPiD+t4RH/HPFwzlr8g4o0lWEp50T/tBwn
	5SM9BpIHpwpYi2byQBSxhLyZFRhiB9kuchz9FQDCi6eRjuX6SAN1PO2j7860fx5RrO
	N9+N6eYuP3yHPASJr6t+gORl7F1VYOEqpwkVuiohvSVpaKkBD4E2F1sP7qE586f+CE
	sSTp4FQulMnZA==
MIME-Version: 1.0
Date: Sun, 24 Oct 2021 08:58:22 +0000
From: birnenkram@posteo.de
In-Reply-To: <da06bc85359e36e0b7471dfaa0b937f8@posteo.de>
References: <5e79ba8579b33e60e9670f2fd99b1c1b@posteo.de>
	<da06bc85359e36e0b7471dfaa0b937f8@posteo.de>
Message-ID: <52d74a56e9fc2176200591617346e196@posteo.de>
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] write permissions for Windows host on Linux guest
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

One more thought after some further digging: This issue is very likely 
related to how WinFsp maps the permissions between Windows and Linux (so 
indeed whether one runs the shell as Administrator or not on the Windows 
guest would matter). See 
http://www.secfs.net/winfsp/doc/SSHFS-Port-Case-Study. The question is 
now how to "make it work" and whether this requires an update of WinFsp 
itself.

