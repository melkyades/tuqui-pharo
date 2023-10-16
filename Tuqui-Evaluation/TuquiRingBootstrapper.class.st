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
		'classSpec'
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
TuquiRingBootstrapper >> addSymbol: aSymbol [

	| new |
	image symbolNamed: aSymbol ifNotNil: [ :s | ^ s ].
	new := self newSymbol: aSymbol.
	image addSymbol: new at: aSymbol.
	^new
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
TuquiRingBootstrapper >> createSpecies: definition [

	| class meta |
	class := self newSlotsOf: definition metaclass.
	meta := self newSlotsOf: self => #Metaclass.
	spec2class at: definition put: class.
	spec2metaclass at: definition metaclass put: meta
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
	specs allClasses do: [ :def | self initializeSpecies: def ].
	image initializeFrom: self
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
	image := TuquiRuntime new wordSize: 8
]

{ #category : #building }
TuquiRingBootstrapper >> initializeClass: definition superclass: superclass superbehavior: superbehavior [

	| class behavior name flag ivars subclasses format |
	class := spec2class at: definition.
	behavior := spec2behavior at: definition.
	self 	ivarOf: behavior named: #class put: class; ivarOf: behavior named: #next put: superbehavior.
	subclasses := definition subclasses collect: [ :def |
		              spec2class at: def ].
	subclasses := self newArray: subclasses.
	name := self newString: definition name.
	flag := self formatOfClass: definition.
	format := self newInteger: flag.
	ivars := self newStringArray: definition instVarNames.
	self
		ivarOf: class named: #superclass put: superclass;
		ivarOf: class named: #instanceBehavior put: behavior;
		ivarOf: class named: #format put: format;
		ivarOf: class named: #instanceVariables put: ivars;
		ivarOf: class named: #name put: name;
		ivarOf: class named: #subclasses put: subclasses.
	definition metaclass allInstVarNames do: [ :ivar |
		class slotNamed: ivar put: nilObj ]
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
TuquiRingBootstrapper >> newSymbol: aString [

	| bytes |
	bytes := aString copyWith: Character null.
	^ self newBytes: 'Symbol' contents: bytes
]

{ #category : #accessing }
TuquiRingBootstrapper >> spec2behavior: anRGDefinition [
	^spec2behavior at: anRGDefinition
]
