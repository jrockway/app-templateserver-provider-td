package My::Template;
use base 'Template::Declare';
use Template::Declare::Tags;

template simple => sub {
    html {
        head {};
        body { "Hello, world!" };
    };
};

package main;
use strict;
use warnings;
use Test::More tests => 3;

use ok 'App::TemplateServer::Provider::TD';
use App::TemplateServer::Context;
use App::TemplateServer;

my $ts = App::TemplateServer->new(
    provider_class => 'TD',
    docroot => ['My::Template']
);

my $provider = $ts->provider;
is_deeply [$provider->list_templates], ['simple'];
like $provider->render_template('simple', {}), qr{<body>Hello, world.</body>};
