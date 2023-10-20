Class {
	#name : #TqLiteralVar,
	#superclass : #TqExpression,
	#instVars : [
		'index'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #accessing }
TqLiteralVar >> index [
	^index
]

{ #category : #accessing }
TqLiteralVar >> index: anInteger [
	index := anInteger
]
