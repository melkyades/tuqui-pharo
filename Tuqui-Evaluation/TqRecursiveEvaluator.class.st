Class {
	#name : #TqRecursiveEvaluator,
	#superclass : #TqEvaluator,
	#category : #'Tuqui-Evaluation-Runtime'
}

{ #category : #visiting }
TqRecursiveEvaluator >> evaluateClosure: receiver whileFalse: arg [
	| result |
	[ result := self evaluateClosure: receiver.
	self booleanFrom: result ]
		whileFalse: [ self evaluateClosure: arg ].
	^ receiver
]

{ #category : #visiting }
TqRecursiveEvaluator >> evaluateClosure: receiver whileTrue: arg [
	| result |
	[ result := self evaluateClosure: receiver.
	self booleanFrom: result ] whileTrue: [ self evaluateClosure: arg ].
	^ receiver
]

{ #category : #private }
TqRecursiveEvaluator >> evaluateClosure: closure withArgs: arguments [
	| block sblock receiver result |
	block := runtime closureBlock: closure.
	sblock := runtime blockExecutableCode: block.
	receiver := (runtime blockCapturesSelf: block)
		            ifTrue: [ closure at: 1 ]
		            ifFalse: [ nilObj ].
	context := TqRecursiveLinkedContext new
		runtime: runtime;
		beBlock;
		parent: context;
		self: receiver;
		initializeForBlock: sblock args: arguments closure: closure.
	result := nilObj.
	sblock statements do: [ :node | result := node acceptVisitor: self ].
	^ result
]

{ #category : #visiting }
TqRecursiveEvaluator >> evaluateSend: symbol to: receiver with: anArray [

	^self
		       send: symbol
		       to: receiver
		       with: anArray
		       super: false
]

{ #category : #visiting }
TqRecursiveEvaluator >> hasFinished [
	^context isNil
]

{ #category : #visiting }
TqRecursiveEvaluator >> initializePrimitives [ 
	super initializePrimitives.
	primitives 
		at: #ClosureWhileTrue put: self primitiveClosureWhileTrue;
		at: #ClosureWhileFalse put: self primitiveClosureWhileFalse
]

{ #category : #visiting }
TqRecursiveEvaluator >> primitiveClosureWhileFalse [
	^ [ self
		evaluateClosure: context self
		whileFalse: context arguments first ]
]

{ #category : #visiting }
TqRecursiveEvaluator >> primitiveClosureWhileTrue [
	^ [ self
		evaluateClosure: context self
		whileTrue: context arguments first ]
]

{ #category : #visiting }
TqRecursiveEvaluator >> send: aSymbol to: receiver with: arguments super: aBoolean sendSite: anSMessage [

	| behavior method environment size |
	behavior := aBoolean
		            ifTrue: [ runtime superBehaviorOf: context classBinding ]
		            ifFalse: [ runtime behaviorOf: receiver ].
	method := self
		          lookup: aSymbol
		          startingAt: behavior
		          sendSite: anSMessage.
	method isBlock ifTrue: [ ^ method value: receiver value: arguments ].
	self ASSERT: method notNil.
	size := runtime methodEnvironmentSize: method.
	environment := runtime newEnvironmentSized: size.
	context := TqRecursiveLinkedContext new
		           runtime: runtime;
		           self: receiver;
		           arguments: arguments;
		           environment: environment;
		           parent: context;
		           method: method.
	^ context evaluateFor: self
]

{ #category : #visiting }
TqRecursiveEvaluator >> superBehaviorOf: class [

	| superclass |
	superclass := self speciesSuperclass: class.
	^ self speciesInstanceBehavior: superclass
]
