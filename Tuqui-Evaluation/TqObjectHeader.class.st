Class {
	#name : #TqObjectHeader,
	#superclass : #Object,
	#instVars : [
		'behavior',
		'flags',
		'size',
		'hash'
	],
	#category : #'Tuqui-Evaluation-Objects'
}

{ #category : #accessing }
TqObjectHeader >> behavior [
	^behavior
]

{ #category : #accessing }
TqObjectHeader >> behavior: aTqBehaviorObject [

	behavior := aTqBehaviorObject
]

{ #category : #accessing }
TqObjectHeader >> bytes: bytes arrayed: arrayed named: named [
	| b a n |
	b := bytes
		ifTrue: [ 1 ]
		ifFalse: [ 0 ].
	a := arrayed
		ifTrue: [ 2 ]
		ifFalse: [ 0 ].
	n := named	ifTrue: [ 4 ]
		ifFalse: [ 0 ].
	flags := b | a | n 
]

{ #category : #accessing }
TqObjectHeader >> flags [
	^flags
]

{ #category : #accessing }
TqObjectHeader >> hash [
	^hash
]

{ #category : #accessing }
TqObjectHeader >> hash: anInteger [
	hash := anInteger
]

{ #category : #accessing }
TqObjectHeader >> isSmall [
	^ self size < 256
]

{ #category : #accessing }
TqObjectHeader >> size [
	^size 
]

{ #category : #accessing }
TqObjectHeader >> size: anInteger [
	size := anInteger.
	self isSmall ifTrue: [ flags := flags | 16r80]
]
