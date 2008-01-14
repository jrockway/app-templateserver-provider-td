use inc::Module::Install;

name 'App-TemplateServer-Provider-TD';
all_from 'lib/App/TemplateServer/Provider/TD.pm';

build_requires 'Catalyst::Runtime';
build_requires 'Test::WWW::Mechanize::Catalyst';
build_requires 'Test::More';
build_requires 'ok';

WriteAll();
