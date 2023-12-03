"
I am a context for TqIterativeLinkedEvaluator. Besides my parent knowledge, I hold an array of bytecodes, a program counter (PC) and a collection of operands to be used for things like sending messages.
"
Class {
	#name : #TqIterativeLinkedContext,
	#superclass : #TqLinkedContext,
	#instVars : [
		'operands',
		'pc',
		'bytecodes'
	],
	#category : #'Tuqui-Evaluation-Runtime'
}

{ #category : #'as yet unclassified' }
TqIterativeLinkedContext >> beBlock [

	super beBlock.
	operands := nil.

]

{ #category : #accessing }
TqIterativeLinkedContext >> bytecodes: anArray [ 
	bytecodes := anArray
]

{ #category : #'as yet unclassified' }
TqIterativeLinkedContext >> dropOperands: anInteger [
	anInteger timesRepeat: [ operands removeLast ]
]

{ #category : #'as yet unclassified' }
TqIterativeLinkedContext >> hasFinished [
	^parent isNil
]

{ #category : #visiting }
TqIterativeLinkedContext >> initialize [

	super initialize.

	pc := 1
]

{ #category : #visiting }
TqIterativeLinkedContext >> nextOperation [
	| op |
	op := bytecodes at: pc.
	pc := pc + 1.
	^op
]

{ #category : #visiting }
TqIterativeLinkedContext >> operandAt: anInteger [
	^operands at: operands size - anInteger 
]

{ #category : #'as yet unclassified' }
TqIterativeLinkedContext >> pc: anInteger [
	pc := anInteger
]

{ #category : #'as yet unclassified' }
TqIterativeLinkedContext >> popOperand [

	^ operands removeLast
]

{ #category : #'as yet unclassified' }
TqIterativeLinkedContext >> popOperands: anInteger [

	^ anInteger = 0 ifTrue: [#()] ifFalse: [operands removeLast: anInteger]
]

{ #category : #'as yet unclassified' }
TqIterativeLinkedContext >> pushOperand: anObject [
	
	operands ifNil: [ operands := OrderedCollection new ].
	operands add: anObject
]

{ #category : #'as yet unclassified' }
TqIterativeLinkedContext >> restart [

	operands ifNotNil: [ operands reset ].
	pc := 1
]
