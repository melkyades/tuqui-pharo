"
I am a Smalltalk expression, the minimal unit of Smalltalk semantics, expressed as a tree
"
Class {
	#name : #TqExpression,
	#superclass : #Object,
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #visiting }
TqExpression >> acceptVisitor: visitor [
	^self subclassResponsibility
]

{ #category : #visiting }
TqExpression >> isAssignment [
	^false
]

{ #category : #visiting }
TqExpression >> isCascade [
	^false
]

{ #category : #visiting }
TqExpression >> isCascadeMessage [
	^false
]

{ #category : #visiting }
TqExpression >> isIdentifier [
	^false
]

{ #category : #testing }
TqExpression >> isInstVar [
	^false
]

{ #category : #visiting }
TqExpression >> isLiteral [
	^false
]

{ #category : #visiting }
TqExpression >> isMessage [
	^false
]

{ #category : #testing }
TqExpression >> isMethod [
	^false
]

{ #category : #visiting }
TqExpression >> isReturn [
	^false
]

{ #category : #visiting }
TqExpression >> isSuper [
	^ false
]

{ #category : #testing }
TqExpression >> printOn: aStream [
	self printOn: aStream indent: 0
]

{ #category : #testing }
TqExpression >> printOn: aStream indent: anInteger [
	super printOn: aStream
]
