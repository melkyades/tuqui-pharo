Class {
	#name : #TqOpDispatchMessage,
	#superclass : #TqOperation,
	#instVars : [
		'message'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #accessing }
TqOpDispatchMessage >> acceptVisitor: visitor [
	^ visitor visitOpDispatchMessage: self
]

{ #category : #accessing }
TqOpDispatchMessage >> message [
	^ message
]

{ #category : #accessing }
TqOpDispatchMessage >> message: anSMessage [
	message := anSMessage
]
