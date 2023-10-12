
all: tuqui.image

pharo pharo-ui Pharo.image:
	curl https://get.pharo.org/64/110+vm | bash
	
tuqui.image: pharo Pharo.image
	./pharo Pharo.image save tuqui
	./pharo $@ eval --save "Metacello new baseline: 'Tuqui'; repository: 'github://melkyades/tuqui-pharo:main/'; load"
	@echo ""
	@echo "To open Tuqui image run:"
	@echo ""
	@echo "    ./pharo-ui tuqui.image"
	@echo ""
	
clean:
	rm -f tuqui.*
#	./pharo $@ eval --save "SystemWindow closeTopWindow. GTPlayground openContents: 'first-steps.st' asFileReference contents withSqueakLineEndings"
	
#		./pharo $@ eval --save "(IceRepositoryCreator new location: '.' asFileReference; createRepository) register"
#	./pharo $@ metacello install github://melkyades/tuqui-pharo BaselineOfTuqui --groups=default

