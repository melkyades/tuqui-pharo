Class {
	#name : #TqOpPrimitive,
	#superclass : #TqOperation,
	#instVars : [
		'block'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #visiting }
TqOpPrimitive >> acceptVisitor: visitor [
	^ visitor visitOpPrimitive: self
]

{ #category : #accessing }
TqOpPrimitive >> block [
	^block
]

{ #category : #accessing }
TqOpPrimitive >> block: aBlockClosure [ 
	block := aBlockClosure
]
