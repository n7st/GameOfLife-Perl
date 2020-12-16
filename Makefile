dependencies:
	dzil listdeps --missing | cpanm

test:
	prove -lv t/**/*.t
