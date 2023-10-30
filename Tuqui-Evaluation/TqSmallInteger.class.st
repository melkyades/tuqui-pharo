Class {
	#name : #TqSmallInteger,
	#superclass : #TqObject,
	#instVars : [
		'value'
	],
	#category : #'Tuqui-Evaluation-Objects'
}

{ #category : #comparing }
TqSmallInteger >> = anObject [
	anObject class == self class
		ifFalse: [ ^ false ].
	^ value = anObject value
]

{ #category : #accessing }
TqSmallInteger >> at: anInteger [

	^ self class new value: (value byteAt: anInteger)
]

{ #category : #accessing }
TqSmallInteger >> hash [
	^value hash
]

{ #category : #accessing }
TqSmallInteger >> isImmediate [
	^true
]

{ #category : #accessing }
TqSmallInteger >> printOn: aStream [
	aStream
		nextPut: $<;
		print: value;
		nextPut: $>
]

{ #category : #evaluating }
TqSmallInteger >> value [
	^value
]

{ #category : #accessing }
TqSmallInteger >> value: anInteger [
	value := anInteger
]
