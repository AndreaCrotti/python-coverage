# Makefile for utility work on Coverage.

default:
	@echo "* No default action *"

TEST_ZIP = test/zipmods.zip
TEST_EGG = test/eggsrc/dist/covtestegg1-0.0.0-py*.egg

clean:
	python test/test_farm.py clean
	-rm -rf build coverage.egg-info dist htmlcov
	-rm -f *.pyd */*.pyd
	-rm -f *.pyc */*.pyc */*/*.pyc */*/*/*.pyc */*/*/*/*.pyc */*/*/*/*/*.pyc
	-rm -f *.pyo */*.pyo */*/*.pyo */*/*/*.pyo */*/*/*/*.pyo */*/*/*/*/*.pyo
	-rm -f *.bak */*.bak */*/*.bak */*/*/*.bak */*/*/*/*.bak */*/*/*/*/*.bak
	-rm -f *$$py.class */*$$py.class */*/*$$py.class */*/*/*$$py.class */*/*/*/*$$py.class */*/*/*/*/*$$py.class
	-rm -f coverage/*,cover
	-rm -f MANIFEST
	-rm -f .coverage .coverage.* coverage.xml
	-rm -f $(TEST_ZIP)
	-rm -rf test/eggsrc/build test/eggsrc/dist test/eggsrc/*.egg-info
	-rm -f setuptools-*.egg
	-rm -rf doc/_build/*

LINTABLE = coverage setup.py test

lint:
	-python -x /Python25/Scripts/pylint.bat --rcfile=.pylintrc $(LINTABLE)
	python /Python25/Lib/tabnanny.py $(LINTABLE)
	python checkeol.py

pep8:
	pep8 --filename=*.py --ignore=E401,E301 --repeat coverage

testready: testdata devinst

tests: testready
	nosetests

testdata: $(TEST_ZIP) $(TEST_EGG)
$(TEST_ZIP): test/covmodzip1.py
	zip -j $@ $+

$(TEST_EGG): test/eggsrc/setup.py test/eggsrc/egg1/egg1.py
	cd test/eggsrc; python setup.py -q bdist_egg

kit:
	python setup.py sdist --formats=gztar
	python setup.py bdist_wininst

pypi:
	python setup.py register

install:
	python setup.py install

DEVINST_FILE = coverage.egg-info/PKG-INFO
devinst: $(DEVINST_FILE)
$(DEVINST_FILE): coverage/tracer.c
	-rm coverage/tracer.pyd
	python setup.py develop

uninstall:
	-rm -rf $(PYHOME)/lib/site-packages/coverage*
	-rm -rf $(PYHOME)/scripts/coverage*

SPHINXBUILD = sphinx-build
SPHINXOPTS = -a -E doc
WEBHOME = c:/ned/web/stellated/pages/code/coverage

px:
	$(SPHINXBUILD) -b px $(SPHINXOPTS) doc/_build/px
	rm doc/_build/px/search.px
	@echo
	@echo "Build finished. The PX files are in doc/_build/px."

dochtml:
	$(SPHINXBUILD) -b html $(SPHINXOPTS) doc/_build/html
	@echo
	@echo "Build finished. The HTML pages are in doc/_build/html."

publish:
	rm -f $(WEBHOME)/*.px
	cp doc/_build/px/*.px $(WEBHOME)
	rm -f $(WEBHOME)/sample_html/*.*
	cp doc/sample_html/*.* $(WEBHOME)/sample_html
