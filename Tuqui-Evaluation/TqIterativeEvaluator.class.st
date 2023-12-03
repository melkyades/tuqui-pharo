Class {
	#name : #TqIterativeEvaluator,
	#superclass : #TqEvaluator,
	#instVars : [
		'regR'
	],
	#category : #'Tuqui-Evaluation-Runtime'
}

{ #category : #accessing }
TqIterativeEvaluator >> evaluate [
	^self subclassResponsibility

]

{ #category : #accessing }
TqIterativeEvaluator >> hasFinished [
	^ context hasFinished
]

{ #category : #accessing }
TqIterativeEvaluator >> prepareDispatch: dispatch [
	self subclassResponsibility
]

{ #category : #private }
TqIterativeEvaluator >> prepareFor: anSCompiledMethod [
	self subclassResponsibility
]

{ #category : #accessing }
TqIterativeEvaluator >> prepareForBlock: sblock [
	^self subclassResponsibility	
]

{ #category : #private }
TqIterativeEvaluator >> prepareForExecution: method [
	self subclassResponsibility
]

{ #category : #accessing }
TqIterativeEvaluator >> regR: anObject [ 
	regR := anObject
]

{ #category : #accessing }
TqIterativeEvaluator >> underprimitiveRestart [
	^ self subclassResponsibility 
]

{ #category : #accessing }
TqIterativeEvaluator >> visitBlock: anSBlock [
	regR := context captureClosure: anSBlock
]

{ #category : #accessing }
TqIterativeEvaluator >> visitIdentifier: anSIdentifier [
	regR := anSIdentifier binding valueWithin: context
]

{ #category : #accessing }
TqIterativeEvaluator >> visitLiteral: anSLiteral [
	regR := runtime literalFor: anSLiteral value
]

{ #category : #accessing }
TqIterativeEvaluator >> visitOpAssign: anSOpAssign [
	anSOpAssign assignees
		do: [ :identifier | identifier binding assign: regR within: context ]
]

{ #category : #accessing }
TqIterativeEvaluator >> visitOpDropToS: anSOpDropToS [
	context dropOperands: anSOpDropToS count
]

{ #category : #accessing }
TqIterativeEvaluator >> visitOpLoadRfromFrame: anSOpLoadRfromFrame [
	regR := context stackTemporaryAt: anSOpLoadRfromFrame index
]

{ #category : #accessing }
TqIterativeEvaluator >> visitOpLoadRfromStack: anSOpLoadRfromStack [
	regR := context operandAt: anSOpLoadRfromStack index
]

{ #category : #accessing }
TqIterativeEvaluator >> visitOpLoadRwithNil: anSOpLoadRwithNil [
	regR := nilObj
]

{ #category : #accessing }
TqIterativeEvaluator >> visitOpLoadRwithSelf: anSOpLoadRwithSelf [
	regR := context self
]

{ #category : #accessing }
TqIterativeEvaluator >> visitOpPushR: anSOpPushR [
	context pushOperand: regR
]

{ #category : #accessing }
TqIterativeEvaluator >> visitOpStoreRintoFrame: anSOpStoreRintoFrame [
	context stackTemporaryAt: anSOpStoreRintoFrame index put: regR
]
