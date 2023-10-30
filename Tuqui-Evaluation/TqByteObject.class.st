"
I represent objects that are made of bytes, like the instances of String and ByteArray.
"
Class {
	#name : #TqByteObject,
	#superclass : #TqHeapObject,
	#instVars : [
		'bytes'
	],
	#category : #'Tuqui-Evaluation-Objects'
}

{ #category : #accessing }
TqByteObject >> asLocalString [
	^ bytes allButLast asString
]

{ #category : #accessing }
TqByteObject >> at: index [

	^ bytes at: index
]

{ #category : #accessing }
TqByteObject >> at: index put: anInteger [

	^ bytes at: index put: anInteger
]

{ #category : #accessing }
TqByteObject >> byteAt: index [

	^ bytes at: index
]

{ #category : #accessing }
TqByteObject >> byteAt: index put: anInteger [
	^bytes at: index put: anInteger.
	
]

{ #category : #accessing }
TqByteObject >> bytes [
	^bytes
]

{ #category : #accessing }
TqByteObject >> bytes: aByteArray [
	self ASSERT: aByteArray size = header size.
	self ASSERT: aByteArray class == ByteArray.
	bytes := aByteArray
]

{ #category : #accessing }
TqByteObject >> header: aTqObjectHeader [

	super header: aTqObjectHeader.
	bytes := ByteArray new: header size
]

{ #category : #accessing }
TqByteObject >> isBytes [
	^true
]

{ #category : #accessing }
TqByteObject >> loadFrom: aByteObject [

	bytes
		replaceFrom: 1
		to: header size
		with: aByteObject
		startingAt: 1
]
