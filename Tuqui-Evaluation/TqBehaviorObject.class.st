Class {
	#name : #TqBehaviorObject,
	#superclass : #TqSlotObject,
	#instVars : [
		'runtime'
	],
	#category : #'Tuqui-Evaluation-Objects'
}

{ #category : #accessing }
TqBehaviorObject >> printInstance: aTqObject on: aStream [
	runtime print: aTqObject on: aStream
]

{ #category : #accessing }
TqBehaviorObject >> printOn: aStream [
	runtime printBehavior: self on: aStream
]

{ #category : #accessing }
TqBehaviorObject >> runtime: aPowertalkLMR [
	runtime := aPowertalkLMR
]
