Class {
	#name : #TqOpLoadRfromStack,
	#superclass : #TqOperation,
	#instVars : [
		'index'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #accessing }
TqOpLoadRfromStack >> acceptVisitor: visitor [
	^ visitor visitOpLoadRfromStack: self
]

{ #category : #accessing }
TqOpLoadRfromStack >> index [
	^index
]

{ #category : #accessing }
TqOpLoadRfromStack >> index: anInteger [
	index := anInteger
]
