"
My instances represent the objects in the virtual image that we are running. See sublcasses for more details.
"
Class {
	#name : #TqObject,
	#superclass : #Object,
	#category : #'Tuqui-Evaluation-Objects'
}

{ #category : #accessing }
TqObject >> at: index [
	"Return indexed value at given index, starting with 1. This CANNOT be 
	 used for accessing named slots (aka, instance variables), to access 
	 them use #instVarAt:"
	
	self subclassResponsibility  
]

{ #category : #accessing }
TqObject >> at: index put: value [
	"Set indexed value at given `index` to `value`. This CANNOT be used for 
	 setting named slots (aka, instance variables), to access them use 
	 #instVarAt:put:"
	
	self subclassResponsibility  
]

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
