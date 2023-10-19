Class {
	#name : #TqVMDictionary,
	#superclass : #TqSlotObject,
	#instVars : [
		'contents'
	],
	#category : #'Tuqui-Evaluation-Objects'
}

{ #category : #initialization }
TqVMDictionary >> atKey: aTqByteObject put: method [

	contents at: aTqByteObject put: method
]

{ #category : #initialization }
TqVMDictionary >> includesKey: aTqByteObject [

	^contents includesKey: aTqByteObject
]

{ #category : #initialization }
TqVMDictionary >> initialize [
	contents := IdentityDictionary new.
]
