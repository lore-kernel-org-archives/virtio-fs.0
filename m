DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
	t=1631627790; bh=ygtUBCZQlhsvVy8Mpq3cPYmpcsoXg4q8Q+Bm6VPv8k4=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To;
	b=UEHypIEim9VjqtsSFhyqQ/uCX1GPPf9LAeQIGOEVA3SZi5lSmDMB+qnIohAPxtB/jCxuIuSIlel0uvsao5GwR/nhRcvdgY1GGcHfuWN6Y22xCd2EGpEiobK5cvTW7Frp9xIPgLPHR/tTUlXlV76aA5RE85dPqcGGXVB2iH9PWp49PJLaJ+pIrNLV7aNgvMV/s+opH1yS2rgsuqeQs5wATILM02eRvAzrYmPQWXXR7LQwhF5oMKcS+/M2BWZ5ZozvyCu9Gp1chd4ilqIZezdv6AHU2wWQs+wP7Bh4rFeAMmFVe85AiR6gs6VHAKvqWkyOuxsOXgZo7X/wmEzgBhGTsQ==
References: <20210902152228.665959-1-vgoyal@redhat.com>
	<79dcd300-a441-cdba-e523-324733f892ca@schaufler-ca.com>
	<YTEEPZJ3kxWkcM9x@redhat.com> <YTENEAv6dw9QoYcY@redhat.com>
	<3bca47d0-747d-dd49-a03f-e0fa98eaa2f7@schaufler-ca.com>
	<YTEur7h6fe4xBJRb@redhat.com>
	<1f33e6ef-e896-09ef-43b1-6c5fac40ba5f@schaufler-ca.com>
	<YTYr4MgWnOgf/SWY@work-vm>
	<496e92bf-bf9e-a56b-bd73-3c1d0994a064@schaufler-ca.com>
	<YUCa6pWpr5cjCNrU@redhat.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <b52527f7-62bb-4d20-9faa-0a085a0ca7a2@schaufler-ca.com>
Date: Tue, 14 Sep 2021 06:56:25 -0700
MIME-Version: 1.0
In-Reply-To: <YUCa6pWpr5cjCNrU@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH v3 0/1] Relax restrictions on user.* xattr
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: gscrivan@redhat.com, tytso@mit.edu, agruenba@redhat.com, miklos@szeredi.hu, selinux@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>, stephen.smalley.work@gmail.com, david@fromorbit.com, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, casey.schaufler@intel.com, linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, bfields@redhat.com, christian.brauner@ubuntu.com

On 9/14/2021 5:51 AM, Vivek Goyal wrote:
> Sorry, I have to repeat this so many times because you are 
> completely ignoring this requirement saying users will get it
> wrong. 

And I keep repeating myself because you are still wrong.
Configuration won't fix the problem. Tools won't fix the
problem. Your scheme is broken. Don't do it.

