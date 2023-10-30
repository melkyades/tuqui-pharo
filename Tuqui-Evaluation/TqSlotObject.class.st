"
I represent objects that have slots, either named instance variables or either arrays.
"
Class {
	#name : #TqSlotObject,
	#superclass : #TqHeapObject,
	#instVars : [
		'slots'
	],
	#category : #'Tuqui-Evaluation-Objects'
}

{ #category : #accessing }
TqSlotObject >> at: index [
	^ slots at: header behavior classInstSize + index
]

{ #category : #accessing }
TqSlotObject >> at: index put: aTqObject [	
	^ slots at: header behavior classInstSize + index put: aTqObject
]

{ #category : #accessing }
TqSlotObject >> basicAt: index put: aTqObject [

	^ slots at: index put: aTqObject
]

{ #category : #accessing }
TqSlotObject >> header: aTqObjectHeader [

	super header: aTqObjectHeader.
	slots := Array new: header size
]

{ #category : #accessing }
TqSlotObject >> nilSlots: nilObj [
	slots atAllPut: nilObj
]

{ #category : #accessing }
TqSlotObject >> pointersSize [
	^ header size
]

{ #category : #accessing }
TqSlotObject >> slotAt: index [
	^ slots at: index
]

{ #category : #accessing }
TqSlotObject >> slotAt: index put: aTqObject [
	^ slots at: index put: aTqObject
]

{ #category : #accessing }
TqSlotObject >> slots [
	^ slots
]
