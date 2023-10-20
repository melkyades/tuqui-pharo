Class {
	#name : #TqAssignment,
	#superclass : #TqExpression,
	#instVars : [
		'assignees',
		'expression'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #unclassified }
TqAssignment class >> decodeUsing: anAstcodeDecoder [
	^anAstcodeDecoder decodeAssignment
]

{ #category : #'instance creation' }
TqAssignment class >> new [
	"return an initialized instance"

	^ self basicNew initialize.

]

{ #category : #visiting }
TqAssignment >> acceptVisitor: visitor [
	^visitor visitAssignment: self
]

{ #category : #private }
TqAssignment >> assign: anSIdentifier [
	assignees add: anSIdentifier
]

{ #category : #visiting }
TqAssignment >> assignees [
	^assignees
]

{ #category : #visiting }
TqAssignment >> expression [
	^expression
]

{ #category : #visiting }
TqAssignment >> expression: anSExpression [
	expression := anSExpression
]

{ #category : #visiting }
TqAssignment >> initialize [
	assignees := OrderedCollection new
]

{ #category : #testing }
TqAssignment >> isAssignment [
	^true
]

{ #category : #testing }
TqAssignment >> printOn: aStream indent: anInteger [
	aStream tab: anInteger; nextPutAll: '{AssignmentId.'.
	assignees
		do: [:identifier | 
			aStream cr.
			identifier printOn: aStream indent: anInteger + 1]
		separatedBy: [aStream nextPutAll: '.'].
	aStream nextPutAll: '.'; cr.
	expression printOn: aStream indent: anInteger + 1.
	aStream nextPutAll: '}'
]
