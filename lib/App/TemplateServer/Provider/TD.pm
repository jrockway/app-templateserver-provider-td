package App::TemplateServer::Provider::TD;
use Moose;
use Method::Signatures;
use Template::Declare;
require Module::Pluggable::Object;

with 'App::TemplateServer::Provider';

method BUILD {
    my $template_root = $self->docroot. q{}; # not a path; evil.
    my $mpo = Module::Pluggable::Object->new(
        require     => 0,
        search_path => $template_root,
    );    
    my @extras = $mpo->plugins;
    foreach my $extra (@extras) {
        # load module
        if (!eval "require $extra"){
            die "Couldn't include $extra: $@";
        }
    }
    Template::Declare->init(roots => [$template_root, @extras]);
};

method list_templates {
    my @templates;
    my %templates = %{Template::Declare->templates};
    foreach my $package (keys %templates){
        push @templates, @{$templates{$package}||[]};
    }
    return @templates;
};

method render_template($template,$context) {
    
    Template::Declare->new_buffer_frame;
    my $out = Template::Declare->show($template) || "Rendering failed";
    Template::Declare->end_buffer_frame;
    
    $out =~ s/^\n+//g; # kill leading newlines
    return $out;
};

1;
__END__

=head1 NAME

App::TemplateServer::Provider::TD - use Template::Declare templates with App::TemplateServer
