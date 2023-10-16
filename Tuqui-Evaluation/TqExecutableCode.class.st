Class {
	#name : #TqExecutableCode,
	#superclass : #TqSlotObject,
	#instVars : [
		'code'
	],
	#category : #'Tuqui-Evaluation-Objects'
}

{ #category : #accessing }
TqExecutableCode >> code [
	^code
]

{ #category : #accessing }
TqExecutableCode >> code: anObject [
	code := anObject
]
