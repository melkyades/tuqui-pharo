Class {
	#name : #TqSymbolSet,
	#superclass : #TqSlotObject,
	#instVars : [
		'contents'
	],
	#category : #'Tuqui-Evaluation-Objects'
}

{ #category : #initialization }
TqSymbolSet >> initialize [

	contents := IdentityDictionary new
]

{ #category : #initialization }
TqSymbolSet >> symbolNamed: aSymbol [
	^contents at: aSymbol ifAbsent: [ nil ]
]

{ #category : #initialization }
TqSymbolSet >> symbolNamed: aSymbol put: aTqByteObject [

	^ contents at: aSymbol put: aTqByteObject
]
