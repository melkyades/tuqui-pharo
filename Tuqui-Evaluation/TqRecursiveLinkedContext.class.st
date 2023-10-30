Class {
	#name : #TqRecursiveLinkedContext,
	#superclass : #TqLinkedContext,
	#instVars : [
		'nonLocalReturn'
	],
	#category : #'Tuqui-Evaluation-Runtime'
}

{ #category : #'as yet unclassified' }
TqRecursiveLinkedContext >> evaluateFor: interpreter [
	| sexpressions result |
	nonLocalReturn := [ :value | 
	interpreter context: self homeContext parent.
	^ value ].
	sexpressions := runtime sexpressionsOf: method.
	result := interpreter visitMethod: sexpressions.
	interpreter context: self parent.
	^ result
]

{ #category : #'as yet unclassified' }
TqRecursiveLinkedContext >> nonLocalReturn: anObject [

	nonLocalReturn value: anObject.
	"unreachable"
	self assert: false
]

{ #category : #'as yet unclassified' }
TqRecursiveLinkedContext >> return: anObject [
	^self isBlock
		ifTrue: [ self homeContext nonLocalReturn: anObject ]
		ifFalse: [ anObject ]
]
