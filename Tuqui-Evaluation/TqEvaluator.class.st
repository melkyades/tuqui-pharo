Class {
	#name : #TqEvaluator,
	#superclass : #Object,
	#instVars : [
		'runtime',
		'falseObj',
		'trueObj',
		'nilObj',
		'context',
		'undermessages',
		'primitives',
		'messageCount'
	],
	#pools : [
		'ClosureElementTypes'
	],
	#category : #'Tuqui-Evaluation-Runtime'
}

{ #category : #'as yet unclassified' }
TqEvaluator class >> undermessages [
	^#(_basicAt: #_basicAt:put: _bitShiftLeft: _byteAt: #_byteAt:put: _smallSize _largeSize _isSmallInteger _basicHash _basicHash: _smallIntegerByteAt: _uShortAtOffset: #_uShortAtOffset:put:)
]

{ #category : #services }
TqEvaluator >> booleanFor: aBoolean [
	^ aBoolean
		ifTrue: [ trueObj ]
		ifFalse: [ falseObj ]
]

{ #category : #services }
TqEvaluator >> booleanFrom: anObject [
	anObject == falseObj
		ifTrue: [ ^ false ].
	anObject == trueObj
		ifTrue: [ ^ true ].
	self error: 'not a boolean'
]

{ #category : #accessing }
TqEvaluator >> context [
	^ context 
]

{ #category : #accessing }
TqEvaluator >> context: anEvaluationContext [ 
	context := anEvaluationContext
]

{ #category : #initializing }
TqEvaluator >> convertPrimitives [
	| original |
	original := primitives.
	primitives := IdentityDictionary new.
	original
		keysAndValuesDo:
			[ :symbol :block | primitives at: (runtime symbolFromLocal: symbol) put: block ]
]

{ #category : #initializing }
TqEvaluator >> convertUndermessages [
	| original |
	original := undermessages.
	undermessages := IdentityDictionary new.
	original keysAndValuesDo: [ :symbol :block | undermessages at: (runtime symbolFromLocal: symbol) put: block ]

]

{ #category : #accessing }
TqEvaluator >> evaluateClosure: receiver [
	^ self evaluateClosure: receiver withArgs: #()
]

{ #category : #visiting }
TqEvaluator >> evaluateClosure: aPClosure with: anObject [
	 ^self evaluateClosure: aPClosure withArgs: { anObject }
]

{ #category : #visiting }
TqEvaluator >> evaluateClosure: aPClosure with: anObject with: anotherObject [
	^ self evaluateClosure: aPClosure withArgs: {anObject. anotherObject}
]

{ #category : #private }
TqEvaluator >> evaluateClosure: receiver withArgs: arguments [
	^self subclassResponsibility
]

{ #category : #accessing }
TqEvaluator >> evaluatePrimitiveHash: receiver [
	| hash |
	hash := receiver headerHash.
	hash = 0
		ifTrue: [ hash := self nextHash.
			receiver headerHash: hash ].
	^ runtime newInteger: hash
]

{ #category : #initialization }
TqEvaluator >> false [
	^ falseObj
]

{ #category : #initialization }
TqEvaluator >> initialize [

	messageCount := 0
]

{ #category : #initializing }
TqEvaluator >> initializePrimitives [

	primitives := IdentityDictionary new.
	primitives
		at: #Behavior put: self primitiveBehavior;
		at: #SetBehavior put: self primitiveSetBehavior;
		at: #BasicSize put: self primitiveSize;
		at: #Hash put: self primitiveHash;
		at: #At put: self primitiveAt;
		at: #AtPut put: self primitiveAtPut;
		at: #NewPointers put: self primitiveNew;
		at: #NewPointersSized put: self primitiveNewPointersSized;
		at: #NewBytesSized put: self primitiveNewBytesSized;
		at: #Equal put: self primitiveEqual;
		at: #ClosureValue put: self primitiveClosureValue;
		at: #ClosureValueWith put: self primitiveClosureValueWith;
		at: #ClosureValueWithWith put: self primitiveClosureValueWithWith;
		at: #ClosureValueWithWithWith
		put: self primitiveClosureValueWithWithWith;
		at: #ClosureValueWithArguments
		put: self primitiveClosureValueWithArgs;
		at: #ClosureWhileTrue put: self primitiveClosureWhileTrue;
		at: #ClosureWhileFalse put: self primitiveClosureWhileFalse;
		at: #LoadClass put: self primitiveLoadClass;
		at: #FlushMethod put: self primitiveFlushMethodFromCaches;
		at: #FlushSymbol put: self primitiveFlushSymbolFromCaches;
		at: #SymbolShortAtOffset put: self primitiveSymbolShortAtOffset;
		at: #VMDictionaryNew put: self primitiveVMDictionaryNew;
		at: #VMDictionaryKeys put: self primitiveVMDictionaryKeys;
		at: #VMDictionaryAt put: self primitiveVMDictionaryAt;
		at: #VMDictionaryAtPut put: self primitiveVMDictionaryAtPut
]

{ #category : #initializing }
TqEvaluator >> initializeUndermessages [

	undermessages := IdentityDictionary new.
	undermessages
		at: #_isSmallInteger put: self underprimitiveIsSmallInteger;
		at: #_basicAt: put: self underprimitiveBasicAt;
		at: #_byteAt: put: self underprimitiveByteAt;
		at: #_byteAt:put: put: self underprimitiveByteAtPut;
		at: #_basicHash put: self underprimitiveBasicHash;
		at: #_basicHash: put: self underprimitiveBasicHashPut;
		at: #_size put: self underprimitiveSize;
		at: #_bitShiftLeft: put: self underprimitiveBitShiftLeft;
		at: #_smiPlus: put: self underprimitiveSMIPlus;
		at: #_smiMinus: put: self underprimitiveSMIMinus;
		at: #_smiTimes: put: self underprimitiveSMITimes;
		at: #_smiLowerThan: put: self underprimitiveSMILowerThan;
		at: #_smiLowerEqualThan: put: self underprimitiveSMILowerEqualThan;
		at: #_smiGreaterThan: put: self underprimitiveSMIGreaterThan;
		at: #_smiGreaterEqualThan:
		put: self underprimitiveSMIGreaterEqualThan;
		at: #_smiEquals: put: self underprimitiveSMIEquals;
		at: #_leadingZeroBitCount
		put: self underprimitiveLeadingZeroBitCount;
		at: #_quotientTowardZero:
		put: self underprimitiveSMIQuotientTowardZero;
		at: #_remainderTowardZero:
		put: self underprimitiveSMIRemainderTowardZero;
		at: #_bitShiftLeft: put: self underprimitiveSMIBitShiftLeft;
		at: #_bitShiftRight: put: self underprimitiveSMIBitShiftRight;
		at: #_smiBitAnd: put: self underprimitiveSMIBitAnd;
		at: #_smiBitOr: put: self underprimitiveSMIBitOr;
		at: #_halt put: self underprimitiveHalt
]

{ #category : #accessing }
TqEvaluator >> isIdentical: anObject to: anotherObject [
	^ anObject == anotherObject
		or: [ anObject isImmediate
				and: [ anotherObject isImmediate
						and: [ anObject value = anotherObject value ] ] ]
]

{ #category : #initialization }
TqEvaluator >> nil [
	^nilObj
	
]

{ #category : #primitives }
TqEvaluator >> primitiveAt [
	| receiver index value |
	^ [ receiver := context self.
	index := context firstArgument value.
	value := receiver at: index.
	receiver isBytes
		ifTrue: [ runtime newInteger: value ]
		ifFalse: [ value ] ]
]

{ #category : #primitives }
TqEvaluator >> primitiveAtPut [
	| index |
	^ [ index := context firstArgument value.
	context self at: index put: context secondArgument ]
]

{ #category : #primitives }
TqEvaluator >> primitiveBehavior [
	| receiver |
	^ [ receiver := context self.
	receiver isImmediate
		ifTrue: [ runtime smallIntegerBehavior ]
		ifFalse: [ receiver behavior ] ]
]

{ #category : #primitives }
TqEvaluator >> primitiveClosureValue [
	^ [ self evaluateClosure: context self ]
]

{ #category : #primitives }
TqEvaluator >> primitiveClosureValueWith [

	^ [ self evaluateClosure: context self with: context firstArgument]
]

{ #category : #primitives }
TqEvaluator >> primitiveClosureValueWithArgs [
	^ [ self
		evaluateClosure: context self
		withArgs: context methodArguments ]
]

{ #category : #primitives }
TqEvaluator >> primitiveClosureValueWithWith [

	^ [ self evaluateClosure: context self with: context firstArgument with: context secondArgument ]
]

{ #category : #primitives }
TqEvaluator >> primitiveClosureValueWithWithWith [

	^ [
	  self
		  evaluateClosure: context self
		  with: context firstArgument
		  with: context secondArgument
		with: context thirdArgument  ]
]

{ #category : #visiting }
TqEvaluator >> primitiveClosureWhileFalse [
	^ [ self
		evaluateClosure: context self
		whileFalse: context arguments first ]
]

{ #category : #visiting }
TqEvaluator >> primitiveClosureWhileTrue [
	^ [ self
		evaluateClosure: context self
		whileTrue: context arguments first ]
]

{ #category : #primitives }
TqEvaluator >> primitiveEqual [
	^ [ self booleanFor: context self = context firstArgument ]
]

{ #category : #primitives }
TqEvaluator >> primitiveFloatNew [
	^ [ runtime newBytesOf: context self sized: 8 ]
]

{ #category : #primitives }
TqEvaluator >> primitiveFlushMethodFromCaches [

	^ [ runtime flushDispatchCache: (runtime methodSelector: context self)]
]

{ #category : #primitives }
TqEvaluator >> primitiveFlushSymbolFromCaches [
	^ [ runtime
		flushDispatchCache: context self
		in: context firstArgument ]
]

{ #category : #accessing }
TqEvaluator >> primitiveFor: aSymbol [
	^primitives at: aSymbol
]

{ #category : #primitives }
TqEvaluator >> primitiveHash [
	^ [ runtime newInteger: (runtime hashFor: context self) ]
]

{ #category : #primitives }
TqEvaluator >> primitiveLoadClass [

	^ [
	  runtime shouldImplement: context self ]
]

{ #category : #primitives }
TqEvaluator >> primitiveNew [

	^ [ runtime newSlotsOf: context self ]
]

{ #category : #primitives }
TqEvaluator >> primitiveNewBytesSized [

	| size |
	^ [
	  size := context firstArgument value.
	  runtime newBytesOf: context self size: size ]
]

{ #category : #primitives }
TqEvaluator >> primitiveNewPointersSized [

	| size |
	^ [
	  size := context firstArgument value.
	  runtime newSlotsOf: context self size: size ]
]

{ #category : #primitives }
TqEvaluator >> primitiveSetBehavior [
	| receiver |
	^ [ receiver := context self.
	receiver behavior: context firstArgument.
	receiver ]
]

{ #category : #primitives }
TqEvaluator >> primitiveSize [
	^ [ runtime newInteger: (runtime arrayedSizeOf: context self) ]
]

{ #category : #primitives }
TqEvaluator >> primitiveSymbolShortAtOffset [

	^ [

	  runtime newInteger: (context self bytes uint16AtOffset: context firstArgument value) ]
]

{ #category : #primitives }
TqEvaluator >> primitiveVMDictionaryAt [

	| string |
	^ [
	  string := context firstArgument asString.
	  context self atKey: string ifAbsent: nil ]
]

{ #category : #primitives }
TqEvaluator >> primitiveVMDictionaryAtPut [

	^ [

	  context self atKey: context firstArgument put: context secondArgument ]
]

{ #category : #primitives }
TqEvaluator >> primitiveVMDictionaryKeys [

	^ [ runtime newArray: context self keys ]
]

{ #category : #primitives }
TqEvaluator >> primitiveVMDictionaryNew [

	^ [ runtime newVMDictionaryOf: context self ]
]

{ #category : #initializing }
TqEvaluator >> runtime [
	^runtime

]

{ #category : #initializing }
TqEvaluator >> runtime: aPowertalkRuntime [
	runtime := aPowertalkRuntime.
	nilObj := runtime nil.
	trueObj := runtime true.
	falseObj := runtime false.
	self
		initializeUndermessages;
		initializePrimitives; convertUndermessages ; convertPrimitives 
]

{ #category : #accessing }
TqEvaluator >> sendLocal: aSymbol to: receiver [
	^ self sendLocal: aSymbol to: receiver with: {}
]

{ #category : #accessing }
TqEvaluator >> stackSize [
	^context framesCount
]

{ #category : #initialization }
TqEvaluator >> true [
	^ trueObj
]

{ #category : #underprimitives }
TqEvaluator >> underprimitiveBasicAt [
	^ [ :receiver :arguments | receiver slots at: arguments first value ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveBasicHash [
	^ [ :receiver :arguments | runtime newInteger: receiver headerHash ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveBasicHashPut [
	^ [ :receiver :arguments | receiver headerHash: arguments first value ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveBitShiftLeft [
	| result |
	^ [ :receiver :arguments | 
	result := receiver value bitShift: arguments first value.
	runtime newInteger: result ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveByteAt [
	| result |
	^ [ :receiver :arguments | 
	result := receiver bytes at: arguments first value.
	runtime newInteger: result ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveByteAtPut [

	^ [ :receiver :arguments | 
	receiver bytes
		at: arguments first value
		put: arguments second value.
	arguments second ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveHalt [
	^ [ :receiver :arguments | receiver halt ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveIsSmallInteger [
	^ [ :receiver :arguments | self booleanFor: receiver isImmediate ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveLeadingZeroBitCount [
	^ [ :receiver :arguments | 
	runtime
		newInteger: (self
		underprimitiveLeadingZeroBitCount: receiver value) ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveLeadingZeroBitCount: anInteger [
	^ anInteger < 0
		ifTrue: [ 0 ]
		ifFalse: [ runtime wordSize * 8 - anInteger highBit ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveSMIBitAnd [
	^ [ :receiver :arguments | runtime newInteger: (receiver value bitAnd: arguments first value) ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveSMIBitOr [
	^ [ :receiver :arguments | runtime newInteger: (receiver value bitOr: arguments first value) ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveSMIBitShiftLeft [
	^ [ :receiver :arguments | runtime newInteger: receiver value << arguments first value ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveSMIBitShiftRight [
	^ [ :receiver :arguments | 
	runtime
		newInteger: (receiver value >> arguments first value) ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveSMIEquals [

	^ [ :receiver :arguments |
	  self booleanFor: receiver value = arguments first value ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveSMIGreaterEqualThan [
	^ [ :receiver :arguments | self booleanFor: receiver value >= arguments first value ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveSMIGreaterThan [

	^ [ :receiver :arguments |
	  self booleanFor: receiver value > arguments first value ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveSMILowerEqualThan [
	^ [ :receiver :arguments | self booleanFor: receiver value <= arguments first value ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveSMILowerThan [

	^ [ :receiver :arguments |
	  self booleanFor: receiver value < arguments first value ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveSMIMinus [

	^ [ :receiver :arguments |
	  runtime newInteger: receiver value - arguments first value ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveSMIPlus [

	^ [ :receiver :arguments |
	  runtime newInteger: receiver value + arguments first value ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveSMIQuotientTowardZero [
	^ [ :receiver :arguments | runtime newInteger: (receiver value quo: arguments first value) ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveSMIRemainderTowardZero [
	^ [ :receiver :arguments | runtime newInteger: (receiver value \\ arguments first value) ]
]

{ #category : #accessing }
TqEvaluator >> underprimitiveSMITimes [
	^ [ :receiver :arguments | runtime newInteger: receiver value * arguments first value ]
]

{ #category : #underprimitives }
TqEvaluator >> underprimitiveSize [

	^ [ :receiver :arguments | runtime newInteger: receiver size ]
]
