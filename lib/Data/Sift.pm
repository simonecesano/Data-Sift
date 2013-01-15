use strict;
use warnings;
package Data::Sift;

use Moose;

use Data::Dump qw/dump/;

use Memoize;

memoize('parse_header');

has 'sift' => (
	       is => 'ro'
	      );

has 'field_indexes' => (
		    is => 'rw'
);

has 'output_fields' => (
			traits  => ['Array'],
			isa     => 'ArrayRef[Int]',
			is => 'rw'
		       );
has 'validate_function' => ( 
			    is => 'rw',
			    default => sub { sub { 1 } }
			   );

around BUILDARGS => sub {
    my $orig = shift;
    my $class = shift;
    
    if ( @_ == 1 && (ref $_[0] eq 'ARRAY') ) {
	return $class->$orig( { sift => $_[0] } );
    } else {
	return $class->$orig(@_);
    }
};

sub parse_header {
    my $self = shift;

    my @header = @_;

    my %header; @header{@header} = (0..$#header);

    for my $s (@{$self->sift}) {
	# a scalar => check that it's in the header, add to output array  
	# a 2-el arrayref => check that it's in the header, add to validate rule and to output array  
	# a 3-el arrayref with a minus => check that it's in the header, add to validate rule  
	# a 3-el arrayref with a plus => add to validate rule, add to output array
    }


    my @idx = grep { defined } map { $header{$_} } $self->output_field_names;

    # do stuff here if some fields are not to be output

    $self->field_indexes(\%header);
    $self->_mk_validate_func;
    return $self->output_fields(\@idx);
}

sub output_field_names {
    return map { ref $_ ? $_->[0] : $_ } grep { !ref $_ || $_->[2] =~ /\-|\+/ } @{ shift->sift };
}

sub additional_fields {
    return map { $_->[0] } grep { ref $_ && $_->[2] eq '+' } @{ shift->sift };
}

sub error {
    return 'error';
}

sub _mk_validate_func {
    my $self = shift;

    # here count the output fields
    # and if the field is additional, put it at the end

    my @d = map { [ $self->field_indexes->{$_->[0]} => $_->[1] ] } grep { ref $_ } @{$self->sift};

    my $v = sprintf 'sub {  %s }',
	join ' && ',
	    map {
		if ($_->[1] =~ /^sub/) {
		    sprintf $_->[1] . '->($_[0][%s])', $_->[0];
		} elsif ($_->[1] =~ /^\s*=\s*sub/) {
		    local $_ = $_->[1]; s/^\s*=\s*//;
		    'defined (' . $_ . '->($_[0]))';
		} else {
		    sprintf '$_[0][%d] =~ /%s/', $_->[0], $_->[1]
		} 
	    } @d;
    $self->validate_function(eval $v);
}

__PACKAGE__->meta->make_immutable;

1;


__DATA__
