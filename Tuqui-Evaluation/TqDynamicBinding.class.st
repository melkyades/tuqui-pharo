Class {
	#name : #TqDynamicBinding,
	#superclass : #TqBinding,
	#instVars : [
		'name',
		'cache'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #unclassified }
TqDynamicBinding class >> decodeUsing: anAstcodeDecoder [
	^ anAstcodeDecoder decodeDynamicVar
]

{ #category : #accessing }
TqDynamicBinding >> assign: value within: anEvaluationContext [
	cache ifNil: [ self lookupWithin: anEvaluationContext ].
	cache assign: value within: anEvaluationContext
]

{ #category : #accessing }
TqDynamicBinding >> isDynamic [
	^true
]

{ #category : #accessing }
TqDynamicBinding >> lookupWithin: anEvaluationContext [
	cache := anEvaluationContext staticBindingFor: name
]

{ #category : #accessing }
TqDynamicBinding >> name [ ^
	name
]

{ #category : #accessing }
TqDynamicBinding >> name: aSymbol [
	name := aSymbol
]

{ #category : #accessing }
TqDynamicBinding >> printOn: aStream [
	aStream
		nextPutAll: 'DinamicVarId. ';
		nextPutAll: name printString
]

{ #category : #accessing }
TqDynamicBinding >> valueWithin: anEvaluationContext [
	cache ifNil: [ self lookupWithin: anEvaluationContext ].
	^ cache valueWithin: anEvaluationContext
]
