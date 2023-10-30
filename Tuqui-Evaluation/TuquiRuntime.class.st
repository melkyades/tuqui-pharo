Class {
	#name : #TuquiRuntime,
	#superclass : #TuquiImage,
	#instVars : [
		'methodCache',
		'symbolCache',
		'evaluatorType',
		'behaviorNextIndex',
		'behaviorMethodDictionaryIndex',
		'behaviorClassIndex',
		'classNameIndex',
		'closureBlockIndex',
		'dictionaryTableIndex',
		'metaclassInstanceClassIndex',
		'methodClassBindingIndex',
		'methodExecutableCodeIndex',
		'methodSelectorIndex',
		'speciesInstanceBehaviorIndex',
		'speciesFormatIndex',
		'speciesSuperclassIndex',
		'speciesIvarsIndex',
		'metaclassClass',
		'smallIntegerClass',
		'methodTreecodesIndex',
		'lastHash',
		'currentEvaluator',
		'methodClass',
		'methodInstSize',
		'methodFormatIndex',
		'arrayClass',
		'blockClass',
		'closureClass',
		'blockFormatIndex',
		'blockMethodIndex',
		'classCVarsIndex',
		'associationClass',
		'associationValueIndex',
		'associationKeyIndex'
	],
	#pools : [
		'SCompiledBlockFlags',
		'SCompiledMethodFlags'
	],
	#category : #'Tuqui-Evaluation-Runtime'
}

