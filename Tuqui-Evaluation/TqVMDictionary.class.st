Class {
	#name : #TqVMDictionary,
	#superclass : #TqSlotObject,
	#instVars : [
		'contents',
		'runtime'
	],
	#category : #'Tuqui-Evaluation-Objects'
}

{ #category : #initialization }
TqVMDictionary >> associationAtKey: aTqByteObject ifPresent: aBlock [

	^ contents
		  at: aTqByteObject
		  ifPresent: aBlock
]

{ #category : #initialization }
TqVMDictionary >> atKey: aTqByteObject ifAbsent: aBlock [
	contents at: aTqByteObject ifPresent: [:assoc | ^runtime associationValue: assoc ].
	^aBlock value
]

{ #category : #initialization }
TqVMDictionary >> atKey: aTqByteObject ifPresent: aBlock [

	^ contents
		  at: aTqByteObject
		  ifPresent: [ :assoc | aBlock value: (runtime associationValue: assoc) ]
]

{ #category : #initialization }
TqVMDictionary >> atKey: aTqByteObject put: method [

	| assoc new |
	assoc := contents at: aTqByteObject ifAbsentPut: [
		         new := runtime newAssociation.
		         runtime associationKey: new put: aTqByteObject. new ].
	runtime associationValue: assoc put: method
]

{ #category : #initialization }
TqVMDictionary >> includesKey: aTqByteObject [

	^contents includesKey: aTqByteObject
]

{ #category : #initialization }
TqVMDictionary >> initialize [
	contents := IdentityDictionary new.
]

{ #category : #initialization }
TqVMDictionary >> runtime: aTuquiRuntime [
	runtime := aTuquiRuntime
]
