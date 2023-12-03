Class {
	#name : #TqLinkedContext,
	#superclass : #TqEvaluationContext,
	#instVars : [
		'parent',
		'method',
		'arguments',
		'temporaries',
		'environment',
		'isBlock',
		'_self'
	],
	#category : #'Tuqui-Evaluation-Runtime'
}

{ #category : #visiting }
TqLinkedContext >> argumentAt: anInteger [
	^arguments at: anInteger
]

{ #category : #visiting }
TqLinkedContext >> argumentAt: index in: environmentIndex [
	| env | 
	environmentIndex ifNil: [ ^ arguments at: index ].
	env := self environmentFor: environmentIndex.
	^ env at: index
]

{ #category : #visiting }
TqLinkedContext >> arguments [
	^arguments
]

{ #category : #visiting }
TqLinkedContext >> arguments: aCollection [
	arguments := aCollection
]

{ #category : #services }
TqLinkedContext >> backtrace [

	| bt current |
	bt := OrderedCollection new.
	current := self.
	[ current notNil ] whileTrue: [
		bt add: {
				[runtime methodSignature: current method] on: Error do: [#nil->#nil].
				current self } , (current arguments ifNil: [#()]).
		current := current parent ].
	^ bt
]

{ #category : #visiting }
TqLinkedContext >> beBlock [
	isBlock := true
]

{ #category : #visiting }
TqLinkedContext >> block [

	^runtime closureBlock: environment
]

{ #category : #accessing }
TqLinkedContext >> environment [
	^ environment
]

{ #category : #visiting }
TqLinkedContext >> environment: anObject [
	environment := anObject
]

{ #category : #visiting }
TqLinkedContext >> environmentFor: anInteger [
	"
	-1: inlined argument.
	 0: current env.
 	>0: index of env in current env. "

	anInteger = 0 ifTrue: [ ^ environment ].
	anInteger = -1 ifTrue: [ ^ temporaries ].
	
	^ self environmentValueAt: anInteger
]

{ #category : #visiting }
TqLinkedContext >> environmentValueAt: anInteger [
	^ environment at: anInteger
]

{ #category : #accessing }
TqLinkedContext >> firstArgument [
	^arguments at: 1
]

{ #category : #accessing }
TqLinkedContext >> fourthArgument [
	^ arguments at: 4
]

{ #category : #accessing }
TqLinkedContext >> framesCount [
	| current result |
	current := self.
	result := 0.
	[ current notNil ]
		whileTrue: [ result := result + 1.
			current := current parent ].
	^ result
]

{ #category : #visiting }
TqLinkedContext >> homeContext [
	| frame searched |
	isBlock
		ifFalse: [ ^ self ].
	frame := parent.
	searched := runtime closureHome: environment.
	[ frame notNil ]
		whileTrue: [ frame environment == searched
				ifTrue: [ ^ frame ].
			frame := frame parent ].
	self error: 'home context not found'
]

{ #category : #visiting }
TqLinkedContext >> initialize [
	isBlock := false
]

{ #category : #visiting }
TqLinkedContext >> initializeForBlock: block args: anArray closure: closure [

	| count |
	count := runtime blockTempCount: block.
	temporaries := Array new: count.
	arguments := anArray.
	environment := closure
]

{ #category : #visiting }
TqLinkedContext >> isBlock [
	^isBlock
	
]

{ #category : #visiting }
TqLinkedContext >> isHomeOf: env [
	^ environment == env andNot: [ isBlock ]
]

{ #category : #visiting }
TqLinkedContext >> method [

	| block |
	^ method ifNil: [ block := runtime closureBlock: environment. ^runtime blockMethod: block ]
]

{ #category : #accessing }
TqLinkedContext >> method: aMethod [
	| count |
	method := aMethod.
	count := runtime methodTempCount: aMethod.
	temporaries := Array new: count
]

{ #category : #visiting }
TqLinkedContext >> methodArguments [
	^ arguments
]

{ #category : #visiting }
TqLinkedContext >> parent [
	^parent
]

{ #category : #visiting }
TqLinkedContext >> parent: anEvaluationContext [
	parent := anEvaluationContext.
	(isBlock not and: [self framesCount > 1000])
		ifTrue: [ self halt ].
]

{ #category : #visiting }
TqLinkedContext >> receiver [
	^_self
]

{ #category : #accessing }
TqLinkedContext >> secondArgument [
	^ arguments at: 2
]

{ #category : #visiting }
TqLinkedContext >> self [
	^ _self
]

{ #category : #visiting }
TqLinkedContext >> self: anObject [
	_self := anObject
]

{ #category : #visiting }
TqLinkedContext >> stackTemporaryAt: index [
	^ temporaries at: index
]

{ #category : #visiting }
TqLinkedContext >> stackTemporaryAt: index put: value [
	^temporaries at: index put: value
	
]

{ #category : #visiting }
TqLinkedContext >> temporaryAt: index in: environmentIndex [

	| env |
	environmentIndex ifNil: [ ^ self stackTemporaryAt: index ].
	env := self environmentFor: environmentIndex.
	^ env at: index
]

{ #category : #visiting }
TqLinkedContext >> temporaryAt: index in: environmentIndex put: value [

	| env |
	environmentIndex ifNil: [ ^ self stackTemporaryAt: index put: value ].
	env := self environmentFor: environmentIndex.
	^ env at: index put: value
]

{ #category : #accessing }
TqLinkedContext >> thirdArgument [
	^ arguments at: 3
]
