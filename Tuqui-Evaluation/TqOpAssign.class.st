Class {
	#name : #TqOpAssign,
	#superclass : #TqOperation,
	#instVars : [
		'assignees'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #accessing }
TqOpAssign >> acceptVisitor: visitor [
	^ visitor visitOpAssign: self
]

{ #category : #accessing }
TqOpAssign >> assignees [
	^assignees
]

{ #category : #accessing }
TqOpAssign >> assignees: aCollection [
	assignees := aCollection
]
