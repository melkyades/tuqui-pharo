"
My instances represent the objects in the virtual image that we are running. See sublcasses for more details.
"
Class {
	#name : #TqObject,
	#superclass : #Object,
	#category : #'Tuqui-Evaluation-Objects'
}

{ #category : #accessing }
TqObject >> isBytes [
	^ false
]

{ #category : #accessing }
TqObject >> isImmediate [
	^false
]

{ #category : #accessing }
TqObject >> pointersSize [
	^0
]
