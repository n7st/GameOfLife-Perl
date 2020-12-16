package Life::Tile;

use Moo;
use Types::Standard qw(Bool Str);

has chr_alive => (is => 'ro', isa => Str, required => 1);
has chr_dead  => (is => 'ro', isa => Str, required => 1);

has alive      => (is => 'rw', isa => Bool, default => 0);
has next_state => (is => 'rw', isa => Bool, default => 0);

sub determine_state {
    my $self             = shift;
    my $alive_neighbours = shift;

    if ($self->alive) {
        $self->flip if $alive_neighbours != 2 && $alive_neighbours != 3;
    } else {
        $self->flip if $alive_neighbours == 3;
    }

    return 1;
}

sub flip {
    my $self = shift;

    return $self->next_state(!$self->alive || 0);
}

sub render {
    my $self = shift;

    return $self->alive ? $self->chr_alive : $self->chr_dead;
}

1;

