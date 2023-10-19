Class {
	#name : #TuquiRingBootstrapper2,
	#superclass : #TuquiRingBootstrapper,
	#category : #'Tuqui-Evaluation-Runtime'
}

{ #category : #accessing }
TuquiRingBootstrapper2 >> basicNewSlots: classname [
	^ self basicNewSlots: classname sized: 0
]

{ #category : #accessing }
TuquiRingBootstrapper2 >> basicNewSlots: classname in: spec [
	^ self basicNewSlots: classname in: spec sized: 0
]

{ #category : #accessing }
TuquiRingBootstrapper2 >> basicNewSlots: classname in: spec sized: size [
	| species |
	species := spec at: classname.
	^self basicNewSlotsOf: species sized: size
]

{ #category : #accessing }
TuquiRingBootstrapper2 >> basicNewSlots: classname sized: size [
	^ self basicNewSlots: classname in: specs sized: size
]

{ #category : #accessing }
TuquiRingBootstrapper2 >> basicNewSlotsOf: anRGBehavior sized: size [
	^ SlotObjectMap new: anRGBehavior size: size withAll: nilObj
]
