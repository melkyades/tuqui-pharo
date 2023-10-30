Class {
	#name : #TuquiRingBootstrapper,
	#superclass : #Object,
	#instVars : [
		'image',
		'nilObj',
		'falseObj',
		'trueObj',
		'specs',
		'behavior2spec',
		'slotNames',
		'spec2behavior',
		'spec2class',
		'spec2metaclass',
		'smiSpec',
		'arraySpec',
		'classSpec',
		'identifiedObjects',
		'symbols'
	],
	#classVars : [
		'KernelSpec'
	],
	#category : #'Tuqui-Evaluation-Runtime'
}

{ #category : #accessing }
TuquiRingBootstrapper class >> kernelSpec [
	^ KernelSpec ifNil: [ KernelSpec := self readSpec: #Kernel at: '.' ]
]

{ #category : #accessing }
TuquiRingBootstrapper class >> readSpec: specName at: path [
	| root repo spec dir |
	root := '..' asFileReference.
	dir := root.
	repo := TonelRepository new directory: dir.
	spec := repo asRingEnvironmentWith: {specName}.
	^ spec clean
]

{ #category : #accessing }
TuquiRingBootstrapper class >> resetSpecs [

	"
		self resetSpecs
	"

	KernelSpec := nil.

]

{ #category : #initialization }
TuquiRingBootstrapper >> => aSymbol [
	^ specs at: aSymbol
]

{ #category : #accessing }
TuquiRingBootstrapper >> addClassToGlobals: def [

	| class symbol |
	class := spec2class at: def.
	symbol := self addSymbol: def name.
	image globals atKey: symbol put: class
]

{ #category : #accessing }
TuquiRingBootstrapper >> addSymbol: aSymbol [

	| new |
	(symbols symbolNamed: aSymbol) ifNotNil: [ :s | ^ s ].
	new := self newSymbol: aSymbol.
	^ new
]

{ #category : #building }
TuquiRingBootstrapper >> allSlotNamesOf: spec [

	| names |
	^ slotNames at: spec ifAbsentPut: [
		  names := spec allInstVarNames.
		  spec isMetaclass
			  ifTrue: [ classSpec allInstVarNames , names ]
			  ifFalse: [ names ] ]
]

{ #category : #accessing }
TuquiRingBootstrapper >> classFor: anRGBehavior [

	^ spec2class at: anRGBehavior
]

{ #category : #building }
TuquiRingBootstrapper >> classNamed: aString [
	^self classFor: self => aString
]

{ #category : #accessing }
TuquiRingBootstrapper >> compile: sourceCode in: species [

	| cm |
	cm := SCompiler new compile: sourceCode.
	^ self transferMethod: cm in: species
]

{ #category : #accessing }
TuquiRingBootstrapper >> createBehavior: definition [

	| size behavior metaclass metabehavior |
	size := (self => #Behavior) instSize.
	behavior := image basicNewBehavior: size.
	metaclass := definition metaclass.
	metabehavior := image basicNewBehavior: size.
	spec2behavior
		at: definition put: behavior;
		at: metaclass put: metabehavior.
	behavior2spec
		at: behavior put: definition;
		at: metabehavior put: metaclass
]

{ #category : #accessing }
TuquiRingBootstrapper >> createMethodDictionary: definition in: species [

	| md cm selector |
	md := self newVMDictionary: self => #MethodDictionary.
	definition methods do: [ :m |
		cm := self compile: m sourceCode in: species.
		selector := self ivarOf: cm named: #selector.
		md atKey: selector put: cm ].
	^ md
]

{ #category : #accessing }
TuquiRingBootstrapper >> createSpecies: definition [

	| class meta |
	class := self newSlotsOf: definition metaclass.
	meta := self newSlotsOf: self => #Metaclass.
	spec2class at: definition put: class.
	spec2metaclass at: definition metaclass put: meta
]

{ #category : #'private - helpers' }
TuquiRingBootstrapper >> createSymbolTable [

	| spec behavior instSize |
	spec := self => #SymbolSet.
	behavior := spec2behavior at: spec.
	instSize := spec instSize.
	symbols := image basicNewSlots: TqSymbolSet sized: instSize.
	symbols behavior: behavior.
	image symbols: symbols
]

{ #category : #accessing }
TuquiRingBootstrapper >> cvarOf: class named: aSymbol put: aTqObject [
	| cvars symbol |
	cvars := self ivarOf: class named: #classVars.
	symbol := self addSymbol: aSymbol.
	cvars atKey: symbol put: aTqObject.
]

{ #category : #accessing }
TuquiRingBootstrapper >> cvarOfSpec: spec named: aSymbol put: aTqObject [
	| class |
	class := spec2class at: spec.
	self cvarOf: class named: aSymbol put: aTqObject
]

{ #category : #accessing }
TuquiRingBootstrapper >> fixBehaviors [
	| behavior |
	nilObj behavior: (spec2behavior at: self => #UndefinedObject).
	trueObj behavior: (spec2behavior at: self => #True).
	falseObj behavior: (spec2behavior at: self => #False).	
	behavior := spec2behavior at: self => #Behavior.
	behavior2spec keysDo: [ :b | b behavior: behavior  ]
]

{ #category : #initialization }
TuquiRingBootstrapper >> formatOfClass: definition [
	| variable pointers  |
	variable := definition isVariable
		ifTrue: [ 16r2000 ]
		ifFalse: [ 0 ].
	pointers := definition isBytes
		ifTrue: [ 0 ]
		ifFalse: [ 16r4000 ].
	^ variable | pointers | definition allInstVarNames size
]

{ #category : #initialization }
TuquiRingBootstrapper >> formatOfMetaclass: definition [
	| variable pointers size |
	variable := definition isVariable
		ifTrue: [ 16r2000 ]
		ifFalse: [ 0 ].
	pointers := definition isBytes
		ifTrue: [ 0 ]
		ifFalse: [ 16r4000 ].
	size := (self => #Class) allInstVarNames size
		+ definition allInstVarNames size.
	^ variable | pointers | size
]

{ #category : #accessing }
TuquiRingBootstrapper >> genesis [
	"
	Create the world (should take less than 6 days). This is named 'genesis' to remind us those who had
	done this (and much more) before us. Namely SELF people. I (JV) would like to use this opportunity and point you to
	
	https://github.com/russellallen/self/blob/2bcf2c4cab23f52bf68ac4f617020e748699a548/vm/src/any/memory/universe.cpp#L79
	"

	nilObj := image nil.
	trueObj := image true.
	falseObj := image false.
	specs allClasses do: [ :def | self createBehavior: def ].
	self fixBehaviors.
	specs allClasses do: [ :def | self createSpecies: def ].
	self createSymbolTable.
	specs allClasses do: [ :def | self initializeSpecies: def ].
	image initializeFrom: self.
	self
		initializeCharacters;
		initializeClassVars; initializeGlobalDictionary.
	specs allClasses do: [ :def |
		self
			initializeMethodDictionary: def;
			initializeMethodDictionary: def metaclass;
			addClassToGlobals: def ]
]

{ #category : #initialization }
TuquiRingBootstrapper >> image [
	^image 
]

{ #category : #initialization }
TuquiRingBootstrapper >> initialize [

	specs := self class kernelSpec.
	smiSpec := self => #SmallInteger.
	arraySpec := self => #Array.
	classSpec := self => #Class.
	spec2class := IdentityDictionary new.
	spec2metaclass := IdentityDictionary new.
	spec2behavior := IdentityDictionary new.
	behavior2spec := IdentityDictionary new.
	slotNames := IdentityDictionary new.
	identifiedObjects := IdentityDictionary new.
	image := TuquiRuntime new wordSize: 8
]

{ #category : #'private - helpers' }
TuquiRingBootstrapper >> initializeBlockFlags [

	| spec argCount tempCount id capturesSelf capturesHome envCount |
	spec := self => #CompiledBlock.
	argCount := self newStretch: (1 thru: 6).
	tempCount := self newStretch: (7 thru: 14).
	id := self newStretch: (15 thru: 22).
	capturesSelf := self newInteger: (1 bitShift: 23 - 1).
	capturesHome := self newInteger: (1 bitShift: 24 - 1).
	envCount := self newStretch: (25 thru: 31).
	self
		cvarOfSpec: spec named: #ArgCount put: argCount;
		cvarOfSpec: spec named: #TempCount put: tempCount;
		cvarOfSpec: spec named: #Id put: id;
		cvarOfSpec: spec named: #CapturesSelf put: capturesSelf;
		cvarOfSpec: spec named: #CapturesHome put: capturesHome;
		cvarOfSpec: spec named: #EnvCount put: envCount
]

{ #category : #'private - helpers' }
TuquiRingBootstrapper >> initializeCharacters [

	| spec instSize array char integer local class |
	spec := self => #Character.
	instSize := spec instSize.
	array := self newArraySized: 255.
	1 to: 255 do: [ :i |
		char := self newSlotsOf: spec.
		integer := self newInteger: i.
		char slotAt: 1 put: integer.
		local := Character value: i.
		identifiedObjects at: local put: char ].
	class := spec2class at: spec.
	self cvarOfSpec: spec named: #ByteCharacters put: array
]

{ #category : #building }
TuquiRingBootstrapper >> initializeClass: definition superclass: superclass superbehavior: superbehavior [

	| class behavior name flag ivars cvars subclasses format |
	class := spec2class at: definition.
	behavior := spec2behavior at: definition.
	self
		ivarOf: behavior named: #class put: class;
		ivarOf: behavior named: #next put: superbehavior.
	subclasses := definition subclasses collect: [ :def |
		              spec2class at: def ].
	subclasses := self newArray: subclasses.
	name := self addSymbol: definition name.
	flag := self formatOfClass: definition.
	format := self newInteger: flag.
	ivars := self newStringArray: definition instVarNames.
	cvars := self newVMDictionary: self => #Dictionary.
	self
		ivarOf: class named: #superclass put: superclass;
		ivarOf: class named: #instanceBehavior put: behavior;
		ivarOf: class named: #format put: format;
		ivarOf: class named: #instanceVariables put: ivars;
		ivarOf: class named: #classVars put: cvars;
		ivarOf: class named: #name put: name;
		ivarOf: class named: #subclasses put: subclasses.
	definition metaclass allInstVarNames do: [ :ivar |
		class slotNamed: ivar put: nilObj ]
]

{ #category : #'private - helpers' }
TuquiRingBootstrapper >> initializeClassVars [

	self
		initializeSymbolTable;
		initializeBlockFlags;
		initializeClosureIndexes;
		initializeHashTable;
		initializeHashTablePolicy;
		initializeMethodFlags;
		initializeSmallInteger;
		initializeSpeciesCvars
]

{ #category : #'private - helpers' }
TuquiRingBootstrapper >> initializeClosureIndexes [

	| spec receiver parent |
	spec := self => #Closure.
	receiver := self newInteger: 1.
	parent := self newInteger: 2.
	self
		cvarOfSpec: spec named: #ReceiverIndex put: receiver;
		cvarOfSpec: spec named: #ParentEnvironmentIndex put: parent
]

{ #category : #accessing }
TuquiRingBootstrapper >> initializeGlobalDictionary [

	| globals |
	globals := self newVMDictionary: self =>#Dictionary.
	image globals: globals
]

{ #category : #'private - helpers' }
TuquiRingBootstrapper >> initializeHashTable [

	| spec obj sizes primes p |
	spec := self => #HashTable.
	obj := self newSlotsOf: self => #Object.
	self cvarOfSpec: spec named: #NilToken put: obj.
	sizes := ByteArray new: 126.
	primes := #( 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71
	             73 79 83 89 97 101 103 107 109 113 127 131 137 139 149
	             151 157 163 167 173 179 181 191 193 197 199 211 223 227
	             229 233 239 241 251 ) readStream.
	p := primes next.
	1 to: sizes size do: [ :i |
		| n |
		n := i * 2 - 1.
		p < n ifTrue: [ p := primes next ].
		sizes at: i put: p ].
	sizes := self newBytes: #ByteArray contents: sizes.
	self cvarOfSpec: spec named: #Sizes put: sizes
]

{ #category : #'private - helpers' }
TuquiRingBootstrapper >> initializeHashTablePolicy [

	| spec obj |
	spec := self => #HashTablePolicy.
	obj := self newSlotsOf: self => #Object.
	self cvarOfSpec: spec named: #EmptySlot put: obj
]

{ #category : #building }
TuquiRingBootstrapper >> initializeMetaclass: definition superclass: superclass superbehavior: superbehavior [

	| metadef meta class behavior ivars flags format |
	metadef := definition metaclass.
	meta := spec2metaclass at: metadef.
	class := spec2class at: definition.
	behavior := spec2behavior at: metadef.
	self
		ivarOf: behavior named: #class put: meta;
		ivarOf: behavior named: #next put: superbehavior.

	ivars := self newStringArray: metadef instVarNames.
	flags := self formatOfMetaclass: metadef.
	format := self newInteger: flags.
	self
		ivarOf: meta named: #superclass put: superclass;
		ivarOf: meta named: #instanceBehavior put: behavior;
		ivarOf: meta named: #format put: format;
		ivarOf: meta named: #instanceVariables put: ivars;
		ivarOf: meta named: #class put: class
]

{ #category : #building }
TuquiRingBootstrapper >> initializeMethodDictionary: spec [

	| species behavior  md |
	species := spec isMetaclass
		           ifTrue: [ spec2metaclass at: spec ]
		           ifFalse: [ spec2class at: spec ].
	behavior := spec2behavior at: spec.
	md := self createMethodDictionary: spec in: species.
	self ivarOf: behavior named: #methods put: md
]

{ #category : #'private - helpers' }
TuquiRingBootstrapper >> initializeMethodFlags [

	| spec argCount blockCount tempCount capturesSelf hasEnvironment hasFrame debuggable envCount |
	spec := self => #CompiledMethod.
	argCount := self newStretch: (1 thru: 6).
	blockCount := self newStretch: (7 thru: 13).
	tempCount := self newStretch: (14 thru: 21).
	capturesSelf := self newInteger: (1 bitShift: 22 - 1).
	hasEnvironment := self newInteger: (1 bitShift: 23 - 1).
	hasFrame := self newInteger: (1 bitShift: 24 - 1).
	debuggable := self newInteger: (1 bitShift: 25 - 1).
	envCount := self newStretch: (26 thru: 31).
	self
		cvarOfSpec: spec named: #ArgCount put: argCount;
		cvarOfSpec: spec named: #BlockCount put: blockCount;
		cvarOfSpec: spec named: #TempCount put: tempCount;
		cvarOfSpec: spec named: #CapturesSelf put: capturesSelf;
		cvarOfSpec: spec named: #HasEnvironment put: hasEnvironment;
		cvarOfSpec: spec named: #HasFrame put: hasFrame;
		cvarOfSpec: spec named: #Debuggable put: debuggable;
		cvarOfSpec: spec named: #EnvCount put: envCount
]

{ #category : #'private - helpers' }
TuquiRingBootstrapper >> initializeSmallInteger [

	| spec min max |
	spec := self => #SmallInteger.
	min := self newInteger: image minSMI.
	max := self newInteger: image maxSMI.
	self
		cvarOfSpec: spec named: #Minimum put: min;
		cvarOfSpec: spec named: #Maximum put: max
]

{ #category : #'own services' }
TuquiRingBootstrapper >> initializeSpecies: spec [

	| sspec sclass sbehavior metasuper metasbehavior |
	sspec := spec superclass.
	sspec
		ifNil: [
			sclass := nilObj.
			sbehavior := nilObj.
			metasuper := spec2class at: self => #Class.
			metasbehavior := spec2behavior at: self => #Class ]
		ifNotNil: [
			sclass := spec2class at: sspec.
			sbehavior := spec2behavior at: sspec.
			metasuper := spec2metaclass at: sspec metaclass.
			metasbehavior := spec2behavior at: sspec metaclass ].
	self
		initializeClass: spec superclass: sclass superbehavior: sbehavior;
		initializeMetaclass: spec superclass: metasuper superbehavior: metasbehavior.
]

{ #category : #'private - helpers' }
TuquiRingBootstrapper >> initializeSpeciesCvars [

	| spec variable pointers |
	spec := self => #Species.
	variable := self newInteger: 16r2000.
	pointers := self newInteger: 16r4000.
	self
		cvarOfSpec: spec named: #Variable put: variable;
		cvarOfSpec: spec named: #Pointers put: pointers
]

{ #category : #'private - helpers' }
TuquiRingBootstrapper >> initializeSymbolTable [

	self cvarOfSpec: self => #Symbol named: #SymbolTable put: symbols.
]

{ #category : #building }
TuquiRingBootstrapper >> ivarOf: anObject named: name [
	| spec index |
	spec := behavior2spec at: anObject behavior.
	index := (self allSlotNamesOf: spec) indexOf: name.
	^anObject slotAt: index

]

{ #category : #building }
TuquiRingBootstrapper >> ivarOf: anObject named: name put: value [

	| spec index |
	spec := behavior2spec at: anObject behavior.
	index := (self allSlotNamesOf: spec) indexOf: name.
	^ anObject slotAt: index put: value
]

{ #category : #accessing }
TuquiRingBootstrapper >> metaclassFor: anRGBehavior [

	^ spec2metaclass at: anRGBehavior
]

{ #category : #initialization }
TuquiRingBootstrapper >> newArray: anArray [
	| array |
	array := self newArraySized: anArray size.
	anArray withIndexDo: [ :obj :i | array slotAt: i put: obj ].
	^ array
]

{ #category : #initialization }
TuquiRingBootstrapper >> newArraySized: anInteger [

	^ self newArrayedSlotsOf: arraySpec sized: anInteger
]

{ #category : #accessing }
TuquiRingBootstrapper >> newArrayedSlotsOf: anRGBehavior sized: anInteger [

	| behavior instSize |
	behavior := spec2behavior at: anRGBehavior.
	instSize := anRGBehavior instSize.
	^ image
		  newArrayedSlots: behavior
		  size: instSize + anInteger named: instSize > 0
]

{ #category : #services }
TuquiRingBootstrapper >> newBytes: classname contents: aByteObject [
	^ self newBytesOf: self => classname contents: aByteObject
]

{ #category : #services }
TuquiRingBootstrapper >> newBytesOf: anRGBehavior contents: aByteObject [
	| behavior |
	behavior := spec2behavior at: anRGBehavior.
	
	^ image newBytes: behavior contents: aByteObject
]

{ #category : #initialization }
TuquiRingBootstrapper >> newInteger: anInteger [

	anInteger > image maxSMI ifTrue: [
		^ self newLargePositiveInteger: anInteger ].
	anInteger < image minSMI ifTrue: [
		^ self newLargeNegativeInteger: anInteger ].
	^ TqSmallInteger new value: anInteger
]

{ #category : #accessing }
TuquiRingBootstrapper >> newSlotsOf: anRGBehavior [

	| behavior instSize |
	behavior := spec2behavior at: anRGBehavior.
	instSize := anRGBehavior instSize. anRGBehavior isMetaclass ifTrue: [
		            instSize := classSpec instSize + instSize ].
	^ image newSlots: behavior size: instSize
]

{ #category : #initialization }
TuquiRingBootstrapper >> newStretch: aStretch [

	|  stretch start end |
	stretch := self newSlotsOf: self => #Stretch.
	start := self newInteger: aStretch start.
	end := self newInteger: aStretch end.
	self ivarOf: stretch named: #start put: start;
	ivarOf: stretch named: #end put: end
.	^stretch
]

{ #category : #initialization }
TuquiRingBootstrapper >> newString: aString [
	| bytes |
	bytes := aString copyWith: Character null.
	^self newBytes: 'String' contents: bytes
]

{ #category : #initialization }
TuquiRingBootstrapper >> newStringArray: strings [

	| array bytes |
	array := self newArrayedSlotsOf: arraySpec sized: strings size.
	strings withIndexDo: [ :s :i |
		bytes := self newString: s.
		array slotAt: i put: bytes ].
	^ array
]

{ #category : #initialization }
TuquiRingBootstrapper >> newSymbol: aSymbol [

	| bytes symbol |
	bytes := aSymbol copyWith: Character null.
	symbol := self newBytes: 'Symbol' contents: bytes.
	symbols symbolNamed: aSymbol put: symbol.
	^symbol
]

{ #category : #accessing }
TuquiRingBootstrapper >> newVMDictionary: spec [

	| behavior |
	behavior := spec2behavior at: spec.
	^ image newVMDictionary: behavior size: spec instSize
]

{ #category : #accessing }
TuquiRingBootstrapper >> spec2behavior: anRGDefinition [
	^spec2behavior at: anRGDefinition
]

{ #category : #accessing }
TuquiRingBootstrapper >> transferBlock: anSCompiledBlock [

	| transferred method format |
	identifiedObjects at: anSCompiledBlock ifPresent: [ :b | ^ b ].
	transferred := self newSlotsOf: self => #CompiledBlock.
	identifiedObjects at: anSCompiledBlock put: transferred.
	method := identifiedObjects at: anSCompiledBlock method.
	format := self newInteger: anSCompiledBlock format.
	self
		ivarOf: transferred named: #method put: method;
		ivarOf: transferred named: #format put: format;
		ivarOf: transferred named: #executableCode put: nilObj.
	^ transferred
]

{ #category : #initialization }
TuquiRingBootstrapper >> transferLiteralDeep: anObject [

	| class transferred slot size ivar isize |
	class := anObject class.
	anObject isInteger ifTrue: [ ^ self newInteger: anObject ].
	anObject == nil ifTrue: [ ^ nilObj ].
	anObject == false ifTrue: [ ^ falseObj ].
	anObject == true ifTrue: [ ^ trueObj ].
	identifiedObjects at: anObject ifPresent: [ :existing | ^ existing ].
	(class == Symbol or: [ class inheritsFrom: Symbol ]) ifTrue: [
		^ self addSymbol: anObject ].
	anObject isString ifTrue: [ ^ self newString: anObject ].
	class = ByteArray ifTrue: [
		^ self newBytes: #ByteArray contents: anObject ].
	(class inheritsFrom: TqObject) ifTrue: [ ^ anObject ].
	class == SCompiledBlock ifTrue: [ ^ self transferBlock: anObject ].
	size := class isVariable
		        ifTrue: [ anObject size ]
		        ifFalse: [ 0 ].
	transferred := self newArrayedSlotsOf: self => class name sized: size.
	isize := class instSize.
	1 to: isize do: [ :i |
		ivar := anObject instVarAt: i.
		slot := self transferLiteralDeep: ivar.
		transferred slotAt: i put: slot ].
	size > 0 ifTrue: [
		anObject withIndexDo: [ :elem :i |
			slot := self transferLiteralDeep: elem.
			transferred slotAt: isize + i put: slot ] ].
	^ transferred
]

{ #category : #initialization }
TuquiRingBootstrapper >> transferMethod: anSCompiledMethod in: species [

	| size transferred treecodes selector format literal tliteral source offset |
	size := anSCompiledMethod size.
	transferred := self
		               newArrayedSlotsOf: self => #CompiledMethod
		               sized: size.
	identifiedObjects at: anSCompiledMethod put: transferred.
	treecodes := self transferLiteralDeep: anSCompiledMethod astcodes.
	selector := self addSymbol: anSCompiledMethod selector.
	format := self newInteger: anSCompiledMethod format.
	source := self newString: anSCompiledMethod source.
	self
		ivarOf: transferred named: #treecodes put: treecodes;
		ivarOf: transferred named: #class put: species;
		ivarOf: transferred named: #selector put: selector;
		ivarOf: transferred named: #format put: format;
		ivarOf: transferred named: #source put: source.
	offset := anSCompiledMethod class instSize.
	1 to: size do: [ :i |
		literal := anSCompiledMethod at: i.
		tliteral := self transferLiteralDeep: literal.
		transferred slotAt: i + offset put: tliteral ].
	^ transferred
]
