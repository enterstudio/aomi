all: test package

version:
	cp version aomi/version

package: version
	python setup.py sdist

test: version
	test -d .ci-env || ( mkdir .ci-env && virtualenv .ci-env )
	.ci-env/bin/pip install -r requirements.txt -r requirements-dev.txt
	.ci-env/bin/pep8 aomi
	.ci-env/bin/pylint --rcfile=/dev/null aomi
	.ci-env/bin/nose2
	./scripts/integration

clean:
	rm -rf aomi.egg-info dist .aomi-test

distclean: clean
	rm -rf build .ci-env aomi/version .vault .bats

container:
	./scripts/container

.PHONY: all version package test clean distclean container
