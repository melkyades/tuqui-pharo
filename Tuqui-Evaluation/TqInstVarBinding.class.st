Class {
	#name : #TqInstVarBinding,
	#superclass : #TqBinding,
	#instVars : [
		'index'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #unclassified }
TqInstVarBinding class >> decodeUsing: anAstcodeDecoder [
	^anAstcodeDecoder decodeInstVar
]

{ #category : #testing }
TqInstVarBinding >> assign: value within: anEvaluationContext [
	anEvaluationContext instanceVarAt: index put: value
]

{ #category : #accessing }
TqInstVarBinding >> index [
	^index
]

{ #category : #accessing }
TqInstVarBinding >> index: anInteger [
	index := anInteger
]

{ #category : #testing }
TqInstVarBinding >> isInstVar [
	^true
]

{ #category : #testing }
TqInstVarBinding >> printOn: aStream [
	aStream nextPutAll: 'InstVarId. '; nextPutAll: index printString
]

{ #category : #accessing }
TqInstVarBinding >> valueWithin: anEvaluationContext [
	^ anEvaluationContext instanceVarAt: index
]
