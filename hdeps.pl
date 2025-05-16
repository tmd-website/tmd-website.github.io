#!/usr/bin/env perl

$quoted = qr{
    " (?<content> (?: [^"\\] | \\. )* ) "
  | ' (?<content> (?: [^'\\] | \\. )* ) '
  | (?<content> [\w\-.]+ )
  }x;

$field = qr{
    (?: src | href | url | srcset | data-src | data-srcset | poster )
}x;

$\ = "\n";
while (<>) {
    if (/^(.*)<!--/) {
        while ($1 =~ m/$field=$quoted/g) {
            print $+{content} unless $+{content} =~ m/^http/;
        }
        unless (m/-->/) {
            while (<>) {
                last if /-->/;
            }
        }
        s/.*-->//;
    }
    while (m/$field=$quoted/g) {
        print $+{content} unless $+{content} =~ m/^http/;
    }
}
