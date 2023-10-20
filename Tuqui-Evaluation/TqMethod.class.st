Class {
	#name : #TqMethod,
	#superclass : #TqScript,
	#instVars : [
		'pragma'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #visiting }
TqMethod >> acceptVisitor: visitor [
	^visitor visitMethod: self
]

{ #category : #testing }
TqMethod >> isMethod [
	^true
]

{ #category : #printing }
TqMethod >> offsetOfCurrentEnvironment [
	^ 0
]

{ #category : #printing }
TqMethod >> offsetOfEnvironment: anInteger [
	^0
]

{ #category : #printing }
TqMethod >> pragma [
	^pragma
]

{ #category : #printing }
TqMethod >> pragma: anSPragma [
	pragma := anSPragma
]

{ #category : #printing }
TqMethod >> primitive [
	^pragma ifNotNil: [ pragma name ]
]

{ #category : #printing }
TqMethod >> printOn: aStream indent: anInteger [
	aStream nextPutAll: '{MethodId. '; cr.
	pragma ifNotNil: [ (pragma isKindOf: TqExpression) ifTrue: [ pragma printOn: aStream indent: anInteger + 1] ifFalse: [ aStream tab: anInteger + 1; print: pragma ] ].
	super printOn: aStream indent: anInteger.
	aStream nextPutAll: '}'
]
