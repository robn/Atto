[![Build Status](https://secure.travis-ci.org/robn/Atto.png)](http://travis-ci.org/robn/Atto)

# NAME

Atto - A tiny microservice builder

# SYNOPSIS

    use Atto qw(hello);
    
    sub hello {
        my (%args) = @_;
        my $name = $args{name} // "world";
        return "hello $name";
    }
    
    Atto->psgi;

# WARNING

This module is experimental. I think the idea is sound but I haven't used it
enough to know if it needs to offer more functions. Take care when using this
in your own code. If you do use it, please let me know!

# DESCRIPTION

Atto makes it trivial to create HTTP+JSON microservices out of regular Perl
code.

Adding it to your code is simple. When you `use Atto`, pass it it a list of
methods (subs) in the same package that you want to make available to the
network:

    use Atto qw(hello);

Then, at the end of your program (or module!), call `Atto->psgi`. This returns a
PSGI application that can be consumed by `plackup`.

    $ plackup hello.pl 
    HTTP::Server::PSGI: Accepting connections at http://0:5000/

To call your methods from the network, send a POST request with the method
(sub) name in the URL:

    $ curl -XPOST http://localhost:5000/hello
    "hello world"

To pass arguments to the method, encode them as JSON in the request body and
add a `Content-type: application/json` header to the request:

    $ curl -XPOST -d '{"name":"dave"}' -H 'Content-type: application/json' http://localhost:5000/hello
    "hello dave"

Arguments are flattened just like in Perl, so passing a JSON array or object
will do what you expect.

Alternatively, you can pass a hash via form parameters, which is less
expressive but easier in many scenarios:

    $ curl -d 'name=dave' http://localhost:5000/hello
    "hello dave"

or with a GET and query parameters:

    $ curl http://localhost:5000/hello?name=dave
    "hello dave"

Methods should return a single value, which is then JSON-encoded for the
return. This can be a simple string or number or a hash or array ref.

# HISTORY & DESIGN

The idea behind Atto is to make it trivial to get existing Perl library code
available via the network.

I needed to write a small aggregator service that things all over my network
could send events to. It collects them, processes them and generates reports.
It's not a new or particularly interesting service. Much of the code I needed
is already written in libraries I already have. All I needed to do was expose a
couple of methods to the network.

There's many excellent libraries to write web services for Perl, and I looked
at a lot of them. All of them, even the "simple" ones, provide a variety of
tools to let you build your application in the way you want to without
enforcing very much, which meant it was left to me to deal with sanitising the
request, parsing the incoming JSON, dispatching the call, then building a
response. None of this was hard but it was things I had to learn and test that
I didn't want to think about because none of it was relevant to the task at
hand.

So I fell back on code I'd already written in the past. I took
[hopscotch](https://github.com/fastmail/hopscotch), a pure-PSGI image proxy I
wrote, and stripped it back to just what I needed to call a method based on the
URL. Once that was done, I looked at it and realised that the only interesting
part of the whole program was the sub that did the actual work of my
application. The rest was just boilerplate to get it onto the network.

Atto is what I got when I lifted that boilerplate out into a module.

The whole point of Atto is that you don't need to think to get your code onto
the network. That's why it has no options and barely any interface. As soon as
you have options, you have to think about what to set them to and now you're
not thinking about your problem anymore.

Of course, that won't suit every need - this is not a toolbox or a framework or
whatever else you want to call it. For that, I refer you to one of the many
fine web frameworks available on the CPAN.

As for the name, [atto-](https://en.wikipedia.org/wiki/Atto-) is the SI unit
prefix denoting 10^-18. It's the next one after femto, so it's pretty small,
but zepto and yocto are still available if you want to go even smaller ;)

# SUPPORT

## Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at [https://github.com/robn/Atto/issues](https://github.com/robn/Atto/issues).
You will be notified automatically of any progress on your issue.

## Source Code

This is open source software. The code repository is available for
public review and contribution under the terms of the license.

[https://github.com/robn/Atto](https://github.com/robn/Atto)

    git clone https://github.com/robn/Atto.git

# AUTHORS

- Robert Norris <rob@eatenbyagrue.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015-2016 by Robert Norris.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
