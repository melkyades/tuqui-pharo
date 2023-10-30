Class {
	#name : #TqLocalBinding,
	#superclass : #TqBinding,
	#instVars : [
		'position',
		'environment'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #testing }
TqLocalBinding >> environment [
	^environment
]

{ #category : #testing }
TqLocalBinding >> environment: anInteger [
	environment := anInteger
]

{ #category : #testing }
TqLocalBinding >> index [
	^position
]

{ #category : #testing }
TqLocalBinding >> index: anInteger [
	position := anInteger
]

{ #category : #testing }
TqLocalBinding >> isInStack [

	^ environment isNil
]
