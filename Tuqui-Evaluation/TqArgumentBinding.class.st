Class {
	#name : #TqArgumentBinding,
	#superclass : #TqLocalBinding,
	#instVars : [
		'inlined'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #unclassified }
TqArgumentBinding class >> decodeUsing: anAstcodeDecoder [
	^anAstcodeDecoder decodeArgument
]

{ #category : #testing }
TqArgumentBinding >> assign: value within: anEvaluationContext [
	self halt
]

{ #category : #testing }
TqArgumentBinding >> isArgument [
	^true
]

{ #category : #testing }
TqArgumentBinding >> isInlined [
	^ environment = -1
]

{ #category : #testing }
TqArgumentBinding >> printOn: aStream [
	aStream
		nextPutAll: 'SArgument ';
		print: position;
		nextPutAll: ' @ env ';
		print: environment
]

{ #category : #testing }
TqArgumentBinding >> valueWithin: anEvaluationContext [
	^ anEvaluationContext argumentAt: position in: environment
]