{ #category : #accessing }
TuquiRuntime >> associationKey: association [

	^ association slotAt: associationKeyIndex
]

{ #category : #accessing }
TuquiRuntime >> associationKey: association put: anObject [

	association slotAt: associationKeyIndex put: anObject
]

{ #category : #accessing }
TuquiRuntime >> associationValue: association [

	^ association slotAt: associationValueIndex
]

{ #category : #accessing }
TuquiRuntime >> associationValue: association put: anObject [

	association slotAt: associationValueIndex put: anObject
]

{ #category : #accessing }
TuquiRuntime >> behaviorClass: aTqObject [
	^ aTqObject slotAt: behaviorClassIndex
]

{ #category : #accessing }
TuquiRuntime >> behaviorMethodDictionary: aTqObject [

	^ aTqObject slotAt: behaviorMethodDictionaryIndex
]

{ #category : #accessing }
TuquiRuntime >> behaviorNext: aTqObject [

	^ aTqObject slotAt: behaviorNextIndex
]

{ #category : #accessing }
TuquiRuntime >> behaviorOf: aTqObject [
	^aTqObject isImmediate ifTrue: [ self smallIntegerBehavior ] ifFalse: [aTqObject behavior]
]

{ #category : #initialization }
TuquiRuntime >> blockCapturesHome: block [

	| flags |
	flags := block slotAt: blockFormatIndex.
	^ flags value anyMask: BlockCapturesHome
]

{ #category : #initialization }
TuquiRuntime >> blockCapturesSelf: block [

	| flags |
	flags := block slotAt: blockFormatIndex.
	^ flags value anyMask: BlockCapturesSelf
]

{ #category : #initialization }
TuquiRuntime >> blockEnvironmentCount: aTqObject [

	| flags |
	flags := aTqObject slotAt: blockFormatIndex.
	^ flags value bitsAt: BlockEnvCount
]

{ #category : #initialization }
TuquiRuntime >> blockExecutableCode: aTqObject [

	^ self methodExecutableCode: aTqObject
]

{ #category : #initialization }
TuquiRuntime >> blockExecutableCode: aTqObject put: anObject [

	^ self methodExecutableCode: aTqObject put: anObject
]

{ #category : #initialization }
TuquiRuntime >> blockMethod: aTqObject [

	^ aTqObject slotAt: blockMethodIndex.
]

{ #category : #initialization }
TuquiRuntime >> blockTempCount: aTqObject [

	| flags |
	flags := aTqObject slotAt: blockFormatIndex.
	^ flags value bitsAt: BlockTempCount
]

{ #category : #initialization }
TuquiRuntime >> classCvars: anLMRObject [

	^ anLMRObject slotAt: classCVarsIndex
]

{ #category : #initialization }
TuquiRuntime >> classIvars: anLMRObject [

	^ anLMRObject slotAt: speciesIvarsIndex
]

{ #category : #accessing }
TuquiRuntime >> className: aTqObject [
	^ aTqObject slotAt: classNameIndex
]

{ #category : #initialization }
TuquiRuntime >> closureBlock: closure [

	^ closure slotAt: closureBlockIndex
]

{ #category : #initialization }
TuquiRuntime >> closureHome: closure [

	| block |
	block := self closureBlock: closure.
	(self blockCapturesHome: block) ifFalse: [
		self error: 'closure has no home' ].
	^ (self blockCapturesSelf: block)
		  ifTrue: [ closure at: 2 ]
		  ifFalse: [ closure at: 1 ]
]

{ #category : #accessing }
TuquiRuntime >> currentEvaluator [

	^ currentEvaluator ifNil: [
		  currentEvaluator := evaluatorType new runtime: self]
]

{ #category : #initialization }
TuquiRuntime >> doLookup: symbol startingAt: aBehavior [

	| behavior m |
	behavior := aBehavior.
	[
	m := self methodFor: symbol in: behavior.
	m ifNotNil: [ ^ m ].
	behavior := self behaviorNext: behavior.
	behavior !== nilObj ] whileTrue.
	^ nil
]

{ #category : #initialization }
TuquiRuntime >> hashFor: aTqObject [
	| shifted hash current |
	aTqObject isImmediate
		ifTrue: [ ^ aTqObject value ].
	current := aTqObject headerHash.
	current != 0
		ifTrue: [ ^ current ].
	shifted := lastHash bitShift: -1.
	hash := (lastHash bitAnd: 1) = 0
		ifTrue: [ shifted ]
		ifFalse: [ shifted bitXor: 16rB9C8 ].
	aTqObject headerHash: hash.
	^ lastHash := hash
]

{ #category : #initialization }
TuquiRuntime >> initialize [

	lastHash := 1.
	methodCache := Dictionary new.
	symbolCache := IdentityDictionary new.
	super initialize
]

{ #category : #accessing }
TuquiRuntime >> initializeFrom: bootstrapper [
	associationKeyIndex := (bootstrapper => #Association) allInstVarNames
		                     indexOf: 'key'.
	associationValueIndex := (bootstrapper => #Association) allInstVarNames
		                     indexOf: 'value'.

	behaviorNextIndex := (bootstrapper => #Behavior) allInstVarNames
		                     indexOf: 'next'.
	behaviorMethodDictionaryIndex := (bootstrapper => #Behavior)
		                                 allInstVarNames indexOf: 'methods'.
	behaviorClassIndex := (bootstrapper => #Behavior) allInstVarNames
		                      indexOf: 'class'.
	classNameIndex := (bootstrapper => #Class) allInstVarNames indexOf:
		                  'name'.
	classCVarsIndex := (bootstrapper => #Class) allInstVarNames indexOf:
		                   'classVars'.
	closureBlockIndex := (bootstrapper => #Closure) allInstVarNames
		                     indexOf: 'block'.
	metaclassInstanceClassIndex := (bootstrapper => #Metaclass)
		                               allInstVarNames indexOf: 'class'.
	methodTreecodesIndex := (bootstrapper => #CompiledMethod)
		                        allInstVarNames indexOf: 'treecodes'.
	methodClassBindingIndex := (bootstrapper => #CompiledMethod)
		                           allInstVarNames indexOf: 'class'.
	methodExecutableCodeIndex := (bootstrapper => #CompiledMethod)
		                             allInstVarNames indexOf:
		                             'executableCode'.
	methodFormatIndex := (bootstrapper => #CompiledMethod)
		                     allInstVarNames indexOf: 'format'.
	methodSelectorIndex := (bootstrapper => #CompiledMethod)
		                       allInstVarNames indexOf: 'selector'.
	methodInstSize := (bootstrapper => #CompiledMethod) allInstVarNames
		                  size.

	blockFormatIndex := (bootstrapper => #CompiledBlock) allInstVarNames
		                    indexOf: 'format'.

	blockMethodIndex := (bootstrapper => #CompiledBlock) allInstVarNames
		                    indexOf: 'method'.

	speciesInstanceBehaviorIndex := (bootstrapper => #Species)
		                                allInstVarNames indexOf:
		                                'instanceBehavior'.
	speciesFormatIndex := (bootstrapper => #Species) allInstVarNames
		                      indexOf: 'format'.
	speciesSuperclassIndex := (bootstrapper => #Species) allInstVarNames
		                          indexOf: 'superclass'.
	speciesIvarsIndex := (bootstrapper => #Species) allInstVarNames
		                     indexOf: 'instanceVariables'.
	metaclassClass := bootstrapper classNamed: #Metaclass.
	smallIntegerClass := bootstrapper classNamed: #SmallInteger.
	methodClass := bootstrapper classNamed: #CompiledMethod.
	blockClass := bootstrapper classNamed: #CompiledBlock.
	closureClass := bootstrapper classNamed: #Closure.
	arrayClass := bootstrapper classNamed: #Array.
	associationClass := bootstrapper classNamed: #Association.
	self useStackedIterativeEvaluator
]

{ #category : #initialization }
TuquiRuntime >> instanceVarOf: receiver at: anInteger [

	^ receiver slotAt: anInteger
]

{ #category : #initialization }
TuquiRuntime >> instanceVarOf: receiver at: anInteger put: value [

	^ receiver slotAt: anInteger put: value
]

{ #category : #initialization }
TuquiRuntime >> isBlock: compiledCode [

	^ (self behaviorClass: compiledCode behavior) == blockClass
]

{ #category : #accessing }
TuquiRuntime >> isMetaclass: aTqObject [
	^ (self speciesFor: aTqObject) == metaclassClass
]

{ #category : #accessing }
TuquiRuntime >> literalFor: anObject [

	^ anObject
]

{ #category : #accessing }
TuquiRuntime >> localSymbolFrom: anObject [

	^ anObject bytes allButLast asString asSymbol
]

{ #category : #accessing }
TuquiRuntime >> metaclassInstanceClass: aTqObject [
	^ aTqObject slotAt: metaclassInstanceClassIndex
]

{ #category : #initialization }
TuquiRuntime >> method: method literalAt: index [

	^ method slotAt: methodInstSize + index
]

{ #category : #initialization }
TuquiRuntime >> methodArgumentCount: aTqObject [

	| flags |
	flags := aTqObject slotAt: methodFormatIndex.
	^ flags value bitsAt: ArgCount
]

{ #category : #initialization }
TuquiRuntime >> methodClassBinding: aTqObject [

	^ aTqObject slotAt: methodClassBindingIndex
]

{ #category : #initialization }
TuquiRuntime >> methodEnvironmentSize: anLMRObject [

	| flags |
	flags := anLMRObject slotAt: methodFormatIndex.
	^ flags value bitsAt: EnvCount
]

{ #category : #accessing }
TuquiRuntime >> methodExecutableCode: anTqObject [

	| slot |
	slot := anTqObject slotAt: methodExecutableCodeIndex.
	^ slot == nilObj
		  ifTrue: [ slot ]
		  ifFalse: [ slot code ]
]

{ #category : #initialization }
TuquiRuntime >> methodExecutableCode: aTqObject put: anObject [

	| code |
	code := self newSlotsOf: arrayClass type: TqExecutableCode.
	code code: anObject.
	aTqObject slotAt: methodExecutableCodeIndex put: code
]

{ #category : #accessing }
TuquiRuntime >> methodFor: symbol in: behavior [

	| md |
	md := self behaviorMethodDictionary: behavior.
	^ md atKey: symbol ifAbsent: nil
]

{ #category : #initialization }
TuquiRuntime >> methodSelector: aTqObject [

	^ aTqObject slotAt: methodSelectorIndex
]

{ #category : #initialization }
TuquiRuntime >> methodSignature: method [

	| species classname selector |
	selector := self methodSelector: method.
	species := self methodClassBinding: method.
	classname := self speciesLocalName: species.
	^ classname -> selector asLocalString
]

{ #category : #initialization }
TuquiRuntime >> methodTempCount: aTqObject [

	| flags |
	flags := aTqObject slotAt: methodFormatIndex.
	^ flags value bitsAt: TempCount
]

{ #category : #initialization }
TuquiRuntime >> methodTreecodes: anLMRObject [

	^ anLMRObject slotAt: methodTreecodesIndex
]

{ #category : #initialization }
TuquiRuntime >> newArraySized: anInteger [

	| behavior |
	behavior := self speciesInstanceBehavior: arrayClass.
	^self newArrayedSlots: behavior size: anInteger named: false
]

{ #category : #initialization }
TuquiRuntime >> newAssociation [ 

	^ self newSlotsOf: associationClass
]

{ #category : #initialization }
TuquiRuntime >> newBytesOf: class size: size [

	| behavior |
	behavior := self speciesInstanceBehavior: class.
	^ self newBytes: behavior size: size
]

{ #category : #initialization }
TuquiRuntime >> newClosureFor: compiledBlock [

	| size closure |
	size := self blockEnvironmentCount: compiledBlock.
	closure := self newSlotsOf: closureClass size: size.
	closure slotAt: closureBlockIndex put: compiledBlock.
	^ closure

]

{ #category : #initialization }
TuquiRuntime >> newCompiledMethod [

	| behavior method |
	behavior := self speciesInstanceBehavior: methodClass.
	method := self newSlots: behavior size: methodInstSize.
	method slotAt: methodFormatIndex put: (self newInteger: 0).
	^ method
]

{ #category : #initialization }
TuquiRuntime >> newEnvironmentSized: anInteger [

	^ self newArraySized: anInteger
]

{ #category : #initialization }
TuquiRuntime >> newInteger: anInteger [
	anInteger > maxSMI
		ifTrue: [ ^ self newLargePositiveInteger: anInteger ].
	anInteger < minSMI
		ifTrue: [ ^ self newLargeNegativeInteger: anInteger ].
	^ TqSmallInteger new value: anInteger
]

{ #category : #initialization }
TuquiRuntime >> newSlotsOf: class [

	^ self newSlotsOf: class size: 0
]

{ #category : #initialization }
TuquiRuntime >> newSlotsOf: class size: size [

	| ivars behavior |
	ivars := self speciesInstanceSize: class.
	behavior := self speciesInstanceBehavior: class.
	^self newSlots: behavior size: ivars + size.

]

{ #category : #initialization }
TuquiRuntime >> newSlotsOf: class type: type [

	| ivars behavior result |
	ivars := self speciesInstanceSize: class.
	behavior := self speciesInstanceBehavior: class.
	result := self basicNewSlots: type sized: ivars.
	^ result behavior: behavior
]

{ #category : #initialization }
TuquiRuntime >> newVMDictionaryOf: class [


	| ivars behavior |
	ivars := self speciesInstanceSize: class.
	behavior := self speciesInstanceBehavior: class.
	self newVMDictionary: behavior size: ivars
]

{ #category : #accessing }
TuquiRuntime >> print: aTqObject on: aStream [

	| species name selector |
	species := self behaviorClass: aTqObject behavior.
	name := self speciesLocalName: species.
	name = 'Symbol' ifTrue: [
		^ aStream nextPutAll: '<#' , aTqObject asLocalString , '>' ].
	name = 'String' ifTrue: [
		^ aStream nextPutAll: '<''' , aTqObject asLocalString , '''>' ].
	name = 'CompiledMethod' ifTrue: [
		selector := aTqObject slotAt: methodSelectorIndex.
		selector := selector == nilObj
			            ifTrue: [ '<nil>' ]
			            ifFalse: [ selector asLocalString ].
		^ aStream
			  nextPutAll: '<';
			  print: (self methodClassBinding: aTqObject);
			  nextPutAll: '>>#';
			  nextPutAll: selector;
			  nextPutAll: '>' ].
	aStream
		nextPut: $<;
		nextPutAll: name withArticle;
		nextPut: $>

]

{ #category : #accessing }
TuquiRuntime >> printBehavior: aTqBehavior on: aStream [
	| species name |
	species := self behaviorClass: aTqBehavior.
	name := self speciesLocalName: species.
	aStream
		nextPutAll: '<' , name , ' instanceBehavior>'
]

{ #category : #accessing }
TuquiRuntime >> registerCache: anSMessage for: symbol [

	| messages |
	messages := symbolCache
		            at: symbol
		            ifAbsentPut: [ OrderedCollection new ].
	messages add: anSMessage
]

{ #category : #accessing }
TuquiRuntime >> sendLocal: aSymbol to: receiver [
	^ self sendLocal: aSymbol to: receiver with: {}
]

{ #category : #accessing }
TuquiRuntime >> sendLocal: aSymbol to: receiver with: anArray [

	| symbol |
	symbol := self symbolFromLocal: aSymbol.
	^ self currentEvaluator evaluateSend: symbol to: receiver with: anArray
]

{ #category : #initialization }
TuquiRuntime >> sexpressionsOf: method [

	| expressions treecodes decoder |
	expressions := self methodExecutableCode: method.
	expressions == nilObj ifFalse: [ ^ expressions ].
	treecodes := self methodTreecodes: method.
	decoder := TqTreecodeDecoder new
		           stream: treecodes bytes readStream;
		           method: method;
		           builder: self.
	expressions := decoder decodeMethod.
	self methodExecutableCode: method put: expressions.
	^ expressions
]

{ #category : #accessing }
TuquiRuntime >> smallIntegerBehavior [
	^self speciesInstanceBehavior: smallIntegerClass
]

{ #category : #accessing }
TuquiRuntime >> speciesFor: aTqObject [
	| behavior |
	behavior := self behaviorOf: aTqObject.
	^self behaviorClass: behavior.


]

{ #category : #accessing }
TuquiRuntime >> speciesInstanceBehavior: aTqObject [
	^aTqObject slotAt: speciesInstanceBehaviorIndex
]

{ #category : #accessing }
TuquiRuntime >> speciesInstanceClass: species [

^	(self isMetaclass: species) ifTrue: [ self metaclassInstanceClass: species]
	ifFalse: [ species ]
]

{ #category : #initialization }
TuquiRuntime >> speciesInstanceSize: aTqObject [
	^ (aTqObject slotAt: speciesFormatIndex) value bitAnd: 16r7F.
]

{ #category : #accessing }
TuquiRuntime >> speciesLocalName: species [
	| name class |
	(self isMetaclass: species) ifFalse: [
		name := self className: species.
		^name asLocalString].
	
	class := self metaclassInstanceClass: species. 
	name := self className: class.
	^ name asLocalString, ' class'
]

{ #category : #accessing }
TuquiRuntime >> speciesSuperclass: aTqObject [

	^ aTqObject slotAt: speciesSuperclassIndex
]

{ #category : #initialization }
TuquiRuntime >> staticBindingForIvar: symbol in: receiver [

	| class all slots bytes |
	class := self speciesFor: receiver.
	all := Array new: 0.
	[ class !== nilObj ] whileTrue: [
		slots := self classIvars: class.
		slots == nilObj ifFalse: [ all := slots slots , all ].
		class := self speciesSuperclass: class ].
	bytes := symbol bytes.
	all withIndexDo: [ :ivar :index |
		ivar bytes = bytes ifTrue: [ ^ index ] ].
	^ 0
]

{ #category : #initialization }
TuquiRuntime >> superBehaviorOf: class [

	| superclass |
	superclass := self speciesSuperclass: class.
	^ self speciesInstanceBehavior: superclass
]

{ #category : #initialization }
TuquiRuntime >> symbolFromLocal: aSymbol [

	^(symbols symbolNamed: aSymbol) ifNil: [ 	self error: 'symbol not found' ]
]

{ #category : #accessing }
TuquiRuntime >> useLinkedIterativeEvaluator [

	evaluatorType := TqLinkedIterativeEvaluator.
	currentEvaluator := nil
]

{ #category : #accessing }
TuquiRuntime >> useRecursiveEvaluator [
	evaluatorType := TqRecursiveEvaluator.
	currentEvaluator := nil

]

{ #category : #accessing }
TuquiRuntime >> useStackedIterativeEvaluator [

	evaluatorType := TqStackedIterativeEvaluator
]
