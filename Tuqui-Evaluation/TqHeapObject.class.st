"
I represent objects that live in the virtual heap. They have a header, hash and size. They may have slots, bytes, or other things (see subclasses).
"
Class {
	#name : #TqHeapObject,
	#superclass : #TqObject,
	#instVars : [
		'header'
	],
	#category : #'Tuqui-Evaluation-Objects'
}

{ #category : #accessing }
TqHeapObject >> behavior [
	^header behavior
]

{ #category : #accessing }
TqHeapObject >> behavior: aTqBehaviorObject [

	header behavior: aTqBehaviorObject
]

{ #category : #accessing }
TqHeapObject >> header: anInteger [
	header := anInteger
]

{ #category : #accessing }
TqHeapObject >> headerFlags [
	^header flags
]

{ #category : #accessing }
TqHeapObject >> headerHash [
	^ header hash
]

{ #category : #accessing }
TqHeapObject >> headerHash: anInteger [
	header hash: anInteger
]

{ #category : #accessing }
TqHeapObject >> isSmall [
	^ header isSmall
]

{ #category : #accessing }
TqHeapObject >> size [
	^header size
]
