package Life::Grid;

use Moo;
use Types::Standard qw(ArrayRef InstanceOf Int Str);

use Life::Tile;

has chr_tile_alive => (is => 'ro', isa => Str, required => 1);
has chr_tile_dead  => (is => 'ro', isa => Str, required => 1);

has tiles => (is => 'ro', isa => ArrayRef[ArrayRef[InstanceOf['Life::Tile']]], lazy => 1, builder => 1);

has dimension => (is => 'ro', isa => Int, default => 50);

sub modify_tile_at {
    my $self = shift;
    my $x    = shift;
    my $y    = shift;
    my $cref = shift;

    return unless $self->tiles->[$y];

    my $tile = $self->tiles->[$y]->[$x];

    return unless $tile;

    return $cref->($tile);
}

sub lifecycle {
    my $self = shift;

    foreach my $row (@{$self->tiles}) {
        foreach my $tile (@{$row}) {
            $tile->alive($tile->next_state);
        }
    }

    for (my $y = 0; $y < @{$self->tiles}; $y++) {
        my $row = $self->tiles->[$y];

        for (my $x = 0; $x < @{$row}; $x++) {
            $self->modify_tile_at($x, $y, sub {
                my $tile = shift;

                my $alive_count = $self->_alive_neighbours($x, $y);

                $tile->determine_state($alive_count);
            });
        }
    }

    return 1;
}

sub render {
    my $self = shift;

    my $output = q{};

    for (my $y = 0; $y < @{$self->tiles}; $y++) {
        my $row = $self->tiles->[$y];

        for (my $x = 0; $x < @{$row}; $x++) {
            $output .= $row->[$x]->render;
        }

        $output .= "\n";
    }

    chomp $output;

    return $output;
}

sub seed {
    my $self        = shift;
    my $coordinates = shift;

    foreach my $coordinate (@{$coordinates}) {
        $self->modify_tile_at($coordinate->{x}, $coordinate->{y}, sub {
            my $tile = shift;

            $tile->flip;
        });
    }

    return 1;
}

sub _alive_neighbours {
    my $self = shift;
    my $x    = shift;
    my $y    = shift;

    my $alive_neighbours = 0;
    my @possible         = (
        { x => $x + 1, y => $y     },
        { x => $x + 1, y => $y - 1 },
        { x => $x + 1, y => $y + 1 },
        { x => $x,     y => $y - 1 },
        { x => $x,     y => $y + 1 },
        { x => $x - 1, y => $y     },
        { x => $x - 1, y => $y - 1 },
        { x => $x - 1, y => $y + 1 },
    );

    foreach my $p (@possible) {
        if ($self->tiles->[$y]) {
            if (my $neighbour = $self->tiles->[$p->{y}]->[$p->{x}]) {
                if ($neighbour->alive) {
                    $alive_neighbours++;
                }
            }
        }
    }

    return $alive_neighbours;
}

sub _build_tiles {
    my $self = shift;

    my @rows;

    for (my $y = 0; $y < $self->dimension; $y++) {
        my @row;

        for (my $x = 0; $x < $self->dimension; $x++) {
            push @row, Life::Tile->new({
                chr_alive => $self->chr_tile_alive,
                chr_dead  => $self->chr_tile_dead,
            });
        }

        push @rows, \@row;
    }

    return \@rows;
}

1;

