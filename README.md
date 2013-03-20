eve-helloworld
==============

A hello-world application to demostrate the eve framework.

About
=============

This is a simple "Hello World" web service that is intended to be used with a PSGI server. It sets up a simple controller that shows a page with the "Hello, World!" text.

Setup
-------------

***Instructions are only available for nginx and [Plack](http://plackperl.org/) so far, if you have any questions about using this code with other software, feel free to contact me.***

**Setting up the daemon**

First make sure you have all the prerequisites installed for [eve](https://github.com/zinigor/eve), as well as for running a FCGI daemon on perl. For instance, to successfully run a daemon with `plackup` on Ubuntu you have to install the following packages:

    sudo apt-get install libplack-perl libfcgi-perl libfcgi-procmanager-perl

After that you are ready to go. Change to the folder you have cloned this repo into and run the daemon:

    plackup -I /var/www/path/to/eve/lib -s FCGI --listen /tmp/fcgi.socket bin/http.psgi

*Note that if you have eve installed and have its `lib` folder already in the perl path, you don't need to set the -I parameter*

After running this command you should have a daemon ready to be plugged into nginx. If something goes wrong, check out the Troubleshooting section below.

**Setting up nginx**

To make nginx forward all requests to this daemon, add this server directive to its configuration:

    server {
      server_name localhost;
      listen      127.0.0.1;
    
      location / {
        fastcgi_pass   unix:/tmp/fcgi.socket;
    
        fastcgi_param  SERVER_NAME      localhost;
        fastcgi_param  SERVER_PORT      80;
        fastcgi_param  SCRIPT_NAME      /tmp$fastcgi_script_name;
        fastcgi_param  QUERY_STRING     $query_string;
        fastcgi_param  REQUEST_METHOD   $request_method;
        fastcgi_param  CONTENT_TYPE     $content_type;
        fastcgi_param  CONTENT_LENGTH   $content_length;
      }
    }

*Please note:* this test example relies on the `SCRIPT_NAME` parameter being prefixed with the `/tmp` string. This is due to nginx restricting this variable's value so that it can not be empty (root folder). This is why you can see in the `http.psgi` that the first four characters of this value are being cut out. If you have a better solution in mind, please tell me, or better yet - fork and fix it. I will gladly accept any help!

Check if everything is OK and restart nginx:

    sudo /etc/init.d/nginx configtest && sudo /etc/init.d/nginx restart
  
Now if everything's fine, you should see the "Hello, World!" page at your http://localhost.

Troubleshooting
---

If your daemon doesn't start check the error output. When there's something wrong with eve or path to eve it will usually say something like this:

    Error while loading bin/http.psgi: Can't locate Eve/Registry.pm

Check that eve's `lib` folder is in your perl path or just specify it explicitly with an `-I` switch to `plackup`.
